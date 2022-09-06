%Description:
%show the number concentration of raindrops,rain rate and rainfall per minute everyday
% History:
% 2022.08.09 by zhangtc
savepath ='E:\DATA\MRR\Pictures\RR\';
file_root = 'E:\DATA\MRR\h5_aveMRR_LT\';

listing = dir([file_root,'*.h5']);
for fnum = 13:13%length(listing)
    daynm = listing(fnum).name(13:20);
    ht = h5read([file_root,listing(fnum).name],'/Height');
    RR = h5read([file_root,listing(fnum).name],'/Rain_Rate');

    figure;
    RR_show_MRR(RR);
    title({'Rainrate';[daynm(1:4),'-',daynm(5:6),'-',daynm(7:8)]})
    
    savename = [savepath,'RR_',listing(fnum).name(13:20),'.png'];
    saveas(gcf,savename);
    close
end