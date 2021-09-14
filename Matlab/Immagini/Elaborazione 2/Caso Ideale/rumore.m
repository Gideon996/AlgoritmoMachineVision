function [immagine] = rumore(image, s, g)
    if(s==0)
        I=image;
    else
        I = imnoise(image, 'salt & pepper', s);
    end
    if(g==0)
        immagine=I;
    else
        immagine = imnoise(I, 'gaussian', g);
    end
end