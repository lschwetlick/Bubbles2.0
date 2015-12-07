function [ ] = Pretest( window, data, settings )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
FixSize=50;
FixLine=5;
total=0;
data1=data;
[windowWidth, windowHeight]=Screen('WindowSize', window);

for trial=1:numel(data1)
    imno= randi(numel(data1));

    [imSizeY,imSizeX, unused1] = size(data1(imno).image);
    x=windowWidth/imSizeX;
    y= windowHeight/imSizeY;
%    f = min([x,y]);
%     theImage=imresize(data1(imno).image,f-0.01);
    theImage=rgb2gray(data1(imno).image);

    %present FixCross
    FixCross(FixSize, FixLine, window)
    WaitSecs(1);

    %this prepares the image for PTB presentation
    imageTexture = Screen('MakeTexture', window, theImage);
    %make Boxes 
    nImages=numel(data);
    boxStats=OptBoxMaker(nImages, windowHeight, windowWidth);
    %make colors
    for i =[1:nImages]
        if mod(i,2)==0
            cols(1:3,i)=100;
        else
            cols(1:3,i)=200;
        end
    end
    % Text Styling
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, 25);
    Screen('TextStyle', window, [0]);
    textCol=[0 0 0];
    disp('id')
    disp(data1(imno).id)
    % Set mouse
    mouseX=1;
    SetMouse(windowWidth/2+100, windowHeight/2, window);
    %When you click somewhere in the stimulus, it ignores it
    while mouseX < windowWidth-200     
        for i=[1:nImages]
            Screen('FillRect', window, cols ,boxStats)
        end
        for i=[1:nImages]
            Screen('DrawText', window, data(i).name, boxStats(1,i)+30, boxStats(2,i)+15,textCol);
        end
        Screen('DrawTexture', window, imageTexture, [], [], 0);
        Screen('Flip', window);
        if mouseX==1
            t1=GetSecs();        
        end
        [clicks,mouseX,mouseY,whichButton] = GetClicks(window);

    end
    for i=[1:nImages]
        if mouseY<boxStats(4,i)
            ans=i;
            disp('ans')
            disp(i)
            break
        end
    end
    if ans==data1(imno).id
        correct=true;
    else
        correct=false;
    end
    disp('correct')
    disp(correct)

    if ~correct
        FailScreen(window, settings.background)
        WaitSecs(2);
    end

    total=total+correct;
    data1(imno)=[];
    Screen('Close', imageTexture)

end

if total/trial<1
    
    RestrictKeysForKbCheck([]);
    PretestFailInstructions(window, total, trial)
    WaitSecs(1);
    [unused, unused2, unused1, button]=GetClicks();
    if button==3 %3 is the right mouse button
        TargetsAgain(window, data)
    else
        Pretest(window, data, settings);
    end            
    
else
    
end


end

