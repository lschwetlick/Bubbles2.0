clear
clc
p=imread('cat.jpg');
% r= p(:,:,1);
% g= p(:,:,2);
% b= p(:,:,3);
r=rgb2gray(p);

r_fft=fft2(r);
%r_fft=fftshift(r_fft);

[x,y,z]=size(r);
%Vorsicht mit ungradzahligen pixelanzahlen
maxrd= sqrt(((x/2)^2)+((y/2)^2));
nBands= 5;
bandDist=[];
for i=1:nBands
    b= nthroot(((i)/(5/maxrd^7)),7);
    bandDist(i)=ceil(b);

end



%ringfilter
[xmat, ymat]= meshgrid(1:x, 1:y);
radiusIn=[0,bandDist(1),bandDist(2),bandDist(3),bandDist(4)];
radiusOut=[bandDist(1),bandDist(2),bandDist(3),bandDist(4), bandDist(5)];
center= [150 150];
dist= sqrt((xmat-center(1)).^2+(ymat-center(2)).^2);
ringList={};
for i=1:length(radiusIn)
    circIn=dist<=radiusIn(i);
    circOut=dist<=radiusOut(i);
    circOut=circOut==0;
    ring=circIn+circOut;
    ring=ring==0;
    ringList{i}=ring;
end
ringAdd=ringList{1}+ringList{2}+ringList{3}+ringList{4}+ringList{5};
%Multiply
r_new_fft1=r_fft.*ringList{1};
r_new_fft2=r_fft.*ringList{2};
r_new_fft3=r_fft.*ringList{3};
r_new_fft4=r_fft.*ringList{4};
r_new_fft5=r_fft.*ringList{5};
bla= r_new_fft1+r_new_fft2+r_new_fft3+r_new_fft4+r_new_fft5;

%transform Back
r_new1= ifft2(r_new_fft1);
r_new2= ifft2(r_new_fft2);
r_new3= ifft2(r_new_fft3);
r_new4= ifft2(r_new_fft4);
r_new5= ifft2(r_new_fft5);
r_newbla= ifft2(bla);


r_new1norm=r_new1/max(max(r_new1)).*255;
r_new2norm=r_new2/max(max(r_new2)).*255;
r_new3norm=r_new3/max(max(r_new3)).*255;
r_new4norm=r_new4/max(max(r_new4)).*255;
r_new5norm=r_new5/max(max(r_new5)).*255;
r_newblanorm=r_newbla/max(max(r_newbla)).*255;

BlaZeit= (r_new1+r_new2+r_new3+r_new4+r_new5);
BlaZeitnorm=BlaZeit/max(max(r_newbla)).*255;


%show
figure(1);

subplot(1,6,1), imshow(uint8(real(r_new1norm))), title('Band1')
subplot(1,6,2), imshow(uint8(real(r_new2norm))), title('Band2')
subplot(1,6,3), imshow(uint8(real(r_new3norm))), title('Band3')
subplot(1,6,4), imshow(uint8(real(r_new4norm))), title('Band4')
subplot(1,6,5), imshow(uint8(real(r_new5norm))), title('Band5')
subplot(1,6,6), imshow(r), title('Original')
% 
% figure(2)
% imshow(uint8(real(BlaZeitnorm)))
% 
% figure(3)
% imshow(uint8(real(r_newblanorm)))