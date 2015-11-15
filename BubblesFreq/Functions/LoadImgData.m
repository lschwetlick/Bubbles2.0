function [ data ] = LoadImgData( dirName )
%This function loads a folder of images into the program. It takes the
%directory path as an input and gives a struct with the image, file name and
%file path
data=struct;

for i=1:numel(dirName) %over all folders
    files={};
    files = dir( fullfile(dirName{i},'*.jpg') );
    files = {files.name}';
    
    for j=1:numel(files)
        fpath = fullfile(dirName{i},files{j});     %# full path to file
        fname = files{j};
        
        
        %transform to black and white
        data(j).image = (imread(fpath)); % load file
        data(j).name = fname(1:end-4); %file name
        data(j).path = fpath; %store file path
        data(j).seen = 0;
        data(j).id = j;
        
                
        
               
    end % for 2
end %for 1

clearvars files fname fpath dirName i j

end

