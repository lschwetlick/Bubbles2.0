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
Screen('DrawText', window, 'Im n�chsten Teil werden die Bilder, teilweise Verdeckt pr�sentiert.', textX, textY,[0 0 0]);
Screen('DrawText', window, 'Bitte versuchen Sie die Bilder die Sie kennengelernt haben ', textX, textY+textSpace);
Screen('DrawText', window, 'wiederzuerkennen. Nehmen Sie sich f�r jedes Bild soviel Zeit, wie ', textX, textY+2*textSpace);
Screen('DrawText', window, 'Sie brauchen.', textX, textY+3*textSpace);
Screen('DrawText', window, 'Klicken Sie einfach auf den richtigen Namen zu jedem Bild.', textX, textY+5*textSpace);
Screen('DrawText', window, 'Dr�cken Sie die Maustaste um fortzufahren', textX, textY+8*textSpace);
% present
Screen('Flip', window);

end

