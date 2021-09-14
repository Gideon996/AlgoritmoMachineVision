clc; clear all; close all;

tolleranza = 0.60;
posizione = 1;
C = {};
centri = [];

in=input('Inserisci il tipo di input: \n -0:crea immagine \n -1:input\n->');
if(in==1)
    I = imread('Matrice7.bmp');
    I = imcomplement(I);
    I = rgb2gray(I);
    figure; imshow(I)

    gradiente_immagine = imgradient(I, 'sobel');

    I_minima = gradiente_immagine/max(gradiente_immagine(:));
    I_minima = I_minima*100;
    Immagine_filtrata = floor(I_minima);
    Immagine_filtrata = Immagine_filtrata/100;

    figure; imshow(Immagine_filtrata);

    J = imbinarize(Immagine_filtrata); %binarizzo l'immagine con valori 0 o 1
    I2=imfill(J, 'holes');
    figure; imshow(I2);
    a=calcolo_angolo(I2, 0.1);
    I2=imrotate(I2, -a);
    figure; imshow(I2);
    rotate = ritaglio2(I2);
elseif(in ==0)
    str=creaimmagine2(4,5);
    I = imread(str);
    I = imcomplement(I);
%     I = rgb2gray(I);
    figure; imshow(I)

    gradiente_immagine = imgradient(I, 'sobel');

    I_minima = gradiente_immagine/max(gradiente_immagine(:));
    I_minima = I_minima*100;
    Immagine_filtrata = floor(I_minima);
    Immagine_filtrata = Immagine_filtrata/100;

    figure; imshow(Immagine_filtrata);

    J = imbinarize(Immagine_filtrata); %binarizzo l'immagine con valori 0 o 1
    I2=imfill(J, 'holes');
    figure; imshow(I2);
    a=calcolo_angolo(I2, 0.1);
    I2=imrotate(I2, -a);
    figure; imshow(I2);
    rotate = ritaglio2(I2);
elseif(in ==5)
    
else
    error('Numero sbagliato');
end
%INIZIO A LAVORARE NUOVAMENTE DA QUI'
%per usare la funzione raddrizza l'immagine deve essere per forza riempita
%e chi lo sapeva? ahahah
% I2 = raddrizza(I2);


rotate = rotazione2(rotate, I2);
figure; imshow(rotate);

[B,L,n,A] = bwboundaries(rotate,'noholes'); %riempimento pixel vuoti %trovo tutti gli oggetti nell'immagine 
figure; imshow(label2rgb(L, @cool, [.5,.5,.5]));
stats = regionprops(L, 'Area', 'Centroid');
hold on 
for i=1:n %Trovare i Bordi dell'immagine
   boundary = B{i}; 
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1)
end

for i=1:n %Trovare tutti i cerchi e i propri centri
    boundary = B{i};
    delta_sq=diff(boundary).^2;
    perimeter=sum(sqrt(sum(delta_sq, 2)));
    area=stats(i).Area;
    metric=4*pi*area/perimeter^2;
    if (metric>tolleranza)
        centroid=stats(i).Centroid;
        plot(centroid(1), centroid(2), 'ko');
        C(posizione)=B(i);
        centri(posizione, :)=centroid; %prima posizione colonna, seconda riga
        posizione=posizione+1;
    end
end
hold off 
[m,n]=size(rotate)
BIT=codifica(rotate, centri); 
BIT
