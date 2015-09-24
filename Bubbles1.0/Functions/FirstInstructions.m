function [ ] = FirstInstructions( window )
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
Screen('DrawText', window, 'Zuerst werden Ihnen einige Bilder gezeigt, die Sie sich möglichst ', textX, textY+2*textSpace);
Screen('DrawText', window, 'genau einprägen sollten.', textX, textY+3*textSpace);
Screen('DrawText', window, 'Drücken Sie eine beliebige Taste um fortzufahren', textX, textY+5*textSpace);
% present
Screen('Flip', window);

end

