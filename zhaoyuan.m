function [IMG_New]= zhaoyuan(filename)
    se=strel('square',3); 
%     RGB0=myhsvdisplay(filename);
%     RGB0=imclose(RGB0,se);        %闭合操作
%     RGB0=imopen(RGB0,se);         %开启操作
     RGB0=myCLAHE(filename);
    IMG_In = myCLAHE(filename);
    [centers, radii, metric] = imfindcircles(RGB0,[6,500] );%,'Sensitivity',0.9
    numc=size(centers,1);
    for item =1:numc
        centersStrong5 = centers(item:item,:); 
        radiiStrong5 = radii(item:item);
        metricStrong5 = metric(item:item);
        % viscircles(centersStrong5, radiiStrong5,'EdgeColor','b');
        Radius=radiiStrong5;
        Center=centersStrong5;
        if ~(abs(Center(1)-Radius)<0 & abs(Center(2)-Radius)<0)
            [m,n,~]=size(IMG_In);
            [X,Y]=meshgrid(1:n,1:m);
            R_temp=sqrt((X-Center(1)).^2+(Y-Center(2)).^2);
            R_temp1=R_temp<=Radius;
            if(numel(size(IMG_In))>2)
                R_Out=R_temp1.*im2double(IMG_In(:,:,1));
                G_Out=R_temp1.*im2double(IMG_In(:,:,2));
                B_Out=R_temp1.*im2double(IMG_In(:,:,3));
                IMG_Out(:,:,1)=R_Out;
                IMG_Out(:,:,2)=G_Out;
                IMG_Out(:,:,3)=B_Out;
            else
                IMG_Out=R_temp1.*im2double(IMG_In);
            end
            IMGTmp=RGB0(round(Center(2)-ceil(Radius/4)):round(Center(2)+floor(Radius/4)),round(Center(1)-ceil(Radius/4)):round(Center(1)+floor(Radius/4)),:);
%             imshow(IMGTmp);
            [w,h,~]=size(IMGTmp);
            flag=0;
            for i=1:w
                for j=1:h
                    if((IMGTmp(i,j,1)>150&IMGTmp(i,j,2)<100&IMGTmp(i,j,3)<100))%
                        flag=1;
                        break;
                    end

                end
                if flag==1
                    break;
                 end
            end
            
%             if numel(size(IMGTmp))>2
%                     IMGTmp=rgb2gray(IMGTmp);            %将rgb图像转化为灰度图像
%             end 
%             se=strel('square',3); 
%             IMGTmp=imclose(IMGTmp,se);        %闭合操作
%             IMGTmp=imopen(IMGTmp,se);         %开启操作
%             IMGTmp = edge(IMGTmp,'canny');%Canny方法提取图像边界，返回二值图像(边界1,否则0)
%             [H,T,R] = hough(BW);%计算二值图像的标准霍夫变换，H为霍夫变换矩阵，I,R为计算霍夫变换的角度和半径值
%             P = houghpeaks(H,1);%提取3个极值点
%             lines=houghlines(BW,T,R,P);%提取线段
%                [L,num] = bwlabel(IMGTmp,4);
            
%             if(length(lines)>0&sqrt((lines(1).point1(1)-lines(1).point2(1))^2+(lines(1).point1(2)-lines(1).point2(2))^2)>0.3*radii)
%                 lines(1).point1(1)-lines(1).point2(1)
%                 lines(1).point2
            if(flag==1)%
                continue;
            else
                IMG_New=IMG_Out(round(Center(2)-Radius-1):round(Center(2)+Radius+1),round(Center(1)-Radius-1):round(Center(1)+Radius)+1,:);
                break;
            end
        
        end
    end
    
    % imshow(RGB0);
     imshow(IMG_New);
end

