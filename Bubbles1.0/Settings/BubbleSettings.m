sca%% Bubble settings
% amount of bubbles to start with
%nBubble=6;
%standard deviation of gaussian window
sd=12;
% color of the mask
overlayGrey=.6;
%color of the background(behind the stimulus)
backgroundColor = [255 255 255];
% how many times should each target be presented
nTimes = 10;
% which amounts of bubbles should be shown
amounts= 3:3:21;
% what should the percentage of distractors in the set be
distractorRatio = 0.5;


%% Export
settings= struct('sd',sd,'shadeOfGrey',overlayGrey,'background', backgroundColor,'nTimes', nTimes, 'amounts',amounts,'distractorRatio',distractorRatio);
save('settings/BubbleSettings.mat', 'settings')