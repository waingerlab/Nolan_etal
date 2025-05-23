%% Stitcher Batchscript

%% neurite analysis stitching; 5x5 tiles
addpath('I:/Scripts/Universal_functions','I:/Scripts/Image_Stitching')
folders = glob('I:\AH-BFP2-TdTomato\AH-*-Iso-Astrocytes-week*\*\*\TimePoint_1');

rownumber = 5; %specify image parameters
columnnumber = 5;
wavelengthnumber = 2;
stitchwavelength = 2;

for n=1:numel(folders)
    cd(folders{n});
    delete('*_thumb*.tif'); %deletes thumb files
    files = glob('*.tif');
    Stitcher_subtract_bgr_v2(files,rownumber,columnnumber,wavelengthnumber,stitchwavelength);
end

