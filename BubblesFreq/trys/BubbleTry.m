%%Bubbles Tryer

addpath('./Functions')
addpath('./Data')
addpath('./Settings')
addpath('./Stimuli')

clear
clc
im=rgb2gray(imread('./Stimuli/imgs/smallish/Abend.jpg'));
s=bubbles(im,7,30,2)
s.sd=[0,0,0,0,0,0,0,0]
s.amount=[1,1,2,3,6,10,20,30]
s
i=s.stimulus()
%% Plot
f1=figure(1);
imshow(s.stimulus)


f2=figure(2);
for i=[1:s.nBands]
    subplot(2,ceil(s.nBands/2),i), imshow(uint8(s.maskedBands{i}/max(max(s.maskedBands{i})).*255)), title(i)
end

%set(f2,'position',[1921 -281 1366 661])

f3=figure(3);
for i=[1:s.nBands]
    subplot(2,ceil(s.nBands/2),i), imshow(uint8(s.filtIm{i}/max(max(s.filtIm{i})).*255)), title(i)
end
%set(f3,'position',[1921 -281 1366 661])

f4=figure(4);
for i=[1:numel(s.maskList)]
    subplot(2,ceil(numel(s.maskList)/2),i), imagesc(s.maskList{i}), title(i+1)
end
%set(f4,'position',[1921 -281 1366 661])
%plotPos=[1 31 1920 973]; % home setup, big screen
plotPos=[-1365 153 1366 661]; %homesetup, small screen
% otherwise get with get(fighandle,'position')
set(f1,'position',plotPos)
set(f2,'position',plotPos)
set(f3,'position',plotPos)
set(f4,'position',plotPos)