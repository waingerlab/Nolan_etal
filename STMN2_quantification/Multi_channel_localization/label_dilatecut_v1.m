%% This function grows labeled objects
%this function grows labeled objects according to the original labeled
%image(labeledobjectmask) if it intersects with a secon mask (cutmask) for the number of growthcycles. The outputs are
%the labeled grown mask (dilatedmask) and a labeled image of the mask where
%the growth is a darker color around the original labeledobjectmask

%function
function [outputimage, dilatedmask] = label_dilatecut_v1(labeledobjectmask,cutmask,growthcycles)

dimensions = size(labeledobjectmask);
labeledobjectmask = uint16(labeledobjectmask);
cutmask = uint16(cutmask);
dilatedmask = labeledobjectmask; %this is the expanded mask that will be iteratively dilated


for n = 1:growthcycles
    dilated = uint16(bwmorph(dilatedmask,'thicken',1)); %grow objects by 1 pixel
    dilated = dilated-uint16(logical(dilatedmask)); %find those new pixels
    dilated = immultiply(dilated,cutmask); %only retain pixels that overlap with the cutmask
    dilated = dilated+dilatedmask+uint16(logical(dilatedmask)); %adds new signal to nuclear mask and also adds 1 so that the first object ==2

    %assign pixels with values ==1
    [col,row] = find(dilated==1);
    dilatedindex = sub2ind([dimensions(1),dimensions(2)],col,row);

    test1 = [col-1,col+1,col,col];
    test1(test1<1)=1; %these two lines are to ensure that edges are not incorporated
    test1(test1>dimensions(1))=dimensions(1);

    test2 = [row,row,row-1,row+1];
    test2(test2<1)=1;
    test2(test2>dimensions(2))=dimensions(2);

    testmatrix = sub2ind([dimensions(1),dimensions(2)],test1,test2); %make a list of the four possible different neighbors
    neighborvalues = dilated(testmatrix); %find the values of neighbors (one should be the nearby object label)
    newvalues = max(neighborvalues,[],2); %determine that object label
    dilated(dilatedindex)=newvalues; %assign the object label to the new pixel
    dilatedmask = dilated-1; %removes the buffer for the first object and any unassigned pixels
end

% this bit shows the labeled objects in different colors
labeledimage = label2rgb(dilatedmask,'jet','k','shuffle');
originalimage = label2rgb(labeledobjectmask,'jet','k','shuffle');
outputimage = (0.5*labeledimage) + (originalimage*0.5);

