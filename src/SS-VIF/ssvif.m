function ssvif_value = ssvif(imR, imT)
% ========================================================================
% SS-VIF Version 1.0
% Copyright(c) 2012 Tien-Ying Kuo, Cheng-Mou Tsai
% All Rights Reserved.
%
% ----------------------------------------------------------------------
%Input : (1) imR: reference image
%        (2) imT: distorted image (order is important)
%
%Output: (1) ssvif_value: is the similarty score calculated using SS-VIF algorithm.
%
%Default Usage:
%   Given 2 test images imR and imT. For gray-scale images, their dynamic
%   range should be 0-255.
%
%   ssvif_value = ssvif(imR, imT);
%========================================================================

if (nargin ~= 2 )
   ssvif_value = -Inf;
   return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% 參考影像和失真影像大小必須一致
%%%%%%%%%%%%%%%%%%%%%%%%%
if (size(imR) ~= size(imT))
   ssvif_value = -Inf;
   return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% 限制長和寬大於64pixel
%%%%%%%%%%%%%%%%%%%%%%%%%
[M N] = size(imR);
if ((M < 64) || (N < 64))
    ssvif_value = -Inf;
    return   
end

%%%%%%%%%%%%%%%%%%%%%%%%%
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

sigma_nsq=0.4;  % 人類視覺系統參數σn2
[responseR, responseT]=log_gabor(imR, imT); % Log-Gabor filter優先擷取失真影像特徵
[ssarr, l_arr]=gsm(responseR,3);    % Source Medel：使用GSM模型將參考影像頻帶轉為高斯向量隨機場
[g_all, vv_all]=distortion(responseR,responseT, 3); % Distortion channel：利用小波域上信號的衰減和雜訊模擬影像的失真
[row,col] = size(ssarr{1}); % 每個頻帶上局部區塊的數量
distortion_map = ssim(imR, imT, row, col, 4);   % SSIM計算失真區域
object_map = laplocian_filter(imR, row, col, 4);    % Laplacian filter偵測物件區域
weight = (distortion_map + object_map)+1;   % 影像評估合成權重W

%%%%%%%%%%%%%%%%%%%%%%%%%
% 估測失真通道使用9x9的window，在此濾除邊界的鏡射區域
%%%%%%%%%%%%%%%%%%%%%%%%%
winsize=9;
offset=(winsize-1)/2;
offset=ceil(offset/3);
weight=weight(offset+1:end-offset,offset+1:end-offset);

%%%%%%%%%%%%%%%%%%%%%%%%%
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
        temp1=temp1+sum(sum(log2(1+g.*g.*ss.*lambda(j)./(vv+sigma_nsq)).*weight));  % I(C；F)
        temp2=temp2+sum(sum(log2(1+ss.*lambda(j)./(sigma_nsq)).*weight));   % I(C；E)
    end
    num(i)=temp1;
    den(i)=temp2;
end
ssvif_value=sum(num)./sum(den); % SS-VIF影像評估結果
return;