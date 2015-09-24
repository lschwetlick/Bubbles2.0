clear
clc
p=imread('cat.jpg');
% r= p(:,:,1);
% g= p(:,:,2);
% b= p(:,:,3);
r=rgb2gray(p);
%r=p;
r_fft=fft2(r);

[x,y,z]=size(r);
maxrd= sqrt(((x/2)^2)+((y/2)^2));
nBands= 5;
bandDist=[];
for i=1:nBands
    b= nthroot(((i)/(5/maxrd^12)),12);
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
%Multiply
r_new_fft1=r_fft.*ringList{1};
r_new_fft2=r_fft.*ringList{2};
r_new_fft3=r_fft.*ringList{3};
r_new_fft4=r_fft.*ringList{4};
r_new_fft5=r_fft.*ringList{5};
% bla= r_new_fft1+r_new_fft2+r_new_fft3+r_new_fft4+r_new_fft5;

%transform Back
r_new1= ifft2(r_new_fft1);
r_new2= ifft2(r_new_fft2);
r_new3= ifft2(r_new_fft3);
r_new4= ifft2(r_new_fft4);
r_new5= ifft2(r_new_fft5);
% r_newbla= ifft2(bla);
% r_newbla=r_newbla/max(max(r_newbla)).*255;


% r_new1=r_new1/max(max(r_new1)).*255;
% r_new2=r_new2/max(max(r_new2)).*255;
% r_new3=r_new3/max(max(r_new3)).*255;
% r_new4=r_new4/max(max(r_new4)).*255;
% r_new5=r_new5/max(max(r_new5)).*255;


%show
% figure(1)
% subplot(1,6,1), imshow(uint8(real(r_new1))), title('Band1')
% subplot(1,6,2), imshow(uint8(real(r_new2))), title('Band2')
% subplot(1,6,3), imshow(uint8(real(r_new3))), title('Band3')
% subplot(1,6,4), imshow(uint8(real(r_new4))), title('Band4')
% subplot(1,6,5), imshow(uint8(real(r_new5))), title('Band5')
% subplot(1,6,6), imshow(r), title('Original')

%Set bubble locations
bandMask={};
for j=1:4
    amount=20;
    xLocations=zeros(1,amount);
    yLocations=zeros(1,amount);
    
    for i=1:amount
        xLocations(i)=randi(x);
        yLocations(i)=randi(y);
    end
    
    bandMask{1,j}=xLocations;
    bandMask{2,j}=yLocations;
    

end



sd=12;
x2 = 1:y;
x1 = 1:x;
[X1,X2] = meshgrid(x1,x2);
maskList={};
for j=1:4    
    mask = zeros(y,x);
    for i = 1:amount
        mu=[bandMask{1,j}(i), bandMask{2,j}(i)];
        F = (1./sqrt(2.*pi.*sd)).*exp( -((((X1-mu(1)).^2)+((X2-mu(2)).^2)) ./ (sd.^2)));
        F=F./max(max(F));
        mask=mask+F;
    end
    mask(mask>1)=1;
    maskList{j}=mask;

end


im1=double(real(r_new1))./255;
im2=double(real(r_new2))./255;
im3=double(real(r_new3))./255;
im4=double(real(r_new4))./255;
im5=double(real(r_new5))./255;

% normalizes the values of the underlying picture to be 0-1
%uses the mask as percentages for how much of the
%original image should be seen
stimulus=(im5)+(im2.* maskList{1})+(im3.* maskList{2})+(im4.* maskList{3})+(im1.* maskList{4}) ;
stimNorm=stimulus/max(max(stimulus)).*255;
stimulus=uint8(stimNorm);
% figure(2)
imshow(stimulus)

