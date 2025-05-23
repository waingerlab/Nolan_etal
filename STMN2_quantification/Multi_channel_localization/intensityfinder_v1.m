%% This function takes an object mask and an image, and then outputs the sum intensity, avg intensity, and pixel number in the image for each object

function [avgintensity,sumintensity,objectsize] = intensityfinder_v1(inputimage,objectmask)

[row,col,val] = find(objectmask);
index = sub2ind(size(inputimage),row,col);
values = inputimage(index);
objectnumber = max(val,[],'all');

sumintensity = zeros(objectnumber,1);
objectsize = zeros(objectnumber,1);

for n = 1:max(val)
    pixels = values(val==n);
    sumintensity(n) = sum(pixels);
    objectsize(n) = numel(pixels);
end

avgintensity = sumintensity./objectsize;