function [immagine] = rotazione(image1, image2, tipo)  
    %{
    In input prende un immagine e la tipologia di rotazione da fare.
    -tipo 1: Trova l'angolo e raddrizza l'immagine
    -tipo 2: Ruota l'immagine ponendola in verticale. Questa funzione fa
             solo rotazioni di 90°
    %}
    tolleranza = 0.7;
    if(tipo == 1)
        angle=calcolo_angolo(image2, 0.1);
        immagine=imrotate(image2, -angle);
    elseif(tipo == 2)
        Angolo = [];
        if(length(image2(:,1))<length(image2(1,:))) %controllo qual è il lato lungo 
            image2=imrotate(image2,90); %la ruoto di 90 gradi, può essere orientata correttamente come al contrario
            image1=imrotate(image1,90);
        end
        [B,L,n,A] = bwboundaries(image1,'noholes');
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
        half=(max(Angolo(:,1))+min(Angolo(:,1)))/2;
        a=min(Angolo(:,2));
        b=0;
        for i=1:length(Angolo(:,1))
            if(floor(Angolo(i,2))==floor(a))
                b=i;
                break
            end
        end
        if(Angolo(b,1) > half)
            image2=imrotate(image2, 180);
        end
        immagine=image2;
    else
        error('Hai inviato il parametro tipo in maniera errata');
    end
end