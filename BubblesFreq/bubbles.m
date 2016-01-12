classdef bubbles
    %Bubbles creates a swiss cheese mask overlay for our image with an
    %adjustable amount of bubbles

    properties
        pic=[] %underlying image
        maskSizeX=300
        maskSizeY=300
        maskList={}
        sd=[200,100,50,25]
        amount=[] %amount of bubbles to be plotted
        maskLocations={}
        nBands=5
        ringList={}
        radiusIn=[]
        radiusOut=[]
        radius=[]
        meanBand=[]
        maskedBands={}
        stimulus=[]
        filtIm={}
        nBubbles=[]
        minOctave=[]
    end

    methods

        function obj=bubbles(pic, nBands, nBubbles, minOctave)
            %constructor
            %obj.pic=rgb2gray(pic);
            obj.pic=pic;
            obj.nBands=nBands;
            obj.nBubbles=nBubbles;
            obj.minOctave=minOctave;
            [obj.maskSizeY,obj.maskSizeX,unused] = size(pic);
%             obj.sd=sd;
            %Place the spots in random locations
            obj=obj.setBands();
            obj=obj.setAmount();
            obj=obj.setlocations();
            obj=obj.filtermaker();
            obj=obj.setBubble();
            obj=obj.maskmaker();
            obj=obj.stimulusMaker();
        end %constructor function
        
        function obj=setBubble(obj)
            % finds bubble sd depending on the bands
            obj.meanBand=[];
            for i =[1:obj.nBands]
                obj.meanBand(i)=mean([obj.radius(i),obj.radius(i+1)]);
            end
            meanBandMask=obj.meanBand(2:end);
            for i=[1:numel(meanBandMask)]
                obj.sd(i)= ceil(obj.maskSizeX/meanBandMask(i))*3;
            end
            
        end
        
        function obj=setBands(obj)
            %sets the bandwidths
            maxrd= ceil(sqrt(((obj.maskSizeX/2)^2)+((obj.maskSizeY/2)^2)));            
            %min=2;
            a=obj.minOctave.*(2.^[0:obj.nBands-2]); %because two values are already set: min and max and the zero also covers one
            b=a(a<maxrd);
%             b2=1+b;
%             obj.radiusIn=horzcat([0],b);
%             obj.radiusOut=horzcat(b, maxrd);
            obj.radius=horzcat([0],b,[maxrd]);
        end
        
        function [obj]=setAmount(obj)
            techNBubbles=(4.^[0:obj.nBands-2]); %one less for zero and background
            probNBubbles=techNBubbles/sum(techNBubbles);
            cutOffNBubbles=cumsum(probNBubbles);
            r1= rand(1,obj.nBubbles);
            for i=[1:obj.nBands-1] %one of the bands will be background
                obj.amount(i)=sum(r1<cutOffNBubbles(i))-sum(obj.amount);
            end
        end
        
        function [obj]=setlocations(obj)
            for j=1:(obj.nBands-1)
                xLocations=zeros(1,obj.amount(j));
                yLocations=zeros(1,obj.amount(j));
                for i=1:numel(xLocations)
                    xLocations(i)=randi(obj.maskSizeX);
                    yLocations(i)=randi(obj.maskSizeY);
                end
                obj.maskLocations{1,j}=xLocations;
                obj.maskLocations{2,j}=yLocations;
            end
            
            
        end%SetLocations Function

        function [obj]=maskmaker(obj)
            %Make Masks
            [X1,X2] = meshgrid(1:obj.maskSizeX,1:obj.maskSizeY);            
            for j=1:(obj.nBands-1)
            % for each frequency band
                mask = zeros(obj.maskSizeY,obj.maskSizeX);
                for i = 1:obj.amount(j)
                    %for each bubble in that band
                    mu=[obj.maskLocations{1,j}(i), obj.maskLocations{2,j}(i)];
                    F = (1./sqrt(2.*pi.*obj.sd(j))).*exp( -((((X1-mu(1)).^2)+((X2-mu(2)).^2)) ./ (obj.sd(j).^2)));
                    F=F./max(max(F));
                    mask=mask+F;
                end
                mask(mask>1)=1;
                obj.maskList{j}=mask;
            end
                       
        end %function

        %
        function [obj] = filtermaker(obj)
            % Ring Filters
            [xmat, ymat]= meshgrid(1:obj.maskSizeX, 1:obj.maskSizeY);
            center= [ceil(obj.maskSizeX/2)+1 ceil(obj.maskSizeY/2)+1];
            dist= sqrt((xmat-center(1)).^2+(ymat-center(2)).^2);

            for i=1:length(obj.radius)-1
                circIn=dist<obj.radius(i);
                circOut=dist>=obj.radius(i+1);
                %circOut=circOut==0;
                ring=circIn+circOut;
                ring=ring==0;
                obj.ringList{i}=ring;
            end

            %obj.ringList{1}(center(2), center(1))=1;
        end
        
        function [obj] = stimulusMaker(obj)
%             obj=obj.filtermaker();
%             obj=obj.maskmaker();
            
            % defining the individual bandwidths. Most information is found in the
            % lowest 10% so we use power functions

            
            %Transform to spectral
            picFft=fft2(obj.pic);
            picFft=fftshift(picFft);
            %Filter
            
            for i=[1:obj.nBands]
                bandFft=picFft.*obj.ringList{i};%frequency filter image
                band=ifft2(ifftshift(bandFft));%shift back to time
                obj.filtIm{i}=double(real(band))./255; %cut imaginary
                if i==1
                    obj.maskedBands{i}=obj.filtIm{i};
                else
                    obj.maskedBands{i}=obj.filtIm{i}.* obj.maskList{i-1};%filter through bubbles
                end
            end
%             band1fft=picFft.*obj.ringList{1};
%             band2fft=picFft.*obj.ringList{2};
%             band3fft=picFft.*obj.ringList{3};
%             band4fft=picFft.*obj.ringList{4};
%             band5fft=picFft.*obj.ringList{5};
            %Transform to Time
%             band1=ifft2(ifftshift(band1fft));
%             band2=ifft2(ifftshift(band2fft));
%             band3=ifft2(ifftshift(band3fft));
%             band4=ifft2(ifftshift(band4fft));
%             band5=ifft2(ifftshift(band5fft));
%             
%             % Cut imaginary part of output
%             im1=double(real(band1))./255;
%             im2=double(real(band2))./255;
%             im3=double(real(band3))./255;
%             im4=double(real(band4))./255;
%             im5=double(real(band5))./255;
%             
%             %Bands filtered through masks
%             s1=im2.* obj.maskList{1};
%             s2=im3.* obj.maskList{2};
%             s3=im4.* obj.maskList{3};
%             s4=im5.* obj.maskList{4};
           
            %uses the mask as percentages for how much of the
            %original image should be seen
%             stimulus=(im1)+(s1)+(s2)+(s3)+(s4);
            obj.stimulus=(obj.maskedBands{1})+(obj.maskedBands{2})+(obj.maskedBands{3})+(obj.maskedBands{4})+(obj.maskedBands{5});
            %normalizes for display
            obj.stimulus=obj.stimulus/max(max(obj.stimulus)).*255;
            obj.stimulus=uint8(obj.stimulus);
        end %function


    end % methods
end %Class