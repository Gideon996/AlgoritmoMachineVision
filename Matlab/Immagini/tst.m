clc; clear all; close all;
%test 1 funzionante
%{ 
I=imread('Untitled.bmp');
I=rgb2gray(I);
figure; imshow(I);

% [B,L,n,A] = bwboundaries(I,'noholes'); %riempimento pixel vuoti %trovo tutti gli oggetti nell'immagine 
% figure; imshow(label2rgb(L, @cool, [.5,.5,.5]));
% stats = regionprops(L, 'Area', 'Centroid');
% hold on 
% for i=1:n %Trovare i Bordi dell'immagine
%    boundary = B{i}; 
%    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1)
% end

[m,n]=size(I);
if(m<150 || n<150)
   a= 200/n;
   b=200/m;
   pr=min([a,b]);
   I=imresize(I,pr);
end
figure; imshow(I);
clear m n pr a b 
[B, L, C, An]=plotC(I);

BIT=codifica(I,C); 
BIT
% pos1=1;
% % pos2=1;
% 
% centri=[];
% % Angolo=[];
% for k = 1:length(B)
%     boundary = B{k};
%     delta_sq=diff(boundary).^2;
%     perimeter=sum(sqrt(sum(delta_sq, 2)));
%     area=stats(k).Area;
%     metric=4*pi*area/perimeter^2;
%     metric_string=sprintf('%2.2f', metric);
%     centroid=stats(k).Centroid;
%     if(metric>1 && metric<2)
%         plot(centroid(1), centroid(2), 'c*');
%         text(boundary(1,2),boundary(1,1),metric_string,'Color','b','FontSize',10,'FontWeight', 'bold');
%         centri(pos1, :)=centroid;
%         pos1=pos1+1;
% %     elseif(metric>0.20&&metric<0.4)
% %         plot(centroid(1), centroid(2), 'ko');
% %         text(boundary(1,2),boundary(1,1),metric_string,'Color','r','FontSize',10,'FontWeight', 'bold');
% %         Angolo(pos2, :)=centroid;
% %         pos2=pos2+1;
%     end
% end
% hold off 

% for i=1:length(centri(:,1))
%     r(i)=centri(i,2);
%     c(i)=centri(i,1);
% end
% r=sort(r);
% c=sort(c);
% [m,n]=size(I);
% if(m<150 || n<150)
%    a= 200/n;
%    b=200/m;
%    pr=min([a,b]);
%    I=imresize(I,pr);
% end
%}

I=imread('immagine_mod.bmp'); %input
% figure; imshow(I); %stampa
% [m,n]=size(I(:, :, 1));
% x1=m/2-40;
% y1=n/2-40;
% x2=150;
% y2=150;
% I3=imcrop(I, [y1 x1 x2 y2]); %ritaglio l'immagine circa dove mi interessa
% figure; imshow(I3);
% J = imadjust(I3,stretchlim(I3),[]); %miglioro la luminosità
J = imadjust(I,stretchlim(I),[]);
I=imcomplement(J); %negativo immagine
I=rgb2gray(I); %scala di griggi
J = im2bw(I, 0.9); %trovo i bordi
gradiente_immagine = imgradient(J, 'sobel'); %filtro per il gradiente
I_minima = gradiente_immagine/max(gradiente_immagine(:));
I_minima = I_minima*100;
Immagine_filtrata = floor(I_minima);
Immagine_filtrata = Immagine_filtrata/100;
J = imbinarize(Immagine_filtrata); %binarizzo l'immagine con valori 0 o 1
I2=imfill(J, 'holes'); %riempio i buchi
a=calcolo_angolo(I2, 0.1); %ruoto l'immagine
I2=imrotate(I2, -a);
figure; imshow(I2); %immagine su cui lavorare

% [B, L, C, An]=plotC(I2);
I=ritaglio2(I2); %cerco e trovo la matrice
figure; imshow(I);

[m,n]=size(I); %ridimensiamo la matrice, ingrandendola 
if(m<150 || n<150)
   a= 200/n;
   b=200/m;
   pr=min([a,b]);
   I=imresize(I,pr);
end
figure; imshow(I);

clear a An b gradiente_immagine I2 I_minima Immagine_filtrata J m n pr; %cancello variabili inutili
[B, L, C, An]=plotC(I, 0.7); %cerco i cerchi

BIT=codifica(I, C); %Matrice bit
BIT
