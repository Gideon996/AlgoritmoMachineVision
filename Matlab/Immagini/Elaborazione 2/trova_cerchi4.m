function [nr,nc,tmpr, tmpc] = trova_cerchi4(I, centri)
    [m,n]=size(I);
    distanza=max([m,n]);
    distanza=distanza/5.5;
    distanza=ceil(distanza); %valore di distanza tra un centro e l'altro relativa alla dimensione dell'immagine
    
    for i=1:length(centri(:,1))
        r(i)=centri(i,2); %salvo tutti i valori delle righe
        c(i)=centri(i,1); %salvo tutti i valori delle colonne
    end
    r=sort(r); %oridno in maniera crescente le righe
    c=sort(c); %ordino in maniera crescente le colonne
   
    nr=0;
    nc=0;
    for i=1:length(c(:)) %salvo solo i valori senza ripetizioni considerando apposite tolleranze delle colonne
        if(i==1)
            nc=nc+1;
            nr=nr+1;
            tmpc(nc)=c(i);
            tmpr(nr)=r(i);
        else
            if(c(i) > tmpc(nc)+10)
                nc=nc+1;
                tmpc(nc)=c(i);
            end
            if(r(i) > tmpr(nr)+10)
                nr=nr+1; %incremento il valore
                tmpr(nr)=r(i); %salvo i valori 
            end
        end
    end

    p=1;

    if(m>1)
        for i=1:length(tmpr(:)) %salvo solo i valori senza ripetizioni considerando apposite tolleranze delle righe
            if(i==1)
                if(tmpr(i) > (distanza+10))
                    j(p)=distanza;
                    p=p+1;
                    j(p)=tmpr(i);
                    p=p+1;
                else
                    j(p)=tmpr(i);
                    p=p+1;
                end
            else
                if((tmpr(i)-tmpr(i-1))>(distanza+10))
                    t=tmpr(i)-tmpr(i-1);
                    t=t/(distanza+10);
                    t=floor(t);
                    for k=p:(p+t)
                        j(k)=j(k-1)+distanza;
                    end
                    p=p+t+1;
                else
                    j(p)=tmpr(i);
                    p=p+1;
                end
            end
        end
        tmpr=j;
    end
    if((m-tmpr(length(tmpr(:))))>distanza+10)
        t=m-tmpr(length(tmpr(:)));
        t=t/distanza;
        t=floor(t);
        t=t-1;
        for i=p:p+t
            tmpr(i)=tmpr(i-1)+distanza;
        end
    end

    clear j;
    p=1;
    if(n>1)
        for i=1:length(tmpc(:))
            if(i==1)
                if(tmpc(i) > (distanza+10))
                    j(p)=distanza;
                    p=p+1;
                    j(p)=tmpc(i);
                    p=p+1;
                else
                    j(p)=tmpc(i);
                    p=p+1;
                end
            else
                if((tmpc(i)-tmpc(i-1))>(distanza+10))
                    t=tmpc(i)-tmpc(i-1);
                    t=t/(distanza+10);
                    t=floor(t);
                    for k=p:(p+t)
                        j(k)=j(k-1)+distanza;
                    end
                    p=p+t+1;
                else
                    j(p)=tmpc(i);
                    p=p+1;
                end
            end
        end
    tmpc=j;
    end
    if((n-tmpc(length(tmpc(:))))>distanza+10)
        t=n-tmpc(length(tmpc(:)));
        t=t/distanza;
        t=floor(t);
        t=t-1;
        for i=p:p+t
            tmpc(i)=tmpc(i-1)+distanza;
        end
    end

    nc=length(tmpc(:));
    nr=length(tmpr(:));
end