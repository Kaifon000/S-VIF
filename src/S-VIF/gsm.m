function [ssarr, l_arr]=gsm(org,M)
%%%%%%%%%%%%%%%%%%%%%%%%%
% The reference image frequency band is converted into a Gaussian vector random field using the GSM model.
% 使用GSM模型將參考影像頻帶轉為高斯向量隨機場
%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:4; % 4 scales 4個尺度
    y=org{i};
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% Change the length and width of the image to multiples of 3.
% 將影像的長和寬變為3的倍數
%%%%%%%%%%%%%%%%%%%%%%%%%    
    sizey=floor(size(y)./M)*M;
    y=y(1:sizey(1),1:sizey(2));
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the covariance matrix as Cu
% 計算共變異數矩陣為Cu
%%%%%%%%%%%%%%%%%%%%%%%%%        
    temp=[];
    for j=1:M
        for k=1:M
            temp=cat(1,temp,reshape(y(k:end-(M-k), j:end-(M-j)),1,[])); % Convert a local 3x3 block into a 9x1 vector (overlapping block) 將局部3x3的block轉為9x1的向量(overlapping block)
        end
    end
    mcu=mean(temp')';
    cu=((temp-repmat(mcu,1,size(temp,2)))*(temp-repmat(mcu,1,size(temp,2)))')./size(temp,2);    % The covariance matrix is ​​Cu 共變異數矩陣為Cu
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the S scalar random field
% 計算S純量隨機場
%%%%%%%%%%%%%%%%%%%%%%%%%      
    temp=[];
    for j=1:M
        for k=1:M
            temp=cat(1,temp,reshape(y(k:M:end, j:M:end),1,[])); % Convert a local 3x3 block into a 9x1 vector (non-overlapping block). 將局部3x3的block轉為9x1的向量(non-overlapping block)
        end
    end
    ss=(inv(cu)*temp);
    ss=sum(ss.*temp)./(M*M);
    ss=reshape(ss,sizey/M); % S squared of a scalar random field S純量隨機場的平方
    
%%%%%%%%%%%%%%%%%%%%%%%%%
% Replace the covariance matrix with eigenvalue λ as Cu to reduce computational complexity.
% 以特徵值λ取代共變異數矩陣為Cu，降低運算量
%%%%%%%%%%%%%%%%%%%%%%%%%       
    [v,d]=eig(cu);
    eigen = diag(d)';   % eigenvalue λ 特徵值λ
    eigen = sort(eigen,'descend');   % Eigenvalues ​​sorted from largest to smallest 特徵值由大到小排序

%%%%%%%%%%%%%%%%%%%%%%%%%
% Output the sum of squares eigenvalues ​​λ of the S scalar random field.
% 輸出S純量隨機場的平方和特徵值λ
%%%%%%%%%%%%%%%%%%%%%%%%%           
    ssarr{i}=ss;
    l_arr(i,:) = eigen;
    temp=0;
end    

