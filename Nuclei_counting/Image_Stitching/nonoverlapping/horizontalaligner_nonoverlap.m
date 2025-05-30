function [mergedimage,otherimagesout] = horizontalaligner_nonoverlap(baseimage,imagetoadd,tempindex,imagetoaddindex,stitchwavelength,otheralignedwavelengths,otherwavelengths);
%fixes other wavelength outputs if alignmentwavelength ~=1

mergedimage = [baseimage,imagetoadd];

%section that aligns other wavelengths based on the chosen wavelength
otherimagesout = cell(numel(otherwavelengths),1);
if numel(otherwavelengths)>=1

for n = 1:numel(otherwavelengths)
    oldimage = otheralignedwavelengths{n};
    newimage = tifread_subtract(tempindex{imagetoaddindex + otherwavelengths(n)-stitchwavelength}); %loads in the correct image and then warps based on alignment
    otherimagesout{n} = [oldimage,newimage];
end

end
    
    