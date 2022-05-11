function model = adaboost_train(label,data,iter)
[model.dim,model.direction,model.thresh,model.alpha] = ...
    adaBoostTrainDs(data,label,iter);
model.iter = iter;