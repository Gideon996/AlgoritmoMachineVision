%Calcolare il fattoriale del numero 7
%se si inserisce il ; alla fine della funzione questa non li stampa su
%Command Window
N=input('N=');
fattoriale=1;
for i=1:N
    fattoriale=fattoriale*i;
end
X = ['Il valore fattoriale di ', num2str(N), ' è: ', num2str(fattoriale)];
disp(X)