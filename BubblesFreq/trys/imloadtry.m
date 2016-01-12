clear
dirName = {'./Stimuli/imgs/jpg'};

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
        data(j).name = fname; %file name
        data(j).path = fpath; %store file path
        
                
        
               
    end % for 2
end %for 1

clearvars files fname fpath dirName i j
