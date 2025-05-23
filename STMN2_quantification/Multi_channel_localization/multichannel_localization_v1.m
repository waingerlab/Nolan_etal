%% This script takes an image stack with a nuclear stain and a cytoplasmic stain. It makes nuclear and cytoplasmic masks and then queries whether the remaining channels are positive for other stains.

addpath('H:/Scripts/Universal_functions','H:/Scripts/Multi_channel_localization');

file = 'H:\NGN2\AH-200802 NGN2 1 week Brn2 FoxG1\2020-08-02\13336\TimePoint_1\Stitched_Images\B01.tif';
nuclearchannel = 3;
nucleusminradius = 5;
cytoplasmchannel = 4;
sensitivitymatrix = [1 1 1 1];
    
image = tifread(file);

%make masks- still need to optimize thresholding
[nucleararray, nuclearmask, nuclearnumber, nuclearbinarymask, estimatedmissednuclei, meannucleisize, multinucleicenters] = object_mask_v3(image(:,:,nuclearchannel),nucleusminradius,sensitivitymatrix(nuclearchannel)); %could be optimized a bit, but is a reasonable start
membranemask = bradley(image(:,:,cytoplasmchannel),[500 500],1e-2);% calculates mask using Bradley method, sensitivity values of 0-100
[objectmask, dilatedmask] = label_dilatecut_v1(nuclearmask,membranemask,30);
[neuritemask,neuritearea,proportionalarea] = neuritefilter_v2(image(:,:,cytoplasmchannel),.3);
cytomask = dilatedmask-nuclearmask;
neuritemask = neuritemask-logical(dilatedmask);
objectmask = objectmask + repmat((uint8(neuritemask)*128),[1 1 3]);