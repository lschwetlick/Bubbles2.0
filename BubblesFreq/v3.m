clear
clc
p=imread('cat.jpg');
r= p(:,:,1);
g= p(:,:,2);
b= p(:,:,3);
[xx,yy,z]=size(r);
% subplot(1,3,1), imshow(r)
% subplot(1,3,2), imshow(g)
% subplot(1,3,3), imshow(b)

% fft2 can take multi-dimensional arrays and will process then one slice
% after the next
r_fft=fft2(r);
% r_old=ifft2(r_fft);
% subplot(1,2,1), imshow(r)
%Watch out!! Imshow wants images to be uint NOT double!!
% subplot(1,2,2), imshow(uint8(r_old))
% Rectangle Filter
w=140;
g1=(xx/2)-w;
g2=(xx/2)+w;

rect= ones(xx,yy);
rect(g1:g2,g1:g2)=0;

irect=zeros(xx,yy);
irect(g1:g2,g1:g2)=1;

%Circle Filter
[xmat, ymat]= meshgrid(1:xx, 1:yy);
radius=185;
center= [(xx/2) (yy/2)];
dist= sqrt((xmat-center(1)).^2+(ymat-center(2)).^2);
circ=dist<=radius;

icirc=circ==0;

%Gaussian Filter
mask= zeros(xx, yy);
x2 = 1:xx; 
x1 = 1:yy;
mu=[(xx/2),(yy/2)];
sd=177*10^8;
%sd=24*10^9;
[X1,X2] = meshgrid(x1,x2);
%F = (1/sqrt(2*pi*sd)).*exp( -((((X1-mu(1)).^2)+((X2-mu(2)).^2)) ./ (sd^2)));
F = (1/2*pi*sd^2).*exp( -((((X1-mu(1)).^2)+((X2-mu(2)).^2)) ./ (2*(sd^2))));
F=F/max(max(F));
F=abs(F-1);

%Ring Filter
[xmat, ymat]= meshgrid(1:xx, 1:yy);
radiusIn=200;
radiusOut=250;
center= [(xx/2) (yy/2)];
dist= sqrt((xmat-center(1)).^2+(ymat-center(2)).^2);
circIn=dist<=radiusIn;
circOut=dist<=radiusOut;
circOut=circOut==0;
ring=circIn+circOut;
ring=ring==0;


%Multiply with spectrum
r_new_fft=r_fft.*rect;
r_new_fft2= r_fft.*irect;
r_new_fft3= r_fft.*circ;
r_new_fft4= r_fft.*icirc;
r_new_fft5= r_fft.*F;
r_new_fft6= r_fft.*ring;

r_new= ifft2(r_new_fft);
r_new=r_new/max(max(r_new)).*255;
r_new2= ifft2(r_new_fft2);
r_new2=r_new2/max(max(r_new2)).*255;
r_new3= ifft2(r_new_fft3);
r_new3=r_new3/max(max(r_new3)).*255;
r_new4= ifft2(r_new_fft4);
r_new4=r_new4/max(max(r_new4)).*255;
r_new5= ifft2(r_new_fft5);
r_new5=r_new5/max(max(r_new5)).*255;
r_new6= ifft2(r_new_fft6);
r_new6=r_new6/max(max(r_new6)).*255;

r_old= ifft2(r_fft);

show=9;
if show==1
    subplot(2,5,1), imshow(r), title('original')
    subplot(2,5,2), imshow(uint8(abs(r_fft))), title('spectrum')
    subplot(2,5,3), imshow(rect), title('rect filter')
    subplot(2,5,4), imshow(uint8(real(r_new))), title('rect')
    subplot(2,5,5), imshow(irect), title('invese rect filter')
    subplot(2,5,6), imshow(uint8(real(r_new2))), title('irect')
    subplot(2,5,7), imshow(circ), title('circle filter')
    subplot(2,5,8), imshow(uint8(real(r_new3))), title('circ')
    subplot(2,5,9), imshow(icirc), title('inverse circle filter')
    subplot(2,5,10), imshow(uint8(real(r_new4))), title('icirc')
elseif show==2
    subplot(3,1,1), imshow(r), title('Original Image')    
    subplot(3,1,2), imshow(icirc), title('Circle Filter')
    subplot(3,1,3), imshow(uint8(real(r_new4))), title('Filtered Image')
elseif show==3
    subplot(1,4,1), imshow(r), title('original')
%     subplot(1,4,2), imshow(uint8(real(r_new))), title('rect filter')
%     subplot(2,3,2), imshow(irect), title('invese rect filter')
%     subplot(2,3,5), imshow(uint8(real(r_new2))), title('irect')
 %   subplot(2,2,2), imshow(icirc), title('inverse circle filter')
    subplot(1,4,3), imshow(uint8(real(r_new4))), title('circle filter')
    subplot(1,4,4), imshow(uint8(real(r_new4))), title('gaus filter')
    
elseif show==4
    subplot(1,2,1), imshow(F), title('gauss filter')
    subplot(1,2,2), imshow(uint8(real(r_new5))), title('gauss image')
elseif show==5
    subplot(1,2,1), imshow(uint8(real(r_new4))), title('icirc')
    subplot(1,2,2), imshow(uint8(real(r_new5))), title('gauss image')
elseif show==6
    imshow(uint8(real(r_new6))), title('ring image')
else
    subplot(1,4,1), imshow(r), title('Original')    
    subplot(1,4,2), imshow(uint8(real(r_new))), title('Rectangle')
    subplot(1,4,3), imshow(uint8(real(r_new4))), title('Circle')
    subplot(1,4,4), imshow(uint8(real(r_new5))), title('Gauss')
    
    
end
% 


