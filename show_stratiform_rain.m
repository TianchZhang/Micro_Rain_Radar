%Description:
%OTT rain type
% History:
% 2022.09.14 by zhangtc
clear
savepath = 'E:\DATA\OTTParsivel\Pictures\type\';
file_root = 'E:\DATA\OTTParsivel\nonQC2019mR-\';
listing = dir([file_root,'*.h5']);
for fnum = 1:length(listing)
    fname = [file_root,listing(fnum).name];
    tflag = h5read(fname,'/typeflag');
    if any(tflag == 2)
        rflag = h5read(fname,'/rainflag');
        figure;
        plot(1:1440,rflag,1:1440,tflag);
        legend('rainflag','typeflag');
        title(listing(fnum).name(1:8));
        savename = [listing(fnum).name(1:8),'.png'];
        saveas(gcf,[savepath,savename]);
        close
    end
    
    
    
end