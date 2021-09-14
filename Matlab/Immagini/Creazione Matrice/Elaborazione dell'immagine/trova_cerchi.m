function [rg, cl, nr, nc] = trova_cerchi(centri)
    %{
    In input prende la matrice contenente le posizioni dei centri dei
    cerchi. Da quì si ricavano il formato della matrice formato dai cerchi
    e, in particolare, si trovano il numero di righe, di colonne. Si
    trovano anche la posizione delle righe e delle colonne.
    In output restituiscono proprio questi valori.
    %}
    %conto quante righe e quante colonne ho nell'immagine
    tolleranza=0;
    for i=1:length(centri(:,1))
        colonne(i)=centri(i,1);
        righe(i)=centri(i,2);
    end
    %ordinamento in maniera crescente
    colonne = sort(colonne);
    righe = sort(righe);
    
    rg = [];
    cl = [];
    %conto se sono uguali
    nr=1;
    nc=1;
    pos=1;
    %conto il numero di colonne e salvo la coordinata di ogni colonna
    for i=1:length(colonne)
        last=colonne(pos);
        if(i==1)
            cl(i)=last;
        end
        a=last-tolleranza;
        b=last+tolleranza;
        if(a>colonne(i)||b<colonne(i))
            pos=i;
            nc=nc+1;
            cl(nc)=colonne(i); %salvo il valore in coordinate
        end
    end
    %Conto il numero di righe e salco la coodinata di ogni riga
    pos=1;
    for i=1:length(righe)
        last=righe(pos);
        if(i==1)
            rg(i)=last;
        end
        a=last-tolleranza;
        b=last+tolleranza;
        if(a>righe(i)||b<righe(i))
            pos=i;
            nr=nr+1;
            rg(nr)=righe(i); %salvo il valore in coordinate
        end
    end
end