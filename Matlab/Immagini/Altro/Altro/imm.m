clc; clear all;%cancello tutti i valori precedenti
tolleranza=0.94; %Mi serve per capire quando c'è un cerchio o meno
posizione(1)=1;%variabile usata per determinare una posizione in un array
posizione(2)=1;
C={}; %Array di celle dove salvo la posizione dei cerchi
centri=[]; %salvo la posizione dei centri dei cerchi
angolo=[];
RGB=imread('Matrice.bmp'); %Apro l'immagine
Negativo_RGB = imcomplement(RGB); %Ne faccio il negativo
trv=0;
%figure; imshow(RGB_1);
figure; imshow(Negativo_RGB); title('INPUT');

%determino tutti gli oggetti in figura
I = rgb2gray(Negativo_RGB); %converto in scala di grigi 

threshold = graythresh(I); %converte l'immagine in binario
bw = im2bw(I,threshold); %converte l'immagine in scala di grigi in binario
bw = bwareaopen(bw,30); %Elimina tutte le impurità causate con l'operazione precedente
se = strel('disk',2); 
bw = imclose(bw,se); %chiusura dell'immagine su se
bw = imfill(bw, 'holes'); 
[B,L,n,A] = bwboundaries(bw,'noholes'); %riempimento pixel vuoti
%questa funzione restituisce gli oggetti su B e il numero su n, L è la
%matrice dell'immagine. A non mi interessa

figure; imshow(label2rgb(L, @jet, [.5,.5,.5])); %label(matrice_immagine, gamma colori, sfondo)
%calcola varie parti dell'immagine 
stats = regionprops(L, 'Area', 'Centroid');
%determinare dei 16 oggetti quale siano i cerchi
hold on %tutte le componenti si sovrapporrano allo stesso plot
%determino tutti i bordi degli oggetti e li segno 
for k = 1:n
   boundary = B{k}; 
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1)
end
%Determino solo i cerchi grazie ad una funzione che mi permette di avere un
%valore tra 0 e 1 dove i valori più vicini ad 1 sono cerchi
for k=1:n
    boundary = B{k};
    delta_sq=diff(boundary).^2;
    perimeter=sum(sqrt(sum(delta_sq, 2)));
    area=stats(k).Area;
    metric=4*pi*area/perimeter^2;
    if metric>tolleranza
        centroid=stats(k).Centroid;
        plot(centroid(1), centroid(2), 'ko');
        C(posizione(1))=B(k);
        centri(posizione(1), :)=centroid; %prima posizione colonna, seconda riga
        posizione(1)=posizione(1)+1;
    else
        centroid=stats(k).Centroid;
        plot(centroid(1), centroid(2), 'ko');
        D(posizione(2))=B(k);
        angolo(posizione(2), :)=centroid; %righe, colonne
        posizione(2)=posizione(2)+1;
    end
end
hold off
% a=angolo(1,1)^2-angolo(2,1)^2
a=sqrt((angolo(1,1)-angolo(2,1))^2+((angolo(1,2)-angolo(2,2))^2))
b=0;
c=0;