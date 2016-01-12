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
nBubbles=30;
%nEach=95;
nEach=1;
pause=5;
%% Stim Images
dirName = {'./Stimuli/imgs/smallish'};
%% setting up presentation
%Debugging mode: depending on monitor setup
Screen('Preference', 'SkipSyncTests', 1); 
if length(Screen('screens'))==1
    monitor= 0;
    % size of the smaller window. First two numbers represent the position on the screen, the second two the size
    rect = [30 30 500 500];
    %rect=[];
    %handle of my Graphic window
    window = Screen('OpenWindow', monitor,backgroundColor, rect);
else
    monitor = 2;
    %handle of my Graphic window
    rect = [30 30 500 500];
    %rect=[];
    window = Screen('OpenWindow', monitor, backgroundColor, rect);
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
ShowCursor('Hand', window);
exp=Tests(window, dirName);
t='Willkommen bei unserem Experiment! \nZuerst werden Ihnen einige Bilder gezeigt, die Sie sich möglichst genau einprägen sollten. \n\n Drücken Sie die Maustaste um fortzufahren.';
exp.display.Instructions(t);

%show Targets
exp.TargetsAgain();
%Pretest
pass=false;
while ~pass
    [exp, pass]=exp.Pretest();
end
%Main test
[exp, result]=exp.MainTest(nEach, nBubbles, pause);
%write to CSV
WriteToCSV(result, subject);
%Post Test
[exp,postResults, total]=exp.PostTest();
%write to CSV
WritePostToCSV(subject, postResults, total);
%end
t='Vielen Dank für Ihre Teilnahme!';
exp.display.Instructions(t);
%% Close
Screen('Close', window); % Grafikfenster wieder schließen