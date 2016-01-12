function [ ] = Posttest( window, data, settings, postFileHandle)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
FixSize=50;
FixLine=5;
total=0;
data1=data;
[windowWidth, windowHeight]=Screen('WindowSize', window);

for t=1:numel(data1)
    imno= randi(numel(data1));

    [imSizeY,imSizeX, unused1] = size(data1(imno).image);
    x=windowWidth/imSizeX;
    y= windowHeight/imSizeY;
%    f = min([x,y]);
%     theImage=imresize(data1(imno).image,f-0.01);
    theImage=data1(imno).image;

    %present FixCross
    FixCross(FixSize, FixLine, window)
    WaitSecs(1);

    %this prepares the image for PTB presentation
    imageTexture = Screen('MakeTexture', window, theImage);
    Screen('DrawTexture', window, imageTexture, [], [], 0);
    %this presents the prepared bit in the window
    disp(data1(imno).type)
    Screen('Flip', window);
    WaitSecs(0.1);

    %guard against other keys being pressed. Program will not react to keys
    %other than 'y' and 'n'
    RestrictKeysForKbCheck([KbName('y'), KbName('n')]);
    [unused1, keyCode, unused]=KbWait();

    if KbName(keyCode)=='y'
        if data1(imno).type==1
            correct=true;
        else
            correct=false;
        end
    elseif KbName(keyCode)=='n'
        if data1(imno).type==1
            correct=false;
        else
            correct=true;
        end
    end


    total=total+correct;
    data1(imno)=[];
    Screen('Close', imageTexture)

end
per= (total/t)*100;

fprintf(postFileHandle, '%d', per);

end

