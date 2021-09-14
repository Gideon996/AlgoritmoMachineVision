function [immagine]=rotazione2(tagliata, non_tagliata)
    
    Angolo=[];
    pos=1;
    
    [r,c]=size(tagliata);
    I1=tagliata;
    I2=non_tagliata;
    
    if(r<c)
        I1=imrotate(I1,90);
        I2=imrotate(I2,90);
    end
    [B,L,n,A] = bwboundaries(I2,'noholes');
    stats = regionprops(L, 'Area', 'Centroid');
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
    
    a=min(Angolo(:,2));
    b=0;
    for i=1:length(Angolo(:,1))
        if(floor(Angolo(i,2))==floor(a))
            b=i;
            break
        end
    end
    
    halfofpoint=(min(Angolo(:,2))+max(Angolo(:,2)))/2;
    if(Angolo(b,2)>halfofpoint)
        I1=imrotate(I1, 180);
    end
    immagine=I1;
end