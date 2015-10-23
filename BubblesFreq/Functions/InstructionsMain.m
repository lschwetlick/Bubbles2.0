function [] = InstructionsMain(window)
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
Screen('DrawText', window, 'Im nächsten Teil werden Bilder, teilweise Verdeckt präsentiert.', textX, textY,[0 0 0]);
Screen('DrawText', window, 'Bitte versuchen Sie die Bilder die Sie kennengelernt haben ', textX, textY+textSpace);
Screen('DrawText', window, 'wiederzuerkennen. Nehmen Sie sich für jedes Bild soviel Zeit ', textX, textY+2*textSpace);
Screen('DrawText', window, 'wie Sie brauchen.', textX, textY+3*textSpace);
Screen('DrawText', window, 'Y - ich kenne das Bild', textX, textY+5*textSpace);
Screen('DrawText', window, 'N - ich kenne das Bild nicht', textX, textY+6*textSpace);
Screen('DrawText', window, 'Drücken Sie eine beliebige Taste um fortzufahren', textX, textY+8*textSpace);
% present
Screen('Flip', window);

end

