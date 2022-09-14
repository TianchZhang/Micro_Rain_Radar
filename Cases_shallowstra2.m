%Description:
%Cases  of shallow stratiform
% History:
% 2022.09.08 by zhangtc

%%
clear
mrrname2 = 'E:\DATA\MRR\h5_aveMRR_LT\MRR_AveData_20220512.h5';
mrrpname2 = 'E:\DATA\MRR\h5_parameters_LT\MRR_Parameters_20220512.h5';
ottname2 = 'E:\DATA\OTTParsivel\nonQC2019mR-\20220512.h5';
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat','central_diameter');
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat', 'diameter_bandwidth');
load('E:\Codes\Micro_Rain_Radar\Colormap_GMT_paired.mat');

temp_centr_dia = central_diameter;
temp_dia_bandw = diameter_bandwidth;
ottND2 = h5read(ottname2,'/ND');
ottRR = h5read(ottname2,'/RR');
ottDm2 = h5read(ottname2,'/Dm');
ottNw2 = h5read(ottname2,'/Nw');

type0512 = h5read(ottname2,'/typeflag');
rain0512 = h5read(ottname2,'/rainflag');
ZZ2 = h5read(mrrname2,'/Radar_Reflectivity');
RR2= h5read(mrrname2,'/Rain_Rate');
ND2 = h5read(mrrname2,'/Spectral_Drop_Densities');
DS = h5read(mrrpname2,'/Drop_Size');
rf2 = find(rain0512 >0);
tf2 = find(type0512>1);
% figure;
% plot(1:1440,rain0512,1:1440,type0512);
%23:00~24:00
%%
%ZZ
tempZZ = ZZ2(1:15,1320:1440);
tempZZ(tempZZ<1) = NaN;
tempZZ(tempZZ>55) = 55;
figure;
set(gcf,'Position',get(0,'ScreenSize')*0.5);
ax1 = gca;
tar1 = pcolor(1320:1:1440,1:15,tempZZ);
shading flat
% tar1 = contourf(1380:1:1440,1:15,tempZZ,'LineColor','none');
% view(2);
shading flat
ax1.Layer = 'top';
ax1.FontSize = 12;
ax1.TickLength = [0.01 0.01];
ax1.LineWidth = 1.2;
ax1.XLim = [1320 1440];
ax1.XTick = 1320:30:1440;
ax1.XTickLabel = {'22:00','22:30','23:00', '23:30', '24:00'};
ax1.XLabel.String = 'Local Time';
ax1.XGrid = 'on';
ax1.YLim = [0 15];
ax1.YTick = 0:2.5:15;
ax1.YTickLabel = {'0.0', '0.5', '1.0', '1.5', '2.0', '2.5', '3.0'};
ax1.YLabel.String = 'Height(km)';
ax1.YGrid = 'on';
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
title({'2022.05.12';'Radar Reflectivity'});
saveas(gcf,'E:\DATA\MRR\Pictures\Casesofshallowstratiform\ZZ20220512.png');
%%
%RR
RR2(RR2<=0)=nan;
RR2(RR2<=0.5 &RR2>0)=0.5;
RR2(RR2<=1 &RR2>0.5)=1.5;
RR2(RR2<=1.5 &RR2>1)=2.5;
RR2(RR2<=2 &RR2>1.5)=3.5;
RR2(RR2>2)=4.5;
tempRR = RR2(1:15,1320:1440);
figure;
set(gcf,'Position',get(0,'ScreenSize')*0.5);
tar2 = pcolor(1320:1:1440,1:15,tempRR);
shading flat
% tar1 = contourf(1380:1:1440,1:15,tempRR,'LineColor','none');
% view(2);
ax1 = gca;
ax1.Layer = 'top';
ax1.FontSize = 12;
ax1.TickLength = [0.01 0.01];
ax1.LineWidth = 1.2;
ax1.XLim = [1320 1440];
ax1.XTick = 1320:30:1440;
ax1.XTickLabel = {'22:00','22:30','23:00', '23:30', '24:00'};
ax1.XLabel.String = 'Local Time';
ax1.XGrid = 'on';
ax1.YLim = [0 15];
ax1.YTick = 0:2.5:15;
ax1.YTickLabel = {'0.0', '0.5', '1.0', '1.5', '2.0', '2.5', '3.0'};
ax1.YLabel.String = 'Height(km)';
ax1.YGrid = 'on';
cm2 = colormap(ax1,jet(6));
c2 = colorbar;
c2.Label.String = 'mm\cdoth^{-1}';
caxis([0.01 6.01]);
c2.FontSize = 12;
c2.Ticks = [0.01 1 2 3 4 5 6];
c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5',''};
title({'2022.05.12';'Radar Rate'});
saveas(gcf,'E:\DATA\MRR\Pictures\Casesofshallowstratiform\RR20220512.png');
%%
%ND
tempND = ND2(1:15,:,1320:1440)*10e-3;
tempND(tempND<1) = 1;
for ih = 1:15
     DD = zeros(64,121);
    %     tRloc = find(RR(ih,1200:1440)>0.01);
    %     DD(:,tRloc) = log10(tempND(ih,:,tRloc));
    DD(:,:) = log10(tempND(ih,:,:));
    figure(ih);
    set(gcf,'Position',get(0,'ScreenSize')*0.5);
    tempDS = double(DS(ih,:));
    figure(ih);
    set(gcf,'Position',get(0,'ScreenSize')*0.5);
    tar2 = pcolor(1320:1:1440,tempDS(tempDS>0),DD(tempDS>0,:));
    shading flat
    ax2 = gca;
    ax2.Layer = 'top';
    ax2.FontSize = 12;
    ax2.TickLength = [0.01 0.01];
    ax2.LineWidth = 1.2;
    ax2.XLim = [1320 1440];
    ax2.XTick = 1320:30:1440;
    ax2.XTickLabel = {'22:00','22:30','23:00', '23:30', '24:00'};
    ax2.XLabel.String = 'Local Time';
    ax2.XGrid = 'on';
    ax2.YLim = [0 6];
    ax2.YTick = 0:2:6;
    ax2.YTickLabel = {'0', '2', '4', '6'};
    ax2.YLabel.String = 'Diameter(mm)';
    ax2.YGrid = 'on';
    cm2 = colormap(ax2,[[1,1,1];jet(12);[0.49,0.18,0.56]]);
    c2 = colorbar;
    c2.Label.String = 'log_{10}N(D)';
    caxis([-0.49 6.5]);
    c2.FontSize = 12;
    c2.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0,4.5,5,5.5,6];
    c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5','5.0','5.5','6.0'};
    title({'2022.05.12';['Rain Drop Densities','@',num2str(ih*200),'m'];})
    saveas(gcf,['E:\DATA\MRR\Pictures\Casesofshallowstratiform\ND20220512_',num2str(200*ih),'.png']);
    close
