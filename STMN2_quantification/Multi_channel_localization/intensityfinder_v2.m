%% This function takes an object mask and an image, and then outputs the sum intensity, avg intensity, and pixel number in the image for each object
%version 2 rewrites to use vector logic instead of loops (about 4-5x
%faster)

function [avgintensity,sumintensity,objectsize] = intensityfinder_v2(inputimage,objectmask)

[row,col,val] = find(objectmask); %find non-zero values
index = sub2ind(size(inputimage),row,col); %index non-zero values

objectsize = [histcounts(objectmask,'BinMethod','integers')]'; %counts pixel numbers for each object
objectsize(1)=[]; %delete 0 values

vals = objectmask(index); %finds object numbers for each index
vals(:,2) = inputimage(index); %finds fluorescent values for each index
vals = sortrows(vals,1); %sort into ascending object number

pixelvalues = mat2cell(vals(:,2),objectsize,1); %segment pixel values into cells based on object number
avgintensity = cellfun(@mean,pixelvalues); %calculate mean for each object
sumintensity = cellfun(@sum,pixelvalues); %calculate sum for each object