%Description:
%Cases  of shallow stratiform
% History:
% 2022.09.08 by zhangtc

%%
clear
mrrname1 = 'E:\DATA\MRR\h5_aveMRR_LT\MRR_AveData_20220509.h5';
mrrpname1 = 'E:\DATA\MRR\h5_parameters_LT\MRR_Parameters_20220509.h5';
ottname1 = 'E:\DATA\OTTParsivel\nonQC2019mR-\20220509.h5';
mrrname2 = 'E:\DATA\MRR\h5_aveMRR_LT\MRR_AveData_20220512.h5';
mrrpname2 = 'E:\DATA\MRR\h5_parameters_LT\MRR_Parameters_20220512.h5';
ottname2 = 'E:\DATA\OTTParsivel\nonQC2019mR-\20220512.h5';
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat','central_diameter');
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat', 'diameter_bandwidth');

temp_centr_dia = central_diameter;
temp_dia_bandw = diameter_bandwidth;
type2 = h5read(ottname2,'/typeflag');
rain2 = h5read(ottname2,'/rainflag');

ottND1 = h5read(ottname1,'/ND');
ottRR1 = h5read(ottname1,'/RR');
ottDm1 = h5read(ottname1,'/Dm');
ottNw1 = h5read(ottname1,'/Nw');
ZZ1 = h5read(mrrname1,'/Radar_Reflectivity');
RR1 = h5read(mrrname1,'/Rain_Rate');
ND1 = h5read(mrrname1,'/Spectral_Drop_Densities');
DS = h5read(mrrpname1,'/Drop_Size');
ottND2 = h5read(ottname2,'/ND');
ottRR2 = h5read(ottname2,'/RR');
ottDm2 = h5read(ottname2,'/Dm');
ottNw2 = h5read(ottname2,'/Nw');
ZZ2 = h5read(mrrname2,'/Radar_Reflectivity');
RR2 = h5read(mrrname2,'/Rain_Rate');
ND2 = h5read(mrrname2,'/Spectral_Drop_Densities');

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
%%
%ottDSD
tempND = [ottND1(1234:1263,3:13);ottND1(1413:1440,3:13);ottND2(1333:1409,3:13)];
tempND(tempND<1) = 1;
figure;
set(gcf,'Position',get(0,'ScreenSize')*0.5);
p1=plot(central_diameter(3:13),mean(tempND,1),...
            'Color',[0.3,0.5,0.9],'LineWidth', 2);
p1.Marker = 'd';
p1.MarkerSize = 3;
p1.MarkerFaceColor = 'b';
p1.LineStyle = ':';
% hold on
ax1 = gca;
ax1.XLim = [0 2];
ax1.XTick = 0:0.2:2;
ax1.YScale = 'log';
ax1.YLim = [1 10000];
ax1.YTick = [1 10e1 10e2 10e3 10e4];
ax1.YTickLabel = {'10^{0}','10^{1}','10^{2}','10^{3}','10^{4}'};
ax1.YMinorTick = 'on';
ax1.Box = 'on';
ax1.FontSize = 12;
ax1.TickLength = [0.015 0.02];
ax1.LineWidth = 1.5;
ax1.XLabel.String = 'D(mm)';
ax1.YLabel.String = 'N(D)(m^{-3}\cdotmm^{-1})';
title('OTT Parsivel');
saveas(gcf,'E:\DATA\MRR\Pictures\Casesofshallowstratiform\DSD_ottcases.png');
%%
mrrflag1 = zeros(13,1440);
mrrflag2 = zeros(13,1440);
mrrflag1(RR1(1:13,:)>0.01) = 1;
mrrflag2(RR2(1:13,:)>0.01) = 1;
hND = zeros(13,64);
for ih = 1:13
    
    
end