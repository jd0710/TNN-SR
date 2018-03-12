function X = IFL_L1_Norm_solver(M, mu )
%IFL_1_Norm_SOLVER: Try to solve L1 norm minmization problem
%   \arg\min_X \| X \|_1 + \frac{\mu}{2} \| X-M \|_F^2
% Reference: 'Positive-Definite l1-Penalized Estimation of Large Covariance Matrices'

X = sign(M).*max(abs(M)-1/mu,0);

end

