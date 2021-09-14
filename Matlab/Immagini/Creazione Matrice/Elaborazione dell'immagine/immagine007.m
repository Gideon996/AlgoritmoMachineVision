clc; clear all;

tolleranza = 0.70;
posizione = 1;
C = {};
centri = []; 

I=imread('MatriceGamma.bmp');%Uso la funzione lettura
J=rumore(I, 0.2, 0.2);
figure; imshow(J); title('Input con rumore');
Negativo_RGB = imcomplement(J);
bw = rgb2gray(Negativo_RGB);
bw=filtri(bw);
figure; imshow(bw); title('Input Filtrato'); %Stampo l'immagine in input
rotate = rotazione(0, bw, 1); %Uso la funzione rotazione per ruotare l'immagine
figure; imshow(rotate); title('Immagine Ruotata');%Stampo l'immagine ruotata
image_cropped = ritaglio2(rotate, tolleranza); %ritaglia l'immagine 
image_cropped2 = rotazione(rotate, image_cropped, 2); %ruota l'immagine di tipo 2
figure; imshow(rotate); title('Immagine Ruotata2'); %stampo l'immagine da elaborare
figure; imshow(image_cropped2); title('Matrice dove lavorare');

[B,L,n,A] = oggetti(image_cropped2); %trovo tutti gli oggetti nell'immagine 
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

[rg, cl, nr, nc]=trova_cerchi(centri); %calcolo il numero di righe, numero colonne e le loro coordinate
BIT=codifica(centri); %codifica l'immagine in bit
BIT