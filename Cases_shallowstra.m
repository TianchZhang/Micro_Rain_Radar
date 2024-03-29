%Description:
%Cases  of shallow stratiform
% History:
% 2022.09.07 by zhangtc
% update 2022.09.15

%%
clear
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat','central_diameter');
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat', 'diameter_bandwidth');
load('E:\Codes\Micro_Rain_Radar\Colormap_GMT_paired.mat');
load('E:\DATA\MRR\MRR_BG','BGND');

shallowday = ['20220320';'20220322';'20220509';'20220512';'20220605'];
mrrloc = {618-15:750;835-15:925;[1234-15:1263,1413-15:1440];1333-15:1409;220-15:284};
ottloc = {618:750;835:925;[1234:1263,1413:1440];1333:1409;220:284};
for ifile = 2:2
    mrrname = ['E:\DATA\MRR\h5_aveMRR_LT\MRR_AveData_',shallowday(ifile,:),'.h5'];
    mrrpname = ['E:\DATA\MRR\h5_parameters_LT\MRR_Parameters_',shallowday(ifile,:),'.h5'];
    ottname = ['E:\DATA\OTTParsivel\nonQC2019mR-\',shallowday(ifile,:),'.h5'];
    
    mitimeloc = fix(min(mrrloc{ifile,1})./60)*60;
    matimeloc = min(1440,(fix(max(mrrloc{ifile,1})./60)+1)*60);
    
    ottDS = central_diameter;
    ottDSW = diameter_bandwidth;
    ottND = h5read(ottname,'/ND');
    ottRR = h5read(ottname,'/RR');
    ottDm = h5read(ottname,'/Dm');
    ottNw = h5read(ottname,'/Nw');
    
    type = h5read(ottname,'/typeflag');
    rain = h5read(ottname,'/rainflag');
    ZZ = h5read(mrrname,'/Radar_Reflectivity');
    RR= h5read(mrrname,'/Rain_Rate');
    ND = h5read(mrrname,'/Spectral_Drop_Densities')*1e-3 -repmat(BGND,1,1,1440);
    DS = h5read(mrrpname,'/Drop_Size');
    % rf1 = find(rain >0);
    % tf1 = find(type>1);
    %     figure;
    %     plot(1:1440,rain,1:1440,type);
    
    %     %ottNw-Dm
    %     tempDm = ottDm(ottloc{ifile,:});
    %     ottNw(ottNw<=1)=1;
    %     tempNw = log10(ottNw(ottloc{ifile,:}));
    %     figure;
    %     set(gcf,'Position',get(0,'ScreenSize')*0.5);
    %     sc2 = scatter(tempDm,tempNw);
    %     sc2.Marker = 'o';
    %     sc2.MarkerEdgeColor = [0.3,0.5,0.9];
    %     sc2.MarkerFaceColor = [0.3,0.5,0.9];
    %     % sc2.LineWidth = 0.75;
    %     ax = gca;
    %     ax.Box = 'on';
    %     ax.FontSize = 12;
    %     ax.TickLength = [0.01 0.01];
    %     ax.LineWidth = 1.5;
    %     ax.XLabel.String = 'Dm(mm)';
    %     ax.YLabel.String = 'log_{10}Nw(mm^{-1}m^{-3})';
    %     ax.XLim = [0.2 1];
    %     ax.YLim = [3.5 5.5];
    %     title({'log_{10}Nw - Dm of Shallow Stratiform';shallowday(ifile,:)});
    %     savename = ['E:\DATA\MRR\Pictures\Casesofshallowstratiform\shallow_Nw_Dm_',shallowday(ifile,:),'.png'];
    %     saveas(gcf,savename);
    %     close
    %
    % %ZZ
    %     tempZZ = ZZ(1:15,mitimeloc:matimeloc);
    %     tempZZ(tempZZ<0) = NaN;
    %     tempZZ(tempZZ>55) = 55;
    %     figure;
    %     set(gcf,'Position',get(0,'ScreenSize')*0.5);
    %     ax1 = gca;
    %     % tar1 = pcolor(1200:1:1440,1:15,tempZZ);
    %     % shading flat
    %     tar1 = contourf(mitimeloc:matimeloc,1:15,tempZZ,'LineColor','none');
    %     view(2);
    %     shading flat
    %     ax1.Layer = 'top';
    %     ax1.FontSize = 12;
    %     ax1.TickLength = [0.01 0.01];
    %     ax1.LineWidth = 1.2;
    %     ax1.XLim = [mitimeloc matimeloc];
    %     ax1.XTick = mitimeloc:60:matimeloc;
    %     ttamp = {};
    %     for ii = 1:fix((matimeloc-mitimeloc)./60)+1
    %         ttamp = [ttamp;[num2str(fix(mitimeloc./60)+ii-1),':00']];
    %     end
    %     ax1.XTickLabel = ttamp;
    %     ax1.XLabel.String = 'Local Time';
    %     ax1.XGrid = 'on';
    %     ax1.YLim = [0 15];
    %     ax1.YTick = 0:2.5:15;
    %     ax1.YTickLabel = {'0.0', '0.5', '1.0', '1.5', '2.0', '2.5', '3.0'};
    %     ax1.YLabel.String = 'Height(km)';
    %     ax1.YGrid = 'on';
    %     ZZcolormap = [0.494117647058824,0.882352941176471,0.949019607843137;...
    %         0.0745098039215686,0.623529411764706,1;0,0,1;0,1,0;...
    %         0.282352941176471,0.701960784313725,0.188235294117647;...
    %         0.0901960784313726,0.529411764705882,0.0313725490196078;...
    %         1,1,0;0.929411764705882,0.694117647058824,0.125490196078431;...
    %         1,0.411764705882353,0.160784313725490;...
    %         1,0,0;0.635294117647059,0.0784313725490196,0.184313725490196];
    %     cm1 = colormap(ax1,ZZcolormap);
    %     c1 = colorbar;
    %     c1.Label.String = 'dBz';
    %     caxis([0.01 55.01]);
    %     c1.Ticks = [0.01 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0]*10;
    %     c1.TickLabels = {'0','5','10','15','20','25','30','35','40','45','50'};
    %     title({'Radar Reflectivity';shallowday(ifile,:)});
    %     saveas(gcf,['E:\DATA\MRR\Pictures\Casesofshallowstratiform\shallow_ZZ',shallowday(ifile,:),'.png']);
    %     close
    
    % %     %RR
    %     RR(RR<=0)=nan;
    %     RR(RR<=0.5 &RR>0)=0.5;
    %     RR(RR<=1 &RR>0.5)=1.5;
    %     RR(RR<=1.5 &RR>1)=2.5;
    %     RR(RR<=2 &RR>1.5)=3.5;
    %     RR(RR>2)=4.5;
    %     tempRR = RR(1:15,mitimeloc:matimeloc);
    %     figure;
    %     set(gcf,'Position',get(0,'ScreenSize')*0.5);
    %     tar2 = pcolor(mitimeloc:matimeloc,1:15,tempRR);
    %     shading flat
    % %     tar1 = contourf(mitimeloc:matimeloc,1:15,tempRR,'LineColor','none');
    % %     view(2);
    %     ax1 = gca;
    %     ax1.Layer = 'top';
    %     ax1.FontSize = 12;
    %     ax1.TickLength = [0.01 0.01];
    %     ax1.LineWidth = 1.2;
    %     ax1.XLim = [mitimeloc matimeloc];
    %     ax1.XTick = mitimeloc:60:matimeloc;
    %     ttamp = {};
    %     for ii = 1:fix((matimeloc-mitimeloc)./60)+1
    %         ttamp = [ttamp;[num2str(fix(mitimeloc./60)+ii-1),':00']];
    %     end
    %     ax1.XTickLabel = ttamp;
    %     ax1.XLabel.String = 'Local Time';
    %     ax1.XGrid = 'on';
    %     ax1.YLim = [0 15];
    %     ax1.YTick = 0:2.5:15;
    %     ax1.YTickLabel = {'0.0', '0.5', '1.0', '1.5', '2.0', '2.5', '3.0'};
    %     ax1.YLabel.String = 'Height(km)';
    %     ax1.YGrid = 'on';
    %     cm2 = colormap(ax1,jet(6));
    %     c2 = colorbar;
    %     c2.Label.String = 'mm\cdoth^{-1}';
    %     caxis([0.01 6.01]);
    %     c2.FontSize = 12;
    %     c2.Ticks = [0.01 1 2 3 4 5 6];
    %     c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5',''};
    %     title({'Radar Rate';shallowday(ifile,:)});
    %     saveas(gcf,['E:\DATA\MRR\Pictures\Casesofshallowstratiform\shallow_RR',shallowday(ifile,:),'.png']);
    %     close
    %
%     %DSD
%     tempND1 =  ND(1:13,:,mrrloc{ifile,1});
%     legloc = [];
%     figure;
%     set(gcf,'Position',get(0,'ScreenSize')*0.5);
%     for ih = 1:13
%         if length(find(RR(ih,mrrloc{ifile,1})>0.01))>3
%             legloc = [legloc;num2str(sprintf('%3.1f km',ih*0.2))];
%             ihND1 = reshape(tempND1(ih,:,:),64,[]);
%             ihND1(ihND1<1e-4) = nan;
%             tempihND1 = mean(ihND1,2,'omitnan');
%             tempDS = DS(ih,:);
%             hold on
%             plot(tempDS(tempDS>0),tempihND1(tempDS>0),'-','LineWidth',1.5,'Color',GMT_paired(ih+1,:));
%             
%         end
%         
%         ax1 = gca;
%         ax1.XLim = [0.2 1.0];
%         ax1.XTick = 0.2:0.2:1.0;
%         ax1.YScale = 'log';
%         ax1.YLim = [1e-1 1e5];
%         %         ax1.YTick = [1e-3 1e-2 1e-1 1e0 1e1 1e2 1e3 1e4 1e5 1e6];
%         %         ax1.YTickLabel = {'10^{-3}','10^{-2}','10^{-1}','10^{0}','10^{1}','10^{2}','10^{3}','10^{4}','10^{5}','10^{6}'};
%         
%         ax1.YMinorTick = 'on';
%         ax1.Box = 'on';
%         ax1.FontSize = 12;
%         ax1.TickLength = [0.015 0.02];
%         ax1.LineWidth = 1.5;
%         ax1.XLabel.String = 'D(mm)';
%         ax1.YLabel.String = 'N(D)(m^{-3}\cdotmm^{-1})';
% %         title({'Raindrop Size Distribution_{Micro Rain Radar}';shallowday(ifile,:)});
%         legend(legloc);
%     end
%     tempottND = ottND(mrrloc{ifile,1},3:18);
%     tempottND(tempottND<1e-4) = nan;
%     plot(central_diameter(3:18),mean(tempottND,1,'omitnan'),...
%         'Color',[195,163,212]./255,'LineWidth', 1.5,'DisplayName','Parsivel 2');
%     hold off
%     
%         saveas(gcf,['E:\DATA\MRR\Pictures\Casesofshallowstratiform\shallow_DSD_',shallowday(ifile,:),'.png']);
%         close
    
    %     %%
    %ND
    %     tempND = ND(1:15,:,mitimeloc:matimeloc);
    %     tempND(tempND<1) = 1;
    %     tempND(tempND>10^4.9) = 10^4.8;
    %     legloc = [];
    %     for ih = 1:13
    %         if length(find(RR(ih,mrrloc{ifile,1})>0.01))>3
    %             legloc = [legloc;num2str(sprintf('%3.1f km',ih*0.2))];
    %             DD = zeros(64,matimeloc-mitimeloc+1);
    %             DD(:,:) = log10(tempND(ih,:,:));
    %             figure(ih);
    %             set(gcf,'Position',get(0,'ScreenSize')*0.5);
    %             tempDS = double(DS(ih,:));
    %             tar2 = pcolor(mitimeloc:matimeloc,tempDS(tempDS>0),DD(tempDS>0,:));
    %             shading flat
    %             ax2 = gca;
    %             ax2.Layer = 'top';
    %             ax2.FontSize = 12;
    %             ax2.TickLength = [0.01 0.01];
    %             ax2.LineWidth = 1.2;
    %             ax1.XLim = [mitimeloc matimeloc];
    %             ax1.XTick = mitimeloc:60:matimeloc;
    %             ttamp = {};
    %             for ii = 1:fix((matimeloc-mitimeloc)./60)+1
    %                 ttamp = [ttamp;[num2str(fix(mitimeloc./60)+ii-1),':00']];
    %             end
    %             ax1.XTickLabel = ttamp;
    %             ax2.XLabel.String = 'Local Time';
    %             ax2.XGrid = 'on';
    %             ax2.YLim = [0 6];
    %             ax2.YTick = 0:2:6;
    %             ax2.YTickLabel = {'0', '2', '4', '6'};
    %             ax2.YLabel.String = 'Diameter(mm)';
    %             ax2.YGrid = 'on';
    %             cm2 = colormap(ax2,[[1,1,1];jet(9);[0.49,0.18,0.56]]);
    %             c2 = colorbar;
    %             c2.Label.String = 'log_{10}N(D)';
    %             caxis([-0.49 5.01]);
    %             c2.FontSize = 12;
    %             c2.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0,4.5];
    %             c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5'};
    %             title({['Rain Drop Densities','@',num2str(ih*200),'m'];shallowday(ifile,:)})
    %             saveas(gcf,['E:\DATA\MRR\Pictures\Casesofshallowstratiform\ND',shallowday(ifile,:),'_',num2str(200*ih),'.png']);
    %             close
    %         end
    %     end
    %
    % %%
    % % ottND
    % tempottND = log10(ottND(mitimeloc:matimeloc,:).');
    % tempottND(tempottND>10^4.9) = 10^4.8;
    % figure;
    % set(gcf,'Position',get(0,'ScreenSize')*0.5);
    % ax2 = gca;
    % % tar2 = pcolor(mitimeloc:matimeloc,ottDS - 0.5 * ottDSW,tempottND);
    % % shading flat
    %     tar2 = contourf(mitimeloc:matimeloc,ottDS - 0.5 * ottDSW,tempottND,'LineColor','none');
    %     view(2);
    % ax2.Layer = 'top';
    % ax2.FontSize = 12;
    % ax2.TickLength = [0.01 0.01];
    % ax2.LineWidth = 1.2;
    % ax2.XLim = [mitimeloc matimeloc];
    % ax2.XTick = mitimeloc:60:matimeloc;
    % ax2.XTickLabel = {'20:00', '21:00', '22:00', '23:00','24:00'};
    % ax2.XLabel.String = 'Local Time';
    % ax2.XGrid = 'on';
    % ax2.YLim = [0 2];
    % ax2.YTick = 0:0.5:2;
    % ax2.YTickLabel = {'0.0', '0.5', '1.0', '1.5','2.0'};
    % ax2.YLabel.String = 'Diameter(mm)';
    % ax2.YGrid = 'on';
    % colormap([[1,1,1];jet(9);[0.49,0.18,0.56]]);
    % c2 = colorbar;
    % c2.Label.String = 'log_{10}N(D)';
    % caxis([-0.49 4.99]);
    % c2.FontSize = 12;
    % c2.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0,4.5];
    % c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5'};
    % title({'Rain Drop Densities';shallowday(ifile,:)});
    % % saveas(gcf,['E:\DATA\MRR\Pictures\Casesofshallowstratiform\DSD_',shallowday(ifile,:),'.png']);
    % % close
    
end