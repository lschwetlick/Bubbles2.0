classdef bubbles
    %Bubbles creates a swiss cheese mask overlay for our image with an
    %adjustable amount of bubbles
    
    properties
        pic=[] %underlying image
        maskSizeX=300
        maskSizeY=300
        mask=[]
        sd=0.09
        amount=15 %amount of bubbles to be plotted
        xLocations=[] %placement of the spots. The coordinates indicate the top left corner
        yLocations=[]
        shadeOfGrey=0.3 %shade of the mask
    end
    
    methods
        
        function obj=bubbles(pic, amount, sd, greyness)
            %constructor            
            obj.pic=pic;
            [obj.maskSizeY,obj.maskSizeX,unused] = size(pic);
            obj.amount=amount;
            obj.sd=sd;
            %Place the spots in random locations
            obj=obj.setlocations();
            if exist('greyness','var')
                obj.shadeOfGrey=greyness;
            end
        end %constructor function
        
        function [obj]=setlocations(obj)
            %sets the locations for the wanted amount of bubbles
            obj.xLocations=zeros(1,obj.amount);
            %pre-defining the length of the vector for speed optimization
            obj.yLocations=zeros(1,obj.amount);
            for i=1:obj.amount
                obj.xLocations(i)=randi([1,obj.maskSizeX],1,1);
                obj.yLocations(i)=randi([1,obj.maskSizeY],1,1);
            end%for
        end%SetLocations Function
        
        function [obj]=maskmaker(obj)
            % a background for the spots to be plotted onto            
            obj.mask= zeros(obj.maskSizeY, obj.maskSizeX);
            x2 = 1:obj.maskSizeY; 
            x1 = 1:obj.maskSizeX;
            for i = 1:obj.amount
                mu=[obj.xLocations(i), obj.yLocations(i)];
                [X1,X2] = meshgrid(x1,x2);
                F = (1/sqrt(2*pi*obj.sd)).*exp( -((((X1-mu(1)).^2)+((X2-mu(2)).^2)) ./ (obj.sd^2)));
                F=F/max(max(F));
                obj.mask=obj.mask+F;
            end
            % exp(-.5*((d/sd).^2));
            obj.mask(obj.mask>1)=1;
        end %function
        
        function[obj]=addbubble(obj)
            %adds an extra bubble to the mask
            obj.amount=obj.amount+1;
            obj.xLocations(obj.amount)=randi([1,obj.maskSizeY],1,1);
            obj.yLocations(obj.amount)=randi([1,obj.maskSizeX],1,1);
            
        end
%         
        function [stimulus] = stimulus(obj)
            obj=obj.maskmaker();
            %Creates the stimulus image
            stimulus=double(obj.pic)./255;
            % normalizes the values of the underlying picture to be 0-1
            [y,x,z]=size(stimulus);
            for i=1:y %for 1
                for j =1:x %for 2
                    for k=1:z %for 3
                        %uses the mask as percentages for how much of the
                        %original image should be seen
                        stimulus(i,j,k)=(stimulus(i,j,k).* obj.mask(i,j)) + (obj.shadeOfGrey.*(1-obj.mask(i,j)));
                    end %for 3
                end %for 2
            end %for 1
            %image(stimulus)
            stimulus=im2uint8(stimulus);
        end %function
          
    end %Methods Block
    
end %Class