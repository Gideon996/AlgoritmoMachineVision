function [B, L, C, An] =calcolo_cerchi(Image)
    %B posizione oggetti, L immagine oggetti senza sfondo, n numero di
    %oggetti, A matrice delle adiacenze
    [B,L,n,A] = bwboundaries(Image,'noholes'); %traccia i bordi degli oggetti nell'immagine binaria eliminando lo sfondo
    %L immagine dei bordi, @cool colore riempimento bordi generato
    %casualmente, [ ] colore dello sfondo
    figure; imshow(label2rgb(L, @cool, [.5,.5,.5])); %stampo l'immagine degli oggetti riempiti casualmente con tipo @cool e mettendo come sfondo il color grigio
    %L immagine bordi, ' ' valori di interesse
    stats = regionprops(L, 'Area', 'Centroid');%calcola i valori indicati degli oggetti
    hold on %plotto tutto sullo stesso grafico
    for i=1:n %traccio i Bordi dell'immagine
        boundary = B{i}; 
        plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1)
    end
    pos1=1;
    pos2=1;

    centri=[];
    Angolo=[];
    for k = 1:length(B) %considero tutti gli oggetti 
        boundary = B{k};%salvo l'oggetto in considerazione
        delta_sq=diff(boundary).^2;%calcolo la differenza con il valore addiacente 
        perimeter=sum(sqrt(sum(delta_sq, 2))); %calcolo il perimetro dell'oggetto 
        area=stats(k).Area; %prelevo l'area dell'oggetto calcolato su stats
        metric=4*pi*area/perimeter^2; %calcolo il valore metrico
        metric_string=sprintf('%2.2f', metric); %convetto il valore in stringa, per poi stamparlo
        centroid=stats(k).Centroid; %salvo il centtro dell'oggetto
        if(metric>0.7 && metric < 1) %determino se è un cerchio
            plot(centroid(1), centroid(2), 'ko'); % plotto il centro dei cerchi con un asterisco
            text(boundary(1,2),boundary(1,1),metric_string,'Color','b','FontSize',10,'FontWeight', 'bold'); %Stampa il valore nella corretta posizione
            centri(pos1, :)=centroid; %salvo il centro del cerchio
            pos1=pos1+1;
        elseif((metric>0.10&&metric<0.2) ||(metric>0.21 && metric<0.35)) %determino se è un angolo
            plot(centroid(1), centroid(2), 'ko');  %plotto il centro dell'angolo 
            text(boundary(1,2),boundary(1,1),metric_string,'Color','r','FontSize',10,'FontWeight', 'bold'); %Stampa il valore nella corretta posizione
            Angolo(pos2, :)=centroid; %salvo la posizione dell'angolo
            pos2=pos2+1;
        end
    end
    C=centri;
    An=Angolo;
end
    