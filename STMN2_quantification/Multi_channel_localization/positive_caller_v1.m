%% This function takes two masks and identifies whether objects are >x standard deviations above background
%inputs
%inputimage = the image to be analyzed
%objectmask = a mask of objects to be measured
%backgroundmask = a mask that doesn't include objects
%threshold = number of standard deviations above mean for positive call
%
%outputs
%positivecall = vector of whether each object is positive
%callmask = mask of which objects were called positive


function [positivecall,callmask] = positive_caller_v1(inputimage,objectmask,backgroundmask,threshold)


%start of function
stdev = double(immultiply(backgroundmask,inputimage));
stdev = std(stdev(:));

[avgintensity,sumintensity,objectsize] = intensityfinder_v1(inputimage,objectmask);
positivecall = avgintensity>(threshold*stdev);

objects = [1:max(objectmask,[],'all')]';
objects = objects(positivecall);

callmask=ismember(objectmask,objects);