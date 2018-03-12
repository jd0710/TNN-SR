% test TNN-SR-AP algorithm with different parameters for updating beta adaptively
% lambda = 0.1;
% r = 15;
% beta0 = 1e-3; % intial beta
% cof_set = [1 1.01, 1.02, 1.04, 1.06, 1.08, 1.1,1.2, 1.5] %gamma0
    
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
    
    %% parameters
    lambda = 0.1;
    r = 15;
    beta0 = 1e-3; % intial beta
    cof_set = [1 1.01, 1.02, 1.04, 1.06, 1.08, 1.1,1.2, 1.5] %gamma0

    
    for noiseLevel = 1:9
        noiseLevel
        ind = (ind0 < noiseLevel);
        mask(:,:,1)=ind;
        mask(:,:,2)=ind;
        mask(:,:,3)=ind;
        
        for num_cof = 1:length(cof_set)
            cof = cof_set(num_cof);  % different coefficient to increase beta
                       
            dataNameL1 = [pic_name(1:end-4), '_TNN_SR_AP_noiseLevel_', ...
                num2str(noiseLevel), '_lambda_', num2str(lambda), '_beta0_', num2str(beta0), '_r_', num2str(r), '_cof_', num2str(cof), '.mat'];
            
            if ~exist(dataNameL1, 'file')
                % run algorithm
                 % TNN-SR-AP
                admmret_L1 = TNN_SR_AP(Xfull, mask, r, lambda, beta0, cof);
                
                Psnr = admmret_L1.Psnr;
                out_iter = admmret_L1.out_iter;
                inner_iter = admmret_L1.inner_iter;
                beta_final = admmret_L1.beta_final;
                
                save(dataNameL1, 'Psnr', 'lambda', 'beta0', 'cof', 'r', 'noiseLevel', 'pic_name', ...
                    'out_iter', 'inner_iter', 'beta_final');
            end
            
            
        end
    end
end