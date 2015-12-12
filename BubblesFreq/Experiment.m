%% Main File of Bubbles Experiment
% git link: C:/Users/Lisa/Documents/Bubbles2.0
%clear workspace
clear
%% Paths
addpath('./Functions')
addpath('./Data')
addpath('./Settings')
addpath('./Stimuli')
%% Settings
subject = input('VP Nummer:');
backgroundColor=[240 240 240];
nBubbles=20;
nEach=1;
%% Stim Images
dirName = {'./Stimuli/imgs/small'}
%% setting up presentation
%Debugging mode: depending on monitor setup
Screen('Preference', 'SkipSyncTests', 1); 
if length(Screen('screens'))==1
    monitor= 0;
    % size of the smaller window. First two numbers represent the position on the screen, the second two the size
    %rect = [30 30 500 500];
    rect=[];
    %handle of my Graphic window
    window = Screen('OpenWindow', monitor,backgroundColor, rect);
else
    monitor = 1;
    %handle of my Graphic window
    window = Screen('OpenWindow', monitor, backgroundColor);
end
%Testing Mode
% monitor= 0;
%uncomment for lab debug
%rect = [600 0 1880 1024];
%window = Screen('OpenWindow', monitor,settings.background,rect);
%uncomment for test
%rect = [0 0 1880 1024]; 
%window = Screen('OpenWindow', monitor,0.5);

%% Initiate Tests
exp=Tests(window, dirName);
% t='Willkommen bei unserem Experiment! \nZuerst werden Ihnen einige Bilder gezeigt, die Sie sich möglichst genau einprägen sollten. \n\n Drücken Sie die Maustaste um fortzufahren.';
% exp.display.Instructions(t);
% exp.TargetsAgain();
% pass=false;
% while ~pass
%     [exp, pass]=exp.Pretest();
% end
[exp, result]=exp.MainTest(nEach, nBubbles);
WriteToCSV(result, subject);
% [exp,postResults]=exp.PostTest();
postFileName = strcat('Data/Bubbles_Subject',int2str(subject),'_Post.csv');
postFileHandle = fopen(postFileName, 'w');
fprintf(infoFileHandle, 'VPNr, PostScore\n %d,%d', subject, postResults)
% t='Vielen Dank für Ihre Teilnahme!';
% exp.display.Instructions(t);
Screen('Close', window); % Grafikfenster wieder schließen