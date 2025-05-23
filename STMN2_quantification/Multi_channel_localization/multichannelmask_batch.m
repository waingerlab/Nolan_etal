%% 201222 tfMN analysis

addpath('H:/Scripts/Universal_functions','H:/Scripts/Multi_channel_localization');

files = glob('I:\Cyclic IF\Stacked_tfMN_day2_201219\*.tif');
filenumber = numel(files);
datalabels = {'totalcells','hb9','chat','neun','isl','tuj','tuj-isl','tuj-isl-chat','allpos'};
dataout = zeros(filenumber,numel(datalabels));

nuclearchannel = 1;
nucleusminradius = 3;
cytoplasmchannel = 9;

parfor n=1:filenumber

file = files{n};
image = tifread(file);

[nuclearmask,cytomask,dilatedmask,neuritemask,backgroundmask,objectmask, nuclearbinarymask] = multichannelmask_v2(image,nuclearchannel,nucleusminradius,cytoplasmchannel);

% positive calls
[hst1call,hst1mask,hst1background] = positive_caller_v3(image(:,:,2),nuclearmask,backgroundmask,2);
[hb9call,hb9mask,hb9background] = positive_caller_v3(image(:,:,3),nuclearmask,backgroundmask,2);
[chatcall,chatmask,chatbackground] = positive_caller_v3(image(:,:,4),dilatedmask,backgroundmask,2);
[neuncall,neunmask,neunbackground] = positive_caller_v3(image(:,:,5),dilatedmask,backgroundmask,2);
[hst2call,hst2mask,hst2background] = positive_caller_v3(image(:,:,6),nuclearmask,backgroundmask,2);
[GFAPcall,GFAPmask,GFAPbackground] = positive_caller_v3(image(:,:,7),dilatedmask,backgroundmask,2);
[Islcall,Islmask,Islbackground] = positive_caller_v3(image(:,:,8),nuclearmask,backgroundmask,2);
[Tujcall,Tujmask,Tujbackground] = positive_caller_v3(image(:,:,9),dilatedmask,backgroundmask,2);

array = [hst1call, hst2call, hb9call, chatcall, neuncall,Islcall, Tujcall];
nuclei = array(:,1)==1; %delete nuclei that don't overlap with hoechst channels
array = array(nuclei,:);
nuclei = array(:,2)==1;
array = array(nuclei,:);

totalcells = sum(array(:,1));
hb9pos = sum(array(:,3))/totalcells*100;
chatpos = sum(array(:,4))/totalcells*100;
neunpos = sum(array(:,5))/totalcells*100;
islpos = sum(array(:,6))/totalcells*100;
tujpos = sum(array(:,7))/totalcells*100;

tujislpos = sum(array(:,6)==1 & array(:,7)==1)/totalcells*100;
tujislchatpos = sum(array(:,4)==1 & array(:,6)==1 & array(:,7)==1)/totalcells*100;
fivepos = sum(array(:,3)==1 & array(:,4)==1 & array(:,5)==1 & array(:,6)==1 & array(:,7)==1)/totalcells*100;

dataout(n,:)=[totalcells,hb9pos,chatpos,neunpos,islpos,tujpos,tujislpos,tujislchatpos,fivepos];

end

xlswrite('staininganalysis.xlsx',dataout,'Summary','B2');
xlswrite('staininganalysis.xlsx',datalabels,'Summary','B1');
xlswrite('staininganalysis.xlsx',files,'Summary','A2');


%% 20122 smMN analysis
addpath('H:/Scripts/Universal_functions','H:/Scripts/Multi_channel_localization');

files = glob('I:\Cyclic IF\Stacked_smMN_day22\*.tif');
filenumber = numel(files);
datalabels = {'totalcells','hb9','chat','neun','isl','tuj','tuj-isl','tuj-isl-chat','allpos'};
dataout = zeros(filenumber,numel(datalabels));

nuclearchannel = 1;
nucleusminradius = 3;
cytoplasmchannel = 8;

parfor n=1:filenumber

file = files{n};
image = tifread(file);

[nuclearmask,cytomask,dilatedmask,neuritemask,backgroundmask,objectmask] = multichannelmask_v1(image,nuclearchannel,nucleusminradius,cytoplasmchannel);

