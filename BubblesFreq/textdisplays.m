classdef textdisplays
    %Contains all text based, non-dynamic screens of the Bubbles Experiment
    
    properties
        window=1;
        windowWidth= 300;
        windowHeight=300;
        textX=10; 
        textY=10;
        textSize=12;
        textSpace=4;
        backgroundColor=[];
    end
    
    methods
        function obj=textdisplays(window, backgroundColor)
            %constructor 
            obj.window=window;
            obj.backgroundColor=backgroundColor;
            [obj.windowWidth, obj.windowHeight]=Screen('WindowSize', window);
            obj.textX= obj.windowWidth*0.07;
            obj.textY= obj.windowHeight*0.1;
            obj.textSize=round(obj.windowHeight*0.03);
            obj.textSpace=obj.textSize+(obj.windowHeight*0.03);
            obj=ScreenValues(obj);
            obj.backgroundColor=backgroundColor;
            
        end %constructor function
            
        function obj=ScreenValues(obj)
            Screen('FillRect', obj.window, obj.backgroundColor)
            Screen('TextFont', obj.window, 'Arial');
            Screen('TextSize', obj.window, obj.textSize);
            Screen('TextStyle', obj.window, [0]);
        end
        
        function obj=Instructions(obj,t)
            obj.ScreenValues();
            % Text that will show up
            %t= 'Willkommen bei unserem Experiment! \nZuerst werden Ihnen einige Bilder gezeigt, die Sie sich möglichst genau einprägen sollten. \n\n Drücken Sie die Maustaste um fortzufahren.'
            DrawFormattedText(obj.window, t,obj.textX,obj.textY,0,70,0,0, 2)
            Screen('Flip', obj.window);
            WaitSecs(1);
            GetClicks();
        end
        
        function obj=Fail(obj)
            [y,Fs] = audioread('Stimuli/Wrong.wav');
            sound(y,Fs);
            %We want larger Letters and centering
            textCenterX= obj.windowWidth*0.15;
            textCenterY= obj.windowHeight*0.35;
            textLSize=round(obj.windowHeight*0.15);
            Screen('TextSize', obj.window, textLSize)
            %red background
            Screen('FillRect', obj.window, [154 11 11], [])
            %text
            t='FALSCH!';
            Screen('DrawText', obj.window, t, textCenterX, textCenterY,[200 200 200]);
            Screen('Flip', obj.window);
            %set back to original
            obj.ScreenValues();
            %Screen('DrawText', obj.window, [0 0 0]);
            
        end
        
        function obj=FixCross(obj)
            centerX=obj.windowWidth/2;
            centerY=obj.windowHeight/2;
            size=30;
            line=3;
            %vertical line
            Screen('DrawLine', obj.window, [0 0 0], centerX, centerY - size, centerX, centerY + size, line);
            %horizontal line
            Screen('DrawLine', obj.window, [0 0 0], centerX - size, centerY, centerX + size, centerY, line);
            %present
            Screen('Flip', obj.window);
        end
        
        function obj=PreFailInstructions(obj, right, total)
            obj.ScreenValues();
            totalstr= num2str(total);
            rightstr= num2str(right);
            t=[rightstr,' von ',totalstr,' Bildern wurden richtig erkannt.\nUm weiterzumachen sollten alle Bilder erkannt werden.\n\nDrücken Sie die rechte Maustaste um die Bilder nochmal zu sehen.\nDrücken Sie die linke Maustaste um den Test nochmal zu machen.'];
            DrawFormattedText(obj.window, t,obj.textX,obj.textY,0,70,0,0, 2)
            Screen('Flip', obj.window);
        end
        
        function obj=Pause(obj, right)
            obj.ScreenValues();
            rightstr= num2str(right);
            t=['In diesem Block haben Sie ', rightstr,' aus 50 richtig erkannt.\n\nSie können jetzt eine Pause machen\n\nWeiter mit der Maustaste.'];
            DrawFormattedText(obj.window, t,obj.textX,obj.textY,0,70,0,0, 2)
            Screen('Flip', obj.window);
        end
        
    end
    
end

