classdef textdisplays
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        window=1;
        windowWidth= 300;
        windowHeight=300;
        textX=10; 
        textY=10;
        textSize=12;
        textSpace=4;
    end
    
    methods
        function obj=textdisplays(window)
            %constructor
            obj.window=window;
            [obj.windowWidth, obj.windowHeight]=Screen('WindowSize', window);
            obj.textX= obj.windowWidth*0.07;
            obj.textY= obj.windowHeight*0.1;
            obj.textSize=round(obj.windowHeight*0.03);
            obj.textSpace=obj.textSize+(obj.windowHeight*0.03);
        end %constructor function
            
        function obj=FirstInstr(obj)
            disp('lala')
            Screen('TextFont', obj.window, 'Arial');
            Screen('TextSize', obj.window, obj.textSize);
            Screen('TextStyle', obj.window, [0]);
            disp('hello')
            % plot the writing
            Screen('DrawText', obj.window, 'Willkommen bei unserem Experiment!', obj.textX, obj.textY, [0 0 0]);
            Screen('DrawText', obj.window, 'Zuerst werden Ihnen einige Bilder gezeigt, die Sie sich möglichst ', obj.textX, obj.textY+2*obj.textSpace);
            Screen('DrawText', obj.window, 'genau einprägen sollten.', obj.textX, obj.textY+3*obj.textSpace);
            Screen('DrawText', obj.window, 'Drücken Sie die Maustaste um fortzufahren', obj.textX, obj.textY+5*obj.textSpace);
            % present
            Screen('Flip', obj.window);
            %KbWait()
        end
    end
    
end

