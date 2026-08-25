function [responseR, responseT]=log_gabor(imR, imT)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Log-Gabor filter擷取多尺度的影像特徵
%%%%%%%%%%%%%%%%%%%%%%%%%

nscale          = 4;    % 影像頻譜被分解的尺度
norient         = 2;    % 每個尺度有幾個方向
minWaveLength   = 6;    % 最小尺度濾波器的波長
mult            = 2;    % 尺度濾波器的縮放因子
sigmaOnf        = 0.55; % 尺度濾波器的頻寬σr
dThetaOnSigma   = 1.2;  % 角頻寬的係數
thetaSigma = pi/(2*norient)/dThetaOnSigma;  % 方向濾波器的角頻寬σθ

%%%%%%%%%%%%%%%%%%%%%%%%%
% 將參考影像和失真影像做傅立葉轉換
%%%%%%%%%%%%%%%%%%%%%%%%%
imagefftR = fft2(imR);
imagefftT = fft2(imT);

%%%%%%%%%%%%%%%%%%%%%%%%%
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
radius = sqrt(x.^2 + y.^2); % 標示頻譜上由低頻到高頻
theta = atan2(-y,x);    % 標示頻譜上由0度到360度
radius = ifftshift(radius); % 將低頻由中心移至左上角
theta  = ifftshift(theta);
radius(1,1) = 1;
sintheta = sin(theta);  % 頻譜不同角度的sin值
costheta = cos(theta);  % 頻譜不同角度的cos值
clear x; clear y; clear theta;

lp = lowpassfilter([rows,cols],.45,15); % 使用低通濾波器濾除較高頻的部分

%%%%%%%%%%%%%%%%%%%%%%%%%
% 創造4個尺度濾波器
%%%%%%%%%%%%%%%%%%%%%%%%%
logGabor = cell(1,nscale);
for s = 1:nscale
    wavelength = minWaveLength*mult^(s-1);
    fo = 1.0/wavelength;    % 中心頻率ω0
    logGabor{s} = exp((-(log(radius/fo)).^2) / (2 * log(sigmaOnf)^2));  % 尺度濾波器的公式
    logGabor{s} = logGabor{s}.*lp;
    logGabor{s}(1,1) = 0; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% 創造2個方向濾波器
%%%%%%%%%%%%%%%%%%%%%%%%%
spread = cell(1,norient);
for o = 1:norient
  direct = 2*(o-1)+1;
  angl = (direct-1)*pi/(2*norient); % 方向角θj (水平和垂直方向)
  ds = sintheta * cos(angl) - costheta * sin(angl); % sin(θ-θj) 積化和差
  dc = costheta * cos(angl) + sintheta * sin(angl); % cos(θ-θj) 積化和差
  dtheta = abs(atan2(ds,dc));   % arctan求出角度(θ-θj)
  spread{o} = exp((-dtheta.^2) / (2 * thetaSigma^2));   % 方向濾波器的公式
end

responseR = cell(1,4);
responseT = cell(1,4);

for  s = 1:nscale

%%%%%%%%%%%%%%%%%%%%%%%%%
% 頻域上同一個尺度的水平和垂直方向濾波器
%%%%%%%%%%%%%%%%%%%%%%%%%    
    filter1 = logGabor{s} .* spread{1};
    filter2 = logGabor{s} .* spread{2};
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% 參考影像和失真影像在空間域的響應(同一個尺度)
%%%%%%%%%%%%%%%%%%%%%%%%%     
    tempR1 = abs(ifft2(imagefftR .* filter1));
    tempR2 = abs(ifft2(imagefftR .* filter2));
    tempT1 = abs(ifft2(imagefftT .* filter1));
    tempT2 = abs(ifft2(imagefftT .* filter2)); 
    mx = tempT2>tempT1;
    tempT1(mx) = tempT2(mx);    % 取相同位置上較大的響應作為該像素點在該尺度的響應(失真影像)
    tempR1(mx) = tempR2(mx);    % 取跟失真影像較大響應相同方向的響應作為該像素點在該尺度的響應(參考影像)
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% 輸出4個尺度失真影像最大頻帶響應和相對應的參考影像頻帶響應
%%%%%%%%%%%%%%%%%%%%%%%%%     
    responseR{s} = tempR1;
    responseT{s} = tempT1;
end  