clc; clear all; close all;    

% RGB =imread(stringa);
% Negativo_RGB = imcomplement(RGB);
immagine = rgb2gray(double(imread('giallo5.bmp')));
I=imcomplement(immagine);
figure; imshow(I);
% [col,row]= size(I);
% J=I;
% % for i=1:col
% %         for j=1:row
% %             if(I(i,j)>10)
% %                 J(i,j)=0;
% %             else
% %                 J(i,j)=255;
% %             end
% %         end
% %     end
% %     figure; imshow(J);
% 
[B,L,n,A]=oggetti(I);
figure; imshow(label2rgb(L, @cool, [.5,.5,.5]));
stats = regionprops(L, 'Area', 'Centroid');
hold on 
for i=1:n %Trovare i Bordi dell'immagine
   boundary = B{i}; 
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 1)
end
% 
% stats = regionprops(L, 'Area', 'Centroid');
% 
% for k = 1:length(B)
%     boundary = B{k};
%     delta_sq=diff(boundary).^2;
%     perimeter=sum(sqrt(sum(delta_sq, 2)));
%     area=stats(k).Area;
%     metric=4*pi*area/perimeter^2;
%     metric_string=sprintf('%2.2f', metric);
%         centroid=stats(k).Centroid;
%         plot(centroid(1), centroid(2), 'ko');
%     text(boundary(1,2),boundary(1,1)+20,metric_string,'Color','y','FontSize',14,'FontWeight', 'bold');
% end