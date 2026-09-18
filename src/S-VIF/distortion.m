function [g_all, vv_all]=distortion(org,dist, M)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulate image distortion by utilizing signal attenuation and noise in the wavelet domain.
% 利用小波域上信號的衰減和雜訊模擬影像的失真
%%%%%%%%%%%%%%%%%%%%%%%%%

tol = 1e-15;    % If the variance is less than or equal to zero, then set it to a very small positive constant. 如果變異數小於零或等於零，則設為很小的正常數
for i=1:4
    y=org{i};
    yn=dist{i};

%%%%%%%%%%%%%%%%%%%%%%%%%
% The window for estimating the distortion channel is 9x9.
% 估測失真通道的window為9x9
%%%%%%%%%%%%%%%%%%%%%%%%%    
    winsize=9;  
    win = ones(winsize);
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% Change the length and width of the image to multiples of 3.
% 將影像的長和寬變為3的倍數
%%%%%%%%%%%%%%%%%%%%%%%%%       
    newsize=floor(size(y)./M)*M;
    y=y(1:newsize(1),1:newsize(2));
    yn=yn(1:newsize(1),1:newsize(2));
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the local mean, covariance, and variance.
% 計算局部的平均、共變異數和變異數
%%%%%%%%%%%%%%%%%%%%%%%%%        
    winstep=[M M];  % Subsampling rate 次取樣倍率
    winstart=[1 1].*floor(M/2)+1;   % Starting sampling point 起始取樣點
    winstop=size(y)-ceil(M/2)+1;    % Termination sampling point 終止取樣點
    % average 平均
    mean_x = corrDn(y,win/sum(win(:)),'reflect1',winstep, winstart,winstop);
    mean_y = corrDn(yn,win/sum(win(:)),'reflect1',winstep, winstart,winstop);
    % Covariance 共變異數
    cov_xy = corrDn(y.*yn, win, 'reflect1',winstep, winstart,winstop) - sum(win(:)).*mean_x.*mean_y;
    % variance 變異數
    ss_x = corrDn(y.^2,win, 'reflect1',winstep, winstart,winstop) - sum(win(:)).*mean_x.^2;
    ss_y = corrDn(yn.^2,win, 'reflect1',winstep, winstart,winstop) - sum(win(:)).*mean_y.^2;

    ss_x(ss_x<0)=0;
    ss_y(ss_y<0)=0;

%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate the distortion channel parameters g and σv2
% 估測失真通道參數g和σv2
%%%%%%%%%%%%%%%%%%%%%%%%%            
    g = cov_xy./(ss_x+tol); % Find g using simple linear regression. 用簡單線性迴歸求g
    vv = (ss_y - g.*cov_xy)/(sum(win(:)));  % Error variation σv2 誤差的變異數σv2
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% Handling cases with very small values
% 處理數值很小的狀況
%%%%%%%%%%%%%%%%%%%%%%%%%        
    g (ss_x < tol) = 0;
    vv (ss_x < tol) = ss_y (ss_x < tol);
    ss_x(ss_x<tol)=0;   
    g (ss_y < tol) = 0;
    vv (ss_y < tol) = 0;
    vv(g<0)=ss_y(g<0);
    g(g<0)=0;
    vv( vv <= tol) = tol;
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% Output distortion channel parameters g and σv2
% 輸出失真通道參數g和σv2
%%%%%%%%%%%%%%%%%%%%%%%%%    
    g_all{i}=g;
    vv_all{i}=vv;
end