%Description:
%show the Radar Reflectivity of Micro Rain Radar
% History:
% 2022.07.04 by zhangtc
savepath ='E:\DATA\MRR\Pictures\DSD\';
file_root = 'E:\DATA\MRR\h5_aveMRR_LT\';
par_root = 'E:\DATA\MRR\h5_parameters_LT\';
load('E:\DATA\Parsivel_temporary\Rainevents-allR-3-30.mat','Rainev_day_30');
event = cell2mat(Rainev_day_30);
for fnum = 3:3%length(listing)
    daynm = listing(fnum).name(13:20);
    if ismember(daynm,event)
        savef = [savepath,daynm,'\'];
        if ~isfolder(savef)
            mkdir(savef);
        end
        ht = h5read([file_root,listing(fnum).name],'/Height');
        RR = h5read([file_root,listing(fnum).name],'/Rain_Rate');
        ND = h5read([file_root,listing(fnum).name],'/Spectral_Drop_Densities');
        
        Hloc = find(sum(ht,1) > 0);
        Rloc = find(sum(RR(1:20,:)~=0,1)<3);
        loc =  intersect(Hloc,Rloc);
        BS = max(ND(:,loc),[],2);
%         ZZ(:,loc) = NaN;
%         ZZ(RR == 0) = NaN;
%         ZZ(ZZ<0) = NaN;
%         ZZ(ZZ>55) = 55;
%         tempht = sum(ht,1);
%         temploc = find(tempht~=0);
%         
%         figure;
%         ZZ_show_MRR(ZZ);
%         title({'Radar Reflectivity';[daynm(1:4),'-',daynm(5:6),'-',daynm(7:8)]})
        
        %     savename = [savepath,'ZZ_',listing(fnum).name(13:20),'.png'];
        %     saveas(gcf,savename);
        %     close
    end
end