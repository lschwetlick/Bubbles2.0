function [  ] = Pause( window, correct )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
correctstr= num2str(correct);
[windowWidth, windowHeight]=Screen('WindowSize', window);
% text Position (at 10% from the top and the right)
textX= windowWidth*0.07;
textY= windowHeight*0.1;
% size and fonty
textSize=round(windowHeight*0.03);
textSpace=textSize+(windowHeight*0.03);
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, textSize);
Screen('TextStyle', window, [0]);
% plot the writing
Screen('DrawText', window, ['In diesem Block haben Sie ', correctstr,' aus 50 richtig erkannt.'], textX, textY, [0 0 0]);
Screen('DrawText', window, 'Sie können jetzt eine Pause machen', textX, textY+2*textSpace);
Screen('DrawText', window, 'Weiter mit der Maustaste.', textX, textY+5*textSpace);

Screen('Flip', window);

end

