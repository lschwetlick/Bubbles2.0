
%% setting up presentation
%depending on monitor setup
Screen('Preference', 'SkipSyncTests', 1); 
if length(Screen('screens'))==1
    monitor= 0;
    % size of the smaller window. First two numbers represent the position on the screen, the second two the size
    rect = [30 30 1280 1024];   
    %handle of my Graphic window
    w = Screen('OpenWindow', monitor,0, rect);
else
    monitor = 1;
    %handle of my Graphic window
    w = Screen('OpenWindow', monitor, 0);
end
[windowWidth, windowHeight]=Screen('WindowSize', window);


%% The screen we're trying out



% MEASURE the SIZE OF LETTERS: 
TextSizeLetters = 17; % 10.5 pixel width (~0.4�); 17 pixel height 
TextSizeIrrDistractor = 22; % 13 pixel width (~0.5�); 22 pixel height

Screen('TextSize', w, TextSizeLetters);
[letterWidth, letterHeight, textbounds] = DrawFormattedText(w, 'Q');
Lx = textbounds(3); % nicht zentriert; Buchstabe startet links oben
Ly = textbounds(4);

Screen('TextSize', w, TextSizeIrrDistractor);
[letterWidth, letterHeight, textbounds] = DrawFormattedText(w, 'Q');
Dx = textbounds(3)/2; % *1/2 damit Buchstabe auf Linie zentriert ist 
Dy = textbounds(4)/2;

% =======================================
% = TARGET DISPLAY =
% =======================================
% get nontargets:
nontargets = ['k' 'n' 's' 'u' 'v'];
rnt = randperm(length(nontargets));
% get target letter:
trial=1;
tarpos = design(trial,1);
nttype = design(trial,2);
targets = ['x' 'z'];
% get positions:
letters = ['Q' 'Q' 'Q' 'Q' 'Q' 'Q'];
nontarpos = setdiff(1:6, tarpos);
letters(tarpos) = targets(nttype);
letters(nontarpos) = nontargets(rnt);

% compute position coordinates for each letter:
LetterWidthDeg = .4;    % Lavie (1995; Exp.1)
SpaceWidthDeg  = .65;   % Lavie (1995; Exp.1)
LetterWidthPix = 10;
SpaceWidthPix  = 10;

nt = length(letters);
LineLengthPix = nt*LetterWidthPix + (nt-1)*SpaceWidthPix;
cx=124
cy=234
LineStartPix = cx - LineLengthPix/2;
LineEndPix   = cx + LineLengthPix/2;

pos_x = linspace(LineStartPix, LineEndPix-LetterWidthPix, nt);
pos_y = repmat(cy - Ly/2,[1 nt]);

% =======================================
% = PERCEPTUAL LOAD =
% =======================================
cPL = design(trial,5);

if cPL == 1
    shift_values = [5 -5];  % random shift up (-5) or down (+5)
    shift = shift_values(randperm(length(shift_values),1));
    pos_y(tarpos) = pos_y(tarpos) + shift; 
end


% =======================================
% = SENSORY LOAD =
% =======================================
cSL = design(trial,6);

switch cSL
    case 1  % low load: white letters
        let_color = [200 200 200];
    case 2  % high load: grey letters
        let_color = [ 50  50  50];
end

% ===================================
% = % IRRELEVANT DISTRACTOR TASK    =
% ===================================
distOfDistractor = 1.93;
distImageCenter = 2;

% distractor location: above (1) or below (2)?
distLoc = design(trial,3);

switch distLoc
    case 1 % above
        disCoordy = cy - distImageCenter - Dy;
    case 2 % below
        disCoordy = cy + distImageCenter - Dy;
end
disCoordx = cx - Dx;

% distractor type: (1) X and (2) Z
irrDistTypes = ['X', 'Z']; 
irrDist = irrDistTypes(design(trial,5));




% ===============================================
% = % PREPARE SCREEN                            =
% ===============================================
% % Draw target/nontarget letters on screen:

for i = 1:length(letters)
    Screen('TextSize', w, TextSizeLetters);
    Screen('DrawText', w, letters(i), pos_x(i), pos_y(i), let_color);
end

% Draw distractor circle:
Screen('TextSize', w, TextSizeIrrDistractor);
Screen('DrawText', w, irrDist, disCoordx, disCoordy, [200 200 200]);   % light grey 


Screen('DrawTexture', w, screens.fixdisp);
Screen('DrawTexture', w, screens.display);
Screen('Flip', w);












Screen('Close', w); % Grafikfenster wieder schlie�en