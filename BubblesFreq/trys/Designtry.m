%% setting up presentation
%Debugging mode: depending on monitor setup
Screen('Preference', 'SkipSyncTests', 1); 
if length(Screen('screens'))==1
    monitor= 0;
    % size of the smaller window. First two numbers represent the position on the screen, the second two the size
    %rect = [30 30 500 500];
    rect=[];
    %handle of my Graphic window
    window = Screen('OpenWindow', monitor,[250 250 250], rect);
else
    monitor = 1;
    %handle of my Graphic window
    window = Screen('OpenWindow', monitor, [250 250 250]);
end


[windowWidth, windowHeight]=Screen('WindowSize', window);
%% First Image viewing
dirName = {'./Stimuli/imgs/small'}
a=Tests(window, dirName )
t= 'Nun werden wir prüfen ob Sie sich die Bilder genau gemerkt haben. Wenn Sie die Bilder nocheinmal sehen wollen, drücken Sie die linke Maustaste.\n\nSonst beginnt jetzt der Test:\nKlicken Sie einfach auf den richtigen Namen zu jedem Bild.\n\nDrücken Sie die Maustaste um fortzufahren.'
a.MainTest()
% pass=false;
% while ~pass
%     [a,pass]=a.Pretest();
% end
%[a,w]=a.PostTest();
%DrawFormattedText(window, 'obus maiores alias consequatur aut perferendis doloribus asperiores repellat.', 10,20,0,40)
%Screen('Flip',window);

Screen('Close', window); 