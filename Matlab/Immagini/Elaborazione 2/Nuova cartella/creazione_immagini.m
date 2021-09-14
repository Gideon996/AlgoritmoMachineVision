clc; close all; clear all;

% I=imread('14_san-giorgio_ragusa.jpg.800x700_q85.jpg');
I=imread('14_san-giorgio_ragusa.jpg.800x700_q85.jpg');
figure; imshow(I);title('originale');
J=rgb2gray(I);
% J=I;
figure; imshow(J);

BW1 = edge(J,'Sobel');
BW1=imcomplement(BW1);
figure; imshow(BW1);

BW2 = edge(J,'Canny');
BW2=imcomplement(BW2);
figure; imshow(BW2);

se = strel('line',11,90);
se2 = offsetstrel('ball',5,5);

erode1=imerode(J,se);
erode2=imerode(J,se2);
figure; imshow(erode1); title('eroso linea');
figure; imshow(erode2); title('eroso palla');

dilatate1=imdilate(J,se);
dilatate2=imdilate(J,se2); 
figure; imshow(dilatate1); title('dilatato linea');
figure; imshow(dilatate2); title('dilatato palla');


J2=imread('150822397-227f7374-6f79-49ac-8ff4-5789e390177c.jpg');
figure; imshow(J2);
J3=rgb2gray(J2);
figure; imshow(J3);
BW1 = edge(J3,'Canny');
figure; imshow(BW1);
J4=imfill(BW1, 'holes');
figure; imshow(J4); title('riempito');

H=im2bw(J, 0.6);
figure; imshow(H);
