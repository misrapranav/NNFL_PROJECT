function CV =  ANFIS (E,CE,PARAMS) 
    PARAMS  = PARAMS';
    GAUSS_MYU = reshape(PARAMS(1:6), 3, 2)';
    GAUSS_SIG = reshape(PARAMS(7:12), 3, 2)';
    R         = reshape(PARAMS(13:21), 1, 9);
    
    MEMBERSHIP= gaussian(E,CE,GAUSS_MYU,GAUSS_SIG);
    W = zeros(1,9);
    c = 1;
    for i = 1:3
        for j = 1:3
            W(c) = MEMBERSHIP(1,i)*MEMBERSHIP(2,j);
            c = c+1;
        end
    end 
    
    W = W./sum(W);
    
    W1 = W.*R;
    CV = sum(W1);  
    CV = min(5, CV);
    CV = max(-5,CV);
end

function OUT = gaussian(E,CE,GAUSS_MYU,GAUSS_SIG)
    
    OUT      = zeros(2,3);  
    OUT(1,:) = ((GAUSS_MYU(1,:) - E).^2)./(GAUSS_SIG(1,:).^2) ;
    OUT(2,:) = ((GAUSS_MYU(2,:) - CE).^2)./(GAUSS_SIG(2,:).^2); 
    OUT      =  exp(-OUT);
  
end


