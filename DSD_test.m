%Description:
%show the Radar Reflectivity of Micro Rain Radar
% History:
% 2022.07.04 by zhangtc
savepath ='E:\DATA\MRR\Pictures\ND\';
file_root = 'E:\DATA\MRR\h5_aveMRR_LT\';
par_root = 'E:\DATA\MRR\h5_parameters_LT\';
load('E:\DATA\Parsivel_temporary\Rainevents-allR-3-30.mat','Rainev_day_30');
event = cell2mat(Rainev_day_30);
for fnum = 3:length(listing)
    daynm = listing(fnum).name(13:20);
    if ismember(daynm,event)
        savef = [savepath,daynm,'\'];
        if ~isfolder(savef)
            mkdir(savef);
        end
        HT = h5read([file_root,listing(fnum).name],'/Height');
        RR = h5read([file_root,listing(fnum).name],'/Rain_Rate');
        ND = h5read([file_root,listing(fnum).name],'/Spectral_Drop_Densities');
        DS = h5read([par_root,'MRR_Parameters',listing(fnum).name(end-11:end)],'/Drop_Size');
        
        %background of Spectral Drop Densities
        %     Hloc = find(HT > 0);
        %     Rloc = find(RR < 0.01);
        %     tempBGND = nan(31,1440);
        %     tempBGND(intersect(Hloc,Rloc)) = ND(intersect(Hloc,Rloc),1);
        %     BGND = mean(tempBGND,2,'omitnan');
        %     BGND = repat(BGND,1,1440);
        for ih = 1:31
            figure(ih);
            DSD_show_MRR(DS(ih,:),ND(ih,:,:));
            title({['Rain Drop Densities','@',num2str(ih*200),'m'];[daynm(1:4),'-',daynm(5:6),'-',daynm(7:8)]})
            
            savename = [savef,'ND_',num2str(ih*200),'m_',listing(fnum).name(13:20),'.png'];
            saveas(gcf,savename);
            close
        end
    end
end