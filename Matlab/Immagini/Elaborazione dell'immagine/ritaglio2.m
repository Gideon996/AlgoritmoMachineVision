function [immagine] = ritaglio2(image, tolleranza)
    [B,L,n,A] = bwboundaries(image);
    stats = regionprops(L, 'Area', 'Centroid');
    pos=1;
    Angolo = [];
    
    for k=1:n %Trovare tutti i cerchi e i propri centri
        boundary = B{k};
        delta_sq=diff(boundary).^2;
        perimeter=sum(sqrt(sum(delta_sq, 2)));
        area=stats(k).Area;
        metric=4*pi*area/perimeter^2;
        if (metric<0.4&&metric>0.1)
            centroid=stats(k).Centroid;
            Angolo(pos, :)=centroid;
            pos=pos+1;
        end
    end
    %La funzione di imcrop indicata funziona nella seguente maniera:
    %[immagine] = imcrop( Immagine, [x1 y1 x2 y2] )
    immagine = imcrop(image, [min(Angolo(:,1)) min(Angolo(:,2)) (max(Angolo(:,1))-min(Angolo(:,1))) (max(Angolo(:,2))-min(Angolo(:,2)))]);
end