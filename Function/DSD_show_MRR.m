%Description:
%show the number concentration of raindrops,rain rate and rainfall per minute everyday
% History:
% 2022.07.04 by zhangtc

function DSD_show_MRR(drop_size,drop_densities)
set(gcf,'Position',get(0,'ScreenSize')*0.5);
drop_densities(drop_densities<1)=1;
tempdsh = double(drop_size);
tempndh = double(reshape(log10(drop_densities),[64,1440]));

tar2 = pcolor(1:1:1440,tempdsh(tempdsh>0),tempndh(tempdsh>0,:));
shading flat
ax2 = gca;
ax2.Layer = 'top';
ax2.FontSize = 12;
ax2.TickLength = [0.01 0.01];
ax2.LineWidth = 1.2;

ax2.XLim = [0 1440];
ax2.XTick = 0:180:1440;
ax2.XTickLabel = {'00:00', '03:00', '06:00', '09:00', '12:00', '15:00', '18:00', '21:00', '24:00'};
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