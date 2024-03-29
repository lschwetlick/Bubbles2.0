function [ ] = TargetsAgain( window, data)
%Shows the Target images and then asks whether to coninue
%   Detailed explanation goes here
[windowWidth, windowHeight]=Screen('WindowSize', window);
textSize=round(windowHeight*0.05);
Screen('TextSize', window, textSize);
Screen('TextFont', window, 'Arial');

for im=1:numel(data)
    
%         %resize
%         [imSizeY,imSizeX, unused] = size(data(im).image);
%         x=windowWidth/imSizeX;
%         y= windowHeight/imSizeY;
%         f = min([x,y]);

        %instance of class
%         theImage=imresize(data(im).image,f-0.01);
        theImage=rgb2gray(data(im).image);

        %this prepares the image for PTB presentation
        
        %Screen('DrawText', window, dataCopy(i).name, boxStats(1,i)+30, boxStats(2,i)+15,textCol);
        imageTexture = Screen('MakeTexture', window, theImage);
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('FillRect', window, [100 100 100] ,[0 windowHeight-100 windowWidth windowHeight])
        Screen(Screen('DrawText', window, data(im).name, windowWidth/2-50, windowHeight-80,[0 0 0]));
        
        %this presents the prepared bit in the window

        Screen('Flip', window);
        WaitSecs(0.5);
        GetClicks();
   
end

GenericInstructions(window)
WaitSecs(1);
[unused, unused2, unused1, button]=GetClicks()

if button==3 %3 is the right mouse button
    TargetsAgain(window, data)
% else
%     Pretest(window, data, settings)
end
    
end

