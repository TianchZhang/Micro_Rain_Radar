%Description:
%Cases  of shallow stratiform
% History:
% 2022.09.08 by zhangtc

%%
clear
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat','central_diameter');
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat', 'diameter_bandwidth');
load('E:\Codes\Micro_Rain_Radar\Colormap_GMT_paired.mat');
load('E:\DATA\MRR\MRR_BG','BGND');

shallowday = ['20220320';'20220322';'20220509';'20220512';'20220605'];
mrrloc = {618-15:750;835-15:925;[1234-15:1263,1413-15:1440];1333-15:1409;220-15:284};
ottloc = {618:750;835:925;[1234:1263,1413:1440];1333:1409;220:284};
for ifile = 2:2
    mrrname = ['E:\DATA\MRR\h5_aveMRR_LT\MRR_AveData_',shallowday(ifile,:),'.h5'];
    mrrpname = ['E:\DATA\MRR\h5_parameters_LT\MRR_Parameters_',shallowday(ifile,:),'.h5'];
    ottname = ['E:\DATA\OTTParsivel\nonQC2019mR-\',shallowday(ifile,:),'.h5'];
    
    mitimeloc = fix(min(mrrloc{ifile,1})./60)*60;
    matimeloc = min(1440,(fix(max(mrrloc{ifile,1})./60)+1)*60);
    
    ottDS = central_diameter;
    ottDSW = diameter_bandwidth;
    ottND = h5read(ottname,'/ND');
    ottRR = h5read(ottname,'/RR');
    ottDm = h5read(ottname,'/Dm');
    ottNw = h5read(ottname,'/Nw');
    
    type = h5read(ottname,'/typeflag');
    rain = h5read(ottname,'/rainflag');
    ZZ = h5read(mrrname,'/Radar_Reflectivity');
    RR= h5read(mrrname,'/Rain_Rate');
    ND = h5read(mrrname,'/Spectral_Drop_Densities')*1e-3-repmat(BGND,1,1,1440);
    DS = h5read(mrrpname,'/Drop_Size');
    
    %%
    figure;
    set(gcf,'Position',get(0,'ScreenSize')*0.5);
    subplot(4,1,1);
    tempottND = log10(ottND(mitimeloc:matimeloc,:).');
    tempottND(tempottND>10^4.9) = 10^4.8;
    ax2 = gca;
    % tar2 = pcolor(mitimeloc:matimeloc,ottDS - 0.5 * ottDSW,tempottND);
    % shading flat
    tar2 = contourf(mitimeloc:matimeloc,ottDS - 0.5 * ottDSW,tempottND,'LineColor','none');
    view(2);
    ax2.Layer = 'top';
    ax2.FontSize = 12;
    ax2.TickLength = [0.01 0.01];
    ax2.LineWidth = 1.2;
    ax2.XLim = [mitimeloc matimeloc];
    ax2.XTick = mitimeloc:60:matimeloc;
    ax2.XTickLabel = {''};
    ax2.XGrid = 'on';
    ax2.YLim = [0 2];
    ax2.YTick = 0:0.5:2;
    ax2.YTickLabel = {'0.0', '', '1.0', '','2.0'};
    ax2.YLabel.String = 'Diameter(mm)';
    ax2.YLabel.Position = [mitimeloc-8,-3.2,-10];
    ax2.YGrid = 'on';
    ax2.Position = [0.08,0.74,0.833,0.19];
    colormap([[1,1,1];jet(9);[0.49,0.18,0.56]]);
    caxis([-0.51 4.99]);
    c2.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0,4.5];
    c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5'};
    %     title(['Rain Drop Densities-',shallowday(ifile,:)]);
    text(mitimeloc+1,1.8,'(a) Parsivel2','Fontsize',12);
    
    tempND = ND(1:15,:,mitimeloc:matimeloc);
    tempND(tempND<1) = 1;
    tempND(tempND>10^4.9) = 10^4.8;
    legloc = [];
    for ih = 1:3
        subplot(4,1,1+ih);
        if length(find(RR(ih,mrrloc{ifile,1})>0.01))>3
            legloc = [legloc;num2str(sprintf('%3.1f km',ih*0.2))];
            DD = zeros(64,matimeloc-mitimeloc+1);
            DD(:,:) = log10(tempND(ih,:,:));
            DD(DD<=0) = -0.02;
            tempDS = double(DS(ih,:));
            tar2 = contourf(mitimeloc:matimeloc,tempDS(tempDS>0),DD(tempDS>0,:),'LineColor','none');
            view(2);
            %             tar2 = pcolor(mitimeloc:matimeloc,tempDS(tempDS>0),DD(tempDS>0,:));
            %             shading flat
            ax2 = gca;
            ax2.Layer = 'top';
            ax2.FontSize = 12;
            ax2.TickLength = [0.01 0.01];
            ax2.LineWidth = 1.2;
            ax2.Position = [0.08,0.74-0.215*ih,0.833,0.19];
            ax2.XLim = [mitimeloc matimeloc];
            ax2.XTick = mitimeloc:60:matimeloc;
            ax2.XTickLabel = {''};
            ax2.XGrid = 'on';
            ax2.YLim = [0 2];
            ax2.YTick = 0:0.5:2;
            ax2.YTickLabel = {'0.0', '', '1.0', '','2.0'};
            ax2.YGrid = 'on';
            cm2 = colormap(ax2,[[1,1,1];jet(9);[0.49,0.18,0.56]]);
            caxis([-0.51 4.99]);
            c2.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0,4.5];
            c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5'};
        end
        if ih == 1
            text(mitimeloc+1,1.8,'(b) MRR@0.2 km','Fontsize',12);
        elseif ih ==2
            text(mitimeloc+1,1.8,'(c) MRR@0.4 km','Fontsize',12);
        else
            text(mitimeloc+1,1.8,'(d) MRR@0.6 km','Fontsize',12);
        end
    end
    ax2.XLim = [mitimeloc matimeloc];
    ax2.XTick = mitimeloc:60:matimeloc;
    ttamp = {};
    for ii = 1:fix((matimeloc-mitimeloc)./60)+1
        ttamp = [ttamp;[num2str(fix(mitimeloc./60)+ii-1),':00']];
    end
    ax2.XTickLabel = ttamp;
    ax2.XLabel.String = 'Local Time';
    c2 = colorbar;
    c2.Label.String = 'log_{10}N(D)';
    caxis([-0.51 4.99]);
    c2.FontSize = 12;
    c2.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0,4.5];
    c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5'};
    c2.Position = [0.92,0.096,0.0185,0.836];
    
    
end
