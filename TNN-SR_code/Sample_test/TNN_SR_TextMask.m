% This file demonstrates how to call the TNN-SR algorithm 
% to recover images with text masks

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

pic_list = {'re1.jpg','re3.jpg'};
picNum = length(pic_list);

lambda_set = [0.1];

for picIndex = 1:picNum
    picIndex
    mask = [];
    pic_name = pic_list{picIndex};
    
    Xfull = double(imread(pic_name));
    
    [sizem, sizen,~] = size(Xfull);
    
    ind0 = imread('111.jpg');
    ind0 = imresize(ind0, [sizem, sizen]);
    ind = ind0>250;    
    mask=ind;    
       
    % TNN-SR
    for lambda = lambda_set
        beta = 0.001;
        r = 15;
        dataName = [pic_name(1:end-4), '_TNN_SR_text_lambda_', num2str(lambda),'_r',num2str(r), '.mat'];
        if ~exist(dataName, 'file')
            admmret_L1 = TNN_SR(Xfull, mask, r, lambda, beta);
            Psnr = admmret_L1.Psnr;
            Xrecover = admmret_L1.Xrecover;
            save(dataName, 'Xrecover','Psnr', 'lambda', 'r', 'beta', 'pic_name');
            
            % show recovered images
            figure;
            imshow(uint8(Xrecover));
            title(['PSNR=', num2str(Psnr)]);
        end
    end
end