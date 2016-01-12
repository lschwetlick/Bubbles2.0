addpath('./Functions/Old Fkt')
addpath('./Data')
addpath('./Analysis')

%% Load in Data
clear
details=ImportDetails('Bubbles__Subject77_Details.csv');
coordinates=ImportCoordinates('Bubbles__Subject77_Coordinates.csv');
%Image names
dirName = './Stimuli/imgs/smallishold';
files = dir( fullfile(dirName,'*.jpg') );
s=size(files);
names=[];
for i=1:s(1)
    names=[names,cellstr(files(i).name(1:end-4))];
end
%% Details file
detailsC=details;
% Throw out wrong answers
toDelete=detailsC.Correct~=1;
detailsC(toDelete,:) = [];
size(detailsC)

%throw out all but one
results={};
for i=1:numel(names)
    toKeep=strcmp(names{i}, detailsC.Image);
    %toDelete=logical(abs(toDelete-1));
    d1=detailsC(toKeep,:);
    results(i).names=names{i};
    results(i).trials=table2array(d1(:,2));
end

%% Coordinates
for i=1:numel(results)
    bandLoc={};
    bandLoc(1).XLoc=[];
    bandLoc(1).YLoc=[];
    for j=1:numel(results(i).trials)
        for k=1:max(coordinates.band)
            toKeep=results(i).trials(j)==coordinates.Trial & coordinates.band==k ;
            d1=coordinates(toKeep,:); 
            
            bandLoc(k).band=k;
            bandLoc(k).XLoc=vertcat(bandLoc(k).XLoc, d1.XLoc);
            bandLoc(k).YLoc=vertcat(bandLoc(k).YLoc, d1.YLoc);
            results(i).Locations=bandLoc;
        end
    end
end
%% 
dirName = {'./Stimuli/imgs/smallishold'};
imgs=LoadImgData(dirName);
results(1).image=[];
for i=1:numel(imgs)
    results(i).image=imgs(i).image;
end
%exemplary bubble
exB=bubbles(imgs(1).image, max(coordinates.band)+1, 1,2);
sd=exB.sd;

%% Saliency Map

maskSizeX=384;
maskSizeY=288;
[X1,X2] = meshgrid(1:maskSizeX,1:maskSizeY);
mask = zeros(maskSizeY,maskSizeX);
results(1).masks={}
for im=1:numel(results)
    %for each image
    
    for band=1:max(coordinates.band)
        %for each band
        for b = 1:numel(results(im).Locations(band).XLoc)
            %for each bubble in that band
            mu=[results(im).Locations(band).XLoc(b),results(im).Locations(band).YLoc(b)];
            F = (1./sqrt(2.*pi.*sd(band))).*exp( -((((X1-mu(1)).^2)+((X2-mu(2)).^2)) ./ (sd(band).^2)));
            F=F./max(max(F));
            mask=mask+F;
        end
        mask=mask./max(max(mask));
        %mask(mask>1)=1;
        results(im).masks(band).bandMask=mask;
        
    end
end
%% draw
im=7
for i=[1:6]
    figure(i)
    imagesc((results(1).masks(i).bandMask))
end
%combined
% for i=[1:6]
%     figure(i)
%     imshow(uint8((results(im).masks(i).bandMask).*double(results(im).image)))
% end



%% Which images were identified most often

for i=1:numel(names)
    toKeep=strcmp(names{i}, details.Image);
    d1=details(toKeep,:);
    totalShows=height(d1);
    CorrectResponse=sum(d1.Correct);
    results(i).shows=totalShows;
    results(i).CorrectResponse=CorrectResponse;
end

