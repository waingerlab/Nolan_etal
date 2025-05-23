%% This function takes the nuclear mask and cytoplasmic channel to make a cytoplasm and neurite mask

%inputs
nuclearmask
cytoplasmchannel = 4;
sensitivitymatrix = [1 1 1 1e-2];    
image = tifread(file);


channel_matrix = image(:,:,cytoplasmchannel);
sensitivity = sensitivitymatrix(cytoplasmchannel);

dimensions = size(channel_matrix);
cytomask = bradley(channel_matrix,[500 500],sensitivity);% calculates mask using Bradley method, sensitivity values of 0-100


%% WORKING HERE
[outputimage, dilatedmask] = label_dilate_dmcut_v1(nuclearmask,cytomask,50);

%% MAKE THIS A SUBFUNCTION- labelgrow?
%grow the nuclear channel by a few pixels if it overlaps with the cytoplasmic signal
dilated = uint16(bwmorph(nuclearmask,'thicken',1)); %grow objects by 1 pixel
dilated = dilated-uint16(logical(nuclearmask));
dilated = immultiply(dilated,cytomask); %makes sure growth overlaps with cytoplasm signal
dilated = dilated+nuclearmask+uint16(logical(nuclearmask)); %adds new signal to nuclear mask and also adds 1 so that the first object ==2

%assign the pixels with value==1 
[col,row] = find(dilated==1);
dilatedindex = sub2ind([dimensions(1),dimensions(2)],col,row);

matrix = zeros(numel(col),4);

test1 = [col-1,col+1,col,col];
test1(test1<1)=1; %these two lines are to ensure that edges are not incorporated
test1(test1>dimensions(1))=dimensions(1);

test2 = [row,row,row-1,row+1];
test2(test2<1)=1;
test2(test2>dimensions(2))=dimensions(2);

testmatrix = sub2ind([dimensions(1),dimensions(2)],test1,test2);
neighborvalues = dilated(testmatrix);
newvalues = max(neighborvalues,[],2);
dilated(dilatedindex)=newvalues;
dilated = dilated-1; %removes the buffer for the first object and any unassigned pixels

%testing
test = logical(dilated-nuclearmask); %it works! the outlines have now expanded by one pixel



%% this section is good for finding the overlap, but I need to grow the nuclear channel a bit first
cytonuclearmask = immultiply(cytomask,nuclearmask);

countspernuclei = countmember(1:max(nuclearmask,[],'all'),nuclearmask)';
countspercytonuclearmask = countmember(1:max(nuclearmask,[],'all'),cytonuclearmask)';
ratio = countspercytonuclearmask./countspernuclei;
ratio = ratio>.75;


