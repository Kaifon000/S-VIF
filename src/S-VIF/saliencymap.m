function saliency_map = saliencymap(img, row, col)
%%%%%%%%%%%%%%%%%%%%%%%%%
% 頻譜冗餘方法偵測物件區域
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
% 將影像的長和寬變為3的倍數
%%%%%%%%%%%%%%%%%%%%%%%%%
newsize=floor(size(img)./3)*3;
img=img(1:newsize(1),1:newsize(2));

%%%%%%%%%%%%%%%%%%%%%%%%%
% 將影像較長的邊等比例縮小至64像素大小
%%%%%%%%%%%%%%%%%%%%%%%%%
if(newsize(1)>newsize(2))
    img64 = imresize (img, [64 NaN], 'bilinear');
else
    img64 = imresize (img, [NaN 64], 'bilinear');
end
imagefft64 = fft2(img64);   % 縮小影像作傅立葉轉換
amplitude = abs(imagefft64);    % A(f)：實部和虛部轉為振幅
log_amp = log(amplitude);   % L(f)：振幅取log

%%%%%%%%%%%%%%%%%%%%%%%%%
% La(f)：L(f)過平均低通濾波器，模擬不同影像間log頻譜一致的趨勢
%%%%%%%%%%%%%%%%%%%%%%%%%
downsample_filter = ones(3)./9;
lowpass_amp = imfilter(log_amp, downsample_filter, 'symmetric', 'same');
residual = log_amp-lowpass_amp; %頻譜冗餘：R(f) = L(f)-La(f)

%%%%%%%%%%%%%%%%%%%%%%%%%
% 頻譜冗餘保留原始相位，作傅立葉反轉換後過高斯平滑濾波器g(x)，
% 產生空間域的顯著特徵圖
%%%%%%%%%%%%%%%%%%%%%%%%%
residual = exp(residual);
imagefft64 = (imagefft64./amplitude).*residual; % 頻譜冗餘保留原始相位
saliency_temp64 = abs(ifft2(imagefft64)).^2;    % 傅立葉反轉換
smooth_filter = fspecial('gaussian', 24, 8);
saliency64 = imfilter(saliency_temp64, smooth_filter, 'same');
saliency = imresize (saliency64, [row,col], 'bilinear');    % 影像的顯著特徵圖
thr = mean2(saliency);
object_map = saliency>(thr*1.5);    % 以1.5倍平均作為門檻值，產生物件特徵圖

%%%%%%%%%%%%%%%%%%%%%%%%%
% 輸出合成權重
%%%%%%%%%%%%%%%%%%%%%%%%%
saliency_map = object_map+1;    % 合成權重圖：將物件區域權重設為非物件區域權重的兩倍