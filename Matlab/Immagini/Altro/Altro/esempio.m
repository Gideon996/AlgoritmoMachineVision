clc;
clear all;

c=[53,95;53,132;54,55;55,210;90,95;92,172;92,210;130,95;131,55;167,132;168,55;169,172;169,210];

%ho bisgono di una tolleranza dato che i centri non sono perfettamente
%allineati, quindi controllo se più o meno la posizione corrente è
%allineata con la posizione precedente oppure l'abbiamo già considerata.
%quindi ho bisogno di un controllo

%divido l'array in due monodimensionale

length(c(1,:)); %riga
length(c(:,1)); %colonna

for i=1:length(c(:,1))
    colonne(i)=c(i,1);
    righe(i)=c(i,2);
end

%ordinamento in maniera crescente
colonne = sort(colonne);
righe = sort(righe);

%conto se sono uguali
nr=1;
nc=1;
pos=1;

for i=1:length(colonne)
    last=colonne(pos);
    a=last-2;
    b=last+2;
    if(a>colonne(i)||b<colonne(i))
        pos=i;
        nc=nc+1;
    end
end

pos=1;
for i=1:length(righe)
    last=righe(pos);
    a=last-2; %53
    b=last+2; %57
    if(a>righe(i)||b<righe(i))
        pos=i;
        nr=nr+1;
    end
end

%stampo il numero di righe e di colonne
nr
nc
