%% This function vertically aligns stitched images

function [mergedimage,otherimagesout] = verticalaligner_nonoverlap(baseimage,imagetoadd,horizontalmergecell,count,otherimagesout)

dimensions = size(imagetoadd);
basedimensions = size(baseimage);

mergedimage = [baseimage;imagetoadd];

%section that stitches other wavelengths

if numel(horizontalmergecell{1,2})>=1

for n=1:numel(horizontalmergecell{1,2})
    oldimage = otherimagesout{n};
    newimage = horizontalmergecell{count+1,2}{n};
    otherimagesout{n} = [oldimage;newimage];
end

end
    
    
%% temp display images for troubleshooting
%figure;imshow(imadjust(mergedimage))
%figure;imshow(imadjust(alignedimagetoadd))
%figure;imshow(imadjust(imagetoadd))

%figure;imshow(imadjust(top10p))
%figure;imshow(imadjust(bottom10p))
