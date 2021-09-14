x1=[-1:0.1:0]; % definisco l'intervallo con valori che vanno ad incrementare di 0.1 alla volta
x2=[0:0.1:1];  %  //         //          //          //          //          //          //
y1=exp(-x1);
y2=1-x2.^3;
plot(x1,y1,'b',x2,y2,'b')
