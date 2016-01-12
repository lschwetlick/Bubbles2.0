clear
clc
hold off
yy=300;
c=[0:yy];
bands=5;

% power changing the exponent
plot((bands/2^yy)*(1.09.^c));
hold on
%%power changing the base
plot((c.^12)*(bands/yy^12));
hold on
%plot(-log2(c)+5)
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

