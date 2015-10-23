function [ ] = PosttestInstructions( window )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
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
Screen('DrawText', window, 'Im letzten Teil des Experiments möchten wir Sie bitten', textX, textY, [0 0 0]);
Screen('DrawText', window, 'nocheinmal die unverdeckten Bilder zu Identifizieren.', textX, textY+textSpace);
Screen('DrawText', window, 'Y - bekanntes Bild', textX, textY+4*textSpace);
Screen('DrawText', window, 'N - unbekanntes Bild ', textX, textY+5*textSpace);
Screen('DrawText', window, 'Drücken Sie eine beliebige Taste um fortzufahren', textX, textY+8*textSpace);
% present
Screen('Flip', window);

end

