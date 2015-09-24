function [ data ] = LoadImgData( dirName , subject)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
data=struct;
for i=1:numel(dirName) %over all folders
    files={};
    files = dir( fullfile(dirName{i},'*.jpg') );
    files = {files.name}';
    
    for j=1:numel(files)
        fname = fullfile(dirName{i},files{j});     %# full path to file
        
        n=numel(data)+1; %we store it in the "data" struct
        if i==1 && j==1 % for the first runthrough n needs to be 1 (not two as it would otherwise be)
            n=1;
        end %if
        
        data(n).image = imread(fname); % load file
        data(n).name = fname; %store file name
        data(n).seen = 0; %number of times seen
        
        %store type           
        % even vp numbers get set 1 as target and set 2 as distractors
        % 1 is a target, 2 a distractor, 3 a predistractor
        if mod(str2num(subject),2)==0
            if i==1
                data(n).type=1;
            elseif i==2
                data(n).type=2;
            else
                data(n).type=3;
            end %if 2
        % odd vp numbers get set 2 as target and set 1 as distractors
        else
            if i==1
                data(n).type=2;
            elseif i==2
                data(n).type=1;
            else
                data(n).type=3;
            end %if 2
        end
               
    end % for 2
end %for 1

end

