fnameZ = 'E:\DATA\h5_aveMRR\MRR_AveData_20220312.h5';
fnameH = 'E:\DATA\MRR_HY\0312.h5';
% rrz = h5read(fnameZ,'/Rain_Rate');
% hz = h5read(fnameZ,'/Height');
% rrh = h5read(fnameH,'/Rain Rate');
% hh = h5read(fnameH,'/Height');

dz = h5read(fnameZ,'/Drop_Size');
dh = pagetranspose(h5read(fnameH,'/Drop Size'));
% 
% fnz = h5read(fnameZ,'/Spectral_Reflectivities');
% fnh = h5read(fnameH,'/Spectral Reflectivities');
temp = dz-dh;
temp(abs(temp)<0.001)=0;
