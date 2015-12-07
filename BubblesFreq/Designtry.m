%% setting up presentation
%Debugging mode: depending on monitor setup
Screen('Preference', 'SkipSyncTests', 1); 
if length(Screen('screens'))==1
    monitor= 0;
    % size of the smaller window. First two numbers represent the position on the screen, the second two the size
    %rect = [30 30 500 500];
    rect=[];
    %handle of my Graphic window
    window = Screen('OpenWindow', monitor,settings.background, rect);
else
    monitor = 1;
    %handle of my Graphic window
    window = Screen('OpenWindow', monitor, settings.background);
end


[windowWidth, windowHeight]=Screen('WindowSize', window);
%% First Image viewing
a=textdisplays(window)
a.FirstInstr()
WaitSecs(1);
GetClicks()
Screen('Close', window); 