%% This script takes an image stack with a nuclear stain and a cytoplasmic stain and makes masks.
%V2 is same as v1, but lower stringency for cytoplasm channel

%this script requires other functions written by AH, so load those
%beforehand:
% Eg. addpath('H:/Scripts/Universal_functions','H:/Scripts/Multi_channel_localization');.

%The inputs are:
%1) the image as a matrix
%2) which channel is the nuclear
%3) what the minimum raidus of a nucleus is in pixels
%4) which channel is the cytoplasm (eg. Tuj)

%The function makes 6 masks:
%dilatedmask = cytoplasm mask + nuclear mask
%cytomask = cytoplasm mask
%nuclearmask = nuclear mask
%neuritemask = neurite mask
%backgroundmask = not cytoplasm, nucleus, or neurite
%objectmask = a synthesis of the nuclear, cytoplasm, and neurite masks for
%display


function [nuclearmask,cytomask,dilatedmask,neuritemask,backgroundmask,objectmask] = multichannelmask_v2(image,nuclearchannel,nucleusminradius,cytoplasmchannel)

[nucleararray, nuclearmask, nuclearnumber, nuclearbinarymask, estimatedmissednuclei, meannucleisize, multinucleicenters] = object_mask_hist_v2(image(:,:,nuclearchannel),nucleusminradius,2); %could be optimized a bit, but is a reasonable start
membranemask = histmask_v2(image(:,:,cytoplasmchannel),1);% calculates mask using histmask_v2, 1 stdevs
[objectmask, dilatedmask] = label_dilatecut_v1(nuclearmask,membranemask,30);
[neuritemask,neuritearea,proportionalarea] = neuritefilter_v2(image(:,:,cytoplasmchannel),.3);
cytomask = dilatedmask-nuclearmask;
neuritemask = neuritemask-logical(dilatedmask);
objectmask = objectmask + repmat((uint8(neuritemask)*128),[1 1 3]);
backgroundmask = ~logical(nuclearbinarymask+membranemask);

backgroundmask2 = ~bwmorph(nuclearbinarymask+membranemask,'thicken',10);

