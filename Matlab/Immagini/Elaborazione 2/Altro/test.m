clc; close all; clear all;

sceneImage = imread('posizione4.bmp');
sceneImage=imcomplement(sceneImage);
Gray = rgb2gray(sceneImage) ;
figure; imshow(Gray);
Gray=im2bw(Gray, 0.8);
figure; imshow(Gray);
% B = imbinarize(sceneImage);
C=edge(Gray, 'log');
C=imbinarize(C);
figure; imshow(C);
B=xor(Gray, C);
figure;imshow(B);
% % sceneImage = imadjust(sceneImage,stretchlim(sceneImage),[]);
% sceneImage=imcomplement(sceneImage);
% J=rgb2gray(sceneImage);
% 
% figure; imshow(J);
% Ibw = im2bw(J,0.8);
% figure; imshow(Ibw);
% gradiente_immagine = imgradient(Ibw, 'sobel'); %filtro per il gradiente
% I_minima = gradiente_immagine/max(gradiente_immagine(:));
% I_minima = I_minima*100;
% Immagine_filtrata = floor(I_minima);
% Immagine_filtrata = Immagine_filtrata/100;
% J = imbinarize(Immagine_filtrata); %binarizzo l'immagine con valori 0 o 1
% Ifill = imfill(J,'holes');
% Iarea = bwareaopen(Ifill,100);
% Ifinal = bwlabel(Iarea);
% se = offsetstrel('ball',7,2);
% erodedI = imerode(Ifinal,se);
% erodedI=imbinarize(erodedI);
% se=strel('disk', 5);
% sceneImage=imdilate(erodedI, se);
% figure;imshow(sceneImage);
% a=calcolo_angolo(sceneImage, 0.1); %ruoto l'immagine
% sceneImage=imrotate(sceneImage, -a);
% 
% [B, L, C, An]=calcolo_cerchi(sceneImage);
% I=ritaglio2(sceneImage, An);
% figure; imshow(I);
% [B, L, C, An]=calcolo_cerchi(I);
% Bit=codifica(I, C)