classdef bubbles
    %Bubbles creates a swiss cheese mask overlay for our image with an
    %adjustable amount of bubbles

    properties
        pic=[] %underlying image
        maskSizeX=300
        maskSizeY=300
        maskList={}
        sd=0.09
        amount=15 %amount of bubbles to be plotted
        bandMask={}
        nBands=5
    end

    methods

        function obj=bubbles(pic, amount, sd)
            %constructor
            obj.pic=rgb2gray(pic);
            [obj.maskSizeY,obj.maskSizeX,unused] = size(pic);
            obj.amount=amount;
            obj.sd=sd;
            %Place the spots in random locations
            obj=obj.setlocations();
        end %constructor function

        function [obj]=setlocations(obj)
            for j=1:(obj.nBands-1)
                
                xLocations=zeros(1,obj.amount);
                yLocations=zeros(1,obj.amount);

                for i=1:obj.amount
                    xLocations(i)=randi(obj.maskSizeX);
                    yLocations(i)=randi(obj.maskSizeY);
                end

                obj.bandMask{1,j}=xLocations;
                obj.bandMask{2,j}=yLocations;
            end
            
            
        end%SetLocations Function

        function [obj]=maskmaker(obj)
            %Make Masks
            [X1,X2] = meshgrid(1:obj.maskSizeX,1:obj.maskSizeY);
            for j=1:(obj.nBands-1)    
                mask = zeros(obj.maskSizeY,obj.maskSizeX);
                for i = 1:obj.amount
                    mu=[obj.bandMask{1,j}(i), obj.bandMask{2,j}(i)];
                    F = (1./sqrt(2.*pi.*obj.sd)).*exp( -((((X1-mu(1)).^2)+((X2-mu(2)).^2)) ./ (obj.sd.^2)));
                    F=F./max(max(F));
                    mask=mask+F;
                end
                mask(mask>1)=1;
                obj.maskList{j}=mask;
            end
                       
        end %function

        %
        function [stimulus] = stimulus(obj)
            obj=obj.maskmaker();
            
            % defining the individual bandwidths. Most information is found in the
            % lowest 10% so we use power functions
            maxrd= ceil(sqrt(((obj.maskSizeX/2)^2)+((obj.maskSizeY/2)^2)));
            bandDist=[];
            pow=12;
            for i=1:obj.nBands
                b= nthroot(((i)/(5/maxrd^pow)),pow);
                bandDist(i)=ceil(b);
            end
            % Ring Filters
            [xmat, ymat]= meshgrid(1:obj.maskSizeX, 1:obj.maskSizeY);
            radiusIn=[0,bandDist(1),bandDist(2),bandDist(3),bandDist(4)];
            radiusOut=[bandDist(1),bandDist(2),bandDist(3),bandDist(4), bandDist(5)];
            center= [ceil(obj.maskSizeX/2) ceil(obj.maskSizeY/2)];
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
            %Transform to spectral
            picFft=fft2(obj.pic);
            %Filter
            band1fft=picFft.*ringList{1};
            band2fft=picFft.*ringList{2};
            band3fft=picFft.*ringList{3};
            band4fft=picFft.*ringList{4};
            band5fft=picFft.*ringList{5};
            %Transform to Time
            band1=ifft2(band1fft);
            band2=ifft2(band2fft);
            band3=ifft2(band3fft);
            band4=ifft2(band4fft);
            band5=ifft2(band5fft);
            
            % Cut imaginary part of output
            im1=double(real(band1))./255;
            im2=double(real(band2))./255;
            im3=double(real(band3))./255;
            im4=double(real(band4))./255;
            im5=double(real(band5))./255;
           
            %uses the mask as percentages for how much of the
            %original image should be seen
            stimulus=(im5)+(im2.* obj.maskList{1})+(im3.* obj.maskList{2})+(im4.* obj.maskList{3})+(im1.* obj.maskList{4}) ;
            %normalizes for display
            stimNorm=stimulus/max(max(stimulus)).*255;
            stimulus=uint8(stimNorm);
        end %function


    end % methods
end %Class