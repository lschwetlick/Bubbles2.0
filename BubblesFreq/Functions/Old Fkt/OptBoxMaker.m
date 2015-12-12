function [ optBoxStats ] = OptBoxMaker( nBoxes, windowHeight, windowWidth )
%Prepares a matrix as can be used by the drawrect command
optHeight=floor(windowHeight/nBoxes);
optBoxStats=[];
    for i= [1:nBoxes]
        optBoxStats(1,i)=windowWidth-200;
        optBoxStats(2,i)=optHeight*(i-1);
        optBoxStats(3,i)=windowWidth;
        optBoxStats(4,i)=optHeight*i;
    end
    optBoxStats(4,nBoxes)=windowHeight;
%     optBoxStats=optBoxStats.';
end

