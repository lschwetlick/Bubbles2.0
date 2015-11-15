% git link: C:/Users/Lisa/Documents/workmat/Bubbles\ Testing\ v07
%clear workspace
clear

addpath('./Functions')
addpath('./Data')
addpath('./Settings')
addpath('./Stimuli')

%% Set up Data
subject = input('VP Nummer:', 's');
bubbleFileName = strcat('Data/Bubbles__Subject',subject,'_Coordinates.csv');
infoFileName = strcat('Data/Bubbles_Subject',subject,'_Details.csv');
postFileName = strcat('Data/Bubbles_Subject',subject,'_Post.csv');

%% Preparing the files
%write out location data
bubbleFileHandle = fopen(bubbleFileName, 'w');
fprintf(bubbleFileHandle, ',x,y\n');
%write out performance datasca

infoFileHandle = fopen(infoFileName, 'w');
fprintf(infoFileHandle, 'VPNr, Trial, Image, Amount, Target, Response, Correct, Time\n');
%write postTest performance
postFileHandle = fopen(postFileName, 'w');
fprintf(postFileHandle, 'percent correct at the end\n');

%% Loading in the Stimulus-Images
dirName = {'./Stimuli/imgs/jpg'};
data=LoadImgData(dirName);
dataCopy=data;

%% bubble parameters
load('Settings/BubbleSettings.mat');
% settings has the following variables:
% - sd
% - shadeOfGrey
% - background
nImages= numel(data);
nEach=1;
nTrials=nImages*nEach;

%% setting up presentation
%Debugging mode: depending on monitor setup
Screen('Preference', 'SkipSyncTests', 1); 
if length(Screen('screens'))==1
    monitor= 0;
    % size of the smaller window. First two numbers represent the position on the screen, the second two the size
    rect = [30 30 500 500];   
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
% FirstInstructions(window)
% WaitSecs(1);
% RestrictKeysForKbCheck([]);
% KbWait();
% TargetsAgain(window, pretestData)
%% Pretest
%Pretest(window, pretestData, settings)
%% Presentation of main instructions
% RestrictKeysForKbCheck([]);
% InstructionsMain(window)
% WaitSecs(1);
% KbWait();
%% Stimulus presentation
feedbackCounter=0;
for trial=1:(nTrials)
    %every 50th trial there is a Break with feedback
    RestrictKeysForKbCheck([ ]);
    if mod(trial,50)==0
        Pause(window, feedbackCounter)
        WaitSecs(1);
        RestrictKeysForKbCheck([]);
        KbWait();
        feedbackCounter=0;
    end
    
    imno = randi([1, numel(data)]);
    disp('Targetnr')
    disp(data(imno).id)
    
    %present FixCross
    big=50;
    line=5;
    FixCross(big, line, window)
    %to allow things to load during the presentation of the cross
    fixT=GetSecs();
%     WaitSecs(1);
    
    smallImage=data(imno).image;
    
    stim=bubbles(rgb2gray(smallImage));
    theImage=stim.stimulus();
%     disp(amountList(amno))
%     disp(data(imno).type)
    
    %write location data
%      fprintf(bubbleFileHandle, 'Trial %d\n', trial);
%      for b = 1:numel(stim.xLocations)
%          x=stim.xLocations(b);
%          y=stim.yLocations(b);
%          fprintf(bubbleFileHandle, ',%d,%d\n',x, y);
%      end
        
    %this prepares the image for PTB presentation
    imageTexture = Screen('MakeTexture', window, theImage);
    
    boxStats=OptBoxMaker(nImages, windowHeight, windowWidth);
%make colors
    for i =[1:nImages]
        if mod(i,2)==0
            cols(1:3,i)=100;
        else
            cols(1:3,i)=200;
        end
    end

    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, 30);
    Screen('TextStyle', window, [0]);
    textCol=[0 0 0];
    x=1;
    SetMouse(0, 0, window);
    while x < windowWidth-200
        disp('FUUU')
        
        for i=[1:nImages]
            Screen('FillRect', window, cols ,boxStats)
        end
        for i=[1:nImages]
            Screen('DrawText', window, dataCopy(i).name, boxStats(1,i)+30, boxStats(2,i)+15,textCol);
        end
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('Flip', window);
        [clicks,x,y,whichButton] = GetClicks(window);

    end

%outputs the answer given
    for i=[1:nImages]
        if y<boxStats(4,i)
            ans=i;
            disp('ans')
            disp(i)
            break
        end
    end
    if ans==data(imno).id
        correct=true;
    else
        correct=false;
    end
    disp('correct')
    disp(correct)
    
%     %make it wait longer if the calculation was quick
%     fixT2 = GetSecs();
%     if fixT2-fixT<1
%         WaitSecs((1-(fixT2-fixT)));
% %         disp('i had to wait')
% %         disp(1-(fixT2-fixT))
%     end

%     secs=t1-t0;
%    
% %     
%      if correct==true
%          feedbackCounter=feedbackCounter+1;
%      end
    %'Trial, Image, Amount, Target, Response, Correct, Time'
%      fprintf(infoFileHandle, '%s,%d,%s,%f,%d,%s,%d,%f\n', subject, trial, data(imno).name, nBubbles, data(imno).type, KbName(keyCode), double(correct), secs);
     
    data(imno).seen = data(imno).seen+1;
    if data(imno).seen==nEach
    %delete from list, so that it doesnt show up again
        data(imno)=[];
    end
%     amountList(amno)=[];
    Screen('Close', imageTexture)
    
end
%% Post Test
% PosttestInstructions(window)
% WaitSecs(0.7);
% RestrictKeysForKbCheck([]);
% KbWait()
% Posttest(window, posttestData, settings, postFileHandle)

% %% TY
% ThankYou(window)
% RestrictKeysForKbCheck([]);
% WaitSecs(0.3);
% KbWait()

%% Close Everything
fclose(bubbleFileHandle);
fclose(infoFileHandle);
fclose(postFileHandle);
Screen('Close', window); % Grafikfenster wieder schließen