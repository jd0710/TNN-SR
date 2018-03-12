function [ X,iterations] = admmAXB_L1( A,B,X,M,known,rho,lambda)

% solve  minimize ||X||_*-trace(A*X*B')

MAX_ITER = 200;

[m,n] = size(M);
%r = size(A,1);

N = X;
Y = zeros(m,n);
Z = Y;
W = rand(m,n);

%eigX = svd(X);

AB = A'*B;
%BA = B'*A;
eeppss = 0.0001;

for k = 1:MAX_ITER
    
    % X-update
    tem = 1/2*(N - Y/rho+mirt_idctn(W+Z/rho));    
    lastX = X;
    [u,sigma,v] = svd(tem);
    X = u*max(sigma-1/rho/2,0)*v';
    
    if(norm(X-lastX,'fro')/norm(M,'fro')<eeppss)
        break;
    end
    
    %W-update
    temp = mirt_dctn(X)-Z/rho;
    W = IFL_L1_Norm_solver(temp, rho/lambda );
    
    %N-update
    lastN = N;
    N = (Y+AB+rho*X)/rho;
    N = M.*known + N.*(ones(size(N))-known);
    
    if(norm(N-lastN,'fro')/norm(M,'fro')<eeppss)
        break;
    end
    
    %Y-update
    if(norm(X-N,'fro')/norm(M,'fro')<eeppss)
        break;
    end
    Y = Y+rho*(X-N);
    Z = Z+rho*(W-mirt_dctn(X));
    
end

iterations = k;

end
