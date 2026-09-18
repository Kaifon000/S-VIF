function assessment_result = assessment(reftxt, distxt, number)
%%%%%%%%%%%%%%%%%%%%%%%%%
% Image evaluation of the entire image database
% 對整個影像資料庫做影像評估
%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('src/S-VIF');

%%%%%%%%%%%%%%%%%%%%%%%%%
% Read the paths of all images in the reference image list.
% 讀取參考影像列表中所有影像的路徑
%%%%%%%%%%%%%%%%%%%%%%%%%
ref = fopen(reftxt, 'r');
Inputref = textscan(ref, '%s', number, 'delimiter', '\n');
path1 = Inputref{1};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Read the paths of all images in the distorted image list.
% 讀取失真影像列表中所有影像的路徑
%%%%%%%%%%%%%%%%%%%%%%%%%
dis = fopen(distxt, 'r');
Inputdis = textscan(dis, '%s', number, 'delimiter', '\n');
path2 = Inputdis{1};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform image evaluation on each image in the image database.
% 對影像資料庫的每一張影像作影像評估
%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:number
    imR = imread(path1{i});
    imT = imread(path2{i});
    % If it's a color image, convert it to grayscale before evaluating it. 如果是彩圖，則轉灰階後再做評估
    if ndims(imR) == 3 && size(imR, 3) == 3
        imR = rgb2gray(imR);
    end
    % If it's a color image, convert it to grayscale before evaluating it. 如果是彩圖，則轉灰階後再做評估
    if ndims(imT) == 3 && size(imT, 3) == 3
        imT = rgb2gray(imT);
    end
    % Calling the function of image evaluation methods 呼叫影像評估方法的function
    result = svif(imR, imT); 
    assessment_result(i,:) = result;
    fprintf('%d\n',i);
end

