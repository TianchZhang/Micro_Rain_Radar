%Description:
%show the Radar Reflectivity of Micro Rain Radar
% History:
% 2022.07.04 by zhangtc
savepath ='E:\DATA\MRR\Pictures\ND\';
file_root = 'E:\DATA\MRR\h5_aveMRR_LT\';
par_root = 'E:\DATA\MRR\h5_parameters_LT\';
listing = dir([file_root,'*.h5']);
load('E:\DATA\Parsivel_temporary\Rainevents-allR-3-30.mat','Rainev_day');
load('E:\DATA\MRR\MRR_BG','BGND');
event = cell2mat(Rainev_day);
for fnum = 13:length(listing)
    daynm = listing(fnum).name(13:20);
    if ismember(daynm,event)
        savef = [savepath,daynm,'\'];
        if ~isfolder(savef)
            mkdir(savef);
        end
        HT = h5read([file_root,listing(fnum).name],'/Height');
        RR = h5read([file_root,listing(fnum).name],'/Rain_Rate');
        ND = h5read([file_root,listing(fnum).name],'/Spectral_Drop_Densities') * 1e-3 - repmat(BGND,1,1,1440);
        ND(ND<1) = 1;
        DS = h5read([par_root,'MRR_Parameters',listing(fnum).name(end-11:end)],'/Drop_Size');
        
        for ih = 1:31
            figure(ih);
            %             tRloc = find(RR(ih,:)<0.01);
            %             ND(ih,:,tRloc) = 1;
            tempND = reshape(ND(ih,:,:),64,[]);
            DSD_show_MRR(DS(ih,:),tempND);
            title({['Rain Drop Densities','@',num2str(ih*200),'m'];[daynm(1:4),'-',daynm(5:6),'-',daynm(7:8)]})
            
            savename = [savef,'ND_',num2str(ih*200),'m_',listing(fnum).name(13:20),'.png'];
            saveas(gcf,savename);
            close
        end
    end
end