function distortion_map = ssim(img1, img2, row, col, multiple)
%%%%%%%%%%%%%%%%%%%%%%%%%
% SSIM計算失真區域
%%%%%%%%%%%%%%%%%%%%%%%%%

window = fspecial('gaussian', 11, 1.5); % 11x11的高斯平均濾波器
window = window/sum(sum(window));
C1 = (0.01*255)^2;  % SSIM的常數C1
C2 = (0.03*255)^2;  % SSIM的常數C2

%%%%%%%%%%%%%%%%%%%%%%%%%
% 影像經次取樣後，每一個像素點對應到原始影像的一個局部區塊
%%%%%%%%%%%%%%%%%%%%%%%%%
downsample_filter = ones(3)./9;
filtered_imR   = filter2(downsample_filter, img1, 'valid');
filtered_imT   = filter2(downsample_filter, img2, 'valid');
img1 = filtered_imR(1:3:end, 1:3:end);
img2 = filtered_imT(1:3:end, 1:3:end);
img1 = img1(1:row, 1:col);
img2 = img2(1:row, 1:col);

%%%%%%%%%%%%%%%%%%%%%%%%%
% SSIM影像評估
%%%%%%%%%%%%%%%%%%%%%%%%%
mu1 = imfilter(img1, window, 'symmetric', 'same');  % 平均
mu2 = imfilter(img2, window, 'symmetric', 'same');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;
sigma1_sq = imfilter(img1.*img1, window, 'symmetric', 'same') - mu1_sq; % 變異數
sigma2_sq = imfilter(img2.*img2, window, 'symmetric', 'same') - mu2_sq;
sigma12 = imfilter(img1.*img2, window, 'symmetric', 'same') - mu1_mu2;  % 共變異數
ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));    % SSIM評估特徵圖S
ssim_map = 1-ssim_map;  % 1-S = 評估特徵圖S'
mx = max(max(ssim_map));
mn = min(min(ssim_map));
diff = mx-mn;

%%%%%%%%%%%%%%%%%%%%%%%%%
% 擷取影像失真較嚴重的區域
%%%%%%%%%%%%%%%%%%%%%%%%%
tol = 0.00000001;
if(mx<tol)
    distortion_map = ones(row, col);    % 當影像無失真時，將失真特徵圖的所有像素點設為1
else
    distortion_map = round((ssim_map-mn)/diff)*(multiple-1);    % 將影像局部分為失真較嚴重和失真不嚴重區域
end
    
