% git link: C:/Users/Lisa/Documents/workmat/Bubbles\ Testing\ v07
%clear workspace
clear

%addpath('C:\Users\labor\Documents\Forschung\Bubbles\Functions')
%% Set up Data
subject = input('VP Nummer:', 's');
bubbleFileName = strcat('Data/Bubbles__Subject',subject,'_Coordinates.csv');
infoFileName = strcat('Data/Bubbles_Subject',subject,'_Details.csv');
postFileName = strcat('Data/Bubbles_Subject',subject,'_Post.csv');

%% Preparing the files
%write out location data
bubbleFileHandle = fopen(bubbleFileName, 'w');
fprintf(bubbleFileHandle, ',x,y\n');
%write out performance data
infoFileHandle = fopen(infoFileName, 'w');
fprintf(infoFileHandle, 'VPNr, Trial, Image, Amount, Target, Response, Correct, Time\n');
%write postTest performance
postFileHandle = fopen(postFileName, 'w');
fprintf(postFileHandle, 'percent correct at the end\n');

%% Loading in the Stimulus-Images
dirName = {'./Stimuli/subset1', './Stimuli/subset2','./Stimuli/subset3','./Stimuli/subset4'};
allData=LoadImgData(dirName, subject);
dataCopy=allData;
%adding all targets and pretest-distractors
pretestData=allData([allData.type]==1 | [allData.type]==3);
%adding all targets and distractors
data=allData([allData.type]==1 | [allData.type]==4);
%posttest data
posttestData=allData([allData.type]==1 | [allData.type]==2);
%% bubble parameters
load('Settings/BubbleSettings.mat')
% settings has the following variables:
% - sd
% - shadeOfGrey
% - background

%amounts = settings.amounts;
amounts = [10,20];
nAmounts = numel(amounts);
nTargets = sum([data.type]==1);
nDistractors = sum([data.type]==4);
% nEach = settings.nTimes;
nEach = 1;

amountList = repmat(amounts,1,(nTargets*2*nEach));
nPerImage = nAmounts*nEach;
totalTrials = nAmounts*nTargets*2*nEach;

%Image List
targetList = repmat([1:nTargets],1,nPerImage);
% Amount of distractors given by the Ratio
neededD= length(targetList)*2*settings.distractorRatio;
neededDFactor= neededD/nDistractors;
distractorList = repmat([nTargets+1:nTargets+nDistractors],1,ceil(neededDFactor));
distRemove= nDistractors*(ceil(neededDFactor)-neededDFactor);
distractorList(length(distractorList)-distRemove+1:length(distractorList))=[];
%concatenating to become 
imageIndexList=[targetList,distractorList];

if numel(imageIndexList)~=totalTrials
    error('Error: Number of trials and number of Images need to be equal')
end
% the image list gets sorted to be [1,1,1,1,2,2,2,2,3,3,3,3]
imageIndexList=sort(imageIndexList);
% the amounts list stays [1,2,3,4,1,2,3,4]
trialList = struct('imageIndex',num2cell(imageIndexList),'nBubbles',num2cell(amountList));

%% setting up presentation
%Debugging mode: depending on monitor setup
%% setting up presentation
%depending on monitor setup
Screen('Preference', 'SkipSyncTests', 1); 
if length(Screen('screens'))==1
    monitor= 0;
    % size of the smaller window. First two numbers represent the position on the screen, the second two the size
    rect = [30 30 1280 1024];   
    %handle of my Graphic window
    window = Screen('OpenWindow', monitor,settings.background, rect);
else
    monitor = 1;
    %handle of my Graphic window
    window = Screen('OpenWindow', monitor, settings.background);
end

%Testing Mode
% monitor= 0;
%uncomment for lab debug
%rect = [600 0 1880 1024];
%window = Screen('OpenWindow', monitor,settings.background,rect);
%uncomment for test
%rect = [0 0 1880 1024]; 
%window = Screen('OpenWindow', monitor,0.5);

[windowWidth, windowHeight]=Screen('WindowSize', window);
%% First Image viewing
FirstInstructions(window)
WaitSecs(1);
RestrictKeysForKbCheck([]);
KbWait();
TargetsAgain(window, pretestData)
%% Pretest
Pretest(window, pretestData, settings)
%% Presentation of main instructions
RestrictKeysForKbCheck([]);
InstructionsMain(window)
WaitSecs(1);
KbWait();
%% Stimulus presentation
feedbackCounter=0;
for trial=1:(totalTrials)
    if mod(trial,50)==0
        Pause(window, feedbackCounter)
        
        WaitSecs(1);
        RestrictKeysForKbCheck([]);
        KbWait();
        feedbackCounter=0;
    end
    
    randIndex = randi(numel(trialList));
    imno = trialList(randIndex).imageIndex;
    nBubbles = trialList(randIndex).nBubbles;
    trialList(randIndex)=[];
    
    %resize
    [imSizeY,imSizeX, unused] = size(data(imno).image);
    x=windowWidth/imSizeX;
    y= windowHeight/imSizeY;
    f = min([x,y]);
    
    %instance of class
%     smallImage=imresize(data(imno).image,f-0.01);

    %present FixCross
    big=50;
    line=5;
    FixCross(big, line, window)
    %to allow things to load during the presentation of the cross
    fixT=GetSecs();
%     WaitSecs(1);
    
    smallImage=data(imno).image;
    
    stim=bubbles(smallImage, nBubbles,settings.sd,settings.shadeOfGrey);
    theImage=stim.stimulus();
%     disp(amountList(amno))
%     disp(data(imno).type)
    
    %write location data
    fprintf(bubbleFileHandle, 'Trial %d\n', trial);
    for b = 1:numel(stim.xLocations)
        x=stim.xLocations(b);
        y=stim.yLocations(b);
        fprintf(bubbleFileHandle, ',%d,%d\n',x, y);
    end
        
    %this prepares the image for PTB presentation
    imageTexture = Screen('MakeTexture', window, theImage);
    %make it wait longer if the calculation was quick
    fixT2 = GetSecs();
    if fixT2-fixT<1
        WaitSecs((1-(fixT2-fixT)));
%         disp('i had to wait')
%         disp(1-(fixT2-fixT))
    end
    
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
    fprintf(infoFileHandle, '%s,%d,%s,%f,%d,%s,%d,%f\n', subject, trial, data(imno).name, nBubbles, data(imno).type, KbName(keyCode), double(correct), secs);
    
    %data(imno).seen = data(imno).seen+1;
    %if data(imno).seen==nPerImage && data(inmo).type~=4        
    %delete from list, so that it doesnt show up again
    %    data(imno)=[];
    %end
    %amountList(amno)=[];
    Screen('Close', imageTexture)
    
end
%% Post Test
PosttestInstructions(window)
WaitSecs(0.7);
RestrictKeysForKbCheck([]);
KbWait()
Posttest(window, posttestData, settings, postFileHandle)

%% TY
ThankYou(window)
RestrictKeysForKbCheck([]);
WaitSecs(0.3);
KbWait()

%% Close Everything
fclose(bubbleFileHandle);
fclose(infoFileHandle);
fclose(postFileHandle);
Screen('Close', window); % Grafikfenster wieder schließen