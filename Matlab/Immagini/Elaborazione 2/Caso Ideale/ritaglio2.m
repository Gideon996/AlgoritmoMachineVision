function [immagine] = ritaglio2(image)
    [B, L, C, Angolo]=plotC(image);

    %La funzione di imcrop indicata funziona nella seguente maniera:
    %[immagine] = imcrop( Immagine, [x1 y1 x2 y2] )
    [m,n]=size(image);
    e=(5*100);
    e=e/max([m,n]);
% pr = (5*100)/(max([m,n]));
    a=min(Angolo(:,1));
    b=min(Angolo(:,2))+e;
    c=(max(Angolo(:,1))-min(Angolo(:,1)))-e;
    d=(max(Angolo(:,2))-min(Angolo(:,2)))-e;
    immagine = imcrop(image, [a b c d]);
%     immagine = imcrop(image, [min(Angolo(:,1)) min(Angolo(:,2)) (max(Angolo(:,1))-min(Angolo(:,1))) (max(Angolo(:,2))-min(Angolo(:,2)))]);
end