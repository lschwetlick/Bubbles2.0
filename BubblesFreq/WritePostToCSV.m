function [ ] = WritePostToCSV(subject, score, total)
subject1=int2str(subject);
postFileName = strcat('Data/Bubbles_Subject',subject1,'_Post.csv');
postFileHandle = fopen(postFileName, 'w');
fprintf(postFileHandle, 'VPNr, Score, Total\n');
fprintf(postFileHandle, '%d,%d,%d\n', subject, score, total);
fclose(postFileHandle);

end

