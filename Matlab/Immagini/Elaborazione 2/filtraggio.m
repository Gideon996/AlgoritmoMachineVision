function [immagine]=filtraggio(image)
    
%     sceneImage=imcomplement(image); %negativo
    J=rgb2gray(image); %scala di grigi
%     figure; imshow(J);
    J=imcomplement(J); %negativo
%     figure; imshow(J);
    %J immagine, 0.8 tollezanza sotto la quale salva i bit in 0 e sopra sono 1
    Ibw = im2bw(J,0.8); %conversione in binario dell'immagine J
%     figure;imshow(Ibw);
    %IBW è un immagine binaria, 'sobel' il tipo di filtro
    gradiente_immagine = imgradient(Ibw, 'sobel'); %Calcolo la dimensione del gradiente e la direzione
%     figure;imshsobelow(gradiente_immagine);
    massimo=max(gradiente_immagine(:))
    I_minima = gradiente_immagine/max(gradiente_immagine(:)); %trovo i valori minimi(più forti)
    I_minima = I_minima*100; %salvo i valori minimi
    Immagine_filtrata = floor(I_minima); %approssimo per difetto
    Immagine_filtrata = Immagine_filtrata/100; %torno ai valori normali
    J = imbinarize(Immagine_filtrata); %binarizzo l'immagine con valori 0 o 1
    figure; imshow(J); title('Sobel');
    Ifill = imfill(J,'holes'); %riempio i bordi vuoti ('holes')
%     figure; imshow(Ifill); title('qui');
    Iarea = bwareaopen(Ifill,300); %rimuovo piccoli oggetti sotto il valore 300
    Ifinal = bwlabel(Iarea); 
    figure; imshow(Ifinal); title('riempita');
%     se = offsetstrel('disk', 15);
    se = offsetstrel('ball',7,2); %creo un filtro
    erodedI = imerode(Ifinal,se); %erodo l'immagine con il filtro se
    se=strel('disk', 5); %creo un filtro
    erodedI=imdilate(erodedI, se); %dilato i pezzi rimanenti nell'immagine usando il filtro se
    erodedI=imbinarize(erodedI); %binarizzo l'immagine e la ritorno
    a=calcolo_angolo(erodedI, 0.1); %calcolo angolo per la rotazione con tollerazna 0.1 (molto buono)
    immagine=imrotate(erodedI, -a); %ruoto l'immagine di un angolo -a e la ritorno in output
%     immagine=raddrizza(erodedI);
    figure; imshow(immagine); title('terminato');
end