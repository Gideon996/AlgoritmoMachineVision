clc; clear all; close all;

I=imread('posizione4.bmp');
figure; imshow(I);
J = imadjust(I,stretchlim(I),[]);
figure; imshow(J);
I=imcomplement(J); %negativo immagine
I=rgb2gray(I); %scala di griggi
J = im2bw(I, 0.9);
figure; imshow(J);

gradiente_immagine = imgradient(J, 'sobel'); %filtro per il gradiente
I_minima = gradiente_immagine/max(gradiente_immagine(:));
I_minima = I_minima*100;
Immagine_filtrata = floor(I_minima);
Immagine_filtrata = Immagine_filtrata/100;
J = imbinarize(Immagine_filtrata); %binarizzo l'immagine con valori 0 o 1
figure; imshow(J);
I2=imfill(J, 'holes'); %riempio i buchi
figure; imshow(I2);
% a=calcolo_angolo(I2, 0.1); %ruoto l'immagine
% I2=imrotate(I2, -a);
[B, L, C, An]=calcolo_cerchi(I2);
% I=rit(I2); %cerco e trovo la matrice
% figure; imshow(I);
% 
% [B, L, C, An]=plotC(I, 0.7); %cerco i cerchi
% 
% BIT=codifica(I, C); %Matrice bit
% BIT
