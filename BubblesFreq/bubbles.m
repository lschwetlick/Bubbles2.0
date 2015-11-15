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
        bandMask={}
        nBands=5
        ringList={}
        radiusIn=[]
        radiusOut=[]
    end

    methods

        function obj=bubbles(pic)
            %constructor
            %obj.pic=rgb2gray(pic);
            obj.pic=pic;
            [obj.maskSizeY,obj.maskSizeX,unused] = size(pic);
            obj.amount=[1,3,10,20];
%             obj.sd=sd;
            %Place the spots in random locations
            obj=obj.setlocations();
            obj=obj.filtermaker();
            obj=obj.maskmaker();
            
        end %constructor function

        function [obj]=setlocations(obj)
            for j=1:(obj.nBands-1)
                
                xLocations=zeros(1,sum(obj.amount));
                yLocations=zeros(1,sum(obj.amount));

                for i=1:numel(xLocations)
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
                %different parameters for the different bands
%                 if j==1 %coarsest/lowest band with fewest and largest bubbles
%                     %nBubbles=obj.amount[j];
%                     m=mean(obj.radiusIn(j)+1:obj.radiusOut(j));
%                     %obj.sd(j)=ceil((obj.maskSizeX/m)*3);
%                     
%                 elseif j==2
%                     %amount =5;
%                     m=mean(obj.radiusIn(j)+1:obj.radiusOut(j));
%                     obj.sd(j)=ceil((obj.maskSizeX/m)*3);
%                 elseif j==3
%                     %amount =10;
%                     m=mean(obj.radiusIn(j)+1:obj.radiusOut(j));
%                     obj.sd(j)=ceil((obj.maskSizeX/m)*3);
%                 else % finest band with most and smallest bubbles
%                     %amount=20;
%                     m=mean(obj.radiusIn(j)+1:obj.radiusOut(j));
%                     obj.sd(j)=ceil((obj.maskSizeX/m)*3);
%                 end
                %make mask with parameters set above
                mask = zeros(obj.maskSizeY,obj.maskSizeX);
                for i = 1:obj.amount(j)
%                     mu=[obj.bandMask{1,j}(i), obj.bandMask{2,j}(i)];
%                     F = (1./sqrt(2.*pi.*obj.sd)).*exp( -((((X1-mu(1)).^2)+((X2-mu(2)).^2)) ./ (obj.sd.^2)));
%                     F=F./max(max(F));
%                     mask=mask+F;
                    mu=[obj.bandMask{1,j}(i), obj.bandMask{2,j}(i)];
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
            maxrd= ceil(sqrt(((obj.maskSizeX/2)^2)+((obj.maskSizeY/2)^2)));
            %powerfuction
%           pow=12;
%           bandDist=[];
%           for i=1:obj.nBands
%               b= nthroot(((i)/(5/maxrd^pow)),pow);
%               bandDist(i)=maxrd-ceil(b);
%           end
%           bandDist=sort(bandDist);
%           obj.radiusIn=[bandDist(1),bandDist(2),bandDist(3),bandDist(4), bandDist(5)];
%           obj.radiusOut=[bandDist(2),bandDist(3),bandDist(4), bandDist(5),maxrd];
            
%           obj.radiusIn=[0,(maxrd/16),(maxrd/8),(maxrd/4),(maxrd/2)];
%           obj.radiusOut=[(maxrd/16),(maxrd/8),(maxrd/4),(maxrd/2), maxrd];
            obj.radiusIn=[0,1,10,30, 80];
            obj.radiusOut=[1,10,30, 80,maxrd];

            % Ring Filters
            [xmat, ymat]= meshgrid(1:obj.maskSizeX, 1:obj.maskSizeY);
            center= [ceil(obj.maskSizeX/2)+1 ceil(obj.maskSizeY/2)+1];
            dist= sqrt((xmat-center(1)).^2+(ymat-center(2)).^2);
            
            for i=1:length(obj.radiusIn)
                circIn=dist<=obj.radiusIn(i);
                circOut=dist<=obj.radiusOut(i);
                circOut=circOut==0;
                ring=circIn+circOut;
                ring=ring==0;
                obj.ringList{i}=ring;
            end
            obj.ringList{1}(center(1), center(2))=1;
        end
        
        function [stimulus] = stimulus(obj)
%             obj=obj.filtermaker();
%             obj=obj.maskmaker();
            
            % defining the individual bandwidths. Most information is found in the
            % lowest 10% so we use power functions

            
            %Transform to spectral
            picFft=fft2(obj.pic);
            picFft=fftshift(picFft);
            %Filter
            band1fft=picFft.*obj.ringList{1};
            band2fft=picFft.*obj.ringList{2};
            band3fft=picFft.*obj.ringList{3};
            band4fft=picFft.*obj.ringList{4};
            band5fft=picFft.*obj.ringList{5};
            %Transform to Time
            band1=ifft2(ifftshift(band1fft));
            band2=ifft2(ifftshift(band2fft));
            band3=ifft2(ifftshift(band3fft));
            band4=ifft2(ifftshift(band4fft));
            band5=ifft2(ifftshift(band5fft));
            
            % Cut imaginary part of output
            im1=double(real(band1))./255;
            im2=double(real(band2))./255;
            im3=double(real(band3))./255;
            im4=double(real(band4))./255;
            im5=double(real(band5))./255;
            
            %Bands filtered through masks
            s1=im2.* obj.maskList{1};
            s2=im3.* obj.maskList{2};
            s3=im4.* obj.maskList{3};
            s4=im5.* obj.maskList{4};
           
            %uses the mask as percentages for how much of the
            %original image should be seen
            stimulus=(im1)+(s1)+(s2)+(s3)+(s4);
            %normalizes for display
            stimNorm=stimulus/max(max(stimulus)).*255;
            stimulus=uint8(stimNorm);
        end %function


    end % methods
end %Class