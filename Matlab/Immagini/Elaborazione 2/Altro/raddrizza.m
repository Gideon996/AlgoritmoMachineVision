function [immagine]=raddrizza(image)
    [B,L,n,A]= bwboundaries(image,'noholes');;
    stats = regionprops(L, 'Area', 'Centroid');
    posizione=1;

    %cerco gli angoli e la loro posizione
    for i=1:n 
        boundary = B{i};
        delta_sq=diff(boundary).^2;
        perimeter=sum(sqrt(sum(delta_sq, 2)));
        area=stats(i).Area;
        metric=4*pi*area/perimeter^2;
        if(metric<0.4&&metric>0.1)
            centroid=stats(i).Centroid;
        	Angolo(posizione, :)=centroid; %salvo il centro dell'angolo
            posizione=posizione+1;
        end
    end
    %controllo quale angolo sta più in alto
    if(Angolo(2,2)==min(Angolo(:,2))) 
        x=Angolo(1,1)-Angolo(2,1);
        y=Angolo(1,2)-Angolo(2,2);
    elseif(Angolo(3,2)==min(Angolo(:,2)))
        y=Angolo(1,1)-Angolo(2,1);
        x=Angolo(1,2)-Angolo(2,2);
    elseif(Angolo(1,2)==min(Angolo(:,2)))
        y=Angolo(1,1)-Angolo(3,1);
        x=Angolo(1,2)-Angolo(3,2);
    else
        x=0;
        y=1;
    end
    alfa=atan(abs(x)/abs(y)); %calcolo l'angolo con l'arcotangente 
    beta=rad2deg(alfa);%converto alfa in gradi
    immagine = imrotate(image, beta); %ruoto l'immagine
end


