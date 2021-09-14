function [angle] = calcolo_angolo(image, precision)
    %{
    In input ha bisogno dell'immagine da ruotare e un valore che usa per
    avere una precisione sull'angolo trovato. Questo valore è compreso tra
    0 e 1. Un buon valore è 0.1.
    %}
    maxsize = max(size(image));
    T = fftshift(fft2(image, maxsize, maxsize)); % Crea una trasformazione rettangolare
    T = log(abs(T)+1);                           % otteniamo una grandezza nell'intervallo [0...inf[  
    % Combina due quadranti FFT insieme (altri due quadranti sono simmetrici).
    center = ceil((maxsize+1)/2);
    evenS = mod(maxsize+1, 2);
    T = (rot90(T(center:end, 1+evenS:center), 1) + T(center:end, center:end));
    T = T(2:end, 2:end);    % Rimuove artefatti dovute ad inesattezze 
    % Trova l'orientamento del dominio
    angles = floor(90/precision);
    score = zeros(angles, 1);
    maxDist = maxsize/2-1;
    for angle = 0:angles-1
        [y,x] = pol2cart(deg2rad(angle*precision), 0:maxDist-1); % tutti gli [x,y]
        for i = 1:maxDist
            score(angle+1) = score(angle+1) + T(round(y(i)+1), round(x(i)+1));
        end
    end
    % Restituisce la direzione più dominante
    [~, position] = max(score);
    angle = (position-1)*precision;
    angle = mod(45+angle,90)-45;
end