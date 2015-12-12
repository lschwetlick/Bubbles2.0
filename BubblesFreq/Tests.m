classdef Tests
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        window=1;
        windowWidth= 300;
        windowHeight=300;
        data={};
        display={};

    end
    
    methods
        function obj=Tests(window, dirName)
            obj.window=window;
            [obj.windowWidth, obj.windowHeight]=Screen('WindowSize', window);
            obj.display=textdisplays(window,[250,250,250]);
            obj=obj.LoadImgData(dirName);
            
        end
        %secret functions
        function [optBoxStats]=OptBoxMaker(obj, nBoxes)
            %Prepares a matrix as can be used by the drawrect command
            optHeight=floor(obj.windowHeight/nBoxes);
            optBoxStats=[];
            for i= [1:nBoxes]
                optBoxStats(1,i)=obj.windowWidth-200;
                optBoxStats(2,i)=optHeight*(i-1);
                optBoxStats(3,i)=obj.windowWidth;
                optBoxStats(4,i)=optHeight*i;
            end
            optBoxStats(4,nBoxes)=obj.windowHeight;
        end
 
        function [obj]=LoadImgData(obj, dirName)
            %Loads Images from Indicated Path into the Class
            for i=1:numel(dirName) %over all folders
                files={};
                files = dir( fullfile(dirName{i},'*.jpg') );
                files = {files.name}';
                for j=1:numel(files)
                    fpath = fullfile(dirName{i},files{j});     %full path to file
                    fname = files{j};
                    obj.data(j).image = rgb2gray(imread(fpath)); % load file
                    obj.data(j).name = fname(1:end-4); %file name
                    obj.data(j).path = fpath; %store file path
                    obj.data(j).seen = 0;
                    obj.data(j).id = j;
                end % for 2
            end %for 1
            clearvars files fname fpath dirName i j
        end %fkt
        
        function obj=TargetsAgain(obj)
            textSize=round(obj.windowHeight*0.05);
            Screen('TextSize', obj.window, textSize);
            for im=1:numel(obj.data)
                %Image
                theImage=(obj.data(im).image);
                imageTexture = Screen('MakeTexture', obj.window, theImage);
                %Name Box
                Screen('DrawTexture', obj.window, imageTexture, [], [], 0);
                Screen('FillRect', obj.window, [100 100 100] ,[0 obj.windowHeight-100 obj.windowWidth obj.windowHeight]);
                Screen('DrawText', obj.window, obj.data(im).name, obj.windowWidth/2-50, obj.windowHeight-80,[0 0 0]);
                %Present
                Screen('Flip', obj.window);
                WaitSecs(0.5);
                GetClicks();
                Screen('Close', imageTexture);
            end
            t='Nun werden wir prüfen ob Sie sich die Bilder genau gemerkt haben. Wenn Sie die Bilder nocheinmal sehen wollen, drücken Sie die rechte Maustaste.\n\nSonst beginnt jetzt der Test:\nKlicken Sie einfach auf den richtigen Namen zu jedem Bild.\n\nDrücken Sie die Maustaste um fortzufahren.';
            obj.display.Instructions(t);
            WaitSecs(1);
            [unused, unused2, unused1, button]=GetClicks();
            
            if button==3 %3 is the right mouse button
                obj.TargetsAgain()
