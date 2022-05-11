clear 
clc
%提取Haar特征
positiveRange=1:1000;
negativeRange=1:2000;
root_dir="RoadPic";
fileList=dir(root_dir);
numxtt=length(fileList);
HarrLike{1}=[1 -1];        
HarrLike{2}=[1 -1].';
HarrLike{3}=[1 -2 1];
HarrLike{4}=[1 -2 1].';
HarrLike{5}=[1 -1;-1 1];


baseSize=2:2:4;
stdSize=[20 20]; 
features=[];
Y=[];
for i=1:numxtt
    if strcmp(fileList(i).name,'.')==1||strcmp(fileList(i).name,'..')==1
        continue;
    else
        if (fileList(i).isdir)
            parentpath=root_dir+"/"+fileList(i).name;
            dirOutput = dir(fullfile(parentpath,'*.bmp'));
            fileNames = {dirOutput.name};
            for item =1:length(fileNames)
                picName=parentpath+"/"+fileNames{item};
                try
                    FaceRegion=zhaoyuan(picName);
                catch ErrorInfo
                    disp("not found"+picName);
                    continue;
                end
                if numel(size(FaceRegion))>2
                     FaceRegion=rgb2gray(FaceRegion);         
                end 
                FaceRegion=imresize(FaceRegion,stdSize);
                [II]=integralImage(FaceRegion);
                [fea]=extHarrLikeFeature(II,HarrLike,baseSize);
                features=[features;fea'];
                Y=[Y str2num(fileList(i).name)];
                disp(picName);
            end
            dirOutput = dir(fullfile(parentpath,'*.JPG'));
            fileNames = {dirOutput.name};
            for item =1:length(fileNames)
                picName=parentpath+"/"+fileNames{item};
%                 FaceRegion=imread(picName);
                try
                    FaceRegion=zhaoyuan(picName);
                catch ErrorInfo
                    disp("not found"+picName);
                    continue;
                end
                if numel(size(FaceRegion))>2
                     FaceRegion=rgb2gray(FaceRegion);            %将rgb图像转化为灰度图像
                end 
                FaceRegion=imresize(FaceRegion,stdSize);
                [II]=integralImage(FaceRegion);
                [fea]=extHarrLikeFeature(II,HarrLike,baseSize);
                features=[features;fea'];
                Y=[Y str2num(fileList(i).name)];
                disp(picName);
            end
        end
    end
end
save HarrLikeFeatures-2.mat features Y 
