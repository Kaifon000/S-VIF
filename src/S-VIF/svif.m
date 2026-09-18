function svif_value = svif(imR, imT)
% ========================================================================
% S-VIF Version 1.0
% Copyright(c) 2012 Tien-Ying Kuo, Cheng-Mou Tsai
% All Rights Reserved.
%
% ----------------------------------------------------------------------
%Input : (1) imR: reference image
%        (2) imT: distorted image (order is important)
%
%Output: (1) svif_value: is the similarty score calculated using S-VIF algorithm.
%
%Default Usage:
%   Given 2 test images imR and imT. For gray-scale images, their dynamic
%   range should be 0-255.
%
%   svif_value = svif(imR, imT);
%========================================================================

if (nargin ~= 2 )
   svif_value = -Inf;
   return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% The reference image and the distorted image must be the same size.
% 參考影像和失真影像大小必須一致
%%%%%%%%%%%%%%%%%%%%%%%%%
if (size(imR) ~= size(imT))
   svif_value = -Inf;
   return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% The length and width are limited to 64 pixels.
% 限制長和寬大於64pixel
%%%%%%%%%%%%%%%%%%%%%%%%%
[M N] = size(imR);
if ((M < 64) || (N < 64))
    svif_value = -Inf;
    return   
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% Haar wavelet transform filters out high-frequency components (subsample).
% Haar小波轉換濾除高頻成分(次取樣)
%%%%%%%%%%%%%%%%%%%%%%%%%
imR = double(imR);
imT = double(imT);
downsample_filter = ones(2)./4;
filtered_imR = imfilter(imR, downsample_filter, 'symmetric', 'same');
filtered_imT = imfilter(imT, downsample_filter, 'symmetric', 'same');
clear imR; 
clear imT;
imR = filtered_imR(1:2:end, 1:2:end);
imT = filtered_imT(1:2:end, 1:2:end);

sigma_nsq=0.4;  % Human visual system parameter σn2 人類視覺系統參數σn2
[responseR, responseT]=log_gabor(imR, imT); % Log-Gabor filters preferentially extract features from distorted images. 優先擷取失真影像特徵
[ssarr, l_arr]=gsm(responseR,3);    % Source Medel: Using a GSM model to convert reference image bandwidth into a Gaussian vector random field 使用GSM模型將參考影像頻帶轉為高斯向量隨機場
[g_all, vv_all]=distortion(responseR,responseT, 3); % Distortion channel: Simulates image distortion by utilizing signal attenuation and noise in the wavelet domain. 利用小波域上信號的衰減和雜訊模擬影像的失真
[row,col] = size(ssarr{1}); % Number of local blocks in each frequency band 每個頻帶上局部區塊的數量
saliency_map = saliencymap(imR, row, col);  % Spectral redundancy method for detecting object regions 頻譜冗餘方法偵測物件區域

%%%%%%%%%%%%%%%%%%%%%%%%%
% The distortion channel is estimated using a 9x9 window, which filters out the mirrored areas at the boundaries.
% 估測失真通道使用9x9的window，在此濾除邊界的鏡射區域
%%%%%%%%%%%%%%%%%%%%%%%%%
winsize=9;
offset=(winsize-1)/2;
offset=ceil(offset/3);
saliency_map=saliency_map(offset+1:end-offset,offset+1:end-offset);

%%%%%%%%%%%%%%%%%%%%%%%%%
% Synthetic overall evaluation results
% 合成整體評估結果
%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:4
    g=g_all{i};
    vv=vv_all{i};
    ss=ssarr{i};
    lambda = l_arr(i,:);
    neigvals=length(lambda);
    g=g(offset+1:end-offset,offset+1:end-offset);
    vv=vv(offset+1:end-offset,offset+1:end-offset);
    ss=ss(offset+1:end-offset,offset+1:end-offset);
    temp1=0; temp2=0;
    for j=1:neigvals
        temp1=temp1+sum(sum(log2(1+g.*g.*ss.*lambda(j)./(vv+sigma_nsq)).*saliency_map));    % I(C；F)
        temp2=temp2+sum(sum(log2(1+ss.*lambda(j)./(sigma_nsq)).*saliency_map)); % I(C；E)
    end
    num(i)=temp1;
    den(i)=temp2;
end
svif_value=sum(num)./sum(den);  % S-VIF image evaluation results S-VIF影像評估結果
return;