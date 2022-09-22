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
for ifile = 1:5
    
    mrrname = ['E:\DATA\MRR\h5_aveMRR_LT\MRR_AveData_',shallowday(ifile,:),'.h5'];
    mrrpname = ['E:\DATA\MRR\h5_parameters_LT\MRR_Parameters_',shallowday(ifile,:),'.h5'];
    ottname = ['E:\DATA\OTTParsivel\nonQC2019mR-\',shallowday(ifile,:),'.h5'];
    
    mitimeloc = fix(min(mrrloc{ifile,1})./60)*60;
    matimeloc = min(1440,(fix(max(mrrloc{ifile,1})./60)+1)*60);
    temp_centr_dia = central_diameter;
    temp_dia_bandw = diameter_bandwidth;
    type = h5read(ottname,'/typeflag');
    rain = h5read(ottname,'/rainflag');
    
    ottND = h5read(ottname,'/ND');
    ottRR = h5read(ottname,'/RR');
    ottDm = h5read(ottname,'/Dm');
    ottNw = h5read(ottname,'/Nw');
    ZZ = h5read(mrrname,'/Radar_Reflectivity');
    RR = h5read(mrrname,'/Rain_Rate');
    ND = h5read(mrrname,'/Spectral_Drop_Densities');
    DS = h5read(mrrpname,'/Drop_Size');

    %%
    tempDm = [ottDm1(1234:1263);ottDm1(1413:1440);ottDm2(1333:1409)];
    ottNw1(ottNw1<=1)=1;
    ottNw2(ottNw2<=1)=1;
    tempNw = [log10(ottNw1(1234:1263));log10(ottNw1(1413:1440));log10(ottNw2(1333:1409))];
    figure;
    set(gcf,'Position',get(0,'ScreenSize')*0.5);
    sc2 = scatter(tempDm,tempNw);
    sc2.Marker = 'o';
    sc2.MarkerEdgeColor = 'green';
    sc2.MarkerFaceColor = 'green';
    % sc2.LineWidth = 0.75;
    ax = gca;
    ax.Box = 'on';
    ax.FontSize = 12;
    ax.TickLength = [0.01 0.01];
    ax.LineWidth = 1.5;
    ax.XLabel.String = 'Dm(mm)';
    ax.YLabel.String = 'log_{10}Nw(mm^{-1}m^{-3})';
    ax.XLim = [0 1.0];
    ax.YLim = [2.5 5.5];
    title('log_{10}Nw - Dm of Shallow Stratiform');
    close
    %%
    %ottDSD
    tempND = [ottND1(1234:1263,3:13);ottND1(1413:1440,3:13);ottND2(1333:1409,3:13)];
    tempND(tempND<=0) = nan;
    figure;
    set(gcf,'Position',get(0,'ScreenSize')*0.5);
    ax1 = gca;
    p1=plot(ax1,central_diameter(3:13),mean(tempND,1,'omitnan'),...
        'Color',[0.3,0.5,0.9],'LineWidth', 1.5);
    p1.Marker = 'd';
    p1.MarkerSize = 3;
    p1.MarkerFaceColor = 'b';
    p1.LineStyle = ':';
    % hold on
    % ax1 = gca;
    ax1.XLim = [0.2 1.8];
    ax1.XTick = 0.2:0.2:1.8;
    ax1.YScale = 'log';
    % ax1.YLim = [1e-1 1e4];
    % ax1.YTick = [1 10e1 10e2 10e3 10e4];
    % ax1.YTickLabel = {'10^{0}','10^{1}','10^{2}','10^{3}','10^{4}'};
    ax1.YMinorTick = 'on';
    ax1.Box = 'on';
    ax1.FontSize = 12;
    ax1.TickLength = [0.015 0.02];
    ax1.LineWidth = 1.5;
    ax1.XLabel.String = 'D(mm)';
    ax1.YLabel.String = 'N(D)(m^{-3}\cdotmm^{-1})';
    title('OTT Parsivel');
%     saveas(gcf,'E:\DATA\MRR\Pictures\Casesofshallowstratiform\DSD_ottcases.png');
%     max(tempND)
    % close
    %%
    loc1 = 1234-15:1263;
    loc2 = 1413-15:1440;
    tempND1 =  ND1(1:9,:,[loc1,loc2])*1e-3;
    tempND1(tempND1<0.1) = nan;
    loc = 1320-15:1440;
    tempND2 =  ND2(1:9,:,loc)*1e-3;
    tempND2(tempND2<0.1) = nan;
    tempNDmmr = cat(3,tempND1,tempND2);
    figure;
    set(gcf,'Position',get(0,'ScreenSize')*0.5);
    hold on
    for ih = 1:9
        ihND = reshape(tempNDmmr(ih,:,:),64,[]);
        tempihND = mean(ihND,2,'omitnan')-BGND(ih,:);
        tempDS = DS(ih,:);
        plot(tempDS(tempDS>0),tempihND(tempDS>0),'-','LineWidth',1.5,'Color',GMT_paired(ih+1,:));
    end
    plot(central_diameter(3:13),mean(tempND,1,'omitnan'),...
        'Color',GMT_paired(end,:),'LineWidth', 1.5);
    hold off
    ax1 = gca;
    ax1.XLim = [0.2 1.8];
    ax1.XTick = 0.2:0.2:1.8;
    ax1.YScale = 'log';
    ax1.YLim = [1e-2 1e5];
    
    ax1.YMinorTick = 'on';
    ax1.Box = 'on';
    ax1.FontSize = 12;
    ax1.TickLength = [0.015 0.02];
    ax1.LineWidth = 1.5;
    ax1.XLabel.String = 'D(mm)';
    ax1.YLabel.String = 'N(D)(m^{-3}\cdotmm^{-1})';
    
    title('Raindrop Size Distribution');
    legend('0.2 km','0.4 km','0.6 km','0.8 km','1.0 km','1.2 km','1.4 km','1.6 km','1.8 km','Parsivel 2');
    %     saveas(gcf,['E:\DATA\MRR\Pictures\Casesofshallowstratiform\DSD_casesall.png']);
end