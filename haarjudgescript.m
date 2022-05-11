%%  
% * adaboost多分类
% 
%% 
clc
clear
close all
data = load('HarrLikeFeatures-2.mat');
HarrLikeFeatures=data.features;
Y=data.Y';
num_train =length(Y)-100;
choose = randperm(size(HarrLikeFeatures,1));
train_data = HarrLikeFeatures(choose,:);
size(train_data);
label_train = Y(choose,end);
HarrLike{1}=[1 -1];        
HarrLike{2}=[1 -1].';
HarrLike{3}=[1 -2 1];
HarrLike{4}=[1 -2 1].';
HarrLike{5}=[1 -1;-1 1];
stdSize=[20 20]; 
%% adaboost的构建与训练
num = 0;
iter = 20;%规定弱分类器的个数
category=[5,10,15,20,30,40,50,60,70,80,90,100,110,120];
numc=14;
baseSize=2:2:4;
for i = 1:numc-1 %5类
    for j = i+1:numc
        num = num + 1;
        %重新归类
        index1 = find(label_train == category(i));
        index2 = find(label_train == category(j));
        label_temp = zeros((length(index1)+length(index2)),1);
        label_temp(1:length(index1)) = 1;
        label_temp(length(index1)+1:length(index1)+length(index2)) = -1;
        train_temp = [train_data(index1,:);train_data(index2,:)];
        model{num} = adaboost_train(label_temp,train_temp,iter);
        i
        j
    end
end

features=[];
Y=[];
parentpath="正样本40";
dirOutput = dir(fullfile(parentpath,'*.bmp'));
fileNames = {dirOutput.name};
for item =1:length(fileNames)
    picName=parentpath+"/"+fileNames{item};
%                 FaceRegion=imread(picName);
%     try
%         FaceRegion=zhaoyuan(picName);
%     catch ErrorInfo
%         disp("not found"+picName);
%         continue;
%     end
%                 imshow(FaceRegion);
%                 picName=strcat('nonface',num2str(i),'.bmp');
    FaceRegion=imread(picName);
%     if numel(size(FaceRegion))>2
%          FaceRegion=rgb2gray(FaceRegion);            %将rgb图像转化为灰度图像
%     end 
%     FaceRegion=imresize(FaceRegion,stdSize);
    [II]=integralImage(FaceRegion);
    [fea]=extHarrLikeFeature(II,HarrLike,baseSize);
%     [fea]=getfeature(FaceRegion);
%                 features(i+positiveNum,:)=fea';
    features=[features;fea'];
    if ~isempty(strfind(fileNames{item},'-'))
        tmpfilename=strsplit(fileNames{item},'-');
%     tmpfilename{1,1}
        Y=[Y str2num(tmpfilename{1,1})];
    else
        tmpfilename=strsplit(fileNames{item},'.');
         Y=[Y str2num(tmpfilename{1,1})];
    end

end
test_data=features;
label_test=Y';

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
%% show the result--testing
figure;
gscatter(test_data(:,1),test_data(:,2),predict);
accuracy = length(find(predict==label_test))/length(test_data);
title(['predict the testing data and the accuracy is :',num2str(accuracy)]);