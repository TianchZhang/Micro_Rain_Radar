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
for ifile = 4:4
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
   %ZZ
        tempZZ = ZZ(1:15,mitimeloc:matimeloc);
        tempZZ(tempZZ<0) = NaN;
        tempZZ(tempZZ>55) = 55;
        figure;
        set(gcf,'Position',get(0,'ScreenSize')*0.5);
        ax1 = gca;
        % tar1 = pcolor(1200:1:1440,1:15,tempZZ);
        % shading flat
        tar1 = contourf(mitimeloc:matimeloc,1:15,tempZZ,'LineColor','none');
        view(2);
        shading flat
        ax1.Layer = 'top';
        ax1.FontSize = 12;
        ax1.TickLength = [0.01 0.01];
        ax1.LineWidth = 1.2;
        ax1.XLim = [mitimeloc matimeloc];
        ax1.XTick = mitimeloc:60:matimeloc;
        ttamp = {};
        for ii = 1:fix((matimeloc-mitimeloc)./60)+1
            ttamp = [ttamp;[num2str(fix(mitimeloc./60)+ii-1),':00']];
        end
        ax1.XTickLabel = ttamp;
        ax1.XLabel.String = 'Local Time';
        ax1.XGrid = 'on';
        ax1.YLim = [0 15];
        ax1.YTick = 0:2.5:15;
        ax1.YTickLabel = {'0.0', '0.5', '1.0', '1.5', '2.0', '2.5', '3.0'};
        ax1.YLabel.String = 'Height(km)';
        ax1.YGrid = 'on';
        ax1.Position = [0.08,0.096,0.833,0.836];
        ZZcolormap = [0.494117647058824,0.882352941176471,0.949019607843137;...
            0.0745098039215686,0.623529411764706,1;0,0,1;0,1,0;...
            0.282352941176471,0.701960784313725,0.188235294117647;...
            0.0901960784313726,0.529411764705882,0.0313725490196078;...
            1,1,0;0.929411764705882,0.694117647058824,0.125490196078431;...
            1,0.411764705882353,0.160784313725490;...
            1,0,0;0.635294117647059,0.0784313725490196,0.184313725490196];
        cm1 = colormap(ax1,ZZcolormap);
        c1 = colorbar;
        c1.Label.String = 'dBz';
        caxis([0.01 55.01]);
        c1.Ticks = [0.01 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0]*10;
        c1.TickLabels = {'0','5','10','15','20','25','30','35','40','45','50'};
%         title({'Radar Reflectivity';shallowday(ifile,:)});
        saveas(gcf,['E:\DATA\MRR\Pictures\figure\shallow_ZZ',shallowday(ifile,:),'.png']);
        close
    %%
    %ND
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
    saveas(gcf,['E:\DATA\MRR\Pictures\figure\ND_OTTMRR_',shallowday(ifile,:),'.png']);
    close
    %%
    %DSD
    tempND1 =  ND(1:13,:,mrrloc{ifile,1});
    legloc = [];
    figure;
    set(gcf,'Position',get(0,'ScreenSize')*0.5);
    for ih = 1:13
        if length(find(RR(ih,mrrloc{ifile,1})>0.01))>3
            legloc = [legloc;num2str(sprintf('%3.1f km',ih*0.2))];
            ihND1 = reshape(tempND1(ih,:,:),64,[]);
            ihND1(ihND1<1e-4) = nan;
            tempihND1 = mean(ihND1,2,'omitnan');
            tempDS = DS(ih,:);
            hold on
            plot(tempDS(tempDS>0),tempihND1(tempDS>0),'-','LineWidth',1.5,'Color',GMT_paired(ih+1,:));   
        end
        ax1 = gca;
        ax1.XLim = [0.2 1.6];
        ax1.XTick = 0.2:0.2:1.6;
        ax1.YScale = 'log';
        ax1.YLim = [1e-1 1e5];
        ax1.YMinorTick = 'on';
        ax1.Box = 'on';
        ax1.FontSize = 12;
        ax1.TickLength = [0.015 0.02];
        ax1.LineWidth = 1.5;
        ax1.XLabel.String = 'D(mm)';
        ax1.YLabel.String = 'N(D)(m^{-3}\cdotmm^{-1})';
        %         title({'Raindrop Size Distribution_{Micro Rain Radar}';shallowday(ifile,:)});
        legend(legloc);
    end
    ax1.Position = [0.08,0.096,0.833,0.836];
    tempottND = ottND(mrrloc{ifile,1},3:18);
    tempottND(tempottND<1e-4) = nan;
    plot(central_diameter(3:18),mean(tempottND,1,'omitnan'),...
        'Color',[0,255,255]./255,'LineWidth', 1.5,'DisplayName','Parsivel 2');
    hold off
    saveas(gcf,['E:\DATA\MRR\Pictures\figure\shallow_DSD_',shallowday(ifile,:),'.png']);
    close
    
    
end
