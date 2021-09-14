clc; clear all;
img = im2double(imread('Matrice_tagliata.bmp'));
bw=rgb2gray(img);
figure; imshow(bw);

angle=horizon(bw,0.1);
angle=abs(angle);
rotate=imrotate(bw, angle);
%angolo circa corretto è il 21°
% rotate = imrotate(bw, f);
figure; imshow(rotate);
% d = imrotate(bw, );
% figure; imshow(d);
% for i=1:length(bw(1,:))
%     if(bw(1,i) != 0)
%         break;
%     else
%         n=n+1;
%     end
% end