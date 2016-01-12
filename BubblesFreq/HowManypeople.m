im=rgb2gray(imread('./Stimuli/imgs/smallish/Abend.jpg'));
%Settings
nBands=7;
minOctave=2;
nBubbles=30;
%example Image
b=bubbles(im, nBands, nBubbles, minOctave);
imSizeX=b.maskSizeX;
imSizeY=b.maskSizeY;
techNBubbles=(4.^[0:nBands-2]); %one less for zero and background
sd=b.sd(1);%in jedem Band wird gleichviel abgedeckt
probNBubbles=techNBubbles/sum(techNBubbles);%wahrscheinlichkeit
%area
imSizeA=imSizeX*imSizeY;
sdA= pi.*(sd.^2);
APerTrial=(imSizeA./sdA)*probNBubbles(1)*nBubbles;
%how many to show each px once
nShow=10;
trials=nShow/APerTrial
time=(trials*5)/60