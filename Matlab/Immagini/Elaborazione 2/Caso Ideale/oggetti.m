function [B,L,n,A] = oggetti(image)
    %{
    In input prende l'immagine in scala di grigi, la quale viene elaborata
    e vengono trovate tutti gli ogetti, i quali sono riempiti. 
    In output vengono restituiti B,L,n,A, dove:
    -B: Contiene tutte le coordinate degli ogetti trovati;
    -L: Immagine elaborata;
    -n: Numero di ogetti trovati;
    -A: Matrice delle adiacenze;
    %}
    threshold = graythresh(image); %converte l'immagine in binario
    bw = im2bw(image,threshold); %converte l'immagine in scala di grigi in binario
    bw = bwareaopen(bw,30); %Elimina tutte le impurità causate con l'operazione precedente
    se = strel('disk',2); 
    bw = imclose(bw,se); %chiusura dell'immagine su se
    bw = imfill(bw, 'holes'); 
    [B,L,n,A] = bwboundaries(bw,'noholes'); %riempimento pixel vuoti
end