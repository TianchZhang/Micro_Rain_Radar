%Description:
%show Rain rate per height bin per minute 
% History:
% 2022.09.06 by zhangtc

function RR_show_MRR(Rainrate)
Rainrate(Rainrate<=0)=nan;
Rainrate(Rainrate<=7.5 &Rainrate>5)=5.5;
Rainrate(Rainrate<=10 &Rainrate>7.5)=6.5;
Rainrate(Rainrate<=15 &Rainrate>10)=7.5;
Rainrate(Rainrate<=20 &Rainrate>15)=8.5;
Rainrate(Rainrate<=30 &Rainrate>20)=9.5;
Rainrate(Rainrate<=50 &Rainrate>30)=10.5;
Rainrate(Rainrate<=100 &Rainrate>50)=11.5;
Rainrate(Rainrate>100)=12.5;

set(gcf,'Position',get(0,'ScreenSize')*0.5);
tar2 = pcolor(1:1:1440,1:31,Rainrate);
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

ax2.YLim = [0 32];
ax2.YTick = 0:5:30;
ax2.YTickLabel = {'0', '1', '2', '3', '4', '5', '6'};
ax2.YLabel.String = 'Height(km)';
ax2.YGrid = 'on';

cm2 = colormap(ax2,[jet(12);[0.49,0.18,0.56]]);
c2 = colorbar;
c2.Label.String = 'mm\cdoth^{-1}';
caxis([0.01 13.01]);
c2.FontSize = 12;
c2.Ticks = [0 1 2 3 4 5 6 7 8 9 10 11 12];
c2.TickLabels = {'0','1.0','2.0','3.0','4.0','5.0','7.5','10','15','20','30','50','100'};