function [ret] = TNN_SR_AP(matrix_pic,matrix_mask,R,lambda, beta, cof)
% This function implements the TNN-SR-AP algorithm 
% @ March 2018, Nanjing Tech University
% 
% Details about the algorithm can be found in the paper:
% J. Dong, Z. Xue, J. Guan, Z. Han, and W. Wang,
% "Low Rank Matrix Completion Using Truncated Nuclear Norm and Sparse Regularizer,"
% submitted to Signal Processing: Image Communication, March 2018.
%
% Inputs:
% matrix_pic: original matrix
% matrix_mask: mask matrix 
% R: r parameter in the defintion of the truncated nuclear norm
% lambda: regularizer parameter in the objective function
% beta: initial penalty parameter in the argumented Lagrangian funciton
% cof: constant to increase beta adaptively

% Outputs:
% ret.Psnr: PSNR of the recovered image
% ret.Xrecover: recovered image

% Written by Jing Dong,version 1.0                                    
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

Xfull = matrix_pic;
mask = matrix_mask;
Xmiss = Xfull.*mask;

[m, n, dim] = size(Xfull);
known = Xmiss(:,:,1) > 0;

Xrecover = zeros(m,n,3);
number_of_out_iter = 10;

for i = 1:3 % for different color channel
    X = Xmiss(:,:,i); % noisy data
    M = X;
    X_rec = zeros(size(Xmiss));
    for out_iter = 1:number_of_out_iter
        %out_iter
        [u, ~, v] = svd(X);
        A = u(:,1:R)'; B = v(:,1:R)';
        
        [X_rec(:,:,out_iter)] = admmAXB_L1_varying_beta(A,B,X,M,known,beta,lambda, cof);
        
        if(out_iter>=2 && norm(X_rec(:,:,out_iter)-X_rec(:,:,out_iter-1),'fro')/norm(M,'fro')<0.01)
            X = X_rec(:,:,out_iter);
            break;
        end
        X = X_rec(:,:,out_iter);
    end
    Xrecover(:,:,i) = X;
end
tem_recover=max(Xrecover(:,:,:),0);
tem_recover = min(tem_recover,255);

Psnr = PSNR(Xfull,tem_recover,ones(size(mask))-mask); 

Xrecover=max(Xrecover,0); 
Xrecover = min(Xrecover,255);

ret.Psnr = Psnr;
ret.Xrecover = Xrecover;
end