clc; clear all;

intens = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5];
I = imread('Matrice.bmp');
I = imnoise(I, 'salt & pepper', intens(4)); %se aumenta l'intensità aumento devo aumentare anche [m n]
% figure; imshow(J);
J = imcomplement(I);
J = rgb2gray(J);
figure; imshowpair(I,J, 'montage');

K = medfilt2(J, [5 5]);
figure; imshowpair(J,K, 'montage');