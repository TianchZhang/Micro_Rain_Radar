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

temp_centr_dia = central_diameter;
temp_dia_bandw = diameter_bandwidth;
ottND = h5read(ottname2,'/ND');
ottRR = h5read(ottname2,'/RR');
ottDm = h5read(ottname2,'/Dm');
ottNw = h5read(ottname2,'/Nw');

type0512 = h5read(ottname2,'/typeflag');
rain0512 = h5read(ottname2,'/rainflag');
ZZ = h5read(mrrname2,'/Radar_Reflectivity');
RR= h5read(mrrname2,'/Rain_Rate');
ND = h5read(mrrname2,'/Spectral_Drop_Densities');
DS = h5read(mrrpname2,'/Drop_Size');
rf2 = find(rain0512 >0);
tf2 = find(type0512>1);
figure;
plot(1:1440,rain0512,1:1440,type0512);
%23:00~24:00
%%
%ZZ
tempZZ = ZZ(1:15,1320:1440);
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
RR(RR<=0)=nan;
RR(RR<=0.5 &RR>0)=0.5;
RR(RR<=1 &RR>0.5)=1.5;
RR(RR<=1.5 &RR>1)=2.5;
RR(RR<=2 &RR>1.5)=3.5;
RR(RR>2)=4.5;
tempRR = RR(1:15,1320:1440);
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
tempND = ND(1:15,:,1320:1440)*10e-3;
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
tempottND = log10(ottND(1320:1440,:).');
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

%%
%Nw-Dm
tempDm = ottDm(1333:1409);
ottNw(ottNw<=1)=1;
tempNw = log10(ottNw(1333:1409));
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