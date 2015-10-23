function [  ] = GenericInstructions( window )
%UNTITLED2 Summary of this function goes here
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
Screen('DrawText', window, 'Nun werden wir prüfen ob Sie sich die Bilder genau gemerkt ', textX, textY+textSpace);
Screen('DrawText', window, 'haben. Wenn Sie die Bilder nocheinmal sehen wollen, drücken', textX, textY+2*textSpace);
Screen('DrawText', window, 'Sie "B".', textX, textY+3*textSpace);
Screen('DrawText', window, 'Sonst beginnt jetzt der Test:', textX, textY+5*textSpace);
Screen('DrawText', window, 'Y - ich kenne das Bild', textX, textY+7*textSpace);
Screen('DrawText', window, 'N - ich kenne das Bild nicht', textX, textY+8*textSpace);
Screen('DrawText', window, 'Drücken Sie eine beliebige Taste um fortzufahren', textX, textY+10*textSpace);
% present
Screen('Flip', window);

end

