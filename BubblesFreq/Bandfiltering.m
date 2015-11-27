clear
clc
dirName = {'./Stimuli/imgs/small'};
data=LoadImgData(dirName);
% r= p(:,:,1);
% g= p(:,:,2);
% b= p(:,:,3);
r=rgb2gray(data(4).image);

r_fft=fft2(r);

%WATCH OUT when you shift, you have to shift that shit back before
%transforming back to image
r_fft=fftshift(r_fft);

[y,x,z]=size(r);
%Vorsicht mit ungradzahligen pixelanzahlen
maxrd= ceil(sqrt(((x/2)^2)+((y/2)^2)));
%% Power Function

nBands= 5;
pow=30;
bandDist=[];
for i=1:nBands
    b= nthroot(((i)/(5/maxrd^pow)),pow);
    bandDist(i)=maxrd-ceil(b);
end
bandDist=sort(bandDist);
%% log
% nBands= 5;
% base= 1.05;
% bandDist=[];
% multiplier= (nBands/base^maxrd);
% for i=1:nBands
%     b= (log2(i/multiplier))/(log2(base));
%     bandDist(i)=ceil(b);
% 
% end
%%

%% Logarithmisch
% adder=5;
% px=300;
% nBands=0;
% multiplier=(nBands-adder)/log2(px);
% plot(adder+multiplier*log2(maxrd));
% 
% bandDist=[];
% for i=1:5
%     b= 2^((i-adder)/multiplier);
%     bandDist(i)=ceil(b);
% end

%% Programm
%ringfilter
[xmat, ymat]= meshgrid(1:x, 1:y);

% radiusIn=[0,bandDist(2),bandDist(3),bandDist(4), bandDist(5)];
% radiusOut=[bandDist(2),bandDist(3),bandDist(4), bandDist(5),maxrd];
% radiusIn=[0,3,11,31, 81];
% radiusOut=[1,10,30, 80,maxrd];

radiusIn=[0,3,(maxrd/8)+1,(maxrd/4)+1,(maxrd/2)+1];
radiusOut=[2,(maxrd/8),(maxrd/4),(maxrd/2), maxrd];

radiusIn=[0,2,4,8,16];
radiusOut=[2,4,8,16, maxrd];
radius=[0,2,4,8,16,maxrd];


center= [ceil(x/2)+1 ceil(y/2)+1 ];
dist= sqrt((xmat-center(1)).^2+(ymat-center(2)).^2);
%dist(151,151)=1;
ringList={};
for i=1:length(radius)-1
    circIn=dist<radius(i);
    circOut=dist>=radius(i+1);
    %circOut=circOut==0;
    ring=circIn+circOut;
    ring=ring==0;
    ringList{i}=ring;
end
ringList{1}(center(2),center(1))=1;
ringAdd=ringList{1}+ringList{2}+ringList{3}+ringList{4}+ringList{5};


%% inverse rimg filter
% [xmat, ymat]= meshgrid(1:x/2, 1:y/2);
% % radiusIn=[0,bandDist(1),bandDist(2),bandDist(3),bandDist(4)];
% % % radiusOut=[bandDist(1),bandDist(2),bandDist(3),bandDist(4), bandDist(5)];
% % radiusIn=[0,(maxrd/5),(maxrd/4),(maxrd/3),(maxrd/2)];
% % radiusOut=[(maxrd/5),(maxrd/4),(maxrd/3),(maxrd/2), maxrd];
% % radiusIn=[0, maxrd/2, maxrd-maxrd/4, maxrd-maxrd/8, maxrd-maxrd/16];
% % radiusOut=[maxrd/2, maxrd-maxrd/4, maxrd-maxrd/8, maxrd-maxrd/16, maxrd];
% radiusIn=[0, maxrd/16, maxrd/8, maxrd/4, maxrd/2];
% radiusOut=[maxrd/16, maxrd/8, maxrd/4, maxrd/2, maxrd];
% 
% center= [1 1];
% dist= sqrt((xmat-center(1)).^2+(ymat-center(2)).^2);
% dist(1,1)=1;
% ringList={};
% for i=1:length(radiusIn)
%     circIn=dist<=radiusIn(i);
%     circOut=dist<=radiusOut(i);
%     circOut=circOut==0;
%     ring=circIn+circOut;
%     ring=ring==0;
%     ring= horzcat(ring, fliplr(ring));
%     ring= vertcat(ring, flipud(ring));
%     ringList{i}=ring;
% end
% ringAdd=ringList{1}+ringList{2}+ringList{3}+ringList{4}+ringList{5};
% %ringList{1}(1, 1)=1;



%% Multiply
r_new_fft1=r_fft.*ringList{1};
r_new_fft2=r_fft.*ringList{2};
r_new_fft3=r_fft.*ringList{3};
r_new_fft4=r_fft.*ringList{4};
r_new_fft5=r_fft.*ringList{5};
bla= r_new_fft1+r_new_fft2+r_new_fft3+r_new_fft4+r_new_fft5;

%transform Back
r_new1= ifft2(ifftshift(r_new_fft1));
r_new2= ifft2(ifftshift(r_new_fft2));
r_new3= ifft2(ifftshift(r_new_fft3));
r_new4= ifft2(ifftshift(r_new_fft4));
r_new5= ifft2(ifftshift(r_new_fft5));
% 


% r_new1= ifft2(r_new_fft1);
% r_new2= ifft2(r_new_fft2);
% r_new3= ifft2(r_new_fft3);
% r_new4= ifft2(r_new_fft4);
% r_new5= ifft2(r_new_fft5);
%  r_newbla= ifft2(bla);


r_new1norm=r_new1/max(max(r_new1)).*255;
r_new2norm=r_new2/max(max(r_new2)).*255;
r_new3norm=r_new3/max(max(r_new3)).*255;
r_new4norm=r_new4/max(max(r_new4)).*255;
r_new5norm=r_new5/max(max(r_new5)).*255;
% % r_newblanorm=r_newbla/max(max(r_newbla)).*255;

% % BlaZeit= (r_new1+r_new2+r_new3+r_new4+r_new5);
% % BlaZeitnorm=BlaZeit/max(max(r_newbla)).*255;


%show
% figure(1);
% 
% subplot(1,6,1), imshow(uint8(real(r_new1norm))), title('Band1')
% subplot(1,6,2), imshow(uint8(real(r_new2norm))), title('Band2')
% subplot(1,6,3), imshow(uint8(real(r_new3norm))), title('Band3')
% subplot(1,6,4), imshow(uint8(real(r_new4norm))), title('Band4')
% subplot(1,6,5), imshow(uint8(real(r_new5norm))), title('Band5')
% subplot(1,6,6), imshow(r), title('Original')
% 
% figure(2)
% imshow(uint8(real(BlaZeitnorm)))
% 
% figure(3)
% imshow(uint8(real(r_newblanorm)))