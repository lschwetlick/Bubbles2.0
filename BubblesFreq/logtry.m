clear
clc
c=[0:300];
plot((5/2^300)*(1.09.^c));
hold on;
plot((c.^12)*(5/300^12));

hold off;
%generic Log version
% multiplier=0.25;
% adder=0;
% px=300;
% nBands=5;
% yEnd= adder+multiplier*-1*log2(px);
% plot(adder+multiplier*-1*log2(c));
% yBandSize=yEnd/nBands;
% xBands=[];
% for i=1:nBands
%     b= -1*2^((i*yBandSize)/multiplier)+adder;
%     xBands(i)=ceil(b);
% end

% adder=5;
% px=300;
% nBands=0;
% multiplier=(nBands-adder)/log2(px);
% plot(adder+multiplier*log2(c));
% 
% bandDist=[];
% for i=1:5
%     b= 2^((i-adder)/multiplier);
%     bandDist(i)=b;
% end

