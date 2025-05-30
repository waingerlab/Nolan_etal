%% Stitcher Batchscript

%2x2 stitching, 2 color
addpath('H:/Scripts/Universal_functions','C:\Users\Aaron\Aaron_Data\Programming\MATLAB\Scripts\Image_Stitching\nonoverlapping')
folders = glob('I:\Scripts\Image_Stitching\nonoverlapping\testimages');

rownumber = 2;
columnnumber = 2;
wavelengthnumber = 2;
stitchwavelength = 2;

for n=1:numel(folders)
    cd(folders{n});
    delete('*_thumb*.tif'); %deletes thumb files

    files = glob('*.tif');
    Stitcher_nonoverlap(files,rownumber,columnnumber,wavelengthnumber,stitchwavelength);
end

