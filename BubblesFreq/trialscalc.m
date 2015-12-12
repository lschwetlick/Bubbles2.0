nBands=6
nBubbles=20

amount=[]
techNBubbles=(4.^[0:nBands-2]); %one less for zero and background
probNBubbles=techNBubbles/sum(techNBubbles);
cutOffNBubbles=cumsum(probNBubbles);
r1= rand(1,nBubbles);
for i=[1:nBands-1] %one of the bands will be background
    amount(i)=sum(r1<cutOffNBubbles(i))-sum(amount);
end