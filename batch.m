%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluation results of batch test image evaluation methods in 7 image databases
% 批次測試影像評估方法在7個影像資料庫的評估結果
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
% Path to read reference image lists from 7 image databases
% 讀取7個影像資料庫的參考影像列表路徑
%%%%%%%%%%%%%%%%%%%%%%%%%
pathref = fopen('pathR.txt', 'r');
Inputref = textscan(pathref, '%s', 7, 'delimiter', '\n');
pathR = Inputref{1};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Path to read the list of distorted images from 7 image databases
% 讀取7個影像資料庫的失真影像列表路徑
%%%%%%%%%%%%%%%%%%%%%%%%%
pathdis = fopen('pathT.txt', 'r');
% Read the header column 讀取標題列
Inputdis = textscan(pathdis, '%s', 7, 'delimiter', '\n'); 
pathT = Inputdis{1};

%%%%%%%%%%%%%%%%%%%%%%%%%
% Tested using the A57 image database
% 以A57影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%% 
% Image evaluation of the entire image database 對整個影像資料庫做影像評估
A57_value = assessment(pathR{1}, pathT{1}, 54); 
% The evaluation results of storing the entire image database 儲存整個影像資料庫的評估結果
save results/A57/output_A57.txt A57_value -ascii;

%%%%%%%%%%%%%%%%%%%%%%%%%
% Tested using the CSIQ image database
% 以CSIQ影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
CSIQ_value = assessment(pathR{2}, pathT{2}, 866);
save results/CSIQ/output_CSIQ.txt CSIQ_value -ascii;

%%%%%%%%%%%%%%%%%%%%%%%%%
% Tested using the IVC image database
% 以IVC影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
IVC_value = assessment(pathR{3}, pathT{3}, 185);
save results/IVC/output_IVC.txt IVC_value -ascii;

%%%%%%%%%%%%%%%%%%%%%%%%%
% Tested using the LIVE image database
% 以LIVE影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
LIVE_value = assessment(pathR{4}, pathT{4}, 779);
save results/LIVE/output_LIVE.txt LIVE_value -ascii;

%%%%%%%%%%%%%%%%%%%%%%%%%
% Tested using the MICT image database
% 以MICT影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
MICT_value = assessment(pathR{5}, pathT{5}, 168);
save results/MICT/output_MICT.txt MICT_value -ascii;

%%%%%%%%%%%%%%%%%%%%%%%%%
% Tested using the TID2008 image database
% 以TID2008影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
TID2008_value = assessment(pathR{6}, pathT{6}, 1700);
save results/TID2008/output_TID2008.txt TID2008_value -ascii;

%%%%%%%%%%%%%%%%%%%%%%%%%
% Tested using the WIQ image database
% 以WIQ影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
WIQ_value = assessment(pathR{7}, pathT{7}, 80);
save results/WIQ/output_WIQ.txt WIQ_value -ascii;
