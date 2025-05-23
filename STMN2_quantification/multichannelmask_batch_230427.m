%% Image stitching
addpath('I:\Scripts\Matthew_STMN2\Universal_functions','I:\Scripts\Matthew_STMN2\Image_Stitching') %make sure this is pointed to the correct directory
folders = glob('H:\Matthew STMN2 quantification\MN-230427-iPSCs\2023-04-27\16160\TimePoint_1'); %all the folders you would like to be stitched; can use wildcards in glob function to get multiple

rownumber = 2; %number of images per row
columnnumber =2; %number of images per column
wavelengthnumber = 2; %number of wavelengths
stitchwavelength = 2; %wavelength to use for stitching

for n=1:numel(folders)
    cd(folders{n});
    delete('*_thumb*.tif'); %deletes thumb files
    files = glob('*.tif');
    Stitcher_subtract_bgr_v2(files,rownumber,columnnumber,wavelengthnumber,stitchwavelength);
end


%% STMN2 quantification
addpath('I:\Scripts\Matthew_STMN2\Universal_functions','I:\Scripts\Matthew_STMN2\Multi_channel_localization');

cd('H:\Matthew STMN2 quantification\MN-230427-iPSCs\2023-04-27\16160\TimePoint_1\Stitched_Images');
mkdir('masks');

files = glob('*.tif');
filenumber = numel(files);
datalabels = {'cellcount','STMN2_intensity'};
dataout = zeros(filenumber,numel(datalabels));
options.color = true;

nuclearchannel = 2;
nucleusminradius = 3;
cytoplasmchannel = 1;

parfor n=1:filenumber

file = files{n};
image = tifread(file);

[nuclearmask,cytomask,dilatedmask,neuritemask,backgroundmask,objectmask] = multichannelmask_v1(image,nuclearchannel,nucleusminradius,cytoplasmchannel);

%STMN2 quantification
[STMN2_intensity,~,~] = intensityfinder_v2(image(:,:,1),cytomask);
allcells = numel(STMN2_intensity);
STMN2_intensity(isnan(STMN2_intensity))=[];

array = [allcells,mean(STMN2_intensity)];

dataout(n,:)=[array];
saveastiff(objectmask,strcat('masks\',file(end-6:end-4),'_mask.tif'),options);

end

xlswrite('staininganalysis.xlsx',dataout,'Summary','B2');
xlswrite('staininganalysis.xlsx',datalabels,'Summary','B1');
xlswrite('staininganalysis.xlsx',files,'Summary','A2');

%% graphs

%read in data
addpath('I:\Scripts\Matthew_STMN2\graphs');

file = 'staininganalysis.xlsx';
sheet = 'Summary_reordered';

one =xlsread(file,sheet,'b2:c8'); %read in each separate group
two =xlsread(file,sheet,'b10:c16');
three =xlsread(file,sheet,'b18:c24');
four =xlsread(file,sheet,'b26:c32');
five =xlsread(file,sheet,'b34:c40');
six =xlsread(file,sheet,'b42:c48');
seven =xlsread(file,sheet,'b50:c56');
eight =xlsread(file,sheet,'b58:c64');
negative =xlsread(file,sheet,'b66:c73')

proximity = 10;
lim = [0 600];
points = [0 300 600];
pointlabels = {'0','50','100'};
xspread = .1;
pointsize = 40;

%STMN2
column = 2;
datacolumns = {one(:,column),two(:,column),three(:,column),four(:,column),five(:,column),six(:,column),seven(:,column),eight(:,column),negative(:,column)};
beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)

%cell number
proximity = 100;
lim = [0 10000];
points = [0 5000 10000];
pointlabels = {'0','5000','10000'};
xspread = .1;
pointsize = 40;

column = 1;
datacolumns = {one(:,column),two(:,column),three(:,column),four(:,column),five(:,column),six(:,column),seven(:,column),eight(:,column),negative(:,column)};
beeswarmbar4(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize)

