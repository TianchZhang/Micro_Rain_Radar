%%
%background day
%2021.12.05
%2021.12.13
%2021.12.22
%2022.01.09
%2022.02.14*
%2022.02.27
%2022.04.06
clear
bkday = ['20211205';'20211213';'20211222';...
    '20220109';'20220214';'20220227';'20220406'];
color = jet(31);
ND = [];
tempBGND = zeros(31,64);
file_root = 'E:\DATA\MRR\h5_aveMRR_LT\';
pfile_root = 'E:\DATA\MRR\h5_parameters_LT\';
for in = 1:7
    DS = h5read(['E:\DATA\MRR\h5_parameters_LT\MRR_Parameters_',bkday(in,:),'.h5'],'/Drop_Size');
    tempND = h5read([file_root,'MRR_AveData_',bkday(in,:),'.h5'],'/Spectral_Drop_Densities')*10e-3;
    ND = cat(3,ND,tempND);
end
ND(ND<0) = nan;
figure;
set(gcf,'Position',get(0,'ScreenSize')*0.5);
hold on
for ih = 1:31
    ihND = mean(reshape(ND(ih,:,:),64,[]),2,'omitnan');
    tempBGND(ih,:) = ihND(:);
    tempDS = DS(ih,:);
    plot(tempDS(tempDS>0),ihND(tempDS>0),'-','LineWidth',1.5,'Color',color(ih,:));
end

hold off
ax1 = gca;
ax1.XLim = [0 5.5];
ax1.XTick = 0:0.5:5.5;
ax1.YScale = 'log';
ax1.YLim = [10e-6 10e6];
%         ax1.YTick = [10e-5 10e0 10e1 10e2 10e3 10e4 10e5 10e6];
%         ax1.YTickLabel = {'10^{0}','10^{1}','10^{2}','10^{3}','10^{4}','10^{5}'};
ax1.YMinorTick = 'on';
ax1.Box = 'on';
ax1.FontSize = 12;
ax1.TickLength = [0.015 0.02];
ax1.LineWidth = 1.5;
ax1.XLabel.String = 'D(mm)';
ax1.YLabel.String = 'N(D)(m^{-3}\cdotmm^{-1})';
title('Raindrop Size Distribution_{Background}');
BGND = tempBGND;
%%
file_root = 'E:\DATA\MRR\h5_aveMRR_LT\';
savefile = 'E:\DATA\MRR\Pictures\Nonrain_ND\';
listing = dir([file_root,'*.h5']);
color = jet(31);
for fnum = 1:length(listing)
    RR = h5read([file_root,listing(fnum).name],'/Rain_Rate');
    if ~any(RR(1:25,:)>0.4)
        ND = h5read([file_root,listing(fnum).name],'/Spectral_Drop_Densities');
        ND = ND * 10e-3;
        ND(ND<0) = nan;
        DS = h5read(['E:\DATA\MRR\h5_parameters_LT\MRR_Parameters',listing(fnum).name(end-11:end)],'/Drop_Size');
        figure;
        set(gcf,'Position',get(0,'ScreenSize')*0.5);
        hold on
        for ih = 1:31
            ihND = mean(reshape(ND(ih,:,:),64,[]),2,'omitnan')-BGND(ih,:);
            tempDS = DS(ih,:);
            plot(tempDS(tempDS>0),ihND(tempDS>0),'-','LineWidth',1.5,'Color',color(ih,:));
        end
        hold off
        ax1 = gca;
        ax1.XLim = [0 5.5];
        ax1.XTick = 0:0.5:5.5;
        ax1.YScale = 'log';
        ax1.YLim = [10e-6 10e6];
        %         ax1.YTick = [10e-5 10e0 10e1 10e2 10e3 10e4 10e5 10e6];
        %         ax1.YTickLabel = {'10^{0}','10^{1}','10^{2}','10^{3}','10^{4}','10^{5}'};
        ax1.YMinorTick = 'on';
        ax1.Box = 'on';
        ax1.FontSize = 12;
        ax1.TickLength = [0.015 0.02];
        ax1.LineWidth = 1.5;
        ax1.XLabel.String = 'D(mm)';
        ax1.YLabel.String = 'N(D)(m^{-3}\cdotmm^{-1})';
        
        title({'Raindrop Size Distribution';listing(fnum).name(end-10:end-3)});
        %         legend('0.2 km','0.4 km','0.6 km','0.8 km','1.0 km',...
        %             '1.2 km','1.4 km','1.6 km','1.8 km','2.0 km',...
        %             '2.2 km','2.4 km','2.6 km','2.8 km','3.0 km',...
        %             '3.2 km','3.4 km','3.6 km','3.8 km','4.0 km',...
        %             '4.2 km','4.4 km','4.6 km','4.8 km','5.0 km',...
        %             '5.2 km','5.4 km','5.6 km','5.8 km','6.0 km', '6.2 km');
        saveas(gcf,[savefile,listing(fnum).name(end-10:end-3),'.png']);
        close
    end
end

