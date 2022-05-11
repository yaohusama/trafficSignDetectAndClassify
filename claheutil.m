%% 
tic
%% 清空工作区与变量
clc;
clear;
% for image_number=1:1
imageName="RoadPic/5/1_1.bmp";
img = imread(imageName);

%% 在LAB空间进行去雾
% RGB转LAB
transform = makecform('srgb2lab');  
LAB = applycform(img,transform);  
% 提取亮度分量 L
L = LAB(:,:,1); 
% 对L进行CLAHE
LAB(:,:,1) = My_adapthisteq(L);
% 减小一定的亮度
LAB(:,:,1) = LAB(:,:,1)-50;
%% 转回到RGB空间
cform2srgb = makecform('lab2srgb');  
J = applycform(LAB, cform2srgb);
  J = 1.35.*J;
%% 输出图像
      
% end
    toc
    figure;
    subplot(121),imshow(img);
     subplot(122 );imshow(J);
