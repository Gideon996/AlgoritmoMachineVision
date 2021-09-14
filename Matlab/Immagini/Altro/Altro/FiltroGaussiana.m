clc; clear all;

intens = [0.01, 0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5];
J = imread('Matrice.bmp');
J = imnoise(J, 'gaussian', intens(3)); %se aumenta l'intensità aumento devo aumentare anche [m n]
I = imcomplement(J);
I = rgb2gray(I);
% figure; imshowpair(J,I, 'montage');


%kernel
sigma = 1;
kernel = zeros(5,5);
W=0;
for i=1:5
    for j=1:5
        sq_dist=(i-3)^2+(j-3)^2;
        kernel(i,j)=exp(-1*(sq_dist)/(2*sigma*sigma));
        W=W+kernel(i,j);
    end
end
kernel=kernel/W;

%applico il filtro 
[m,n]=size(I);
output=zeros(m,n);
Im = padarray(I, [2 2]);

for i=1:m
    for j=1:n
        temp=Im(i:i+4, j:j+4);
        temp=double(temp);
        conv = temp*kernel;
        output(i,j)=sum(conv(:));
    end
end

output=uint8(output);

%mostro l'immagine

figure; imshowpair(I,output, 'montage');





