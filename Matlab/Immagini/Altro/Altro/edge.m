clc; clear all;

I = imread('Matrice.bmp');
valori=[];
punto=[];
TMP1=[];
TMP2=[];
P=[23.8669, 20.4179; 23.2332, 247.2361; 205.2054, 21.7829];
valori(1)=sqrt((P(1,1)-P(2,1))^2+((P(1,2)-P(2,2))^2));
valori(2)=sqrt((P(1,1)-P(3,1))^2+((P(1,2)-P(3,2))^2));
valori(3)=sqrt((P(2,1)-P(3,1))^2+((P(2,2)-P(3,2))^2));

valori = sort(valori);
%valore(1) lato orizzontale
%valore(2) lato verticale
%valore(3) ipotenusa
P1=P(:,1);
P2=P(:,2);
P1=sort(P1);
P2=sort(P2);

centro = valori(3)/2;

posizione1=1;
posizione2=1;
n=1;
m=1;
for i=1:3
    if(i==1)
        TMP1(n)=P1(posizione1);
        TMP2(m)=P2(posizione2);
        n=n+1;
        m=m+1;
    else
        tmp=P1(posizione1);
        a=tmp-2;
        b=tmp+2;
        if(a>P1(i) || b<P1(i))
            TMP1(n)= P1(i);
            n=n+1;
            posizione1=i;
        end
        tmp=P2(posizione2);
        a=tmp-2;
        b=tmp+2;
        if(a>P2(i) || b<P2(i))
            TMP2(m)= P2(i);
            m=m+1;
            posizione2=i;
        end
    end
end
TMP1 %righe
TMP2 %colonne
n=0;
somma1=0;
somma2=0;
for i=1:length(TMP1)
    somma1=somma1+TMP1(i);
    n=n+1;
end
m=0;
for i=1:length(TMP2)
    somma2=somma2+TMP2(i);
    m=m+1;
end
somma1=somma1/n
somma2=somma2/m

posizione1=length(I(:,1))/2
posizione2=length(I(1,:))/2
