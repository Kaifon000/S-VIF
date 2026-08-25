%%%%%%%%%%%%%%%%%%%%%%%%%
% 批次測試影像評估方法在7個影像資料庫的評估結果
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
% 讀取7個影像資料庫的參考影像列表路徑
%%%%%%%%%%%%%%%%%%%%%%%%%
pathref = fopen('pathR.txt', 'r');
Inputref = textscan(pathref, '%s', 7, 'delimiter', '\n');
pathR = Inputref{1};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 讀取7個影像資料庫的失真影像列表路徑
%%%%%%%%%%%%%%%%%%%%%%%%%
pathdis = fopen('pathT.txt', 'r');
Inputdis = textscan(pathdis, '%s', 7, 'delimiter', '\n'); % 讀取標題列
pathT = Inputdis{1};

%%%%%%%%%%%%%%%%%%%%%%%%%
% 以A57影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
A57_value = assessment(pathR{1}, pathT{1}, 54); % 對整個影像資料庫做影像評估
save results/A57/output_A57.txt A57_value -ascii;  % 儲存整個影像資料庫的評估結果

%%%%%%%%%%%%%%%%%%%%%%%%%
% 以CSIQ影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
CSIQ_value = assessment(pathR{2}, pathT{2}, 866);
save results/CSIQ/output_CSIQ.txt CSIQ_value -ascii;

%%%%%%%%%%%%%%%%%%%%%%%%%
% 以IVC影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
IVC_value = assessment(pathR{3}, pathT{3}, 185);
save results/IVC/output_IVC.txt IVC_value -ascii;

%%%%%%%%%%%%%%%%%%%%%%%%%
% 以LIVE影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
LIVE_value = assessment(pathR{4}, pathT{4}, 779);
save results/LIVE/output_LIVE.txt LIVE_value -ascii;

%%%%%%%%%%%%%%%%%%%%%%%%%
% 以MICT影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
MICT_value = assessment(pathR{5}, pathT{5}, 168);
save results/MICT/output_MICT.txt MICT_value -ascii;

%%%%%%%%%%%%%%%%%%%%%%%%%
% 以TID2008影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
TID2008_value = assessment(pathR{6}, pathT{6}, 1700);
save results/TID2018/output_TID2018.txt TID2008_value -ascii;

%%%%%%%%%%%%%%%%%%%%%%%%%
% 以WIQ影像資料庫做測試
%%%%%%%%%%%%%%%%%%%%%%%%%
WIQ_value = assessment(pathR{7}, pathT{7}, 80);
save results/WIQ/output_WIQ.txt WIQ_value -ascii;