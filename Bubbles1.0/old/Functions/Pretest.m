function [ ] = Pretest( window, data, settings )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
FixSize=50;
FixLine=5;
total=0;
data1=data;
[windowWidth, windowHeight]=Screen('WindowSize', window);

for trial=1:numel(data1)
    disp(total)
    imno= randi([1,numel(data1)],1,1);

    [imSizeY,imSizeX, ~] = size(data1(imno).image);
    x=windowWidth/imSizeX;
    y= windowHeight/imSizeY;
    f = min([x,y]);
    theImage=imresize(data1(imno).image,f-0.01);

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
    [unused1, keyCode, unused2]=KbWait();

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

    if ~correct
        FailScreen(window, settings.background)
        WaitSecs(2);
    end

    total=total+correct;
    data1(imno)=[];
    Screen('Close', imageTexture)

end

if total/trial<1
    disp('do it again!');
    RestrictKeysForKbCheck([]);
    PretestFailInstructions(window, total, trial)
    WaitSecs(1);
    [unused1, keyCode, unused2]=KbWait();
    
    if KbName(keyCode)=='b'
        TargetsAgain(window,data);
        Pretest(window, data, settings)
    else
        Pretest(window, data, settings);
    end            
    
else
    disp('you did it')
    
end


end

