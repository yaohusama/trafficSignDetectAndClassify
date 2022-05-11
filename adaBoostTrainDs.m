function [dim,direction,thresh,alpha] = adaBoostTrainDs(data,label,iter)
[m,~] = size(data);
D = ones(m,1)/m;
alpha = zeros(iter,1);
direction = zeros(iter,1);
dim = zeros(iter,1);
thresh = zeros(iter,1);
for i = 1:iter
    [aa,bb,cc,best_label,error] = buildSimpleStump(data,label,D);
    dim(i)=aa;
    direction(i)=bb;
%    s thresh(i)=cc;
    try
       thresh(i)=cc;
    catch
        cc
        thresh(i)
          "hello"
        continue
        
    end
%      dim(i),direction(i),thresh(i)=a,b,c;
    alpha(i) = 0.5*log((1-error)/max(error,1e-15));
    D = D.*(exp(-1*alpha(i)*(label.*best_label)));
    D = D/sum(D);
end