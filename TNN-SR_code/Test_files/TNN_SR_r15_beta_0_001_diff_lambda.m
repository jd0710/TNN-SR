% test TNN-SR algorithm with different parameters
% fixed r, beta, test different beta's
% lambda_set = [0.001, 0.01, 0.1, 0.5, 1, 5];
% beta = 0.001;
% r =15;

% References:
% J. Dong, Z. Xue, J. Guan, Z. Han, and W. Wang,
% "Low Rank Matrix Completion Using Truncated Nuclear Norm and Sparse Regularizer,"
% submitted to Signal Processing: Image Communication, March 2018.
%
% Written by Jing Dong, version 1.0        

clear
clc
close all

pic_list = {'re1.jpg','re2.jpg','re3.jpg','re4.jpg','re5.jpg','re6.jpg','re7.jpg','re8.jpg'};
picNum = length(pic_list);

for picIndex = 1:picNum
    picIndex
    mask = [];
    pic_name = pic_list{picIndex};
    
    Xfull = double(imread(pic_name));
    [sizem, sizen,~] = size(Xfull);
    
    rng(2017);
    ind0 = randi(10, sizem, sizen);
    ind0 = ind0-1;
    
    %% parameter settings
    lambda_set = [0.001, 0.01, 0.1, 0.5, 1, 5];
    beta = 0.001;
    r =15;
    
    for noiseLevel = 1:9
        noiseLevel
        ind = (ind0 < noiseLevel);
        mask(:,:,1)=ind;
        mask(:,:,2)=ind;
        mask(:,:,3)=ind;
        
        % TNN-SR
        for num_lambda = 1:length(lambda_set)
            lambda = lambda_set(num_lambda);
            
            dataName = [pic_name(1:end-4), '_TNN_SR_noiseLevel_', ...
                num2str(noiseLevel), '_lambda_', num2str(lambda), '_beta_', num2str(beta), '_r_', num2str(r), '.mat'];
            
            if ~exist(dataName, 'file')
                admmret_L1 = TNN_SR(Xfull, mask, r, lambda, beta);
                Psnr = admmret_L1.Psnr;
                save(dataName, 'Psnr', 'lambda', 'r', 'noiseLevel', 'beta', 'pic_name');
            end
        end
    end
end