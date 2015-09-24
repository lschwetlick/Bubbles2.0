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
Screen('DrawText', window, 'Wir pr�fen jetzt, ob Sie sich die Bilder, die Ihnen der Versuchsleiter', textX, textY,[0 0  0]);
Screen('DrawText', window, 'gezeigt hat, gut gemerkt haben.', textX, textY+textSpace);
Screen('DrawText', window, 'Wenn Sie die Bilder nocheinmal sehen m�chten, dr�cken Sie "B"', textX, textY+2*textSpace);
Screen('DrawText', window, 'Sonst beginnt jetzt der Test:', textX, textY+4*textSpace);
Screen('DrawText', window, 'Y - ich kenne das Bild', textX, textY+6*textSpace);
Screen('DrawText', window, 'N - ich kenne das Bild nicht', textX, textY+7*textSpace);
Screen('DrawText', window, 'Dr�cken Sie eine beliebige Taste um fortzufahren', textX, textY+9*textSpace);
% present
Screen('Flip', window);

end

