fnameZ = 'E:\DATA\h5_aveMRR\MRR_AveData_20210719.h5';
fnameH = 'E:\DATA\MRR_HY\0719.h5';
rrz = h5read(fnameZ,'/Rain_Rate');
hz = h5read(fnameZ,'/Height');
rrh = h5read(fnameH,'/Rain Rate');
hh = h5read(fnameH,'/Height');

dz = h5read(fnameZ,'/Drop_Size');
dh = h5read(fnameH,'/Drop Size');
ttemp = dh-dz;
