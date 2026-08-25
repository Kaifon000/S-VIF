function object_map = laplocian_filter(imR, row, col, multiple)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Laplacian filter偵測物件區域
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
% 將影像的長和寬變為3的倍數
%%%%%%%%%%%%%%%%%%%%%%%%%
newsize=floor(size(imR)./3)*3;
imR=imR(1:newsize(1),1:newsize(2));

%%%%%%%%%%%%%%%%%%%%%%%%%
% 將影像較長的邊等比例縮小至64像素大小
%%%%%%%%%%%%%%%%%%%%%%%%%
if(newsize(1)>newsize(2))
    imR64 = imresize (imR, [64 NaN], 'bilinear');
else
    imR64 = imresize (imR, [NaN 64], 'bilinear');
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% 使用Laplacian filter擷取縮小影像較明顯的邊緣和紋理特徵
%%%%%%%%%%%%%%%%%%%%%%%%%
window = fspecial('laplacian',0.2); % Laplacian運算子
res = imfilter(imR64, window, 'symmetric', 'same');
res = abs(res); % 縮小影像的邊緣影像e

%%%%%%%%%%%%%%%%%%%%%%%%%
% 使用高斯平滑濾波器將邊緣影像e的邊緣和紋理特徵擴散至整個局部區域
%%%%%%%%%%%%%%%%%%%%%%%%%
smooth_filter = fspecial('gaussian', 9, 3);
smooth_res = imfilter(res, smooth_filter, 'symmetric', 'same');
s_map = imresize (smooth_res, [row,col], 'bilinear');   % 邊緣顯著圖R

%%%%%%%%%%%%%%%%%%%%%%%%%
% 擷取邊緣顯著圖上包含物件的區域
%%%%%%%%%%%%%%%%%%%%%%%%%
thr = mean2(s_map);
object_map = s_map>(1.5*thr);   % 以1.5倍平均作為門檻值，產生物件特徵圖
object_map = object_map*(multiple-1);   % 物件特徵圖O