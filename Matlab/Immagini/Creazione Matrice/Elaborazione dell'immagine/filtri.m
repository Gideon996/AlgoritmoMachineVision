function [immagine] = filtri(image)
    dimensione_filtro=3;
    I = medfilt2(image, [dimensione_filtro dimensione_filtro]); %rimuove il salt&pepper noise
    
    %filtro per la gaussiana 
    sigma = 1; %deviazione standard della distribuzione
    %Si normalizza il kernel quindi ci importa solo la parte esponenziale
    kernel = zeros(dimensione_filtro,dimensione_filtro); %kernel 5x5 (troppo grande
    W=0; %somma degli elementi del kernel per la normalizzazione
    centro=length(kernel(:,1))-2;
    for i=1:length(kernel(:,1))
        for j=1:length(kernel(:,1))
            sq_dist=(i-centro)^2+(j-centro)^2; %distanza dal centro
            kernel(i,j)=exp(-1*(sq_dist)/(2*sigma*sigma)); %valore dell'esponenziale della gaussiana
            W=W+kernel(i,j);
        end
    end
    kernel=kernel/W; %normalizzazione

    %applico il filtro 
    [m,n]=size(I);
    output=zeros(m,n); %immagine di uscita
    Im = padarray(I, [2 2]);
    a=dimensione_filtro-1;
    for i=1:m
        for j=1:n
            temp=Im(i:i+a, j:j+a);
            temp=double(temp);
            conv = temp*kernel;
            output(i,j)=sum(conv(:));
        end
    end
    immagine=uint8(output);
end