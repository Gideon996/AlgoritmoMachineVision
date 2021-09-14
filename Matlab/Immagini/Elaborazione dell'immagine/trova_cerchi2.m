function [rg, cl, nr, nc,tr, tc] = trova_cerchi2(image, centri)
    %{
    In input prende la matrice contenente le posizioni dei centri dei
    cerchi. Da quì si ricavano il formato della matrice formato dai cerchi
    e, in particolare, si trovano il numero di righe, di colonne. Si
    trovano anche la posizione delle righe e delle colonne.
    In output restituiscono proprio questi valori.
    %}
    %conto quante righe e quante colonne ho nell'immagine
    for i=1:length(centri(:,1))
        colonne(i)=centri(i,1);
        righe(i)=centri(i,2);
    end
    %ordinamento in maniera crescente
    colonne = sort(colonne);
    righe = sort(righe);
    tc=0;
    tr=0;
    
    tmpc=colonne(1);
    tmpc=floor(tmpc/10)+1;

    for i=1:length(colonne)
        tmp2=colonne(i);
        tmp2=floor(tmp2/10);
        if(tmpc < tmp2)
            tc=floor(tmp2-tmpc);
            tc=tc*10;
            break
        end
    end
    
    tmpr=righe(1);
    tmpr=floor(tmpr/10)+1;

    for i=1:length(righe)
        tmp2=righe(i);
        tmp2=floor(tmp2/10);
        if(tmpr < tmp2)
            tr=floor(tmp2-tmpr);
            tr=tr*10;
            break
        end
    end
    
    rg = [];
    cl = [];
    nr=1;
    nc=1;
    pos=1;
    if(tc==0)
        tc=1;
    end
    if(tr==0)
        tr=1;
    end
    for i=1:length(colonne)
        last=colonne(pos);
        b=last+tc;
        if(i==1)
            cl(nc)=last;
        end
        if(colonne(i)>b)
            nc=nc+1;
            cl(nc)=colonne(i);
            pos=i;
        end
    end
    pos=1;
    for i=1:length(righe)
        last=righe(pos);
        b=last+tr;
        if(i==1)
            rg(nr)=last;
        end
        if(righe(i)>=b)
            nr=nr+1;
            rg(nr)=righe(i);
            pos=i;
        end
    end
end