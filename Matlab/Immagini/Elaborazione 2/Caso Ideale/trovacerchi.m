function [nr,nc,tmpr, tmpc] =trovacerchi(centri)
%conto in maniera perfetta
for i=1:length(centri(:,1))
   r(i)=centri(i,2);
   c(i)=centri(i,1);
end
r=sort(r);
c=sort(c);

nr=0;
nc=0;
for i=1:length(c(:))
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

end




