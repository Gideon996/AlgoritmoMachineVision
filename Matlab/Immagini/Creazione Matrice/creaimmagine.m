clc; clear all; close all;

%appunti sulle scelte da fare e soluzioni a cui sono arrivato
%{ 
%generatore di matrici:
%in base alle dimensioni della matrice fornite in input determinare
dimensione immagine FATTO
%fissare distanza tra un cerchio e l'altro (scelta da me) -circa 40 pixel
centro-centro FATTO
%fissare pow cerchio (scelta da me)  -> raggio 13.5 pixel FATTO
%generare cerchi in maniera casuale FATTO
%inserire cerchi generati nell'immagine
%fissare angoli(dimensioni)
%inserire angoli nell'immagine

% matrice = ones (268,224,3); %lato lungo, lato corto, canale rgb
% matrice (50:100,150:200,1) = 0.2; 
% matrice (50:100,150:200,2) = 0.3;
% matrice (50:100,150:200,3) = 0.4;
% whos
% imagesc(matrice)
% impixelinfo
% imwrite(matrice,'nomefile.jpg','jpg') %salvare le immagini(matrice dei valori, nome del file, formato del file

%dal bordo al primo bordo del cerchio voglio 45 pixels (righe)
% "  "      "   "    "     "    "       "    42  "     (colonne) ->
% approssimo tutto a 45 così che uso un valore solo.


%sulla x voglio: 45+26*colonna+27*(colonna-1)+45
                 45+27*colonna+(distancacc-raggio*2)*(colonna-1)+45
%sulla y voglio: 45+26*riga+27*(riga-1)+45
%zeros(m,n) m righe e n colonne riempite di 0

%}
distanzab_cerchio=45;%distanza dal bordo
% raggior=10.5;%raggio di ogni cerchio
raggio=13;
raggior=raggio+0.5;
distanzacc=40;%distanza centro-centro
distanzab_angolo=floor(distanzab_cerchio/4);
spessore=floor(distanzab_angolo/2);

x=input('Inserisci numero di colonne: ');
y=input('Inserisci numero di righe: ');

m=distanzab_cerchio*2+(raggior*2)*floor(y)+(distanzacc-raggior*2)*(floor(y)-1);
n=distanzab_cerchio*2+(raggior*2)*floor(x)+(distanzacc-raggior*2)*(floor(x)-1);
matrice = zeros(m,n);

%inserisco gli angoli
pos=distanzab_angolo;
for j=1:spessore
    for i=distanzab_angolo:(distanzacc+distanzab_angolo)
        matrice(pos,i)=1;
        matrice(i, pos)=1;
        matrice(i, n-pos)=1;
        matrice(m-pos,i)=1;
        matrice(pos,n-i)=1;
        matrice(m-i, pos)=1;
    end
    pos=pos+1;
end

%genero numeri casuali con valori 0 o 1.
%numero è una matrice X x Y con la posizione dei cerchi.
posizione_cerchi=randi([0 1], y, x)
posizione=[];
posr=distanzab_cerchio+raggio+1;
posc=distanzab_cerchio+raggio+1;
p=1;
for i=1:y %righe
    for j=1:x %colonne
        if(posizione_cerchi(i,j)==1)
            posizione(p,1)=posr+randi([-(distanzacc/10) (distanzacc/10)], 1, 1);
            posizione(p,2)=posc+randi([-(distanzacc/10) (distanzacc/10)], 1, 1);
            p=p+1;
        end
        posc=posc+distanzacc;
    end
    posr=posr+distanzacc;
    posc=distanzab_cerchio+raggio+1;%resettare la riga
end

%disegno la matrice
[x,y] = meshgrid(1:n, 1:m);
for i=1:(p-1)
    inside = (x - posizione(i,2)).^2 + (y - posizione(i,1)).^2 <= raggio^2;
    matrice=matrice+inside;
end
figure; imshow(matrice);


