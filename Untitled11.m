clc
clear
close all
%% 加载数据
% * 最终data格式：m*n，m样本数，n维度
% * label:m*1  标签为-1与1这两类
clc
clear
close all
data = load('HarrLikeFeatures-2.mat');
HarrLikeFeatures=data.HarrLikeFeatures;
Y=data.Y';
%选择训练样本个数
num_train =length(Y)-100;
%构造随机选择序列
choose = randperm(length(data));
train_data = HarrLikeFeatures(choose(1:num_train),:);
label_train = Y(choose(1:num_train),end);

test_data = HarrLikeFeatures(choose(num_train+1:end),:);
label_test = Y(choose(num_train+1:end),end);
predict = zeros(length(test_data),1);
%% -------训练集训练所有的弱分类器
iter = 50; %规定弱分类器的个数
[dim,direction,thresh,alpha] = adaBoostTrainDs(train_data,label_train,iter);
%% -------预测测试集的样本分类
for i = 1:length(test_data)
    data_temp = test_data(i,:);
    h = zeros(iter,1);
    for j = 1:iter
        if direction(j) == -1
            if data_temp(dim(j)) <= thresh(j)
                h(j) = -1;
            else
                h(j) = 1;
            end
        elseif direction(j) == 1
            if data_temp(dim(j)) <= thresh(j)
                h(j) = 1;
            else
                h(j) = -1;
            end
        end
    end
    predict(i) = sign(alpha'*h);
end
%% 显示结果
figure;
index1 = find(predict==1);
data1 = (test_data(index1,:))';
plot(data1(1,:),data1(2,:),'or');
hold on
index2 = find(predict==-1);
data2 = (test_data(index2,:))';
plot(data2(1,:),data2(2,:),'*');
hold on
indexw = find(predict~=(label_test));
dataw = (test_data(indexw,:))';
plot(dataw(1,:),dataw(2,:),'+g','LineWidth',3);
accuracy = length(find(predict==label_test))/length(test_data);
title(['predict the testing data and the accuracy is :',num2str(accuracy)]);