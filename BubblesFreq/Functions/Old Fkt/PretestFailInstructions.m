function [  ] = PretestFailInstructions( window,right, total )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
totalstr= num2str(total);
rightstr= num2str(right);
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
Screen('DrawText', window, [rightstr,' von ',totalstr,' Bildern wurden richtig erkannt.'], textX, textY, [0 0 0]);
Screen('DrawText', window, 'Um weiterzumachen sollten alle Bilder erkannt werden.', textX, textY+2*textSpace);
Screen('DrawText', window, 'Drücken Sie die linke Maustaste um die Bilder nochmal zu sehen.', textX, textY+3*textSpace);
Screen('DrawText', window, 'Drücken Sie die rechte Maustaste um den Test nochmal zu', textX, textY+5*textSpace);
Screen('DrawText', window, 'machen.', textX, textY+6*textSpace);


% present
Screen('Flip', window);

end

