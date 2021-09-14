clc; clear all; close all;

I = lettura('Matrice.bmp'); %leggo l'immagine filtrata.
figure; imshow(I);%stampo

%raddrizzare la figura se necessario
angolo=calcolo_angolo(I, 0.1);
I2=imrotate(I, -angolo);
figure; imshow(I2);%stampo l'immagine ruotata

