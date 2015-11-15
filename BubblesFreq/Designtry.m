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

p=imread('cat.jpg');
r=rgb2gray(p);
s=bubbles(r);
i=s.stimulus();

%this prepares the image for PTB presentation
imageTexture = Screen('MakeTexture', w, i);

option1 = [windowWidth-200, 0, windowWidth, 100];
option2 = [windowWidth-200, 100, windowWidth, 200];
option3 = [windowWidth-200, 200, windowWidth, 300];
option4 = [windowWidth-200, 300, windowWidth, 400];
option5 = [windowWidth-200, 400, windowWidth, 500];

rects= [option1(1) option2(1) option3(1) option4(1) option5(1); 
    option1(2) option2(2) option3(2) option4(2) option5(2);
    option1(3) option2(3) option3(3) option4(3) option5(3);
    option1(4) option2(4) option3(4) option4(4) option5(4)];


% Screen('FillRect', w, [255 0 255],rects)
% Screen('DrawText', w, 'Buch', option1(1)+20, option1(2)+20,[0 250 0]);
% Screen('DrawTexture', w, imageTexture, [], [], 0);

%this presents the prepared bit in the window

% Screen('Flip', w);
% WaitSecs(0.1);
RestrictKeysForKbCheck([ ]);
Screen('TextFont', w, 'Arial');
Screen('TextSize', w, 30);
Screen('TextStyle', w, [0]);
cols= [
    100 200 100 200 100;
    100 200 100 200 100; 
    100 200 100 200 100];

x=1;
SetMouse(0, 0, w);
while x < windowWidth-200
    disp('FUUU')
    Screen('FillRect', w, cols ,rects)
    
    Screen('DrawText', w, 'Buch', option1(1)+50, option1(2)+35,[0 0 0]);
    Screen('DrawText', w, 'Hase', option2(1)+50, option2(2)+35,[0 0 0]);
    Screen('DrawText', w, 'See', option3(1)+50, option3(2)+35,[0 0 0]);
    Screen('DrawText', w, 'Grab', option4(1)+50, option4(2)+35,[0 0 0]);
    Screen('DrawText', w, 'Spiel', option5(1)+50, option5(2)+35,[0 0 0]);
    
    Screen('DrawTexture', w, imageTexture, [], [], 0);
    Screen('Flip', w);
    [clicks,x,y,whichButton] = GetClicks(w)
    
end

if y>option1(2) && y<option1(4)
    disp('option1')
elseif y>option2(2) && y<option2(4)
    disp('option2')
else
    disp ('x richtung problem')
end


Screen('Close', w); % Grafikfenster wieder schließen