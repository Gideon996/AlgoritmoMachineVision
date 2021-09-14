function [immagine] = lettura(stringa, tipo)
    %{
    prende in input il nome dell'immagine da elaborare. Questa viene aperta
    portata in negativo e convertita in scala di grigi.
    In output fornisce l'immagine convertita con la scala di grigi.
    %}
    if(tipo==1)
%         path=strcat('D:\Adriano\Matlab\Programma\Immagini\',stringa);
        RGB =imread(stringa);
        Negativo_RGB = imcomplement(RGB);
        immagine = rgb2gray(Negativo_RGB);
    elseif(tipo==2)
%         path=strcat('D:\Adriano\Matlab\Programma\Immagini\',stringa);
        RGB =imread(stringa);
        sp=input('Inserisci intensità rumore Salt & Pepper: ');
        g=input('Inserisci intensità rumore Gaussiano: ');
        RGB=rumore(RGB, sp, g);
        Negativo_RGB = imcomplement(RGB);
        immagine = rgb2gray(Negativo_RGB);
    else
        error('Numero di tipo errato');
    end
end