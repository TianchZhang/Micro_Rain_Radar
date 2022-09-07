%Description:
%Cases  of shallow stratiform
% History:
% 2022.09.07 by zhangtc

%%
clear 
mrrname1 = 'E:\DATA\MRR\h5_aveMRR_LT\MRR_AveData_20220509.h5'; 
mrrpname1 = 'E:\DATA\MRR\h5_parameters_LT\MRR_Parameters_20220509.h5';
ottname1 = 'E:\DATA\OTTParsivel\nonQC2019-\20220509.h5';

type0509 = h5read(ottname1,'/typeflag');
rain0509 = h5read(ottname1,'/rainflag');
ZZ = h5read(mrrname1,'/Radar_Reflectivity');
RR= h5read(mrrname1,'/Rain_Rate');
ND = h5read(mrrname1,'/Spectral_Drop_Densities');

rf1 = find(rain0509 >0);
tf1 = find(type0509>1);
figure;
plot(1:1440,rain0509,1:1440,type0509);

tempZZ = ZZ(1:15,1380:1440);


%23:00~24:00
%ZZ 
tempZZ(tempZZ<3) = NaN;
tempZZ(tempZZ>55) = 55;
set(gcf,'Position',get(0,'ScreenSize')*0.5);
ax1 = gca;
tar1 = contourf(1380:1:1440,1:15,tempZZ,'LineColor','none');
view(2);
shading flat
ax1.Layer = 'top';
ax1.FontSize = 12;
ax1.TickLength = [0.01 0.01];
ax1.LineWidth = 1.2;
ax1.XLim = [1380 1440];
ax1.XTick = 1380:20:1440;
ax1.XTickLabel = {'23:00', '23:20', '23:40', '24:00'};
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
c1.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0]*10;
c1.TickLabels = {'0','5','10','15','20','25','30','35','40','45','50'};
title({'2022.05.09';'Radar Reflectivity'});

%
%RR

%%
% clear
% mrrname2 = 'E:\DATA\MRR\h5_aveMRR_LT\MRR_AveData_20220512.h5'; 
% mrrpname2 = 'E:\DATA\MRR\h5_parameters_LT\MRR_Parameters_20220512.h5';
% ottname2 = 'E:\DATA\OTTParsivel\nonQC2019-\20220512.h5';

% type0512 = h5read(ottname2,'/typeflag');
% rain0512 = h5read(ottname2,'/rainflag');
% rf2 = find(rain0512 >0);
% tf2 = find(type0512>1);
% plot(1:1440,rain0512,1:1440,type0512);
% tempZZ = ZZ(1:15,1380:1440);