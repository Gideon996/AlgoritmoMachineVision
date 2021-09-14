clc; clear all; close all;
I = imread('posizione4.bmp');
I = imadjust(I,stretchlim(I),[]);
I=imcomplement(I); %negativo immagine
I=rgb2gray(I);
Ibw = im2bw(I,0.8);
gradiente_immagine = imgradient(Ibw, 'sobel'); %filtro per il gradiente
I_minima = gradiente_immagine/max(gradiente_immagine(:));
I_minima = I_minima*100;
Immagine_filtrata = floor(I_minima);
Immagine_filtrata = Immagine_filtrata/100;
J = imbinarize(Immagine_filtrata); %binarizzo l'immagine con valori 0 o 1

Ifill = imfill(J,'holes');
Iarea = bwareaopen(Ifill,100);
Ifinal = bwlabel(Iarea);

figure; imshow(Ifinal);
% stat = regionprops(Ifinal,'BoundingBox');
% figure; imshow(I); hold on;
% for cnt = 1 : numel(stat)
%     bb = stat(cnt).BoundingBox;
%     rectangle('position',bb,'edgecolor','r','linewidth',2);
% end

% a = imread('Matrice.bmp');
% a=rgb2gray(a);
% bw = a < 100;
% imshow(bw)
% title('Image with Circles')
% stats = regionprops('table',bw,'Centroid',...
%     'MajorAxisLength','MinorAxisLength')
% centers = stats.Centroid;
% diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
% radii = diameters/2;
% hold on
% viscircles(centers,radii);
% hold off