function [res] = myhsvdisplay(file)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
% rgb0=imread(file);
rgb0=myCLAHE(file);
[sizex,sizey,~]=size(rgb0);
rgb=im2double(rgb0);
r=rgb(:,:,1);
g=rgb(:,:,2);
b=rgb(:,:,3);

%   H 单位弧度
num=0.5*((r-g)+(r-b));
den=sqrt( (r-g).^2 + (r-b).*(g-b) );
theta=acos(num./(den+eps)); %分母+eps防止为0  acos得到的是弧度
H0=theta.*(g>=b);   %G>=B
H1=(2*pi-theta).*(g<b);  %G<B
H=H0+H1;
% %转成角度
% H=H.*360./(2*pi);

%   S
num=3.*min(min(r,g),b);
S=1-num./(r+g+b+eps);

%   I
I=(r+g+b)/3;

H=(H-min(min(H)))./(max(max(H))-min(min(H)));
S=(S-min(min(S)))./(max(max(S))-min(min(S)));
res=rgb0;
hsi=cat(3,H,S,I);
% //img_HSI to img_Out
for i=1:sizex
    for j=1:sizey
        hh=hsi(i,j,1);
        ss=hsi(i,j,2);
        ii=hsi(i,j,3);
        R=0;
        B=0;
        G=0;
        if(((hh<=0.056&hh>=0)|(hh>=0.740&hh<=1.0))&ss>=0.169&ss<=1.0&ii>=0.180&ii<=1.0)
%         if(hh>=20 & hh<312)
%             hh=0;
%             ss=0;
%             ii=0;
%         elseif(ss<0.1686||ii<0.1804)
%             hh=0;
%             ss=0;
%             ii=0;
%         elseif(hh>0 & hh<20)
%             B = ii * (1 - ss);
% 			R = ii * (1 + (ss * cos(hh * pi / 180)) / (cos((60 - hh) * pi / 180)));
% 			G = 3 * ii - (R + B);
%         elseif(hh>=312)
%             hh = hh - 120;
% 			R = I * (1 - ss);
% 			G = I * (1 + (ss * cos(hh * pi / 180)) / (cos((60 - hh) * pi / 180)));
% 			B = 3 * I - (R + G);
%         end
%         if(R>0 | B>0 | G>0)
            res(i,j,1)=rgb0(i,j,1);
            res(i,j,2)=rgb0(i,j,2);
            res(i,j,3)=rgb0(i,j,3);
        else
            res(i,j,1)=0;
            res(i,j,2)=0;
            res(i,j,3)=0;
        end
    end
end

% res=cat(3,resr,resg,resb);


% imshow(res);



end