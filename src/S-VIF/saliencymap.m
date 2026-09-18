function saliency_map = saliencymap(img, row, col)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Spectral redundancy method for detecting object regions
% 頻譜冗餘方法偵測物件區域
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
% Change the length and width of the image to multiples of 3.
% 將影像的長和寬變為3的倍數
%%%%%%%%%%%%%%%%%%%%%%%%%
newsize=floor(size(img)./3)*3;
img=img(1:newsize(1),1:newsize(2));

%%%%%%%%%%%%%%%%%%%%%%%%%
% The longer side of the image is proportionally reduced to 64 pixels.
% 將影像較長的邊等比例縮小至64像素大小
%%%%%%%%%%%%%%%%%%%%%%%%%
if(newsize(1)>newsize(2))
    img64 = imresize (img, [64 NaN], 'bilinear');
else
    img64 = imresize (img, [NaN 64], 'bilinear');
end
imagefft64 = fft2(img64);   % Fourier transform of a reduced image 縮小影像作傅立葉轉換
amplitude = abs(imagefft64);    % A(f): The real and imaginary parts are converted into amplitude. 實部和虛部轉為振幅
log_amp = log(amplitude);   % L(f)：Amplitude taken as log 振幅取log

%%%%%%%%%%%%%%%%%%%%%%%%%
% La(f): L(f) passes through an average low-pass filter to simulate the trend of consistent log spectrum across different images.
% La(f)：L(f)過平均低通濾波器，模擬不同影像間log頻譜一致的趨勢
%%%%%%%%%%%%%%%%%%%%%%%%%
downsample_filter = ones(3)./9;
lowpass_amp = imfilter(log_amp, downsample_filter, 'symmetric', 'same');
residual = log_amp-lowpass_amp; % Spectral redundancy(頻譜冗餘)：R(f) = L(f)-La(f)

%%%%%%%%%%%%%%%%%%%%%%%%%
% The spectral redundancy is preserved to retain the original phase.
% After inverse Fourier transform, the image is smoothed by a Gaussian filter g(x) to produce a salient feature map in the spatial domain.
% 頻譜冗餘保留原始相位，作傅立葉反轉換後過高斯平滑濾波器g(x)，
% 產生空間域的顯著特徵圖
%%%%%%%%%%%%%%%%%%%%%%%%%
residual = exp(residual);
imagefft64 = (imagefft64./amplitude).*residual; % Spectral redundancy preserves the original phase 頻譜冗餘保留原始相位
saliency_temp64 = abs(ifft2(imagefft64)).^2;    % Inverse Fourier Transform 傅立葉反轉換
smooth_filter = fspecial('gaussian', 24, 8);
saliency64 = imfilter(saliency_temp64, smooth_filter, 'same');
saliency = imresize (saliency64, [row,col], 'bilinear');    % Image salient feature map 影像的顯著特徵圖
thr = mean2(saliency);
object_map = saliency>(thr*1.5);    % Using 1.5 times the average as the threshold value, an object feature map is generated. 以1.5倍平均作為門檻值，產生物件特徵圖

%%%%%%%%%%%%%%%%%%%%%%%%%
% Output composite weights
% 輸出合成權重
%%%%%%%%%%%%%%%%%%%%%%%%%
saliency_map = object_map+1;    % Composite weighted map: Set the weight of the object region to twice the weight of the non-object region. 合成權重圖：將物件區域權重設為非物件區域權重的兩倍