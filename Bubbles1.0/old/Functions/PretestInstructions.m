function [ ] = PretestInstructions( window )
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
Screen('DrawText', window, 'Willkommen bei unserem Experiment!', textX, textY, [0 0 0]);
Screen('DrawText', window, 'Zuerst werden wir prüfen ob Sie sich die Bilder, die Ihnen der', textX, textY+2*textSpace);
Screen('DrawText', window, 'Versuchsleiter gezeigt hat, gut gemerkt haben. Wenn Sie die', textX, textY+3*textSpace);
Screen('DrawText', window, 'Bilder nocheinmal sehen wollen, drücken Sie "B".', textX, textY+4*textSpace);
Screen('DrawText', window, 'Sonst beginnt jetzt der Test:', textX, textY+6*textSpace);
Screen('DrawText', window, 'Y - ich kenne das Bild', textX, textY+8*textSpace);
Screen('DrawText', window, 'N - ich kenne das Bild nicht', textX, textY+9*textSpace);
Screen('DrawText', window, 'Drücken Sie eine beliebige Taste um fortzufahren', textX, textY+11*textSpace);
% present
Screen('Flip', window);

end

