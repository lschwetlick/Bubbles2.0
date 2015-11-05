%%Bubbles Tryer

clear
clc
p=imread('cat.jpg');
r=rgb2gray(p);
s=bubbles(r)
i=s.stimulus();
imshow(i)