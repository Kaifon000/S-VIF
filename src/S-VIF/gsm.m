function [ssarr, l_arr]=gsm(org,M)
%%%%%%%%%%%%%%%%%%%%%%%%%
% 使用GSM模型將參考影像頻帶轉為高斯向量隨機場
%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:4; % 4個尺度
    y=org{i};
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% 將影像的長和寬變為3的倍數
%%%%%%%%%%%%%%%%%%%%%%%%%    
    sizey=floor(size(y)./M)*M;
    y=y(1:sizey(1),1:sizey(2));
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% 計算共變異數矩陣為Cu
%%%%%%%%%%%%%%%%%%%%%%%%%        
    temp=[];
    for j=1:M
        for k=1:M
            temp=cat(1,temp,reshape(y(k:end-(M-k), j:end-(M-j)),1,[])); % 將局部3x3的block轉為9x1的向量(overlapping block)
        end
    end
    mcu=mean(temp')';
    cu=((temp-repmat(mcu,1,size(temp,2)))*(temp-repmat(mcu,1,size(temp,2)))')./size(temp,2);    % 共變異數矩陣為Cu
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% 計算S純量隨機場
%%%%%%%%%%%%%%%%%%%%%%%%%      
    temp=[];
    for j=1:M
        for k=1:M
            temp=cat(1,temp,reshape(y(k:M:end, j:M:end),1,[])); % 將局部3x3的block轉為9x1的向量(non-overlapping block)
        end
    end
    ss=(inv(cu)*temp);
    ss=sum(ss.*temp)./(M*M);
    ss=reshape(ss,sizey/M); % S純量隨機場的平方
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% 以特徵值λ取代共變異數矩陣為Cu，降低運算量
%%%%%%%%%%%%%%%%%%%%%%%%%       
    [v,d]=eig(cu);
    eigen = diag(d)';   % 特徵值λ
    eigen = sort(eigen,'descend');   % 特徵值由大到小排序

%%%%%%%%%%%%%%%%%%%%%%%%%
% 輸出S純量隨機場的平方和特徵值λ
%%%%%%%%%%%%%%%%%%%%%%%%%           
    ssarr{i}=ss;
    l_arr(i,:) = eigen;
    temp=0;
end    

