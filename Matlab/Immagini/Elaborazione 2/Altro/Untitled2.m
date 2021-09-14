clc; clear all; close all;

I=imread('foglia.png');
figure; imshow(I);
I=rgb2gray(I);
figure; imshow(I);


gradiente_immagine = imgradient(I, 'sobel'); %Calcolo la dimensione del gradiente e la direzione
%     figure;imshsobelow(gradiente_immagine);
massimo=max(gradiente_immagine(:));
I_minima = gradiente_immagine/max(gradiente_immagine(:)); %trovo i valori minimi(più forti)
I_minima = I_minima*100; %salvo i valori minimi
Immagine_filtrata = floor(I_minima); %approssimo per difetto
Immagine_filtrata = Immagine_filtrata/100; %torno ai valori normali
J = imbinarize(Immagine_filtrata); %binarizzo l'immagine con valori 0 o 1
figure; imshow(J); title('qui');
Ifill = imfill(J,'holes');
figure; imshow(Ifill);
