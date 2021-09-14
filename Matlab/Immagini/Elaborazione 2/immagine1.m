clc;
clear all;
close all;

%Leggo l'immagine
I=imread('posizione6.bmp');
figure; imshow(I);
%filtro l'immagine così da lasciare solo la matrice
J=filtraggio(I); %commentato
% figure; imshow(J);
% J=imcomplement(J);
figure; imshow(J);
% J=imcomplement(J);
%cerco gli angoli
[B, L, C, An]=calcolo_cerchi(J); %commentato
%ritaglio l'immagine dove ci sono gli angoli
I=ritaglio2(J, An); %commentato
% figure; imshow(I);
%cerco i cerchi e li codifico in bit
[B, L, C, An]=calcolo_cerchi(I);
Bit=codifica(I, C)