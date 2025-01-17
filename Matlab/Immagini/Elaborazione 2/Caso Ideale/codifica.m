function [A] = codifica(image, centri)
    %{
    In input serve la matrice centri, la quale contiene i centri dei vari
    cerchi troati. 
    In output fornisce una matrice dove inserisce 1 nelle
    posizioni in cui � presente un cerchio, 0 in tutte le altre
    %}
%     [rg, cl, nr, nc, tr, tc]=trova_cerchi2(image, centri);
%     [nr,nc,rg, cl] = trova_cerchi2(image, centri);
[nr,nc,rg, cl] = trova_cerchi4(image, centri);
A = zeros(nr,nc); %Creo una matrice di zeri con le dimensioni della griglia
%     if(tc==0)
%         tc=1;
%     end
%     if(tr==0)
%         tr=1;
%     end
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
           break %inserisco il break perch� cos� non ho necessar bisogno di fare tutti i cicli
       end
    end
   A(TMPR, TMPC)=1; %Nella posizione desiderata dico che � presente un cerchio 
end
end