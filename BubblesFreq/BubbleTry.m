%%Bubbles Tryer

clear
clc
dirName = {'./Stimuli/imgs/jpg'};
data=LoadImgData(dirName);
r=rgb2gray(data(2).image);
s=bubbles(r);
i=s.stimulus();
imshow(i)