clc; clear all; close all;

I = imread('immagine_mod2.png');
I = imadjust(I,stretchlim(I),[]);
figure; imshow(I);
I=imcomplement(I);
J=rgb2gray(I);
Ibw = im2bw(J,0.8);
gradiente_immagine = imgradient(Ibw, 'prewitt'); %filtro per il gradiente
I_minima = gradiente_immagine/max(gradiente_immagine(:));
I_minima = I_minima*100;
Immagine_filtrata = floor(I_minima);
Immagine_filtrata = Immagine_filtrata/100;
J = imbinarize(Immagine_filtrata); %binarizzo l'immagine con valori 0 o 1
Ifill = imfill(J,'holes');
Iarea = bwareaopen(Ifill,100);
Ifinal = bwlabel(Iarea);
se = offsetstrel('ball',5,5);
erodedI = imerode(Ifinal,se);
erodedI=imbinarize(erodedI);
se=strel('disk', 5);
I=imdilate(erodedI, se);
figure; imshow(I);
% a=calcolo_angolo(I2, 0.1); %ruoto l'immagine
% I2=imrotate(I2, -a);
[B, L, C, An]=calcolo_cerchi(I);
I=ritaglio2(I); %cerco e trovo la matrice
figure; imshow(I);
% 
% [B, L, C, An]=plotC(I, 0.7); %cerco i cerchi
% 
% BIT=codifica(I, C); %Matrice bit
% BIT
