function [immagine] = ritaglio2(image, Angolo)
    %prendo la prima coordinata in alto a sinistra
    a=min(Angolo(:,1));  %y
    b=min(Angolo(:,2));  %x
    %prendo la seconda coordinata relativa alla prima in basso a destra
    c=(max(Angolo(:,1))-min(Angolo(:,1)));
    d=(max(Angolo(:,2))-min(Angolo(:,2)));
    immagine = imcrop(image, [a b c d]); %ritaglio l'immagine nelle coordinate indicate
end