function [A] = codifica(image, centri)
    %{
    In input serve la matrice centri, la quale contiene i centri dei vari
    cerchi troati. 
    In output fornisce una matrice dove inserisce 1 nelle
    posizioni in cui è presente un cerchio, 0 in tutte le altre
    %}

    [nr,nc,rg, cl] = trova_cerchi4(image, centri); %salvo il valore del numero di righe e colonne e i loro valori
    A = zeros(nr,nc); %Creo una matrice di zeri con le dimensioni della griglia
    tr=10;
    tc=10;
    for i=1:length(centri(:,1))
        for j=1:nc
            a=cl(j)-tc;
            b=cl(j)+tc;
            if(a<centri(i,1)&&b>centri(i,1))
                TMPC=j; %Salvo la cella che mi interessa dell'array poscl che mi interessa
                break
            end
        end
        for j=1:nr
            a=rg(j)-tr;
            b=rg(j)+tr;
            if(a<centri(i,2)&&b>centri(i,2))
                TMPR=j; %Salvo la cella che mi interessa dell'array posrg in questione
                break %inserisco il break perchè così non ho necessar bisogno di fare tutti i cicli
            end
        end
        A(TMPR, TMPC)=1; %Nella posizione desiderata dico che è presente un cerchio 
    end
end