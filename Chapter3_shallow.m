%Description:
%Cases  of shallow stratiform
% History:
% 2022.09.08 by zhangtc

%%
clear
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat','central_diameter');
load('E:\DATA\Parsivel_temporary\DSD_parameters.mat', 'diameter_bandwidth');
load('E:\Codes\Micro_Rain_Radar\Colormap_GMT_paired.mat');
load('E:\DATA\MRR\MRR_BG','BGND');
load('D:\Codes\Micro_Rain_Radar\Modified_dropsize.mat','mdf_DS');
shallowday = ['20220320';'20220322';'20220509';'20220512';'20220605'];
mrrloc = {618-15:750;835-15:925;[1234-15:1263,1413-15:1440];1333-15:1409;220-15:284};
ottloc = {618:750;835:925;[1234:1263,1413:1440];1333:1409;220:284};
for ifile =2:2
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
    ottLWC = h5read(ottname,'/LWC');
    ottNt= h5read(ottname,'/Nt');
    
    type = h5read(ottname,'/typeflag');
    rain = h5read(ottname,'/rainflag');
    ZZ = h5read(mrrname,'/Radar_Reflectivity');
    RR= h5read(mrrname,'/Rain_Rate');
    ND = h5read(mrrname,'/Spectral_Drop_Densities')*1e-3-repmat(BGND,1,1,1440);
    DS = h5read(mrrpname,'/Drop_Size');
    LWC = h5read(mrrname,'/Liquid_Water_Content');
    Nt = h5read(mrrpname,'/Nt');
    lwcnt = zeros(31,1440);
    lwcnt(Nt>1e-4) =  LWC(Nt>1e-4)./Nt(Nt>1e-4);
    
    %     %%
    %         %ZZ
    %             tempZZ = ZZ(1:15,mitimeloc:matimeloc);
    %             tempZZ(tempZZ<0) = NaN;
    %             tempZZ(tempZZ>55) = 55;
    %             figure;
    %             set(gcf,'Position',get(0,'ScreenSize')*0.5);
    %             ax1 = gca;
    %             % tar1 = pcolor(1200:1:1440,1:15,tempZZ);
    %             % shading flat
    %             tar1 = contourf(mitimeloc:matimeloc,1:15,tempZZ,'LineColor','none');
    %             view(2);
    %             shading flat
    %             ax1.Layer = 'top';
    %             ax1.FontSize = 12;
    %             ax1.TickLength = [0.01 0.01];
    %             ax1.LineWidth = 1.2;
    %             ax1.XLim = [mitimeloc matimeloc];
    %             ax1.XTick = mitimeloc:60:matimeloc;
    %             ttamp = {};
    %             for ii = 1:fix((matimeloc-mitimeloc)./60)+1
    %                 ttamp = [ttamp;[num2str(fix(mitimeloc./60)+ii-1),':00']];
    %             end
    %             ax1.XTickLabel = ttamp;
    %             ax1.XLabel.String = 'Local Time';
    %             ax1.XGrid = 'on';
    %             ax1.YLim = [0 15];
    %             ax1.YTick = 0:2.5:15;
    %             ax1.YTickLabel = {'0.0', '0.5', '1.0', '1.5', '2.0', '2.5', '3.0'};
    %             ax1.YLabel.String = 'Height(km)';
    %             ax1.YGrid = 'on';
    %
    %             ZZcolormap = [0.494117647058824,0.882352941176471,0.949019607843137;...
    %                 0.0745098039215686,0.623529411764706,1;0,0,1;0,1,0;...
    %                 0.282352941176471,0.701960784313725,0.188235294117647;...
    %                 0.0901960784313726,0.529411764705882,0.0313725490196078;...
    %                 1,1,0;0.929411764705882,0.694117647058824,0.125490196078431;...
    %                 1,0.411764705882353,0.160784313725490;...
    %                 1,0,0;0.635294117647059,0.0784313725490196,0.184313725490196];
    %             cm1 = colormap(ax1,ZZcolormap);
    %             c1 = colorbar;
    %             c1.Label.String = 'dBz';
    %             caxis([0.01 55.01]);
    %             c1.Ticks = [0.01 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0]*10;
    %             c1.TickLabels = {'0','5','10','15','20','25','30','35','40','45','50'};
    %             c1.Label.String = 'Z(dBz)';
    %             c1.Position = [0.92,0.096,0.0185,0.836];
    %             ax1.Position = [0.08,0.096,0.833,0.836];
    %         %         title({'Radar Reflectivity';shallowday(ifile,:)});
    %         saveas(gcf,['E:\DATA\MRR\Pictures\figure\shallow_ZZ',shallowday(ifile,:),'.png']);
    %         close
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     %ND
    %     figure;
    %     set(gcf,'Position',get(0,'ScreenSize')*0.5);
    %     subplot(4,1,1);
    %     tempottND = log10(ottND(mitimeloc:matimeloc,:).');
    %     tempottND(tempottND>10^4.9) = 10^4.8;
    %     ax2 = gca;
    %     % tar2 = pcolor(mitimeloc:matimeloc,ottDS - 0.5 * ottDSW,tempottND);
    %     % shading flat
    %     tar2 = contourf(mitimeloc:matimeloc,ottDS - 0.5 * ottDSW,tempottND,'LineColor','none');
    %     view(2);
    %     ax2.Layer = 'top';
    %     ax2.FontSize = 12;
    %     ax2.TickLength = [0.01 0.01];
    %     ax2.LineWidth = 1.2;
    %     ax2.XLim = [mitimeloc matimeloc];
    %     ax2.XTick = mitimeloc:60:matimeloc;
    %     ax2.XTickLabel = {''};
    %     ax2.XGrid = 'on';
    %     ax2.YLim = [0 2];
    %     ax2.YTick = 0:0.5:2;
    %     ax2.YTickLabel = {'0.0', '', '1.0', '','2.0'};
    %     ax2.YLabel.String = 'Diameter(mm)';
    %     ax2.YLabel.Position = [mitimeloc-8,-3.2,-10];
    %     ax2.YGrid = 'on';
    %     ax2.Position = [0.08,0.74,0.833,0.19];
    %     colormap([[1,1,1];jet(9);[0.49,0.18,0.56]]);
    %     caxis([-0.51 4.99]);
    % %     c2.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0,4.5];
    % %     c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5'};
    %     %     title(['Rain Drop Densities-',shallowday(ifile,:)]);
    %     text(mitimeloc+1,1.8,'(a) Parsivel2','Fontsize',12);
    %
    %     tempND = ND(1:15,:,mitimeloc:matimeloc);
    %     tempND(tempND<1) = 1;
    %     tempND(tempND>10^4.9) = 10^4.8;
    %     legloc = [];
    %     for ih = 1:3
    %         subplot(4,1,1+ih);
    %         if length(find(RR(ih,mrrloc{ifile,1})>0.01))>3
    %             legloc = [legloc;num2str(sprintf('%3.1f km',ih*0.2))];
    %             DD = zeros(64,matimeloc-mitimeloc+1);
    %             DD(:,:) = log10(tempND(ih,:,:));
    %             DD(DD<=0) = -0.02;
    %             tempDS = double(DS(ih,:));
    %             tar2 = contourf(mitimeloc:matimeloc,tempDS(tempDS>0),DD(tempDS>0,:),'LineColor','none');
    %             view(2);
    %             %             tar2 = pcolor(mitimeloc:matimeloc,tempDS(tempDS>0),DD(tempDS>0,:));
    %             %             shading flat
    %             ax2 = gca;
    %             ax2.Layer = 'top';
    %             ax2.FontSize = 12;
    %             ax2.TickLength = [0.01 0.01];
    %             ax2.LineWidth = 1.2;
    %             ax2.Position = [0.08,0.74-0.215*ih,0.833,0.19];
    %             ax2.XLim = [mitimeloc matimeloc];
    %             ax2.XTick = mitimeloc:60:matimeloc;
    %             ax2.XTickLabel = {''};
    %             ax2.XGrid = 'on';
    %             ax2.YLim = [0 2];
    %             ax2.YTick = 0:0.5:2;
    %             ax2.YTickLabel = {'0.0', '', '1.0', '','2.0'};
    %             ax2.YGrid = 'on';
    %             c2 = colormap(ax2,[[1,1,1];jet(9);[0.49,0.18,0.56]]);
    %             caxis([-0.51 4.99]);
    % %             c2.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0,4.5];
    % %             c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5'};
    %         end
    %         if ih == 1
    %             text(mitimeloc+1,1.8,'(b) MRR@0.2 km','Fontsize',12);
    %         elseif ih ==2
    %             text(mitimeloc+1,1.8,'(c) MRR@0.4 km','Fontsize',12);
    %         else
    %             text(mitimeloc+1,1.8,'(d) MRR@0.6 km','Fontsize',12);
    %         end
    %     end
    %     ax2.XLim = [mitimeloc matimeloc];
    %     ax2.XTick = mitimeloc:60:matimeloc;
    %     ttamp = {};
    %     for ii = 1:fix((matimeloc-mitimeloc)./60)+1
    %         ttamp = [ttamp;[num2str(fix(mitimeloc./60)+ii-1),':00']];
    %     end
    %     ax2.XTickLabel = ttamp;
    %     ax2.XLabel.String = 'Local Time';
    %     c2 = colorbar;
    %     c2.Label.String = 'log_{10}N(D)';
    %     caxis([-0.51 4.99]);
    %     c2.FontSize = 12;
    %     c2.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0,4.5];
    %     c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5'};
    %     c2.Position = [0.92,0.096,0.0185,0.836];
    %     saveas(gcf,['E:\DATA\MRR\Pictures\figure\ND_OTTMRR_',shallowday(ifile,:),'.png']);
    %     close
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     %%
    %DSD
    %     if ifile ==2
    %         tempND = ND(1:4,1:30,mitimeloc:matimeloc);
    %         tempDS = mdf_DS(1:4,1:30);
    %         tempy = repmat((1:4).',1,30);
    %     else
    %         tempND = ND(1:9,1:30,mitimeloc:matimeloc);
    %         tempDS = mdf_DS(1:9,1:30);
    %         tempy = repmat((1:9).',1,30);
    %     end
    %     tempND(tempND<0) = nan;
    %     tempND = log10(tempND);
    %     meanND = mean(tempND,3,'omitnan');
    %     tempND(tempND>10^4.9) = 10^4.8;
    %     figure;
    %     set(gcf,'Position',get(0,'ScreenSize')*0.5);
    %     subplot(1,2,1);
    %     tar2 = contourf(tempDS,tempy,meanND,'LineColor','none');
    %     view(2);
    %     colormap([[1,1,1];jet(9);[0.49,0.18,0.56]]);
    %     c2 = colorbar;
    %     caxis([-0.497 5.002]);
    %     c2.Ticks = [0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0,4.5];
    %     c2.TickLabels = {'0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5'};
    %     c2.Label.String = 'log_{10}N(D)';
    %     c2.Label.Position = [0.7975,5.3,0];
    %     c2.Label.Rotation = 0;
    %     c2.Position = [0.472,0.096,0.0185,0.8];
    %     ax2 = gca;
    %     ax2.FontSize = 12;
    %     ax2.Layer = 'top';
    %     ax2.TickLength = [0.01 0.01];
    %     ax2.LineWidth = 1.2;
    %     ax2.XLim = [0.2 0.8];
    %     ax2.XTick = 0.2:0.1:0.8;
    %     %     ax2.XTickLabel = {''};
    %     ax2.XLabel.String = 'Diameter(mm)';
    %     ax2.XGrid = 'on';
    %     if ifile ==2
    %         ax2.XLim = [0.2 0.8];
    %         ax2.XTick = 0.2:0.2:0.8;
    %         ax2.YLim = [1 4];
    %         ax2.YTick = 1:4;
    %         ax2.YTickLabel = {'0.2', '0.4', '0.6','0.8'};
    %         ax2.YLabel.Position = [0.16,2.57,1];
    %         text(0.22,3.92,'(a) MRR','Fontsize',12);
    %     else
    %         ax2.XLim = [0.2 1];
    %         ax2.XTick = 0.2:0.2:1;
    %         ax2.XTickLabel = {'0.2', '0.4', '0.6','0.8','1.0'};
    %         ax2.YLim = [1 9];
    %         ax2.YTick = 1:9;
    %         ax2.YTickLabel = {'0.2', '0.4', '0.6','0.8','1.0','1.2','1.4','1.6','1.8'};
    %         ax2.YLabel.Position = [0.138,5.1,1];
    %         text(0.22,8.8,'(a) MRR','Fontsize',12);
    %     end
    %     ax2.YLabel.String = 'Height(km)';
    %     ax2.YGrid = 'on';
    %     ax2.Position = [0.07,0.096,0.38,0.836];
    %
    %     tempND1 =  ND(1:13,:,mrrloc{ifile,1});
    %     legloc = [];
    %     subplot(1,2,2);
    %     for ih = 1:13
    %         if length(find(RR(ih,mrrloc{ifile,1})>0.01))>3
    %             legloc = [legloc;['MRR ',num2str(sprintf('%3.1f km',ih*0.2))]];
    %             ihND1 = reshape(tempND1(ih,:,:),64,[]);
    %             ihND1(ihND1<1e-4) = nan;
    %             tempihND1 = mean(ihND1,2,'omitnan');
    %             tempDS = DS(ih,:);
    %             hold on
    %             plot(tempDS(tempDS>0),tempihND1(tempDS>0),'-','LineWidth',1.5,'Color',GMT_paired(ih+1,:));
    %         end
    %         ax1 = gca;
    %         ax1.XLim = [0.2 1.6];
    %         ax1.XTick = 0.2:0.2:1.6;
    %         ax1.YScale = 'log';
    %         ax1.YLim = [1e-1 1e5];
    %         ax1.YMinorTick = 'on';
    %         ax1.Box = 'on';
    %         ax1.FontSize = 12;
    %         ax1.TickLength = [0.015 0.02];
    %         ax1.LineWidth = 1.2;
    %         ax1.Position = [0.58,0.096,0.38,0.836];
    %         ax1.XLabel.String = 'Diameter(mm)';
    %         ax1.YLabel.String = 'N(D)(m^{-3}\cdotmm^{-1})';
    %         ax1.YLabel.Position =[0.08166,103.111,-1];
    %         legend(legloc);
    %     end
    %     tempottND = ottND(mrrloc{ifile,1},3:18);
    %     tempottND(tempottND<1e-4) = nan;
    %     plot(central_diameter(3:18),mean(tempottND,1,'omitnan'),...
    %         'Color',[0,255,255]./255,'LineWidth', 1.5,'DisplayName','Parsivel 2');
    %     text(0.25,7*1e4,'(b)','Fontsize',12);
    %     hold off
    %         saveas(gcf,['E:\DATA\MRR\Pictures\figure\shallow_DSD_',shallowday(ifile,:),'.png']);
    %         close
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     %%
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
    %     savename = ['E:\DATA\MRR\Pictures\figure\shallow_Nw_Dm_',shallowday(ifile,:),'.png'];
    %     saveas(gcf,savename);
    %     close
    
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % LWC/Nt_image_line
    %     if ifile ==2
    %         templwc = LWC(1:4,mitimeloc:matimeloc)*1e3;
    %         templn = lwcnt(1:4,mitimeloc:matimeloc)*1e5;
    %         tempnt = Nt(1:4,mitimeloc:matimeloc);
    %     else
    %         templwc = LWC(1:9,mitimeloc:matimeloc)*1e3;
    %         templn = lwcnt(1:9,mitimeloc:matimeloc)*1e5;
    %         tempnt = Nt(1:9,mitimeloc:matimeloc);
    %     end
    %
    % ttamp = {};
    %     for ii = 1:fix((matimeloc-mitimeloc)./60)+1
    %         ttamp = [ttamp;[num2str(fix(mitimeloc./60)+ii-1),':00']];
    %     end
    %     figure;
    %     set(gcf,'Position',get(0,'ScreenSize')*0.5);
    %     if ifile ==2
    %         s1=subplot(1,4,1);
    %         tar1 = contourf(mitimeloc:matimeloc,1:4,templwc,'LineColor','none','levels',10);
    %         s1.Position = [0.075,0.14,0.16,0.8];
    %         s1.FontSize = 12;
    %         s1.TickLength = [0.01 0.01];
    %         s1.LineWidth = 1.2;
    %         s1.XLim = [mitimeloc matimeloc];
    %         s1.XTick = mitimeloc:60:matimeloc;
    %         s1.XTickLabel = ttamp;
    %         s1.XGrid = 'on';
    %         s1.YLim = [1 4];
    %         s1.YTick = 1:1:4;
    %         s1.YTickLabel = {'0.2', '0.4', '0.6', '0.8'};
    %         s1.YLabel.String = 'Height(km)';
    %         colormap(s1,[[1 1 1];jet(8);[0.49,0.18,0.56]]);
    %         c1=colorbar;
    %         caxis( [-9.89 90.11]);
    %         c2.Ticks = [0:10:90];
    % %         c2.TickLabels = {num2str(0:10:90)};
    %         c1.Position = [0.238,0.14,0.0085,0.8];
    %         text(mitimeloc+5,3.92,'(a) LWC(10^{-3}g\cdotm^{-3})','Fontsize',12);
    %
    %
    %         s2=subplot(1,4,2);
    %         tar2 = contourf(mitimeloc:matimeloc,1:4,tempnt,'LineColor','none','levels',10);
    %         s2.Position = [0.31,0.14,0.16,0.8];
    %         s2.FontSize = 12;
    %         s2.TickLength = [0.01 0.01];
    %         s2.LineWidth = 1.2;
    %         s2.XLim = [mitimeloc matimeloc];
    %         s2.XTick = mitimeloc:60:matimeloc;
    %         s2.XTickLabel = ttamp;
    %         s2.XGrid = 'on';
    %         s2.YLim = [1 4];
    %         s2.YTick = 1:1:4;
    %         s2.YTickLabel = {''};
    %         s2.XLabel.String = 'Local Time';
    %         c2=colorbar;
    %         colormap(s2,[[1 1 1];jet(8);[0.49,0.18,0.56]]);
    %         c2.Position = [0.476,0.14,0.0085,0.8];
    %         caxis([-988 9000.1]);
    %         text(mitimeloc+5,3.92,'(b) Nt(m^{-3})','Fontsize',12);
    %         c2.Ticks = [0:1000:9000];
    %         c2.TickLabels = {'0','\cdot10^{3}','2\cdot10^{3}','3\cdot10^{3}',...
    %             '4\cdot10^{3}','5\cdot10^{3}','6\cdot10^{3}',...
    %             '7\cdot10^{3}','8\cdot10^{3}','9\cdot10^{3}'};
    %
    %         s3=subplot(1,4,3);
    %         tar3 = contourf(mitimeloc:matimeloc,1:4,templn,'LineColor','none');
    %         s3.Position = [0.54,0.14,0.16,0.8];
    %         s3.FontSize = 12;
    %         s3.TickLength = [0.01 0.01];
    %         s3.LineWidth = 1.2;
    %         s3.XLim = [mitimeloc matimeloc];
    %         s3.XTick = mitimeloc:60:matimeloc;
    %         s3.XTickLabel = ttamp;
    %         s3.XGrid = 'on';
    %         s3.YLim = [1 4];
    %         s3.YTick = 1:1:4;
    %         s3.YTickLabel = {''};
    %         c3=colorbar;
    %         c3.Position = [0.703,0.14,0.0085,0.8];
    %         colormap(s3,[[1 1 1];jet(9);[0.49,0.18,0.56]]);
    %         caxis([-0.1985 2.008]);
    %         c3.Ticks = [0:0.2:2];
    %         c3.TickLabels = {'0','0.2','0.4','0.6','0.8','1.0','1.2','1.4','1.6','1.8','2.0'};
    %         text(mitimeloc+5,3.92,'(c) LWC/Nt(10^{-5}g)','Fontsize',12);
    %
    %         s4=subplot(1,4,4);
    %         load('E:\DATA\MRR\GDAS_20220322.mat');
    %         plot(s4,temprt(1:4),height(1:4),'color',[0.7 0 0],'Linewidth',1.5);
    %         s4.Position = [0.76,0.14,0.20,0.8];
    %         s4.TickLength = [0.01 0.01];
    %         s4.XLim = [2 6];
    %         s4.XTick = [2 4 6];
    %         s4.LineWidth = 1.2;
    %         s4.YLim = [200 800];
    %         s4.YTick = 200:200:800;
    %         s4.YTickLabel = {''};
    %         s4.XColor = [0.7 0 0];
    %         s4.FontSize = 12;
    %         text(2.5,775,'Temperature(^{\circ}C)','color',[0.7 0 0],'Fontsize',12);
    %         text(2.07,780,'(d)','Fontsize',12);
    %         s4.XLabel.String = 'GDAS 14:00';
    %         s4.XLabel.Color = [0 0 0];
    %         s44 = axes('Position', get(s4, 'Position'), ...
    %             'XAxisLocation', 'top', ...
    %             'Color', 'none');
    %         hold on
    %         plot(s44,rlhum(1:4),height(1:4),'color',[0 0.4 0],...
    %             'Linewidth',1.5);
    %         hold off
    %         s44.TickDir = 'out';
    %         s44.TickLength = [0.01 0.01];
    %         s44.XLim = [96 100];
    %         s44.XColor = [0 0.4 0];
    %         s44.YLim = [200 800];
    %         s44.YTick = 200:200:800;
    %         s44.YTickLabel = {''};
    %         s44.LineWidth = 1.2;
    %         s44.FontSize = 12;
    %         text(96.5,725,'Raletive Humidity(%)','color',[0 0.4 0],'Fontsize',12);
    %
    %     else
    % %         colormap([[1 1 1];jet]);
    %         s1=subplot(1,4,1);
    %         tar1 = contourf(mitimeloc:matimeloc,1:9,templwc,'LineColor','none','levels',11);
    %         s1.Position = [0.075,0.14,0.16,0.8];
    %         s1.FontSize = 12;
    %         s1.TickLength = [0.01 0.01];
    %         s1.LineWidth = 1.2;
    %         s1.XLim = [mitimeloc matimeloc];
    %         s1.XTick = mitimeloc:60:matimeloc;
    %         s1.XTickLabel = ttamp;
    %         s1.XGrid = 'on';
    %         s1.YLim = [1 9];
    %         s1.YTick = 1:2:9;
    %         s1.YTickLabel = {'0.2', '0.6', '1.0', '1.4','1.8'};
    %         s1.YLabel.String = 'Height(km)';
    %         colormap(s1,[[1 1 1];jet(9);[0.49,0.18,0.56]]);
    %         caxis([-24.85 250.15]);
    %         c1=colorbar;
    %         c1.Position = [0.238,0.14,0.0085,0.8];
    %         c1.Ticks = [0:25:250];
    %         text(mitimeloc+5,8.82,'(a) LWC(10^{-3}g\cdotm^{-3})','Fontsize',12);
    %
    %
    %         s2=subplot(1,4,2);
    %         tar2 = contourf(mitimeloc:matimeloc,1:9,tempnt,'LineColor','none','levels',7);
    %         s2.Position = [0.31,0.14,0.16,0.8];
    %         s2.FontSize = 12;
    %         s2.TickLength = [0.01 0.01];
    %         s2.LineWidth = 1.2;
    %         s2.XLim = [mitimeloc matimeloc];
    %         s2.XTick = mitimeloc:60:matimeloc;
    %         s2.XTickLabel = ttamp;
    %         s2.XGrid = 'on';
    %         s2.YLim = [1 9];
    %         s2.YTick = 1:2:9;
    %         s2.YTickLabel = {''};
    %         s2.XLabel.String = 'Local Time';
    %          colormap(s2,[[1 1 1];jet(5);[0.49,0.18,0.56]]);
    %          caxis([-1999 12001]);
    %         c2=colorbar;
    %         c2.Position = [0.476,0.14,0.0085,0.8];
    %         text(mitimeloc+5,8.82,'(b) Nt(m^{-3})','Fontsize',12);
    %         c2.Ticks = [0:2000:12000];
    %         c2.TickLabels = {'0','2\cdot10^{3}','4\cdot10^{3}',...
    %             '6\cdot10^{3}','8\cdot10^{3}','10\cdot10^{3}','12\cdot10^{3}'};
    %
    %         s3=subplot(1,4,3);
    %         tar3 = contourf(mitimeloc:matimeloc,1:9,templn,'LineColor','none');
    %         s3.Position = [0.54,0.14,0.16,0.8];
    %         s3.FontSize = 12;
    %         s3.TickLength = [0.01 0.01];
    %         s3.LineWidth = 1.2;
    %         s3.XLim = [mitimeloc matimeloc];
    %         s3.XTick = mitimeloc:60:matimeloc;
    %         s3.XTickLabel = ttamp;
    %         s3.XGrid = 'on';
    %         s3.YLim = [1 9];
    %         s3.YTick = 1:2:9;
    %         s3.YTickLabel = {''};
    %         colormap(s3,[[1 1 1];jet(5);[0.49,0.18,0.56]]);
    %         caxis([-2.97 18.03]);
    %         c3=colorbar;
    %         c3.Position = [0.703,0.14,0.0085,0.8];
    %         c3.Ticks = [0:3:18];
    % %         c3.TickLabels = {'0','0.2','0.4','0.6','0.8','1.0','1.2','1.4','1.6','1.8','2.0'};
    %         text(mitimeloc+5,8.82,'(c) LWC/Nt(10^{-5}g)','Fontsize',12);
    %
    %         s4=subplot(1,4,4);
    %         load('E:\DATA\MRR\GDAS_20220512.mat');
    %         plot(s4,temprt(1:9),height(1:9),'color',[0.7 0 0],'Linewidth',1.5);
    %         s4.Position = [0.76,0.14,0.20,0.8];
    %         s4.TickLength = [0.01 0.01];
    %         s4.XLim = [10 25];
    % %         s4.XTick = [2 4 6];
    %         s4.LineWidth = 1.2;
    %         s4.YLim = [200 1800];
    %         s4.YTick = 200:400:1800;
    %         s4.YTickLabel = {''};
    %         s4.XColor = [0.7 0 0];
    %         s4.FontSize = 12;
    %         text(11.5,1700,'Temperature(^{\circ}C)','color',[0.7 0 0],'Fontsize',12);
    %         text(10.4,1755,'(d)','Fontsize',12);
    %         s4.XLabel.String = 'GDAS 23:00';
    %         s4.XLabel.Color = [0 0 0];
    %         s44 = axes('Position', get(s4, 'Position'), ...
    %             'XAxisLocation', 'top', ...
    %             'Color', 'none');
    %         hold on
    %         plot(s44,rlhum(1:9),height(1:9),'color',[0 0.4 0],...
    %             'Linewidth',1.5);
    %         hold off
    %         s44.TickDir = 'out';
    %         s44.TickLength = [0.01 0.01];
    %         s44.XLim = [70 100];
    %         s44.XColor = [0 0.4 0];
    %         s44.YLim = [200 1800];
    %         s44.YTick = 200:400:1800;
    %         s44.YTickLabel = {''};
    %         s44.LineWidth = 1.2;
    %         s44.FontSize = 12;
    %         text(75.5,1550,'Raletive Humidity(%)','color',[0 0.4 0],'Fontsize',12);
    %     end
    %     templwc(templwc==0)=nan;
    %     meanlwc = mean(templwc,2,'omitnan');
    %     templn(templn==0)=nan;
    %     meanln = mean(templn,2,'omitnan');
    %     tempnt(tempnt==0)=nan;
    %     meannt = mean(tempnt,2,'omitnan');
    %     if ifile ==2
    %         s11 = axes('Position', get(s1, 'Position'), ...
    %             'XAxisLocation', 'top', ...
    %             'Color', 'none');
    %         hold on
    %         plot(s11,meanlwc,1:4,'color',[0.63 0.13 0.94],...
    %             'Linewidth',1.2);
    %         hold off
    %         s11.TickDir = 'out';
    %         s11.FontSize = 12;
    %         s11.TickLength = [0.01 0.01];
    %         s11.LineWidth = 1.2;
    %         s11.XLim = [20 40];
    %         s11.XColor = [0.63 0.14 0.94];
    %         s11.XGrid = 'on';
    %         s11.YLim = [1 4];
    %         s11.YTick = 1:1:4;
    %         s11.YTickLabel = {''};
    %
    %         s22 = axes('Position', get(s2, 'Position'), ...
    %             'XAxisLocation', 'top', ...
    %             'Color', 'none');
    %         hold on
    %         plot(s22,meannt,1:4,'color',[0.63 0.13 0.94],...
    %             'Linewidth',1.2);
    %         hold off
    %         s22.TickDir = 'out';
    %         s22.FontSize = 12;
    %         s22.TickLength = [0.01 0.01];
    %         s22.LineWidth = 1.2;
    %         s22.XLim = [3000 7000];
    %         s22.XTick = 3e3:2e3:7e3;
    %         s22.XTickLabels = {'3\cdot10^{3}','5\cdot10^{3}','7\cdot10^{3}'};
    %         s22.XColor = [0.63 0.14 0.94];
    %         s22.XGrid = 'on';
    %         s22.YLim = [1 4];
    %         s22.YTick = 1:1:4;
    %         s22.YTickLabel = {''};
    %
    %         s33 = axes('Position', get(s3, 'Position'), ...
    %             'XAxisLocation', 'top', ...
    %             'Color', 'none');
    %         hold on
    %         plot(s33,meanln,1:4,'color',[0.63 0.13 0.94],...
    %             'Linewidth',1.2);
    %         hold off
    %         s33.TickDir = 'out';
    %         s33.FontSize = 12;
    %         s33.TickLength = [0.01 0.01];
    %         s33.LineWidth = 1.2;
    %         s33.XLim = [0.2 0.8];
    %         s33.XTick = 0.2:0.2:0.8;
    %         s33.XColor = [0.63 0.14 0.94];
    %         s33.XGrid = 'on';
    %         s33.YLim = [1 4];
    %         s33.YTick = 1:1:4;
    %         s33.YTickLabel = {''};
    %     else
    %         s11 = axes('Position', get(s1, 'Position'), ...
    %             'XAxisLocation', 'top', ...
    %             'Color', 'none');
    %         hold on
    %         plot(s11,meanlwc,1:9,'color',[0.63 0.13 0.94],...
    %             'Linewidth',1.2);
    %         hold off
    %         s11.TickDir = 'out';
    %         s11.FontSize = 12;
    %         s11.TickLength = [0.01 0.01];
    %         s11.LineWidth = 1.2;
    %         s11.XLim = [0 150];
    %         s11.XColor = [0.63 0.14 0.94];
    %         s11.XGrid = 'on';
    %         s11.YLim = [1 9];
    %         s11.YTick = 1:2:9;
    %         s11.YTickLabel = {''};
    %
    %         s22 = axes('Position', get(s2, 'Position'), ...
    %             'XAxisLocation', 'top', ...
    %             'Color', 'none');
    %         hold on
    %         plot(s22,meannt,1:9,'color',[0.63 0.13 0.94],...
    %             'Linewidth',1.2);
    %         hold off
    %         s22.TickDir = 'out';
    %         s22.FontSize = 12;
    %         s22.TickLength = [0.01 0.01];
    %         s22.LineWidth = 1.2;
    %         s22.XLim = [0 7000];
    %         s22.XTick = [0 3e3 6e3];
    %         s22.XTickLabels = {'0','3\cdot10^{3}','6\cdot10^{3}'};
    %         s22.XColor = [0.63 0.14 0.94];
    %         s22.XGrid = 'on';
    %         s22.YLim = [1 9];
    %         s22.YTick = 1:2:9;
    %         s22.YTickLabel = {''};
    %
    %         s33 = axes('Position', get(s3, 'Position'), ...
    %             'XAxisLocation', 'top', ...
    %             'Color', 'none');
    %         hold on
    %         plot(s33,meanln,1:9,'color',[0.63 0.13 0.94],...
    %             'Linewidth',1.2);
    %         hold off
    %         s33.TickDir = 'out';
    %         s33.FontSize = 12;
    %         s33.TickLength = [0.01 0.01];
    %         s33.LineWidth = 1.2;
    %         s33.XLim = [0 8];
    %         s33.XTick = 0:2:8;
    % %         s33.XTickLabels = {'3e3','5e3','7e3'};
    %         s33.XColor = [0.63 0.14 0.94];
    %         s33.XGrid = 'on';
    %         s33.YLim = [1 9];
    %         s33.YTick = 1:2:9;
    %         s33.YTickLabel = {''};
    %     end
    %
    %
    %             savename = ['E:\DATA\MRR\Pictures\figure\shallow_LWC_image_line_',shallowday(ifile,:),'.png'];
    %             saveas(gcf,savename);
    %             close
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%Rainrate/Rainfall/LWC
    ttamp = {};
    for ii = 1:fix((matimeloc-mitimeloc)./60)+1
        ttamp = [ttamp;[num2str(fix(mitimeloc./60)+ii-1),':00']];
    end
    figure;
    set(gcf,'Position',get(0,'ScreenSize')*0.5);
    ff.fontsize = 12;
    s1=subplot(4,3,1);
    tempoRR = ottRR(mitimeloc:matimeloc);
    plot(mitimeloc:matimeloc,tempoRR,'Linewidth',1.2);
    if ifile ==2
        s1.YLim = [0 0.5];
        s1.YTick = [0 0.25 0.5];
        s1.YTickLabel = {'0';'0.25';'0.50'};
        text(mitimeloc+5,0.45,'(a) Parsivel2','Fontsize',12);
    else
        s1.YLim = [0 2];
        text(mitimeloc+5,1.8,'(a) Parsivel2','Fontsize',12);
    end
    s1.Position = [0.07,0.78,0.24,0.2];
    s1.FontSize = 12;
    s1.TickLength = [0.03 0.03];
    s1.LineWidth = 1.2;
    s1.XLim = [mitimeloc matimeloc];
    s1.XTick = mitimeloc:60:matimeloc;
    s1.XTickLabel = {''};
    s2=subplot(4,3,2);
    tempoNT = ottNt(mitimeloc:matimeloc);
    plot(mitimeloc:matimeloc,tempoNT,'Linewidth',1.2);
    if ifile ==2
        s2.YLim = [0 1.5e3];
        text(mitimeloc+5,1.5e3*0.9,'(b) Parsivel2','Fontsize',12);
    else
%         s2.YLim = [0 1];
%         s2.YTickLabel = {'0';'0.5';'1.0'};
%         text(mitimeloc+5,0.9,'(b) Parsivel2','Fontsize',12);
    end
    s2.Position = [0.4,0.78,0.24,0.2];
    s2.FontSize = 12;
    s2.TickLength = [0.03 0.03];
    s2.LineWidth = 1.2;
    s2.XLim = [mitimeloc matimeloc];
    s2.XTick = mitimeloc:60:matimeloc;
    s2.XTickLabel = {''};
    s3=subplot(4,3,3);
    tempoLWC = ottLWC(mitimeloc:matimeloc);
    tempoln = zeros(length(tempoNT));
    tempoln(tempoNT>0) = tempoLWC(tempoNT>0)./tempoNT(tempoNT>0);
    plot(mitimeloc:matimeloc,tempoln,'Linewidth',1.2);
    if ifile ==2
        s3.YLim = [0 6e-5];
        s3.YTick = [0 3e-5 6e-5];
        s3.YTickLabel = {'0';'3';'6'};
        text(mitimeloc+5,6e-5*0.9,'(c) Parsivel2','Fontsize',12);
    else
%         s3.YLim = [0 0.2];
%         text(mitimeloc+5,0.18,'(c) Parsivel2','Fontsize',12);
    end
    s3.Position = [0.73,0.78,0.24,0.2];
    s3.FontSize = 12;
    s3.TickLength = [0.03 0.03];
    s3.LineWidth = 1.2;
    s3.XLim = [mitimeloc matimeloc];
    s3.XTick = mitimeloc:60:matimeloc;
    s3.XTickLabel = {''};
    s4=subplot(4,3,4);
    tempmRR = RR(1,mitimeloc:matimeloc);
    plot(mitimeloc:matimeloc,tempmRR,'Linewidth',1.2);
    if ifile ==2
        s4.YLim = [0 0.5];
        s4.YTick = [0 0.25 0.5];
        s4.YTickLabel = {'0';'0.25';'0.50'};
        s4.YLabel.Position = [748.8,0.03,-1];
        text(mitimeloc+5,0.45,'(d) MRR 0.2 km','Fontsize',12);
    else
%         s4.YLim = [0 2];
%         s4.YLabel.Position = [1238.5,0.09,-1.3];
%         text(mitimeloc+5,1.8,'(d) MRR 0.2 km','Fontsize',12);
    end
    s4.Position = [0.07,0.55,0.24,0.2];
    s4.FontSize = 12;
    s4.TickLength = [0.03 0.03];
    s4.LineWidth = 1.2;
    s4.XLim = [mitimeloc matimeloc];
    s4.XTick = mitimeloc:60:matimeloc;
    s4.XTickLabel = {''};
    s4.YLabel.String = 'Rainrate(mm\cdoth^{-1})';
    s5=subplot(4,3,5);
    tempmNT = Nt(1,mitimeloc:matimeloc);
    plot(mitimeloc:matimeloc,tempmNT,'Linewidth',1.2);
    if ifile ==2
        s5.YLim = [0 6e3];
        s5.YTick = [0 3e3 6e3];
        s5.YTickLabel = {'0';'3.0';'6.0'};
        s5.YLabel.Position = [748.8,0,-1];
        text(mitimeloc+5,6e3*0.9,'(e) MRR 0.2 km','Fontsize',12);
    else
        s5.YLim = [0 1];
        s5.YTickLabel = {'0';'0.5';'1.0'};
        s5.YLabel.Position = [1234.27,0,0];
        text(mitimeloc+5,0.9,'(e) MRR 0.2 km','Fontsize',12);
    end
    s5.Position = [0.4,0.55,0.24,0.2];
    s5.FontSize = 12;
    s5.TickLength = [0.03 0.03];
    s5.LineWidth = 1.2;
    s5.XLim = [mitimeloc matimeloc];
    s5.XTick = mitimeloc:60:matimeloc;
    s5.XTickLabel = {''};
    s5.YLabel.String = 'Nt(m^{-3})';
    s6=subplot(4,3,6);
   tempmLWC = LWC(1,mitimeloc:matimeloc);
    tempmln = zeros(length(tempmNT));
    tempmln(tempmNT>0) = tempmLWC(tempmNT>0)./tempmNT(tempmNT>0);
    plot(mitimeloc:matimeloc,tempmln,'Linewidth',1.2);
    if ifile ==2
        s6.YLim = [0 2e-5];
        s6.YTickLabel = {'0';'1';'2'};
        s6.YLabel.Position = [741.8,0,-1];
        text(mitimeloc+5,2e-5*0.9,'(f) MRR 0.2 km','Fontsize',12);
    else
        s6.YLim = [0 0.2];
        s6.YLabel.Position = [1227.24,0.02,-1];
        text(mitimeloc+5,0.18,'(f) MRR 0.2 km','Fontsize',12);
    end
    s6.Position = [0.73,0.55,0.24,0.2];
    s6.FontSize = 12;
    s6.TickLength = [0.03 0.03];
    s6.LineWidth = 1.2;
    s6.XLim = [mitimeloc matimeloc];
    s6.XTick = mitimeloc:60:matimeloc;
    s6.XTickLabel = {''};
    s6.YLabel.String = 'LWC/Nt(10^{-5}\cdotg)';
    s7=subplot(4,3,7);
    tempmRR = RR(2,mitimeloc:matimeloc);
    plot(mitimeloc:matimeloc,tempmRR,'Linewidth',1.2);
    if ifile ==2
        s7.YLim = [0 0.5];
        s7.YTick = [0 0.25 0.50];
        s7.YTickLabel = {'0';'0.25';'0.50'};
        text(mitimeloc+5,0.45,'(g) MRR 0.4 km','Fontsize',12);
    else
        s7.YLim = [0 2];
        text(mitimeloc+5,1.8,'(g) MRR 0.4 km','Fontsize',12);
    end
    s7.Position = [0.07,0.32,0.24,0.2];
    s7.FontSize = 12;
    s7.TickLength = [0.03 0.03];
    s7.LineWidth = 1.2;
    s7.XLim = [mitimeloc matimeloc];
    s7.XTick = mitimeloc:60:matimeloc;
    s7.XTickLabel = {''};
    s8=subplot(4,3,8);
    tempmNT = Nt(2,mitimeloc:matimeloc);
    plot(mitimeloc:matimeloc,tempmNT,'Linewidth',1.2);
    if ifile ==2
        s8.YLim = [0 10e3];
        text(mitimeloc+5,10e3*0.9,'(h) MRR 0.4 km','Fontsize',12);
    else
        s8.YLim = [0 1];
        s8.YTickLabel = {'0';'0.5';'1.0'};
        text(mitimeloc+5,0.9,'(h) MRR 0.4 km','Fontsize',12);
    end
    s8.Position = [0.4,0.32,0.24,0.2];
    s8.FontSize = 12;
    s8.TickLength = [0.03 0.03];
    s8.LineWidth = 1.2;
    s8.XLim = [mitimeloc matimeloc];
    s8.XTick = mitimeloc:60:matimeloc;
    s8.XTickLabel = {''};
    s9=subplot(4,3,9);
    tempmLWC = LWC(2,mitimeloc:matimeloc);
    tempmln = zeros(length(tempmNT));
    tempmln(tempmNT>0) = tempmLWC(tempmNT>0)./tempmNT(tempmNT>0);
    plot(mitimeloc:matimeloc,tempmln,'Linewidth',1.2);
    if ifile ==2
        s9.YLim = [0 2e-5];
        s9.YTick = [0 1e-5 2e-5];
        s9.YTickLabel = {'0';'1';'2'};
        text(mitimeloc+5,2e-5*0.9,'(i) MRR 0.4 km','Fontsize',12);
    else
        s9.YLim = [0 0.2];
        text(mitimeloc+5,0.18,'(i) MRR 0.4 km','Fontsize',12);
    end
    s9.Position = [0.73,0.32,0.24,0.2];
    s9.FontSize = 12;
    s9.TickLength = [0.03 0.03];
    s9.LineWidth = 1.2;
    s9.XLim = [mitimeloc matimeloc];
    s9.XTick = mitimeloc:60:matimeloc;
    s9.XTickLabel = {''};
    s10=subplot(4,3,10);
    tempmRR = RR(3,mitimeloc:matimeloc);
    plot(mitimeloc:matimeloc,tempmRR,'Linewidth',1.2);
    if ifile ==2
        s10.YLim = [0 0.5];
        s10.YTick = [0 0.25 0.5];
        s10.YTickLabel = {'0';'0.25';'0.50'};
        text(mitimeloc+5,0.45,'(j) MRR 0.6 km','Fontsize',12);
    else
        s10.YLim = [0 2];
        text(mitimeloc+5,1.8,'(j) MRR 0.6 km','Fontsize',12);
    end
    s10.Position = [0.07,0.09,0.24,0.2];
    s10.FontSize = 12;
    s10.TickLength = [0.03 0.03];
    s10.LineWidth = 1.2;
    s10.XLim = [mitimeloc matimeloc];
    s10.XTick = mitimeloc:60:matimeloc;
    s10.XTickLabel = ttamp;
    s11=subplot(4,3,11);
    tempmNT = Nt(3,mitimeloc:matimeloc);
    plot(mitimeloc:matimeloc,tempmNT,'Linewidth',1.2);
    if ifile ==2
        s11.YLim = [0 10e3];
        text(mitimeloc+5,10e3*0.9,'(k) MRR 0.6 km','Fontsize',12);
    else
        s11.YLim = [0 1];
        s11.YTickLabel = {'0';'0.5';'1.0'};
        text(mitimeloc+5,0.9,'(k) MRR 0.6 km','Fontsize',12);
    end
    %     s11.YTick = [0 0.05 0.1];
    s11.Position = [0.4,0.09,0.24,0.2];
    s11.FontSize = 12;
    s11.TickLength = [0.03 0.03];
    s11.LineWidth = 1.2;
    s11.XLim = [mitimeloc matimeloc];
    s11.XLabel.String = 'Local Time';
    s11.XTick = mitimeloc:60:matimeloc;
    s11.XTickLabel = ttamp;
    s12 = subplot(4,3,12);
    tempmLWC = LWC(3,mitimeloc:matimeloc);
    tempmln = zeros(length(tempmNT));
    tempmln(tempmNT>0) = tempmLWC(tempmNT>0)./tempmNT(tempmNT>0);
    plot(mitimeloc:matimeloc,tempmln,'Linewidth',1.2);
    if ifile ==2
        s12.YLim = [0 2e-5];
        s12.YTick = [0 1e-5 2e-5];
        s12.YTickLabel = {'0';'1';'2'};
        text(mitimeloc+5,2e-5*0.9,'(l) MRR 0.6 km','Fontsize',12);
    else
        s12.YLim = [0 0.2];
        text(mitimeloc+5,0.18,'(l) MRR 0.6 km','Fontsize',12);
    end
    s12.Position = [0.73,0.09,0.24,0.2];
    s12.FontSize = 12;
    s12.TickLength = [0.03 0.03];
    s12.LineWidth = 1.2;
    s12.XLim = [mitimeloc matimeloc];
    s12.XTick = mitimeloc:60:matimeloc;
    s12.XTickLabel = ttamp;
%     savename = ['E:\DATA\MRR\Pictures\figure\shallow_Rainrate_NT_line_',shallowday(ifile,:),'.png'];
%     saveas(gcf,savename);
%     close
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%Rainrate/Rainfall/LWC
%     ttamp = {};
%     for ii = 1:fix((matimeloc-mitimeloc)./60)+1
%         ttamp = [ttamp;[num2str(fix(mitimeloc./60)+ii-1),':00']];
%     end
%     figure;
%     set(gcf,'Position',get(0,'ScreenSize')*0.5);
%     ff.fontsize = 12;
%     s1=subplot(4,3,1);
%     tempoRR = ottRR(mitimeloc:matimeloc);
%     plot(mitimeloc:matimeloc,tempoRR,'Linewidth',1.2);
%     if ifile ==2
%         s1.YLim = [0 0.5];
%         s1.YTick = [0 0.25 0.5];
%         s1.YTickLabel = {'0';'0.25';'0.50'};
%         text(mitimeloc+5,0.45,'(a) Parsivel2','Fontsize',12);
%     else
%         s1.YLim = [0 2];
%         text(mitimeloc+5,1.8,'(a) Parsivel2','Fontsize',12);
%     end
%     s1.Position = [0.07,0.78,0.24,0.2];
%     s1.FontSize = 12;
%     s1.TickLength = [0.03 0.03];
%     s1.LineWidth = 1.2;
%     s1.XLim = [mitimeloc matimeloc];
%     s1.XTick = mitimeloc:60:matimeloc;
%     s1.XTickLabel = {''};
%     s2=subplot(4,3,2);
%     tempoRRcum = cumsum(tempoRR)./60;
%     plot(mitimeloc:matimeloc,tempoRRcum,'Linewidth',1.2);
%     if ifile ==2
%         s2.YLim = [0 0.2];
%         text(mitimeloc+5,0.18,'(b) Parsivel2','Fontsize',12);
%     else
%         s2.YLim = [0 1];
%         s2.YTickLabel = {'0';'0.5';'1.0'};
%         text(mitimeloc+5,0.9,'(b) Parsivel2','Fontsize',12);
%     end
%     s2.Position = [0.4,0.78,0.24,0.2];
%     s2.FontSize = 12;
%     s2.TickLength = [0.03 0.03];
%     s2.LineWidth = 1.2;
%     s2.XLim = [mitimeloc matimeloc];
%     s2.XTick = mitimeloc:60:matimeloc;
%     s2.XTickLabel = {''};
%     s3=subplot(4,3,3);
%     tempoLWC = ottLWC(mitimeloc:matimeloc);
%     plot(mitimeloc:matimeloc,tempoLWC,'Linewidth',1.2);
%     if ifile ==2
%         s3.YLim = [0 0.1];
%         s3.YTickLabel = {'0';'0.05';'0.10'};
%         text(mitimeloc+5,0.09,'(c) Parsivel2','Fontsize',12);
%     else
%         s3.YLim = [0 0.2];
%         text(mitimeloc+5,0.18,'(c) Parsivel2','Fontsize',12);
%     end
%     s3.Position = [0.73,0.78,0.24,0.2];
%     s3.FontSize = 12;
%     s3.TickLength = [0.03 0.03];
%     s3.LineWidth = 1.2;
%     s3.XLim = [mitimeloc matimeloc];
%     s3.XTick = mitimeloc:60:matimeloc;
%     s3.XTickLabel = {''};
%     s4=subplot(4,3,4);
%     tempmRR = RR(1,mitimeloc:matimeloc);
%     plot(mitimeloc:matimeloc,tempmRR,'Linewidth',1.2);
%     if ifile ==2
%         s4.YLim = [0 0.5];
%         s4.YTick = [0 0.25 0.5];
%         s4.YTickLabel = {'0';'0.25';'0.50'};
%         s4.YLabel.Position = [748.8,0.03,-1];
%         text(mitimeloc+5,0.45,'(d) MRR 0.2 km','Fontsize',12);
%     else
%         s4.YLim = [0 2];
%         s4.YLabel.Position = [1238.5,0.09,-1.3];
%         text(mitimeloc+5,1.8,'(d) MRR 0.2 km','Fontsize',12);
%     end
%     s4.Position = [0.07,0.55,0.24,0.2];
%     s4.FontSize = 12;
%     s4.TickLength = [0.03 0.03];
%     s4.LineWidth = 1.2;
%     s4.XLim = [mitimeloc matimeloc];
%     s4.XTick = mitimeloc:60:matimeloc;
%     s4.XTickLabel = {''};
%     s4.YLabel.String = 'Rainrate(mm\cdoth^{-1})';
%     s5=subplot(4,3,5);
%     tempmRRcum = cumsum(tempmRR)./60;
%     plot(mitimeloc:matimeloc,tempmRRcum,'Linewidth',1.2);
%     if ifile ==2
%         s5.YLim = [0 0.2];
%         s5.YLabel.Position = [748.8,0,-1];
%         text(mitimeloc+5,0.18,'(e) MRR 0.2 km','Fontsize',12);
%     else
%         s5.YLim = [0 1];
%         s5.YTickLabel = {'0';'0.5';'1.0'};
%         s5.YLabel.Position = [1234.27,0,0];
%         text(mitimeloc+5,0.9,'(e) MRR 0.2 km','Fontsize',12);
%     end
%     s5.Position = [0.4,0.55,0.24,0.2];
%     s5.FontSize = 12;
%     s5.TickLength = [0.03 0.03];
%     s5.LineWidth = 1.2;
%     s5.XLim = [mitimeloc matimeloc];
%     s5.XTick = mitimeloc:60:matimeloc;
%     s5.XTickLabel = {''};
%     s5.YLabel.String = 'Accumulated Precipitation(mm)';
%     s6=subplot(4,3,6);
%     tempmLWC = LWC(1,mitimeloc:matimeloc);
%     plot(mitimeloc:matimeloc,tempmLWC,'Linewidth',1.2);
%     if ifile ==2
%         s6.YLim = [0 0.1];
%         s6.YTickLabel = {'0';'0.05';'0.10'};
%         s6.YLabel.Position = [748.8,0.003,-1];
%         text(mitimeloc+5,0.09,'(f) MRR 0.2 km','Fontsize',12);
%     else
%         s6.YLim = [0 0.2];
%         s6.YLabel.Position = [1227.24,0.02,-1];
%         text(mitimeloc+5,0.18,'(f) MRR 0.2 km','Fontsize',12);
%     end
%     s6.Position = [0.73,0.55,0.24,0.2];
%     s6.FontSize = 12;
%     s6.TickLength = [0.03 0.03];
%     s6.LineWidth = 1.2;
%     s6.XLim = [mitimeloc matimeloc];
%     s6.XTick = mitimeloc:60:matimeloc;
%     s6.XTickLabel = {''};
%     s6.YLabel.String = 'LWC(g\cdotmm^{-3})';
%     s7=subplot(4,3,7);
%     tempmRR = RR(2,mitimeloc:matimeloc);
%     plot(mitimeloc:matimeloc,tempmRR,'Linewidth',1.2);
%     if ifile ==2
%         s7.YLim = [0 0.5];
%         s7.YTick = [0 0.25 0.50];
%         s7.YTickLabel = {'0';'0.25';'0.50'};
%         text(mitimeloc+5,0.45,'(g) MRR 0.4 km','Fontsize',12);
%     else
%         s7.YLim = [0 2];
%         text(mitimeloc+5,1.8,'(g) MRR 0.4 km','Fontsize',12);
%     end
%     s7.Position = [0.07,0.32,0.24,0.2];
%     s7.FontSize = 12;
%     s7.TickLength = [0.03 0.03];
%     s7.LineWidth = 1.2;
%     s7.XLim = [mitimeloc matimeloc];
%     s7.XTick = mitimeloc:60:matimeloc;
%     s7.XTickLabel = {''};
%     s8=subplot(4,3,8);
%     tempmRRcum = cumsum(tempmRR)./60;
%     plot(mitimeloc:matimeloc,tempmRRcum,'Linewidth',1.2);
%     if ifile ==2
%         s8.YLim = [0 0.2];
%         text(mitimeloc+5,0.18,'(h) MRR 0.4 km','Fontsize',12);
%     else
%         s8.YLim = [0 1];
%         s8.YTickLabel = {'0';'0.5';'1.0'};
%         text(mitimeloc+5,0.9,'(h) MRR 0.4 km','Fontsize',12);
%     end
%     s8.Position = [0.4,0.32,0.24,0.2];
%     s8.FontSize = 12;
%     s8.TickLength = [0.03 0.03];
%     s8.LineWidth = 1.2;
%     s8.XLim = [mitimeloc matimeloc];
%     s8.XTick = mitimeloc:60:matimeloc;
%     s8.XTickLabel = {''};
%     s9=subplot(4,3,9);
%     tempmLWC = LWC(2,mitimeloc:matimeloc);
%     plot(mitimeloc:matimeloc,tempmLWC,'Linewidth',1.2);
%     if ifile ==2
%         s9.YLim = [0 0.1];
%         s9.YTick = [0 0.05 0.1];
%         s9.YTickLabel = {'0';'0.05';'0.10'};
%         text(mitimeloc+5,0.09,'(i) MRR 0.4 km','Fontsize',12);
%     else
%         s9.YLim = [0 0.2];
%         text(mitimeloc+5,0.18,'(i) MRR 0.4 km','Fontsize',12);
%     end
%     s9.Position = [0.73,0.32,0.24,0.2];
%     s9.FontSize = 12;
%     s9.TickLength = [0.03 0.03];
%     s9.LineWidth = 1.2;
%     s9.XLim = [mitimeloc matimeloc];
%     s9.XTick = mitimeloc:60:matimeloc;
%     s9.XTickLabel = {''};
%     s10=subplot(4,3,10);
%     tempmRR = RR(3,mitimeloc:matimeloc);
%     plot(mitimeloc:matimeloc,tempmRR,'Linewidth',1.2);
%     if ifile ==2
%         s10.YLim = [0 0.5];
%         s10.YTick = [0 0.25 0.5];
%         s10.YTickLabel = {'0';'0.25';'0.50'};
%         text(mitimeloc+5,0.45,'(j) MRR 0.6 km','Fontsize',12);
%     else
%         s10.YLim = [0 2];
%         text(mitimeloc+5,1.8,'(j) MRR 0.6 km','Fontsize',12);
%     end
%     s10.Position = [0.07,0.09,0.24,0.2];
%     s10.FontSize = 12;
%     s10.TickLength = [0.03 0.03];
%     s10.LineWidth = 1.2;
%     s10.XLim = [mitimeloc matimeloc];
%     s10.XTick = mitimeloc:60:matimeloc;
%     s10.XTickLabel = ttamp;
%     s11=subplot(4,3,11);
%     tempmRRcum = cumsum(tempmRR)./60;
%     plot(mitimeloc:matimeloc,tempmRRcum,'Linewidth',1.2);
%     if ifile ==2
%         s11.YLim = [0 0.2];
%         text(mitimeloc+5,0.18,'(k) MRR 0.6 km','Fontsize',12);
%     else
%         s11.YLim = [0 1];
%         s11.YTickLabel = {'0';'0.5';'1.0'};
%         text(mitimeloc+5,0.9,'(k) MRR 0.6 km','Fontsize',12);
%     end
%     %     s11.YTick = [0 0.05 0.1];
%     s11.Position = [0.4,0.09,0.24,0.2];
%     s11.FontSize = 12;
%     s11.TickLength = [0.03 0.03];
%     s11.LineWidth = 1.2;
%     s11.XLim = [mitimeloc matimeloc];
%     s11.XLabel.String = 'Local Time';
%     s11.XTick = mitimeloc:60:matimeloc;
%     s11.XTickLabel = ttamp;
%     s12 = subplot(4,3,12);
%     tempmLWC = LWC(3,mitimeloc:matimeloc);
%     plot(mitimeloc:matimeloc,tempmLWC,'Linewidth',1.2);
%     if ifile ==2
%         s12.YLim = [0 0.1];
%         s12.YTick = [0 0.05 0.1];
%         s12.YTickLabel = {'0';'0.05';'0.10'};
%         text(mitimeloc+5,0.09,'(l) MRR 0.6 km','Fontsize',12);
%     else
%         s12.YLim = [0 0.2];
%         text(mitimeloc+5,0.18,'(l) MRR 0.6 km','Fontsize',12);
%     end
%     s12.Position = [0.73,0.09,0.24,0.2];
%     s12.FontSize = 12;
%     s12.TickLength = [0.03 0.03];
%     s12.LineWidth = 1.2;
%     s12.XLim = [mitimeloc matimeloc];
%     s12.XTick = mitimeloc:60:matimeloc;
%     s12.XTickLabel = ttamp;
%     savename = ['E:\DATA\MRR\Pictures\figure\shallow_Rainrate_LWC_line_',shallowday(ifile,:),'.png'];
%     saveas(gcf,savename);
%     close
end