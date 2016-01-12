%% Settings
clear
clc
%how many Bubbles per frequency
howMany=100;
%power of bandwidth distribution
pow=12;
%bubble size
sd=12;
%Bild in den speicher Laden
p=imread('./Stimuli/imgs/smallish/Abend.jpg');
%Schwarz-Weiﬂ konvertieren
r=rgb2gray(p);
%r=p;
[y,x,z]=size(r);
%% Transform to spectral
r_fft=fft2(r);
%WATCH OUT when you shift, you have to shift that shit back before
%transforming back to image
r_fft=fftshift(r_fft);
maxrd= ceil(sqrt(((x/2)^2)+((y/2)^2)));

% %% Bandwidths
% % defining the individual bandwidths. Most information is found in the
% % lowest 10% so we use power functions
% maxrd= ceil(sqrt(((x/2)^2)+((y/2)^2)));
% nBands= 5;
% bandDist=[];
% for i=1:nBands
%     b= nthroot(((i)/(5/maxrd^pow)),pow);
%     bandDist(i)=ceil(b);
% 
% end
%% ringfilter
[xmat, ymat]= meshgrid(1:x, 1:y);
radiusIn=[0,ceil(maxrd/16),ceil(maxrd/8),ceil(maxrd/4),ceil(maxrd/2)];
radiusOut=[ceil(maxrd/16),ceil(maxrd/8),ceil(maxrd/4),ceil(maxrd/2), maxrd];

center= [ceil(x/2)+1 ceil(y/2)+1];
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
ringList{1}(center(1), center(2))=1;
ringAdd=ringList{1}+ringList{2}+ringList{3}+ringList{4}+ringList{5};

%% Use Filters
%Creating an image for each Bandwidth
r_new_fft1=r_fft.*ringList{1};
r_new_fft2=r_fft.*ringList{2};
r_new_fft3=r_fft.*ringList{3};
r_new_fft4=r_fft.*ringList{4};
r_new_fft5=r_fft.*ringList{5};
% bla= r_new_fft1+r_new_fft2+r_new_fft3+r_new_fft4+r_new_fft5;

%transform Back to Time
r_new1= ifft2(ifftshift(r_new_fft1));
r_new2= ifft2(ifftshift(r_new_fft2));
r_new3= ifft2(ifftshift(r_new_fft3));
r_new4= ifft2(ifftshift(r_new_fft4));
r_new5= ifft2(ifftshift(r_new_fft5));
% r_newbla= ifft2(bla);
% r_newbla=r_newbla/max(max(r_newbla)).*255;


%% Set bubble locations
bandMask={};
for j=1:4
    amount=howMany;
    xLocations=zeros(1,amount);
    yLocations=zeros(1,amount);
    
    for i=1:amount
        xLocations(i)=randi(x);
        yLocations(i)=randi(y);
    end
    
    bandMask{1,j}=xLocations;
    bandMask{2,j}=yLocations;
end
%% Make one Mask per Frequency
x2 = 1:y;
x1 = 1:x;
[X1,X2] = meshgrid(x1,x2);
maskList={};
for j=1:4
    if j==1
       amount=1;
       m=mean(radiusIn(j)+1:radiusOut(j));
       sd=ceil((x/m)*3)
       
    elseif j==2
        amount =5;
        m=mean(radiusIn(j)+1:radiusOut(j));
        sd=ceil((x/m)*3)
       
    elseif j==3
        amount =10;
        m=mean(radiusIn(j)+1:radiusOut(j));
        sd=ceil((x/m)*3)
    else
        amount=20;
        m=mean(radiusIn(j)+1:radiusOut(j));
        sd=ceil((x/m)*3)
       
    end
            
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

%% Cut imaginary part of output
im1=double(real(r_new1))./255;
im2=double(real(r_new2))./255;
im3=double(real(r_new3))./255;
im4=double(real(r_new4))./255;
im5=double(real(r_new5))./255;

s1=im2.* maskList{1};
s2=im3.* maskList{2};
s3=im4.* maskList{3};
s4=im5.* maskList{4};

%% making the Stimulus
%uses the mask as percentages for how much of the
%original image should be seen
%stimulus=(im1)+(im2.* maskList{1})+(im3.* maskList{2})+(im4.* maskList{3})+(im5.* maskList{4}) ;
stimulus=(im1)+(s1)+(s2)+(s3)+(s4) ;

%normalizes for display
stimNorm=stimulus/max(max(stimulus)).*255;
stimulus=uint8(stimNorm);
% figure(2)
imshow(stimulus)


figure(3)
subplot(1,5,1), imshow(uint8(im1/max(max(im1)).*255))
subplot(1,5,2), imshow(uint8(s1/max(max(s1)).*255))
subplot(1,5,3), imshow(uint8(s2/max(max(s2)).*255))
subplot(1,5,4), imshow(uint8(s3/max(max(s3)).*255))
subplot(1,5,5), imshow(uint8(s4/max(max(s4)).*255))