end
%%
tempottND = log10(ottND2(1320:1440,:).');
figure;
set(gcf,'Position',get(0,'ScreenSize')*0.5);
ax2 = gca;
tar2 = pcolor(1320:1:1440,temp_centr_dia - 0.5 * temp_dia_bandw,tempottND);
shading flat
ax2.Layer = 'top';
ax2.FontSize = 12;
ax2.TickLength = [0.01 0.01];
ax2.LineWidth = 1.2;
ax2.XLim = [1320 1440];
ax2.XTick = 1320:30:1440;
ax2.XTickLabel = {'22:00','22:30','23:00', '23:30', '24:00'};
ax2.XLabel.String = 'Local Time';
ax2.XGrid = 'on';
ax2.YLim = [0 6];
ax2.YTick = 0:2:6;
ax2.YTickLabel = {'0', '2', '4', '6'};
ax2.YLabel.String = 'Diameter(mm)';
ax2.YGrid = 'on';
colormap([[1,1,1];jet(8);[0.49,0.18,0.56]]);
c2 = colorbar;
c2.Label.String = 'log_{10}N(D)';
caxis([-0.51 4.5]);
c2.FontSize = 12;
c2.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0];
c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0'};
title({'2022.05.12';'Rain Drop Densities';})
saveas(gcf,['E:\DATA\MRR\Pictures\Casesofshallowstratiform\ND20220512_ott.png']);
%%
%DSD
loc = 1320-15:1440;
tempND2 =  ND2(1:15,:,loc)*10e-3;
tempND2(tempND2<1) = nan;
figure;
set(gcf,'Position',get(0,'ScreenSize')*0.5);
for ih = 1:9
    if length(find(RR2(ih,loc)>0.01))>3
        ihND2 = reshape(tempND2(ih,:,:),64,[]);
        ihND2(ihND2<=0) = nan;
        tempihND2 = mean(ihND2,2,'omitnan');
        tempDS = DS(ih,:);
        %         p1=plot(tempDS(tempDS>0),tempihND1(tempDS>0),...
        %             'Color',[0.3,0.5,0.9],'LineWidth', 2);
        %         % p1.Marker = 'd';
        %         p1.MarkerSize = 3;
        %         p1.LineStyle = ':';
        hold on
        plot(tempDS(tempDS>0),tempihND2(tempDS>0),'-','LineWidth',1.5,'Color',GMT_paired(ih+1,:));
        
        %         title({['Micro Rain Radar','@',num2str(ih*200),'m'];'2022.05.09';})
        %         saveas(gcf,['E:\DATA\MRR\Pictures\Casesofshallowstratiform\DSD20220509_',num2str(200*ih),'.png']);
    end
    hold off
    ax1 = gca;
    ax1.XLim = [0.2 1.8];
    ax1.XTick = 0.2:0.2:1.8;
    ax1.YScale = 'log';
    ax1.YLim = [1 10e5];
    ax1.YTick = [1 10e1 10e2 10e3 10e4 10e5];
    ax1.YTickLabel = {'10^{0}','10^{1}','10^{2}','10^{3}','10^{4}','10^{5}'};
    ax1.YMinorTick = 'on';
    ax1.Box = 'on';
    ax1.FontSize = 12;
    ax1.TickLength = [0.015 0.02];
    ax1.LineWidth = 1.5;
    ax1.XLabel.String = 'D(mm)';
    ax1.YLabel.String = 'N(D)(m^{-3}\cdotmm^{-1})';
    
    title({'Raindrop Size Distribution';'Micro Rain Radar'});
    legend('0.2 km','0.4 km','0.6 km','0.8 km','1.0 km','1.2 km','1.4 km','1.6 km','1.8 km');
    saveas(gcf,['E:\DATA\MRR\Pictures\Casesofshallowstratiform\DSD20220512_mrr.png']);
end

%%
%Nw-Dm
tempDm = ottDm2(1333:1409);
ottNw2(ottNw2<=1)=1;
tempNw = log10(ottNw2(1333:1409));
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
ax.XLim = [0 1.5]; 
ax.YLim = [2.5 5.5];
title('log_{10}Nw - Dm of Shallow Stratiform');
