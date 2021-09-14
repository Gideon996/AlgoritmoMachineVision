function [nr,nc,tmpr, tmpc] = trova_cerchi2(I, centri)
    %conto in maniera perfetta
    %{
%     for i=1:length(centri(:,1))
%         r(i)=centri(i,2);
%         c(i)=centri(i,1);
%     end
%     r=sort(r);
%     c=sort(c);
% 
%     nr=0;
%     nc=0;
%     for i=1:length(c(:))
%         if(i==1)
%             nc=nc+1;
%             nr=nr+1;
%             tmpc(nc)=c(i);
%             tmpr(nr)=r(i);
%         else
%             if(c(i) > tmpc(nc)+10)
%             nc=nc+1;
%             tmpc(nc)=c(i);
%             end
%             if(r(i) > tmpr(nr)+10)
%             nr=nr+1; %incremento il valore
%             tmpr(nr)=r(i); %salvo i valori 
%             end
%         end
%     end
%     
%     p=1;
% for i=1:length(tmpr(:))
%     if(i==1)
%          if(tmpr(i) > 50)
%             j(p)=40;
%             p=p+1;
%             j(p)=tmpr(i);
%             p=p+1;
%         else
%             j(p)=tmpr(i);
%             p=p+1;
%         end
%     else
%         if((tmpr(i)-tmpr(i-1))>50)
%             j(p)=tmpr(i-1)+40;
%             p=p+1;
%             j(p)=tmpr(i);
%             p=p+1;
%         else
%             j(p)=tmpr(i);
%             p=p+1;
%         end
%     end
% end
% tmpr=j;
% 
% clear j;
% p=1;
% for i=1:length(tmpc(:))
%     if(i==1)
%         if(tmpc(i) > 50)
%             j(p)=40;
%             p=p+1;
%             j(p)=tmpc(i);
%             p=p+1;
%         else
%             j(p)=tmpc(i);
%             p=p+1;
%         end
%     else
%         if((tmpc(i)-tmpc(i-1))>50)
%             j(p)=tmpc(i-1)+40;
%             p=p+1;
%             j(p)=tmpc(i);
%             p=p+1;
%         else
%             j(p)=tmpc(i);
%             p=p+1;
%         end
%     end
% end
% tmpc=j;
% 
% nc=length(tmpc(:));
% nr=length(tmpr(:));
    %}
    %40=x*100/513->x=40*100/513
    
    
    %513:100=x:40
    [m,n]=size(I);
    distanza=40;
    
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

p=1;

if(m>1)
for i=1:length(tmpr(:))
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
if(max([m,n])-tmpr(length(tmpr(:)))>(distanza+10))
    t=max([m,n])-tmpr(length(tmpr(:)));
    t=t/(distanza);
    t=floor(t)-1;
    for k=p:(p+t)
        tmpr(length(tmpr(:))+1)=tmpr(length(tmpr(:)))+distanza;
    end
    p=p+t+1;
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
%             j(p)=tmpc(i-1)+40;
%             p=p+1;
%             j(p)=tmpc(i);
%             p=p+1;
        else
            j(p)=tmpc(i);
            p=p+1;
        end
    end
end
tmpc=j;
end
% [m,n]=size(I);
% a=max([m,n])
% if(max([m,n])-tmpr(length(tmpr(:)))>50)
%     t=tmpr(i)-tmpr(i-1);
%     t=t/50;
%     t=floor(t);
%     for k=p:(p+t)
%         tmpr(length(tmpr(:))+1)=tmpr(length(tmpr(:)))+40;
%     end
%     p=p+t+1;
% end
if(min([m,n])-tmpc(length(tmpc(:)))>(distanza+10))
    t=min([m,n])-tmpc(length(tmpc(:)));
    t=t/(distanza);
	t=floor(t)-1;
	for k=p:(p+t)
        tmpc(length(tmpc(:))+1)=tmpc(length(tmpc(:)))+distanza;
    end
	p=p+t+1;
end

nc=length(tmpc(:));
nr=length(tmpr(:));

end