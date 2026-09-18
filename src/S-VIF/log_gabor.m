function [responseR, responseT]=log_gabor(imR, imT)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Log-Gabor filters extract multi-scale image features
% Log-Gabor filter擷取多尺度的影像特徵
%%%%%%%%%%%%%%%%%%%%%%%%%

nscale          = 4;    % The scale at which the image spectrum is decomposed 影像頻譜被分解的尺度
norient         = 2;    % Each scale has several directions 每個尺度有幾個方向
minWaveLength   = 6;    % Wavelength of the minimum scale filter 最小尺度濾波器的波長
mult            = 2;    % Scaling factor of the scaling filter 尺度濾波器的縮放因子
sigmaOnf        = 0.55; % The bandwidth σr of the scaling filter 尺度濾波器的頻寬σr
dThetaOnSigma   = 1.2;  % Angular bandwidth coefficient 角頻寬的係數
thetaSigma = pi/(2*norient)/dThetaOnSigma;  % Angular bandwidth σθ of the directional filter 方向濾波器的角頻寬σθ

%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform Fourier transform on the reference image and the distorted image.
% 將參考影像和失真影像做傅立葉轉換
%%%%%%%%%%%%%%%%%%%%%%%%%
imagefftR = fft2(imR);
imagefftT = fft2(imT);

%%%%%%%%%%%%%%%%%%%%%%%%%
% Pre-processing of frequency domain upscale filters and directional filters
% 頻域上尺度濾波器和方向濾波器的前置工作
%%%%%%%%%%%%%%%%%%%%%%%%%
[rows,cols] = size(imR);
if mod(cols,2)
    xrange = [-(cols-1)/2:(cols-1)/2]/(cols-1);
else
    xrange = [-cols/2:(cols/2-1)]/cols;	
end

if mod(rows,2)
    yrange = [-(rows-1)/2:(rows-1)/2]/(rows-1);
else
    yrange = [-rows/2:(rows/2-1)]/rows;	
end

[x,y] = meshgrid(xrange, yrange);
radius = sqrt(x.^2 + y.^2); % Indicates the frequency range from low to high frequencies on the spectrum. 標示頻譜上由低頻到高頻
theta = atan2(-y,x);    % Indicates the range of 0 degrees to 360 degrees on the spectrum. 標示頻譜上由0度到360度
radius = ifftshift(radius); % Move the low frequencies from the center to the upper left corner 將低頻由中心移至左上角
theta  = ifftshift(theta);
radius(1,1) = 1;
sintheta = sin(theta);  % sin values ​​at different angles of the spectrum 頻譜不同角度的sin值
costheta = cos(theta);  % cos values ​​at different angles of the spectrum 頻譜不同角度的cos值
clear x; clear y; clear theta;

lp = lowpassfilter([rows,cols],.45,15); % Use a low-pass filter to filter out the higher frequency components. 使用低通濾波器濾除較高頻的部分

%%%%%%%%%%%%%%%%%%%%%%%%%
% Create 4 scale filters
% 創造4個尺度濾波器
%%%%%%%%%%%%%%%%%%%%%%%%%
logGabor = cell(1,nscale);
for s = 1:nscale
    wavelength = minWaveLength*mult^(s-1);
    fo = 1.0/wavelength;    % Center frequency ω0 中心頻率ω0
    logGabor{s} = exp((-(log(radius/fo)).^2) / (2 * log(sigmaOnf)^2));  % Formula for scaling filters 尺度濾波器的公式
    logGabor{s} = logGabor{s}.*lp;
    logGabor{s}(1,1) = 0; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% Create two directional filters
% 創造2個方向濾波器
%%%%%%%%%%%%%%%%%%%%%%%%%
spread = cell(1,norient);
for o = 1:norient
  direct = 2*(o-1)+1;
  angl = (direct-1)*pi/(2*norient); % Direction angle θj (horizontal and vertical directions) 方向角θj (水平和垂直方向)
  ds = sintheta * cos(angl) - costheta * sin(angl); % sin(θ-θj) Product-to-sum 積化和差
  dc = costheta * cos(angl) + sintheta * sin(angl); % cos(θ-θj) Product-to-sum 積化和差
  dtheta = abs(atan2(ds,dc));   % Find the angle (θ-θj) using arctan. arctan求出角度(θ-θj)
  spread{o} = exp((-dtheta.^2) / (2 * thetaSigma^2));   % Formula for directional filter 方向濾波器的公式
end

responseR = cell(1,4);
responseT = cell(1,4);

for  s = 1:nscale

%%%%%%%%%%%%%%%%%%%%%%%%%
% Horizontal and vertical filters of the same scale in the frequency domain
% 頻域上同一個尺度的水平和垂直方向濾波器
%%%%%%%%%%%%%%%%%%%%%%%%%    
    filter1 = logGabor{s} .* spread{1};
    filter2 = logGabor{s} .* spread{2};
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% The spatial domain response of the reference image and the distorted image (at the same scale).
% 參考影像和失真影像在空間域的響應(同一個尺度)
%%%%%%%%%%%%%%%%%%%%%%%%%     
    tempR1 = abs(ifft2(imagefftR .* filter1));
    tempR2 = abs(ifft2(imagefftR .* filter2));
    tempT1 = abs(ifft2(imagefftT .* filter1));
    tempT2 = abs(ifft2(imagefftT .* filter2)); 
    mx = tempT2>tempT1;
    tempT1(mx) = tempT2(mx);    % The larger response at the same location is taken as the response of that pixel at that scale (distorted image). 取相同位置上較大的響應作為該像素點在該尺度的響應(失真影像)
    tempR1(mx) = tempR2(mx);    % The response in the same direction as the larger response of the distorted image is taken as the response of that pixel at that scale (reference image). 取跟失真影像較大響應相同方向的響應作為該像素點在該尺度的響應(參考影像)
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% Output the maximum bandwidth response of the distorted images at four scales and the corresponding bandwidth response of the reference image.
% 輸出4個尺度失真影像最大頻帶響應和相對應的參考影像頻帶響應
%%%%%%%%%%%%%%%%%%%%%%%%%     
    responseR{s} = tempR1;
    responseT{s} = tempT1;
end  