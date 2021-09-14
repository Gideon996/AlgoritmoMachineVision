
clc;
clear all;
close all;
I=imread('immagine_mod2.png');
figure; imshow(I);
J = imadjust(I,stretchlim(I),[]);
% figure; imshow(J);
% I=double(J);
% figure; imshow(I);
I=imcomplement(J);
I=rgb2gray(I);
% figure; imshow(I);
J = im2bw(I, 0.9);
% figure; imshow(J);
[m,n]=size(I);
gradiente_immagine = imgradient(J, 'sobel');
I_minima = gradiente_immagine/max(gradiente_immagine(:));
I_minima = I_minima*100;
Immagine_filtrata = floor(I_minima);
Immagine_filtrata = Immagine_filtrata/100;
% figure; imshow(Immagine_filtrata);
J = imbinarize(Immagine_filtrata); %binarizzo l'immagine con valori 0 o 1
I2=imfill(J, 'holes');
figure; imshow(I2);

a=calcolo_angolo(I2, 0.1);
I2=imrotate(I2, -a);
figure; imshow(I2);

[B,L,n,A] = bwboundaries(I2,'noholes'); %riempimento pixel vuoti %trovo tutti gli oggetti nell'immagine 
figure; imshow(label2rgb(L, @cool, [.5,.5,.5]));
stats = regionprops(L, 'Area', 'Centroid');
hold on 
for i=1:n %Trovare i Bordi dell'immagine
   boundary = B{i}; 
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1)
end

pos1=1;
pos2=1;

centri=[];
Angolo=[];
for k = 1:length(B)
    boundary = B{k};
    delta_sq=diff(boundary).^2;
    perimeter=sum(sqrt(sum(delta_sq, 2)));
    area=stats(k).Area;
    metric=4*pi*area/perimeter^2;
    metric_string=sprintf('%2.2f', metric);
    centroid=stats(k).Centroid;
    if(metric>1)
        plot(centroid(1), centroid(2), 'c*');
        text(boundary(1,2),boundary(1,1),metric_string,'Color','y','FontSize',10,'FontWeight', 'bold');
        centri(pos1, :)=centroid;
        pos1=pos1+1;
    elseif(metric>0.20&&metric<0.4)
        plot(centroid(1), centroid(2), 'ko');
        text(boundary(1,2),boundary(1,1),metric_string,'Color','r','FontSize',10,'FontWeight', 'bold');
        Angolo(pos2, :)=centroid;
        pos2=pos2+1;
    end
end
hold off 
% pos=1;
% Angolo = [];
% for k=1:n %Trovare tutti i cerchi e i propri centri
%         boundary = B{k};
%         delta_sq=diff(boundary).^2;
%         perimeter=sum(sqrt(sum(delta_sq, 2)));
%         area=stats(k).Area;
%         metric=4*pi*area/perimeter^2;
%         if (metric<0.4&&metric>0.2)
%             centroid=stats(k).Centroid;
%             Angolo(pos, :)=centroid;
%             pos=pos+1;
%         end
% end

%[immagine] = imcrop( Immagine, [x1 y1 x2 y2] )

% e=(5*100);
% e=e/max([m,n]);
% pr = (5*100)/(max([m,n]));
% a=min(Angolo(:,1));
% b=min(Angolo(:,2))+e;
% c=(max(Angolo(:,1))-min(Angolo(:,1)))-e;
% d=(max(Angolo(:,2))-min(Angolo(:,2)))-e;
immagine = ritaglio2(I2);
[m,n]=size(immagine);
if(m<150 || n<150)
   a= 200/n;
   b=200/m;
   pr=min([a,b]);
   immagine=imresize(immagine,pr);
end
figure; imshow(immagine);
BIT=codifica(immagine, centri); 
BIT
