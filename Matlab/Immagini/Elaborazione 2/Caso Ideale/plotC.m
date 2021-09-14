function [B, L, C, An] =plotC(Image)
    [B,L,n,A] = bwboundaries(Image,'noholes'); %riempimento pixel vuoti %trovo tutti gli oggetti nell'immagine 
    figure; imshow(label2rgb(L, @cool, [.5,.5,.5]));
    stats = regionprops(L, 'Area', 'Centroid');
    hold on 
    for i=1:n %Trovare i Bordi dell'immagine
        boundary = B{i}; 
        plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1)
    end
    pos1=1;
    pos2=1;

    centri=[];
    Angolo=[];
    for k = 1:length(B)
        boundary = B{k};
        delta_sq=diff(boundary).^2;
        perimeter=sum(sqrt(sum(delta_sq, 2)));
        area=stats(k).Area;
        metric=4*pi*area/perimeter^2;
        metric_string=sprintf('%2.2f', metric);
        centroid=stats(k).Centroid;
        if(metric>0.7 && metric < 1)
            plot(centroid(1), centroid(2), 'ko');
%             text(boundary(1,2),boundary(1,1),metric_string,'Color','b','FontSize',10,'FontWeight', 'bold');
            centri(pos1, :)=centroid;
            pos1=pos1+1;
        elseif(metric>0.10&&metric<0.5)
%             plot(centroid(1), centroid(2), 'ko');
%             text(boundary(1,2),boundary(1,1),metric_string,'Color','k','FontSize',10,'FontWeight', 'bold');
            Angolo(pos2, :)=centroid;
            pos2=pos2+1;
        end
    end
    C=centri;
    An=Angolo;
end
    