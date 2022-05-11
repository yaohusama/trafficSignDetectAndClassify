%%  
% * adaboost多分类
% 
%% 
clc
clear
close all
stdSize=[20 20]; 
features=[];
Y=[];
parentpath="正样本40";
dirOutput = dir(fullfile(parentpath,'*.bmp'));
fileNames = {dirOutput.name};
for item =1:length(fileNames)
    picName=parentpath+"/"+fileNames{item};
    FaceRegion=imread(picName);
    if numel(size(FaceRegion))>2
         FaceRegion=rgb2gray(FaceRegion);            %将rgb图像转化为灰度图像
    end 
    FaceRegion=imresize(FaceRegion,stdSize);
    [fea]=getfeature(FaceRegion);
    features=[features;fea];
    if ~isempty(strfind(fileNames{item},'-'))
        tmpfilename=strsplit(fileNames{item},'-');
        Y=[Y str2num(tmpfilename{1,1})];
    else
        tmpfilename=strsplit(fileNames{item},'.');
         Y=[Y str2num(tmpfilename{1,1})];
    end

end
choose = randperm(size(features,1));
train_data=features(choose,:);
label_train=Y';
label_train=label_train(choose,end);
data = load('HuLikeFeatures.mat');
HarrLikeFeatures=data.features;
Y=data.Y';
num_train =length(Y)-100;

test_data = HarrLikeFeatures(:,:);
size(test_data);
label_test = Y(:,end);

%% adaboost的构建与训练
num = 0;
iter =200;%规定弱分类器的个数
category=[5,15,30,40,50,60,70,80,90,100,110,120];%10,20
numc=12;
for i = 1:numc-1 %5类
    for j = i+1:numc
        num = num + 1;
        %重新归类
        index1 = find(label_train == category(i));
        index2 = find(label_train == category(j));
        if(length(index1)==0 | length(index2)==0)
            "wrong answer"
            i
            j
            continue;
        end
        label_temp = zeros((length(index1)+length(index2)),1);
        label_temp(1:length(index1)) = 1;
        label_temp(length(index1)+1:length(index1)+length(index2)) = -1;
        train_temp = [train_data(index1,:);train_data(index2,:)];
        model{num} = adaboost_train(label_temp,train_temp,iter);
    end
end


% 用模型来预测测试集的分类
predict = zeros(length(test_data),1);
for i = 1:length(test_data)
    data_test = test_data(i,:);
    num = 0;

    addnum = zeros(1,numc);
    for j = 1:numc-1
        for k = j+1:numc
            num = num + 1;
            temp = adaboost_predict(data_test,model{num});
            if temp > 0
                addnum(j) = addnum(j) + 1;
            else
                addnum(k) = addnum(k) + 1;
            end
        end
    end
    [~,predict(i)] = max(addnum);
    predict(i)=category(predict(i));
end
%% 显示结果
figure;
gscatter(test_data(:,1),test_data(:,2),predict);
accuracy = length(find(predict==label_test))/length(test_data);
title(['predict the testing data and the accuracy is :',num2str(accuracy)]);
pause(10);
test_data=train_data;
label_test=label_train;

% 用模型来预测测试集的分类
predict = zeros(length(test_data),1);
for i = 1:length(test_data)
    data_test = test_data(i,:);
    num = 0;

    addnum = zeros(1,numc);
    for j = 1:numc-1
        for k = j+1:numc
            num = num + 1;
            temp = adaboost_predict(data_test,model{num});
            if temp > 0
                addnum(j) = addnum(j) + 1;
            else
                addnum(k) = addnum(k) + 1;
            end
        end
    end
    [~,predict(i)] = max(addnum);
    predict(i)=category(predict(i));
end
%% 显示结果
figure;
gscatter(test_data(:,1),test_data(:,2),predict);
accuracy = length(find(predict==label_test))/length(test_data);
title(['predict the training data and the accuracy is :',num2str(accuracy)]);