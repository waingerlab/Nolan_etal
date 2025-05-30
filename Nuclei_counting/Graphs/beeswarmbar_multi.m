%% This function plots data as beeswarm plots with an average and SEM. It is different from other versions in that it can change how data is displayed within a group (eg. multiple batches with different symbols) 
%This function plots data from a cell array where each column is a group and each row is a batch. Example inputs are shown below:
%
%proximity = 2;                                 %% how close values need to be to be spread apart
%lim = [0 200];                                 %% y-axis limit
%points = [0 50 100 150 200];                   %%points to show
%pointlabels = {'0','50','100','150','200'};    %%how to label points
%xspread = .1;                                  %%how much to spread out points
%pointsize = [40,60];                           %%size of symbols
%symbols = {"o","square"};                      %%type of symbols, see "scatter function"
%color = {[0 0 0],[.5 .5 .5]};                  %%color of symbols
%datacolumns = {TARDBPWT_1,TARDBPG298S_1,PFN1WT_1,PFN1G118V_1;TARDBPWT_2,TARDBPG298S_2,PFN1WT_2,PFN1G118V_2}; %%genotypes written in x direction, batches in y direction
%
%beeswarmbar_multi(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize,color,symbols)


function graph = beeswarmbar_multi(datacolumns,proximity,lim,points,pointlabels,xspread,pointsize,color,symbols)

%sort data for analysis and symbol application
data=datacolumns;
data = arrayfun(@(col) vertcat(data{:, col}), 1:size(data, 2), 'UniformOutput', false); %merge rows by column; no positional data

groupnum= numel(data);
symbolnum = numel(datacolumns(:,1));

%reformat datacolumns- add new row to designate different symbols
for n=1:symbolnum
    for nn=1:groupnum
        temp = datacolumns{n,nn};
        temp(:,2)=n;
        datacolumns{n,nn}=temp;
    end
end
datacolumns = arrayfun(@(col) vertcat(datacolumns{:, col}), 1:size(datacolumns, 2), 'UniformOutput', false);%merge rows by column; positional data included


figure('Color',[1 1 1],'Position',[100, 100,(75*groupnum)+300,500]);
for n=1:groupnum
    %statistics
    avg= mean(data{n});
    counts = numel(data{n});
    SEM = std(data{n})/sqrt(counts);
    
    nscale = (1.2*n)-.5; %controls how closely genotypes are grouped
    
    
    %format the data for plotting
    position = positionfinder2(data{n}); %positionfinder sorts data first, which is why sort function is called later
    
    %% WORKING HERE- can use these statements to alter symbols
    temp = [sortrows(datacolumns{n}),position];
    for nn=1:symbolnum
        temp2=temp(temp(:,2)==nn,:);
        scatter(temp2(:,3),temp2(:,1),pointsize(temp2(1,2)),color{temp2(1,2)},'filled',symbols{temp2(1,2)});
        hold on
    end
    hold on
    
    %this next bit specifies bar colors and widths
    meanwidth = .5;
    SEMwidth = meanwidth/2; 
    
    line([nscale-meanwidth, nscale+meanwidth],[avg,avg],'color','r','linewidth',2.5); %mean
    line([nscale-SEMwidth, nscale+SEMwidth],[avg-SEM,avg-SEM],'color','r','linewidth',1.5); %lower limit
    line([nscale-SEMwidth, nscale+SEMwidth],[avg+SEM,avg+SEM],'color','r','linewidth',1.5); %upper limit
    line([nscale, nscale],[avg+SEM,avg-SEM],'color','r','linewidth',1.5); %connects upper and lower limit

    
end

ax.YAxis.LineWidth = 10000;
ax.XAxis.LineWidth = 10000;
xlim([0 nscale+(meanwidth*1.5)]);
%these next few lines control the y axis
ylim(lim)
set(gca,'Ytick',points,'YTickLabel',pointlabels);
set(gca,'XTickLabel',{},'XTick',[]);
set(gca,'FontSize',20);
set(gca,'FontName','Arial');
set(gca,'Linewidth',2);

hold off


function position = positionfinder2(genotype)

%the point of this function is to scatter overlapping points in a horizontal manner
%without distorting their values (their vertical location)
    
genotype = sort(genotype);
position = [];
dataproximity = proximity; %controls horizontal spread bin size

a=1;
while a<=(numel(genotype))
    if genotype(end)==genotype(a); position = [position; nscale]; %if it's the last data point (because last point wasn't grouped)
    elseif genotype(a+1)-genotype(a)>dataproximity; %if data point is not near others, plot in middle
        position = [position; nscale];
    else group = find(genotype<(genotype(a)+dataproximity) & genotype >= genotype(a)); %if two points are within dataproximity, group them
        if mod(numel(group),2)==0; %if even
            for o=1:numel(group);
            if o==1; position = [position; nscale-(xspread/2)];
            else position = [position; position(end)-(xspread*(o-1)*(-1)^(o-1))]; %equation moves data left/right by dataspread
            end
            end
        else 
            for o=1:numel(group);
            if o==1; position = [position; nscale];
            else position = [position; position(end)+ (xspread*(o-1)*(-1)^(o-1))]; %equation moves data to left/right by dataspread
            end
            end
        end
    end
    a=numel(position)+1;
end
end
end