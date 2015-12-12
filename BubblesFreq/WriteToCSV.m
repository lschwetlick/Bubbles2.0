function [  ] = WriteToCSV( struct, subject )
%writes contents of results to CVS
subject1=int2str(subject);
infoFileName = strcat('Data/Bubbles__Subject',subject1,'_Details.csv');
infoFileHandle = fopen(infoFileName, 'w');
fprintf(infoFileHandle, 'VPNr, Trial, Amount, Image, Response, Correct, Time\n');
for i=[1:numel(struct)]
    fprintf(infoFileHandle, '%s,%d,%d,%s,%s,%d,%d\n', subject1, struct(i).Trial, struct(i).Amount, struct(i).Image, struct(i).Response, struct(i).Correct, struct(i).RT);
end
fclose(infoFileHandle);

bubbleFileName = strcat('Data/Bubbles__Subject',subject1,'_Coordinates.csv');
bubbleFileHandle = fopen(bubbleFileName, 'w');
fprintf(bubbleFileHandle, 'VPNr, Trial, band, XLoc, YLoc\n');
for trial=[1:numel(struct)]
    for band=[1:(numel(struct(trial).Locations)/2)]
        for co=[1:numel(struct(trial).Locations{1,band})]
            fprintf(bubbleFileHandle, '%d,%d,%d,%d,%d\n', subject, struct(trial).Trial, band, struct(trial).Locations{1,band}(co), struct(trial).Locations{2,band}(co));
        end
    end
end
fclose(bubbleFileHandle);

end

