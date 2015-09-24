%% Bubble settings
% amount of bubbles to start with
nBubble=6;
%standard deviation of gaussian window
sd=12;
% color of the mask
overlayGrey=.6;
%color of the background(behind the stimulus)
backgroundColor = [255 255 255];


%% Export
settings= struct('amount', nBubble,'sd',sd,'shadeOfGrey',overlayGrey,'background', backgroundColor);
save BubbleSettings settings