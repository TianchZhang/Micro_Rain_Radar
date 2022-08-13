%Description:
%show the number concentration of raindrops,rain rate and rainfall per minute everyday
% History:
% 2022.08.09 by zhangtc
savepath ='E:\DATA\MRR\Pictures\ZZ\';
file_root = 'E:\DATA\MRR\h5_aveMRR_LT\';

listing = dir([file_root,'*.h5']);
for fnum = 3:3%length(listing)
    daynm = listing(fnum).name(13:20);
    ht = h5read([file_root,listing(fnum).name],'/Height');
    RR = h5read([file_root,listing(fnum).name],'/Rain_Rate');
    ZZ = h5read([file_root,listing(fnum).name],'/Radar_Reflectivity');
    loc = find(sum(ht,1) < 100);
    ZZ(:,loc) = NaN;
    ZZ(RR == 0) = NaN;
    ZZ(ZZ<0) = NaN;
    ZZ(ZZ>55) = 55;
    tempht = sum(ht,1);
    temploc = find(tempht~=0);
    
    figure;
    ZZ_show_MRR(ZZ);
    title({'Radar Reflectivity';[daynm(1:4),'-',daynm(5:6),'-',daynm(7:8)]})
    
%     savename = [savepath,'ZZ_',listing(fnum).name(13:20),'.png'];
%     saveas(gcf,savename);
%     close
end