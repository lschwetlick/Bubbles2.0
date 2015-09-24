%clear workspace
clear
addpath('C:\Users\labor\Documents\Forschung\Bubbles\Functions')
%% Set up Data
subject = input('VP Nummer:', 's');
bubbleFileName = strcat('Data/Bubbles__Subject',subject,'_Coordinates.csv');
infoFileName = strcat('Data/Bubbles_Subject',subject,'_Details.csv');

%% Loading in the Stimulus-Images
dirName = {'./Stimuli/subset1', './Stimuli/subset2','./Stimuli/subset3'};
allData=LoadImgData(dirName, subject);
dataCopy=allData;
%adding all targets and pretest-distractors
pretestData=allData([allData.type]==1 | [allData.type]==3);
%adding all targets and distractors
data=allData([allData.type]==1 | [allData.type]==2);

%% bubble parameters
load('Settings/BubbleSettings.mat')
% settings has the following variables:
% - amount
% - sd
% - shadeOfGrey
% - background
amounts=[4,6,8,10,12,14,16];
amountList=repmat(amounts,1,4);

nPerImage=2;
%% setting up presentation
%depending on monitor setup
monitor= 0;
rect = [600 0 1880 1024]; 
window = Screen('OpenWindow', monitor,settings.background,rect);

[windowWidth, windowHeight]=Screen('WindowSize', window);
%% Pretest
PretestInstructions(window)
WaitSecs(1);
RestrictKeysForKbCheck([]);
[unused1, keyCode,unused2]=KbWait();
if KbName(keyCode)=='b'
    TargetsAgain(window, pretestData)
end

Pretest(window, pretestData, settings)

%% Presentation of instructions
RestrictKeysForKbCheck([]);
InstructionsMain(window)
WaitSecs(1);
KbWait();
%% Stimulus presentation
%write out location data
bubbleFileHandle = fopen(bubbleFileName, 'w');
fprintf(bubbleFileHandle, ',x,y\n');
%write out performance data
infoFileHandle = fopen(infoFileName, 'w');
fprintf(infoFileHandle, 'VPNr, Trial, Image, Amount, Target, Response, Correct, Time\n');

feedbackCounter=0;
for trial=1:(numel(data)*nPerImage)
    if mod(trial,10)==0
        Pause(window, feedbackCounter)
        
        WaitSecs(1);
        RestrictKeysForKbCheck([]);
        KbWait();
        feedbackCounter=0;
    end
    imno= randi([1,numel(data)],1,1);
    amno= randi([1,numel(amountList)],1,1);
    %resize
    [imSizeY,imSizeX, unused] = size(data(imno).image);
    x=windowWidth/imSizeX;
    y= windowHeight/imSizeY;
    f = min([x,y]);
    
    %instance of class
    %smallImage=imresize(data(imno).image,f-0.00);
    %% resize image resolution
    simg = size(data(imno).image);
    simg(1) = simg(1)-1024-0-1;
    simg(2) = simg(2)-1280-0-1;

    if all(simg(1:2)>0)
        rx=ceil(rand*simg(2));
        ry=ceil(rand*simg(1));
        smallImage=data(imno).image(ry:ry+1024-0-1,rx:rx+1280-0-1,:);
    end

    stim=bubbles(smallImage, amountList(amno),settings.sd,settings.shadeOfGrey);
    theImage=stim.stimulus();
    disp(amountList(amno))
    disp(data(imno).type)
    
    %write location data
    fprintf(bubbleFileHandle, 'Trial %d\n', trial);
    for b = 1:numel(stim.xLocations)
        x=stim.xLocations(b);
        y=stim.yLocations(b);
        fprintf(bubbleFileHandle, ',%d,%d\n',x, y);
    end
        
    %present FixCross
    big=50;
    line=5;
    FixCross(big, line, window)
    WaitSecs(1);
    
    %this prepares the image for PTB presentation
    imageTexture = Screen('MakeTexture', window, theImage);
    %WHAT DOES THIS DO??
    Screen('DrawTexture', window, imageTexture, [], [], 0);
    %this presents the prepared bit in the window
    
    t0=Screen('Flip', window);
    WaitSecs(0.1);
    
    %guard against other keys being pressed. Program will not react to keys
    %other than 'y' and 'n'
    RestrictKeysForKbCheck([KbName('y'), KbName('n')]);
    [t1, keyCode, deltaSecs]=KbWait();
    
    secs=t1-t0;
   
    if KbName(keyCode)=='y'
        if data(imno).type==1
            correct=true;
        else
            correct=false;
        end
        
    elseif KbName(keyCode)=='n'
        if data(imno).type==1
            
            correct=false;
        else
            correct=true;
        end
    end
    
    if correct==true
        feedbackCounter=feedbackCounter+1;
    end
   %'Trial, Image, Amount, Target, Response, Correct, Time'
    fprintf(infoFileHandle, '%s,%d,%s,%f,%d,%s,%d,%f\n', subject, trial, data(imno).name, amountList(amno), data(imno).type, KbName(keyCode), double(correct), secs);
    
    data(imno).seen = data(imno).seen+1;
    if data(imno).seen==nPerImage        
    %delete from list, so that it doesnt show up again
        data(imno)=[];
    end
    amountList(amno)=[];
    Screen('Close', imageTexture)
    
end
%% TY
ThankYou(window)
RestrictKeysForKbCheck([]);
WaitSecs(0.3);
KbWait()

%% Close Everything
fclose(bubbleFileHandle);
fclose(infoFileHandle);
Screen('Close', window); % Grafikfenster wieder schlieﬂen