%             else  
%                  Pretest(window, data, settings)
            end
            
            
        end
        
        
        function [obj, correct, response, t]=ImageChoice(obj, theImage,id)
            %make Boxes
            nImages=numel(obj.data);
            boxStats=obj.OptBoxMaker(nImages);
            %make colors
            for i =[1:nImages]
                if mod(i,2)==0
                    cols(1:3,i)=100;
                else
                    cols(1:3,i)=200;
                end
            end
            % Text Styling
            Screen('TextFont', obj.window, 'Arial');
            Screen('TextSize', obj.window, 25);
            Screen('TextStyle', obj.window, [0]);
            textCol=[0 0 0];
            imageTexture = Screen('MakeTexture', obj.window, theImage);
            % Set mouse
            mouseX=1;
            SetMouse(obj.windowWidth/2+200, obj.windowHeight/2, obj.window);
            %When you click somewhere in the stimulus, it ignores it
            while mouseX < obj.windowWidth-200
                for i=[1:nImages]
                    Screen('FillRect', obj.window, cols ,boxStats);
                end
                for i=[1:nImages]
                    Screen('DrawText', obj.window, obj.data(i).name, boxStats(1,i)+30, boxStats(2,i)+15,textCol);
                end
                Screen('DrawTexture', obj.window, imageTexture, [], [], 0);
                Screen('Flip', obj.window);
                if mouseX==1
                    t1=GetSecs();
                end
                [clicks,mouseX,mouseY,whichButton] = GetClicks(obj.window);                
            end
            t2=GetSecs();
            t=t2-t1;
            for i=[1:nImages]
                if mouseY<boxStats(4,i)
                    response=i;
                    break
                end
            end
            if response==id
                correct=true;
            else
                correct=false;
            end
            Screen('Close', imageTexture);
        end
        
        function [obj, pass]=Pretest(obj)
            %Pretest outputs pass or fail
            total=0;
            data1=obj.data;
            for trial=1:numel(data1)
                imno= randi(numel(data1));
                theImage=(data1(imno).image);
                %present FixCross
                obj.display.FixCross();
                WaitSecs(1);
                %Presents image and Menu, gives back time and correctness 
                [obj, correct, response, t1]=obj.ImageChoice(theImage, data1(imno).id);
                %what happens when the answer ist correct
                if ~correct
                    obj.display.Fail();
                    WaitSecs(2);
                end
                %add to total correctness taly
                total=total+correct;
                %deletes image from array, so it wont be shown again
                data1(imno)=[]; 
            end
            %When all all are correct quit, otherwise do it all again
            if total/trial<1
                pass=false; 
                RestrictKeysForKbCheck([]);
                obj.display.PreFailInstructions(total, trial);
                WaitSecs(1);
                [unused, unused2, unused1, button]=GetClicks();
                if button==3 %3 is the right mouse button
                    obj=obj.TargetsAgain();
                end
            else
                pass=true;
            end
        end  %Funtion
        
        function [obj, total]=PostTest(obj)
            t='Im letzten Teil des Experiments möchten wir Sie bitten nocheinmal die unverdeckten Bilder zu Identifizieren.\nKlicken Sie dazu einfach auf den richtigen Namen zu jedem Bild.\n\nDrücken Sie die Maustaste um fortzufahren.';
            obj.display.Instructions(t);
            data1=obj.data;
            total=0;
            for t=1:numel(data1)
                imno= randi(numel(data1));
                theImage=data1(imno).image;
                %present FixCross
                obj.display.FixCross()
                WaitSecs(1);
                %Presents image and Menu, gives back time and correctness
                [obj, correct, response, t1]=obj.ImageChoice(theImage, data1(imno).id);
                %add to total correctness taly
                total=total+correct;
                %deletes image from array, so it wont be shown again
                data1(imno)=[];
            end
        end
        
        function [obj, results]=MainTest(obj,nEach,nBubbles)
            t='Im nächsten Teil werden die Bilder, teilweise Verdeckt präsentiert. Bitte versuchen Sie die Bilder die Sie kennengelernt haben wiederzuerkennen. Nehmen Sie sich für jedes Bild soviel Zeit, wie Sie brauchen.\nKlicken Sie einfach auf den richtigen Namen zu jedem Bild.\n\nDrücken Sie die Maustaste um fortzufahren.';
            obj.display.Instructions(t);
            results={};
            data1=obj.data;
            feedbackCounter=0;
            %need ntrials
            nImages=numel(data1);
            nTrials=nImages*nEach;
            for trial=1:(nTrials)
                %every 50th trial there is a Break with feedback
                if mod(trial,50)==0
                    obj.display.Pause(feedbackCounter)
                    WaitSecs(1);
                    getClicks();
                    feedbackCounter=0;
                end
                imno = randi([1, numel(data1)]);
                %fixcross
                obj.display.FixCross()
                WaitSecs(1);
                %
                im=data1(imno).image;
                stim=bubbles(im,6,nBubbles,2);
                %Write out some bubbles stats
                results(trial).Trial=trial;
                results(trial).Image=data1(imno).name;
                results(trial).Amount=nBubbles;
                results(trial).Locations=stim.maskLocations; %x direction is 1, y direction is 2
                
                %Image Presentation
                theImage=stim.stimulus;
                [obj, correct, response, t]=obj.ImageChoice(theImage, data1(imno).id);
                disp(t)
                %Adapt
                if correct
                    feedbackCounter=feedbackCounter+1;
                    nBubbles=nBubbles-1;
                else
                    nBubbles=nBubbles+3;
                end
                data1(imno).seen = data1(imno).seen+1;
                %delete from list, so that it doesnt show up again
                if data1(imno).seen==nEach
                    data1(imno)=[];
                end
                %results
                results(trial).Correct=correct;
                results(trial).RT=t;
                results(trial).Response=obj.data(response).name;
            end
            
        end
        
        
    end
    
end

