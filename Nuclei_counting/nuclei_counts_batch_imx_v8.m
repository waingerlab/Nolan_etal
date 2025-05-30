%% This script counts the number of nuclei in an image

addpath('I:/Scripts/Universal_functions','I:/Scripts/Image_Stitching')
folders = glob('I:\AH-2111215-Matthew\2021-12-15\15033\TimePoint_1');

for n=1:numel(folders)
    cd(folders{n});
    delete('*_thumb*.tif'); %deletes thumb files
    rownumber = 5;
    columnnumber = 5;
    wavelengthnumber = 1;
    stitchwavelength = 1;
    files = glob('*.tif');
    Stitcher_subtract_bgr_v2(files,rownumber,columnnumber,wavelengthnumber,stitchwavelength);
end

addpath('I:\Scripts\Nuclei_counts','I:/Scripts/Universal_functions');
cd('I:\AH-2111215-Matthew\2021-12-15\15033\TimePoint_1\Stitched_Images');

files = glob('*.tif'); %can be changed

data = cell(numel(files),1);
channel=1; %this is which channel to count on

parfor n=1:numel(files)
    n
    workingfile = tifread(files{n});
    dimensions = size(workingfile);
    if numel(dimensions)==2
        dimensions(3:4)=1;
    end
    temp = zeros(1,dimensions(4),3);
    for nn=1:dimensions(4)
        [objectarray, objectmask, objectnumber, binarymask, estimatedmissedcells, meansize, multiobjectcenters] = object_mask_hist_v2(workingfile(:,:,channel,nn),3,2); %changed to 1st channel
        temp(1,nn,1) = objectnumber + estimatedmissedcells;
        temp(1,nn,2) = objectnumber;
        temp(1,nn,3) = estimatedmissedcells;
    end
    data{n} = temp;
end

data2 = cell2mat(data);    
xlswrite('TARDBP_MN_set3.xlsx',files,'Nuclei_Count','A1');
xlswrite('TARDBP_MN_set3.xlsx',data2(:,:,2),'Nuclei_Count','B1');



%% part 3- analysis of set1
addpath('I:/Scripts/Graphs');

xpoints = [7 14 21 28 35 42 49]; %these mark the time passed in weeks since day 16
xlimit = [0 50];
ypoints = [0 50 100];
ylimit = [0 100];
linecolors = {[0 0 0], [1 0 0]};
shadecolors = {[.5 .5 .5], [.5 0 0]};

file = 'TARDBP_MN_set3.xlsx';
sheet = 'MN_Count';
wtmn = xlsread(file,sheet,'b1:h24');
g298smn = xlsread(file,sheet,'b26:h49');

wtmncell = cell(7,1);
g298smncell = cell(7,1);

for n=1:7
    wtmncell{n} = 100*wtmn(:,n)./wtmn(:,1);
    g298smncell{n} = 100*g298smn(:,n)./g298smn(:,1);
end

repeatplotter_v2([wtmncell,g298smncell],xpoints, xlimit, ypoints, ylimit, linecolors, shadecolors);

%exclude wells with unreliable counting- these are due to fluorescent
%artifacts that I might be able to fix
wtngn2([1,2,5,7,8,10,12,21,22,23],:)=[];
wtmn(23,:)=[];
g298sngn2(2,:)=[];

wtngn2cell = cell(6,1);
g298sngn2cell = cell(6,1);
wtmncell = cell(6,1);
g298smncell = cell(6,1);

for n=1:6
    wtngn2cell{n} = 100*wtngn2(:,n)./wtngn2(:,1);
    g298sngn2cell{n} = 100*g298sngn2(:,n)./g298sngn2(:,1);
    wtmncell{n} = 100*wtmn(:,n)./wtmn(:,1);
    g298smncell{n} = 100*g298smn(:,n)./g298smn(:,1);
end

repeatplotter_v2([wtngn2cell,g298sngn2cell],xpoints, xlimit, ypoints, ylimit, linecolors, shadecolors);
repeatplotter_v2([wtmncell,g298smncell],xpoints, xlimit, ypoints, ylimit, linecolors, shadecolors);

