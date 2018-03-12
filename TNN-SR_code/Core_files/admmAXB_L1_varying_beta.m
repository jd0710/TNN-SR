function [ X,iterations, rho_final] = admmAXB_L1_varying_beta( A,B,X,M,known,rho,lambda, cof)

% solve  minimize ||X||_*-trace(A*X*B')

MAX_ITER = 200;

[m,n] = size(M);


N = X;
Y = zeros(m,n);
Z = Y;
W = rand(m,n);

AB = A'*B;
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
   
    %increase rho, i.e. penalty parameter beta in the paper
    val = rho*max(norm(X-lastX, 'fro'), norm(N-lastN, 'fro')) / norm(M, 'fro');
    if (val < 10e-3)    
        rho = cof*rho; 
    end           
    rho = min(rho, 10e10);   % beta_max = 10e10       
end

iterations = k;
rho_final = rho;
end