% positive calls
[hb9call,hb9mask,hb9background] = positive_caller_v3(image(:,:,2),nuclearmask,backgroundmask,2);
[chatcall,chatmask,chatbackground] = positive_caller_v3(image(:,:,3),dilatedmask,backgroundmask,2);
[neuncall,neunmask,neunbackground] = positive_caller_v3(image(:,:,4),dilatedmask,backgroundmask,2);
[hst2call,hst2mask,hst2background] = positive_caller_v3(image(:,:,5),nuclearmask,backgroundmask,2);
[GFAPcall,GFAPmask,GFAPbackground] = positive_caller_v3(image(:,:,6),dilatedmask,backgroundmask,2);
[Islcall,Islmask,Islbackground] = positive_caller_v3(image(:,:,7),nuclearmask,backgroundmask,2);
[Tujcall,Tujmask,Tujbackground] = positive_caller_v3(image(:,:,8),dilatedmask,backgroundmask,2);

array = [hst2call, hb9call, chatcall, neuncall,Islcall, Tujcall];
nuclei = array(:,1)==1; %delete nuclei that don't overlap with hoechst channels
array = array(nuclei,:);

totalcells = sum(array(:,1));
hb9pos = sum(array(:,2))/totalcells*100;
chatpos = sum(array(:,3))/totalcells*100;
neunpos = sum(array(:,4))/totalcells*100;
islpos = sum(array(:,5))/totalcells*100;
tujpos = sum(array(:,6))/totalcells*100;

tujislpos = sum(array(:,5)==1 & array(:,6)==1)/totalcells*100;
tujislchatpos = sum(array(:,5)==1 & array(:,6)==1 & array(:,3)==1)/totalcells*100;
fivepos = sum(array(:,2)==1 & array(:,3)==1 & array(:,4)==1 & array(:,5)==1 & array(:,6)==1)/totalcells*100;

dataout(n,:)=[totalcells,hb9pos,chatpos,neunpos,islpos,tujpos,tujislpos,tujislchatpos,fivepos];

end

xlswrite('staininganalysis.xlsx',dataout,'Summary','B2');
xlswrite('staininganalysis.xlsx',datalabels,'Summary','B1');
xlswrite('staininganalysis.xlsx',files,'Summary','A2');

%% 210126 NGN2 analysis
addpath('I:/Scripts/Universal_functions','I:/Scripts/Multi_channel_localization');

files = glob('I:\Cyclic IF\Stacked_210126_TARDBP_NGN2_day5\*.tif');
filenumber = numel(files);
datalabels = {'bfp2cells','hoechstcells','brn2','foxg1','tuj1','brn2tuj1pos','triplepos','neuritearea/bfp2cells'}; %analyses I want
dataout = zeros(filenumber,numel(datalabels));
options.color = true;

nuclearchannel = 1;
nucleusminradius = 3;
cytoplasmchannel = 5;

parfor n=1:filenumber

file = files{n};
image = tifread(file);

[nuclearmask,cytomask,dilatedmask,neuritemask,backgroundmask,objectmask] = multichannelmask_v1(image,nuclearchannel,nucleusminradius,cytoplasmchannel);

% positive calls
[brn2call,brn2mask,brn2background] = positive_caller_v3(image(:,:,3),nuclearmask,backgroundmask,2);
[foxg1call,foxg1mask,foxg1background] = positive_caller_v3(image(:,:,4),dilatedmask,backgroundmask,2);
[tuj1call,tuj1mask,tuj1background] = positive_caller_v3(image(:,:,5),dilatedmask,backgroundmask,2);
[hst2call,hst2mask,hst2background] = positive_caller_v3(image(:,:,2),nuclearmask,backgroundmask,2);

%prep for writing out
array = [hst2call, brn2call, foxg1call, tuj1call];
nuclei = array(:,1)==1; %delete nuclei that don't overlap with hoechst channels
array = array(nuclei,:);

bfp2cells = max(nuclearmask,[],'all');
totalcells = sum(array(:,1));
brn2pos = sum(array(:,2))/totalcells*100;
foxg1pos = sum(array(:,3))/totalcells*100;
tuj1pos = sum(array(:,4))/totalcells*100;

brn2tuj1pos = sum(array(:,2)==1 & array(:,4)==1)/totalcells*100;
triplepos = sum(array(:,2)==1 & array(:,3)==1 & array(:,4)==1)/totalcells*100;

dataout(n,:)=[bfp2cells,totalcells,brn2pos,foxg1pos,tuj1pos,brn2tuj1pos,triplepos,(sum(neuritemask>0,'all')/bfp2cells)];
saveastiff(objectmask,strcat('masks\',file(end-6:end-4),'_mask.tif'),options);

end

xlswrite('staininganalysis.xlsx',dataout,'Summary','B2');
xlswrite('staininganalysis.xlsx',datalabels,'Summary','B1');
xlswrite('staininganalysis.xlsx',files,'Summary','A2');