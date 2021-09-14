clc; clear all; close all;

I=imread('posizione2.bmp');
J=filtraggio(I);
figure; imshow(J);
