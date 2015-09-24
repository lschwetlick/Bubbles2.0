function [] = FixCross(size, line, window)
%Presents a fix cross with the given parameters
%   size is the length of the lines, line is the thinkness of the line,
%   window is the handle to the current Window
[windowWidth, windowHeight]=Screen('WindowSize', window); %getting window size
centerX=windowWidth/2;
centerY=windowHeight/2;
%vertical line
Screen('DrawLine', window, [0 0 0], centerX, centerY - size, centerX, centerY + size, line);
%horizontal line
Screen('DrawLine', window, [0 0 0], centerX - size, centerY, centerX + size, centerY, line);
%present
Screen('Flip', window);
end

