function [ ] = TargetsAgain( window, data)
%Shows the Target images and then asks whether to coninue
%   Detailed explanation goes here
[windowWidth, windowHeight]=Screen('WindowSize', window);

for im=1:numel(data)
    if data(im).type==1
        %resize
        [imSizeY,imSizeX, unused1] = size(data(im).image);
        x=windowWidth/imSizeX;
        y= windowHeight/imSizeY;
        f = min([x,y]);

        %instance of class
        theImage=imresize(data(im).image,f-0.01);

        %this prepares the image for PTB presentation

        imageTexture = Screen('MakeTexture', window, theImage);
        %WHAT DOES THIS DO??
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        %this presents the prepared bit in the window

        Screen('Flip', window);
        WaitSecs(0.1);
        KbWait();
    end
end

GenericInstructions(window)
WaitSecs(1);
[unused1, keyCode,unused2]=KbWait();

if KbName(keyCode)=='b'
    TargetsAgain(window, data)
% else
%     Pretest(window, data, settings)
end
    
end

