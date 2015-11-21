%%Bubbles Tryer

clear
clc
dirName = {'./Stimuli/imgs/small'};
data=LoadImgData(dirName);
r=rgb2gray(data(3).image);
s=bubbles(r,6)
% s.sd=[0,0,0,0,0,0,0,0]
% s.amount=[1,1,2,3,6,10,20,30]
% s
%i=s.stimulus()
f1=figure(1)
imshow(s.stimulus)
set(f1,'position',[31 -277 1790 907])

f2=figure(2)
for i=[1:s.nBands]
    subplot(2,ceil(s.nBands/2),i), imshow(uint8(s.maskedBands{i}/max(max(s.maskedBands{i})).*255)), title(i)
end

set(f2,'position',[31 -277 1790 907])

f3=figure(3)
for i=[1:s.nBands]
    subplot(2,ceil(s.nBands/2),i), imshow(uint8(s.filtIm{i}/max(max(s.filtIm{i})).*255)), title(i)
end
set(f3,'position',[31 -277 1790 907])