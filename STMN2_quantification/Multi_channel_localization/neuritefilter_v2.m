%% This function finds the area of neurites

function [filteredimage,neuritearea,proportionalarea] = neuritefilter_v2(matrix,sensitivity)

imagesize = size(matrix);
background = imopen(matrix,strel('disk',5));
subtracted = matrix-background;
subtracted = imadjust(subtracted); %normalize fluorescence for segmentation
lsubtracted = imbinarize(subtracted,sensitivity);
filteredimage = bwareafilt(lsubtracted,[100,10000000]);

neuritearea = sum(filteredimage,'all');
proportionalarea = neuritearea/(imagesize(1)*imagesize(2));