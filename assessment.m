function assessment_result = assessment(reftxt, distxt, number)
%%%%%%%%%%%%%%%%%%%%%%%%%
% 對整個影像資料庫做影像評估
%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('src/S-VIF');
addpath('src/SS-VIF');

%%%%%%%%%%%%%%%%%%%%%%%%%
% 讀取參考影像列表中所有影像的路徑
%%%%%%%%%%%%%%%%%%%%%%%%%
ref = fopen(reftxt, 'r');
Inputref = textscan(ref, '%s', number, 'delimiter', '\n');
path1 = Inputref{1};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 讀取失真影像列表中所有影像的路徑
%%%%%%%%%%%%%%%%%%%%%%%%%
dis = fopen(distxt, 'r');
Inputdis = textscan(dis, '%s', number, 'delimiter', '\n');
path2 = Inputdis{1};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 對影像資料庫的每一張影像作影像評估
%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:number
    imR = imread(path1{i});
    imT = imread(path2{i});
   
    if ndims(imR) == 3 && size(imR, 3) == 3 % 如果是彩圖，則轉灰階後再做評估
        imR = rgb2gray(imR);
    end

    if ndims(imT) == 3 && size(imT, 3) == 3% 如果是彩圖，則轉灰階後再做評估
        imT = rgb2gray(imT);
    end
    result = svif(imR, imT); % 呼叫影像評估方法的function
    assessment_result(i,:) = result;
    fprintf('%d\n',i);
end

