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
            obj.mask= zeros(obj.maskSizeY, obj.maskSizeX);
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
                obj.xLocations(i)=randi(obj.maskSizeX);
                obj.yLocations(i)=randi(obj.maskSizeY);
            end%for
            
        end%SetLocations Function

        function [obj]=maskmaker(obj)
            t1=GetSecs();
            % a background for the spots to be plotted onto
            
            %F=obj.mask;
            x2 = 1:obj.maskSizeY;
            x1 = 1:obj.maskSizeX;
            [X1,X2] = meshgrid(x1,x2);
            for i = 1:obj.amount
                
                mu=[obj.xLocations(i), obj.yLocations(i)];
                F = (1./sqrt(2.*pi.*obj.sd)).*exp( -((((X1-mu(1)).^2)+((X2-mu(2)).^2)) ./ (obj.sd.^2)));
                F=F./max(max(F));
                obj.mask=obj.mask+F;
                
            end
            % exp(-.5*((d/sd).^2));
            obj.mask(obj.mask>1)=1;
        end %function

        function[obj]=addbubble(obj)
            %adds an extra bubble to the mask
            obj.amount=obj.amount+1;
            obj.xLocations(obj.amount)=randi(obj.maskSizeY);
            obj.yLocations(obj.amount)=randi(obj.maskSizeX);

        end
        %
        function [stimulus] = stimulus(obj)
            obj=obj.maskmaker();
            %Creates the stimulus image
            stimulus=double(obj.pic)./255;
            % normalizes the values of the underlying picture to be 0-1
            [y,x,z]=size(stimulus);
            %uses the mask as percentages for how much of the
            %original image should be seen
            stimulus=(stimulus.* repmat(obj.mask,[1 1 z])) + (obj.shadeOfGrey.* repmat(1-obj.mask,[1 1 z]));
            stimulus=uint8(stimulus*255);
            
        end %function


    end % methods
end %Class