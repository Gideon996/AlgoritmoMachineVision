clc; clear all;%cancello tutti i valori precedenti

tolleranza=0.94; %Mi serve per capire quando c'è un cerchio o meno
posizione=1; %variabile usata per determinare una posizione in un array
C={}; %Array di celle dove salvo la posizione dei cerchi
centri=[]; %salvo la posizione dei centri dei cerchi
% RGB=imread('Matrice_tagliata.bmp'); %Apro l'immagine
Negativo_RGB=imread('Matrice.bmp'); %Apro l'immagine
% Negativo_RGB = imcomplement(RGB); %Ne faccio il negativo

trv=0;
%figure; imshow(RGB_1);
figure; imshow(Negativo_RGB); title('INPUT');

%determino tutti gli oggetti in figura
I = rgb2gray(Negativo_RGB); %converto in scala di grigi 


if(length(I(:,1))<length(I(1,:))) %controllo qual è il lato lungo 
    I=imrotate(I,90); %la ruoto di 90 gradi, può essere orientata correttamente come al contrario
end
%CERCO IL PRIMO COLORE BIT DI COLORE NERO

%Ho 4 casi differenti:
%caso 1: questo è il caso desiderato
%caso 2: matrice caso 1 specchiata
%caso 3: matrice caso 1 ruotata di 180°
%caso 4: matrice caso 2 ruotata di 180°

% CASO 3:
ext=1;
for i=1:length(I(:,1)) %RIGHE
     for j=1:length(I(1,:))%COLONNE
         if(I(i,j)==255) %il valore 255 è nero
             ext=0;
             crd(1)=i;
             crd(2)=j;
             break
         end
     end
     if(ext==0)
         break
     end
 end
halfofpoint=length(I(:,1))/2; %calcolo punto medio immagine 
if(crd(2) > halfofpoint) %controllo dov'è situata la 
    I=imrotate(I,180); %ruoto l'immagine di 180°
    trv=1;
end

% CASO 4:
if(trv==0)
    ext=1;
    for i=1:length(I(:,1))
        for j=length(I(1,:)):-1:1 %for inverso
            if(I(i,j)==255)
                ext=0;
                crd(1)=i;
                crd(2)=j;
                break
            end
        end
        if(ext==0)
            break
        end
    end
    halfofpoint=length(I(:,1))/2;
    if(crd(2) < halfofpoint)
        I=imrotate(I,180); 
        for i=1:length(I(:,1))
            for j=1:length(I(1,:))-1
                y=length(I(1,:))-j;
                NI(i,j)=I(i,y);
            end
        end
        I=NI;
        trv=1;
    end
end

% CASO 2:
if(trv==0)
    ext=1;
    for i=length(I(:,1)):-1:1
        for j=length(I(1,:)):-1:1
            if(I(i,j)==255)
                ext=0;
                crd(1)=i;
                crd(2)=j;
                break
            end
        end
        if(ext==0)
            break
        end
    end
    halfofpoint=length(I(:,1))/2;
    if(crd(2) > halfofpoint)
        for i=1:length(I(:,1))
            for j=1:length(I(1,:))-1
                y=length(I(1,:))-j;
                NI(i,j)=I(i,y);
            end
        end
        I=NI;
        trv=1;
    end
end
 
 
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
        C(posizione)=B(k);
        centri(posizione, :)=centroid; %prima posizione colonna, seconda riga
        posizione=posizione+1;
    end
end
hold off 

%conto quante righe e quante colonne ho nell'immagine
for i=1:length(centri(:,1))
    colonne(i)=centri(i,1);
    righe(i)=centri(i,2);
end

%ordinamento in maniera crescente
colonne = sort(colonne);
righe = sort(righe);
posrg = [];
poscl = [];

%conto se sono uguali
nr=1;
nc=1;
pos=1;
%conto il numero di colonne e salvo la coordinata di ogni colonna
for i=1:length(colonne)
    last=colonne(pos);
    if(i==1)
        poscl(i)=last;
    end
    a=last-2;
    b=last+2;
    if(a>colonne(i)||b<colonne(i))
        pos=i;
        nc=nc+1;
        poscl(nc)=colonne(i); %salvo il valore in coordinate
    end
end
%Conto il numero di righe e salco la coodinata di ogni riga
pos=1;
for i=1:length(righe)
    last=righe(pos);
    if(i==1)
        posrg(i)=last;
    end
    a=last-2; %53
    b=last+2; %57
    if(a>righe(i)||b<righe(i))
        pos=i;
        nr=nr+1;
        posrg(nr)=righe(i); %salvo il valore in coordinate
    end
end

%Codifico L'immagine in Bit, ovvero trovo tutte le coordinate dove è
%presente un cerchio e dove no. Quando trovo un cerchio lo aggiungo su BIT
BIT = zeros(nr,nc); %Creo una matrice di zeri con le dimensioni della griglia
for i=1:length(centri(:,1))
   for j=1:nc
       a=poscl(j)-3;
       b=poscl(j)+3;
       if(a<centri(i,1)&&b>centri(i,1))
           TMPC=j; %Salvo la cella che mi interessa dell'array poscl che mi interessa
           break
       end
   end
    for j=1:nr
       a=posrg(j)-3;
       b=posrg(j)+3;
       if(a<centri(i,2)&&b>centri(i,2))
           TMPR=j; %Salvo la cella che mi interessa dell'array posrg in questione
           break %inserisco il break perchè così non ho necessar bisogno di fare tutti i cicli
       end
    end
   BIT(TMPR, TMPC)=1; %Nella posizione desiderata dico che è presente un cerchio 
end
BIT %stampo la matrice BIT




