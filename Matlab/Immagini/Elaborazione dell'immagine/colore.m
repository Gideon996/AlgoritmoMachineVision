function [image]=colore(I)
    [col,row]= size(I);
    [B,L,n,A]=oggetti(I);
    J=I;
    for i=1:col
        for j=1:row
            if(L(i,j)==0)
                J(i,j)=0;
            else
                J(i,j)=255;
            end
        end
    end
    image=J;
% figure; imshowpair(I, J, 'montage');
end