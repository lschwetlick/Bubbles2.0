function [  ] = FailScreen( window, bg )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[y,Fs] = audioread('Stimuli/Wrong.mp3');
sound(y,Fs);
[windowWidth, windowHeight]=Screen('WindowSize', window);
% text Position 
textX= windowWidth*0.15;
textY= windowHeight*0.35;
% size and font
textSize=round(windowHeight*0.15);
textSpace=textSize+(windowHeight*0.03);
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, textSize);
%Screen('TextStyle', window, [4]);
Screen('TextStyle', window, [1]);

% plot the writing
Screen('FillRect', window, [154 11 11])
Screen('DrawText', window, 'FALSCH!', textX, textY,[200 200 200]);

% present

Screen('Flip', window);
Screen('FillRect', window, bg)
Screen('DrawText', window, [0 0 0]);

end

