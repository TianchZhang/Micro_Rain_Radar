%Description:
%show the Radar Reflectivity of Micro Rain Radar
% History:
% 2022.07.04 by zhangtc
savepath ='E:\DATA\MRR\Pictures';
file_root = 'E:\DATA\MRR\h5_aveMRR\';
% load('E:\DATA\Parsivel_temporary\Rainevents-allR-3-30.mat')
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat','central_diameter');
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat', 'diameter_bandwidth');

file_day = dir([file_root,'*.h5']);
mrrf = 'E:\DATA\MRR\h5_aveMRR\MRR_AveData_20220330.h5';
ottf = 'E:\DATA\OTTParsivel\nonQC2019-\20220330.h5';
mrrfh = 'E:\DATA\MRR\0330_LT.h5';
NDott = h5read(ottf,'/ND');
NDmrr = h5read(mrrf,'/Spectral_Drop_Densities');
NDmrrh = h5read(mrrfh,'/Spectral Drop Densities');
DS = h5read(mrrf,'/Drop_Size');
DSh = h5read(mrrfh,'/Drop Size');

height = 200:200:6200;
time = 1:1440;
%%%
%1
figure;
set(gcf,'Position',get(0,'ScreenSize'));
ax1 = subplot(3,1,1);
tar1 = pcolor(1:1:1440,central_diameter - 0.5 * diameter_bandwidth,log10(NDott.'));
% title('2022-03-30(LT)')
title('2022-03-30')
shading flat
ax1.Layer = 'top';
ax1.FontSize = 12;
ax1.TickLength = [0.01 0.01];
ax1.LineWidth = 1.2;

ax1.XLim = [0 1440];
ax1.XTick = 0:180:1440;
ax1.XTickLabel = {'00:00', '03:00', '06:00', '09:00', '12:00', '15:00', '18:00', '21:00', '24:00'};
ax1.XGrid = 'on';

ax1.YLim = [0 6];
ax1.YTick = 0:2:6;
ax1.YTickLabel = {'0', '2', '4', '6'};
ax1.YLabel.String = 'Diameter(mm)';
ax1.YGrid = 'on';

cm1 = colormap(ax1,[[1,1,1];jet(8);[0.49,0.18,0.56]]);
c1 = colorbar;
c1.Label.String = 'log_{10}N(D)';
caxis([-0.49 4.5]);
c1.FontSize = 12;
c1.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0];
c1.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0'};
%%
%2
ax2 = subplot(3,1,2);
DSD_show_MRR(DSh(:,1,1),NDmrrh(:,1,:));

%%
%3
ax3 = subplot(3,1,3);
DSD_show_MRR(DS(1,:,1),NDmrr(1,:,:));

%%
for ik = 1:31
   figure;
   DSD_show_MRR(DS(ik,:,1),NDmrr(ik,:,:));
end