%% This script takes an image stack with a nuclear stain and a cytoplasmic stain. It makes nuclear and cytoplasmic masks and then queries whether the remaining channels are positive for other stains.

addpath('H:/Scripts/Universal_functions','H:/Scripts/Multi_channel_localization');

file = 'H:\MN_Cyclic_IF\AH-MN-cyclicIF-Stacked\AH-201022-MNday2-Stacked\E04.tif';
nuclearchannel = 1;
nucleusminradius = 3;
cytoplasmchannel = 8;
stdevs = [2 2 2 2 2 2 2 2];
    
image = tifread(file);

%make masks- still need to optimize thresholding
[nucleararray, nuclearmask, nuclearnumber, nuclearbinarymask, estimatedmissednuclei, meannucleisize, multinucleicenters] = object_mask_hist_v2(image(:,:,nuclearchannel),nucleusminradius,2); %could be optimized a bit, but is a reasonable start
membranemask = histmask_v2(image(:,:,cytoplasmchannel),2);% calculates mask using histmask_v2, 2 stdevs
[objectmask, dilatedmask] = label_dilatecut_v1(nuclearmask,membranemask,30);
[neuritemask,neuritearea,proportionalarea] = neuritefilter_v2(image(:,:,cytoplasmchannel),.3);
cytomask = dilatedmask-nuclearmask;
neuritemask = neuritemask-logical(dilatedmask);
objectmask = objectmask + repmat((uint8(neuritemask)*128),[1 1 3]);
backgroundmask = ~logical(nuclearbinarymask+membranemask);

%There are now 5 masks:
%dilatedmask = cytoplasm mask + nuclear mask
%cytomask = cytoplasm mask
%nuclearmask = nuclear mask
%neuritemask = neurite mask
%backgroundmask = not cytoplasm, nucleus, or neurite