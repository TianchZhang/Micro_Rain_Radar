%Description:
%show the number concentration of raindrops,rain rate and rainfall per minute everyday
% History:
% 2022.08.09 by zhangtc
function ZZ_show_MRR(ZZ)
set(gcf,'Position',get(0,'ScreenSize')*0.5);
ax1 = gca;
tar1 = contourf(1:1:1440,1:31,ZZ,'LineColor','none');
view(2);
shading flat
ax1.Layer = 'top';
ax1.FontSize = 12;
ax1.TickLength = [0.01 0.01];
ax1.LineWidth = 1.2;

ax1.XLim = [0 1440];
ax1.XTick = 0:180:1440;
ax1.XTickLabel = {'00:00', '03:00', '06:00', '09:00', '12:00', '15:00', '18:00', '21:00', '24:00'};
ax1.XLabel.String = 'Local Time';
ax1.XGrid = 'on';

ax1.YLim = [0 32];
ax1.YTick = 0:5:30;
ax1.YTickLabel = {'0', '1', '2', '3', '4', '5', '6'};
ax1.YLabel.String = 'Height(km)';
ax1.YGrid = 'on';
%
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
c1.TickLabels = {'0','5','10','15','20','25','30','30','40','45','50'};