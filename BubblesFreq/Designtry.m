%% setting up presentation
%depending on monitor setup
Screen('Preference', 'SkipSyncTests', 1); 
if length(Screen('screens'))==1
    monitor= 0;
    % size of the smaller window. First two numbers represent the position on the screen, the second two the size
    rect = [30 30 1280 1024];   
    %handle of my Graphic window
    w = Screen('OpenWindow', monitor,0, rect);
else
    monitor = 1; 
    %handle of my Graphic window
    w = Screen('OpenWindow', monitor, 0);
end
[windowWidth, windowHeight]=Screen('WindowSize', w);

%% The screen we're trying out

% p=imread('cat.jpg');
%r=rgb2gray(p);
% s=bubbles(r);
% i=s.stimulus();
dirName = {'./Stimuli/imgs/jpg'};
data=LoadImgData(dirName);
 
TargetsAgain(w,data) 
KbWait() 

Screen('Close', w); % Grafikfenster wieder schlieﬂen