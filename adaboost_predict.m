function predict = adaboost_predict(data,model)
h = zeros(model.iter,1);
for j = 1:model.iter
    if model.direction(j) == -1
        if data(model.dim(j)) <= model.thresh(j)
            h(j) = -1;
        else
            h(j) = 1;
        end
    elseif model.direction(j) == 1
        if data(model.dim(j)) <= model.thresh(j)
            h(j) = 1;
        else
            h(j) = -1;
        end
    end
end
predict = sign(model.alpha'*h);