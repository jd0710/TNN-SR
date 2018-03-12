% This file demonstrates how to call the TNN-SR algorithm 
% to recover images with random masks at differnt missing ratios

% Parameters of TNN-SR:
% R: r parameter in the defintion of the truncated nuclear norm
% lambda: regularizer parameter in the objective function
% beta: penalty parameter in the argumented Lagrangian funciton

% References:
% J. Dong, Z. Xue, J. Guan, Z. Han, and W. Wang,
% "Low Rank Matrix Completion Using Truncated Nuclear Norm and Sparse Regularizer,"
% submitted to Signal Processing: Image Communication, March 2018.
%
% Written by Jing Dong, version 1.0                                    
%
% If you have any questions or comments regarding this package, or if you want to 
% report any bugs or unexpected error messages, please send an e-mail to
% jingdong@njtech.edu.cn
%         
% Copyright 2018 J. Dong, Z. Xue, J. Guan, Z. Han, and W. Wang
% 
% This software is a free software distributed under the terms of the GNU 
% Public License version 3 (http://www.gnu.org/licenses/gpl.txt). You can 
% redistribute it and/or modify it under the terms of this licence, for 
% personal and non-commercial use and research purpose. 


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
    
    lambda = 0.1;
    beta = 0.001;
    r = 15;
    
    for noiseLevel = 1:9
        noiseLevel
        ind = (ind0 < noiseLevel);
        mask(:,:,1)=ind;
        mask(:,:,2)=ind;
        mask(:,:,3)=ind;
        
        % TNN-SR        
        dataNameL1 = [pic_name(1:end-4), '_TNN_SR_noiseLevel_', num2str(noiseLevel),...
            '_r_', num2str(r), '.mat'];
        
        if ~exist(dataNameL1, 'file')            
            admmret_L1 = TNN_SR(Xfull, mask, r, lambda, beta);            
            Psnr = admmret_L1.Psnr;
            Xrecover = admmret_L1.Xrecover;
            save(dataNameL1, 'Xrecover','Psnr', 'lambda', 'beta', 'r', 'noiseLevel', 'pic_name');
        
            % show recovered images
            figure;
            imshow(uint8(Xrecover));
            title(['noiseLevel=', num2str(noiseLevel), ',PSNR=', num2str(Psnr)]);
        end             
    end
end