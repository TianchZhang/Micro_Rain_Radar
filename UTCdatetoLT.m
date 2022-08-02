%Description:
%UTC date to LT
% History:
% 2022.07.18 by zhangtc

utcfile = 'E:\DATA\MRR\h5_aveMRR_UTC\';
ltfile = 'E:\DATA\MRR\h5_aveMRR_LT\';
listing = dir([utcfile,'*.h5']);

for lnum = 1:length(listing)
    dnm = datenum(str2double(listing(lnum).name(13:16)),...
        str2double(listing(lnum).name(17:18)),str2double(listing(lnum).name(19:20)));
    TF = zeros(31,1440);
    FV = zeros(31,1440);
    HT = zeros(31,1440);
    LWC = zeros(31,1440);
    PIA = zeros(31,1440);
    RF = zeros(31,1440);
    RR = zeros(31,1440);
    DS = zeros(31,64,1440);
    SDD = zeros(31,64,1440);
    SR = zeros(31,64,1440);
    
    TF(:,481:end) = h5read([utcfile,listing(lnum).name],'/Transfer_Function',[1 1],[31 960]);
    FV(:,481:end) = h5read([utcfile,listing(lnum).name],'/Fall_Velocity',[1 1],[31 960]);
    HT(:,481:end) = h5read([utcfile,listing(lnum).name],'/Height',[1 1],[31 960]);
    LWC(:,481:end) = h5read([utcfile,listing(lnum).name],'/Liquid_Water_Content',[1 1],[31 960]);
    PIA(:,481:end) = h5read([utcfile,listing(lnum).name],'/Path_Integrated_Attenuation',[1 1],[31 960]);
    RF(:,481:end) = h5read([utcfile,listing(lnum).name],'/Radar_Reflectivity',[1 1],[31 960]);
    RR(:,481:end) = h5read([utcfile,listing(lnum).name],'/Rain_Rate',[1 1],[31 960]);
    DS(:,:,481:end) = h5read([utcfile,listing(lnum).name],'/Drop_Size',[1 1 1],[31 64 960]);
    SDD(:,:,481:end) = h5read([utcfile,listing(lnum).name],'/Spectral_Drop_Densities',[1 1 1],[31 64 960]);
    SR(:,:,481:end) = h5read([utcfile,listing(lnum).name],'/Spectral_Reflectivities',[1 1 1],[31 64 960]);
    
    formatout = 'yyyymmdd';
    dtemp = ['MRR_AveData_',datestr(dnm-1,formatout),'.h5'];
    if isfile([utcfile,dtemp])
        TF(:,1:480) = h5read([utcfile,dtemp],'/Transfer_Function',[1 961],[31 480]);
        FV(:,1:480) = h5read([utcfile,dtemp],'/Fall_Velocity',[1 961],[31 480]);
        HT(:,1:480) = h5read([utcfile,dtemp],'/Height',[1 961],[31 480]);
        LWC(:,1:480) = h5read([utcfile,dtemp],'/Liquid_Water_Content',[1 961],[31 480]);
        PIA(:,1:480) = h5read([utcfile,dtemp],'/Path_Integrated_Attenuation',[1 961],[31 480]);
        RF(:,1:480) = h5read([utcfile,dtemp],'/Radar_Reflectivity',[1 961],[31 480]);
        RR(:,1:480) = h5read([utcfile,dtemp],'/Rain_Rate',[1 961],[31 480]);
        DS(:,:,1:480) =h5read([utcfile,dtemp],'/Drop_Size',[1 1 961],[31 64 480]);
        SDD(:,:,1:480) = h5read([utcfile,dtemp],'/Spectral_Drop_Densities',[1 1 961],[31 64 480]);
        SR(:,:,1:480) = h5read([utcfile,dtemp],'/Spectral_Reflectivities',[1 1 961],[31 64 480]);
    end
    if sum(sum(fix(HT))) == 0
        continue
    else
        %% global attributes
        globalAttris.instrument = 'Micro Rain Radar';
        globalAttris.location = 'Wuhan';
        globalAttris.institute = 'MUA';
        globalAttris.source = 'Operational measurements';
        globalAttris.station_longitude = 114.37;
        globalAttris.station_latitude = 30.53;
        globalAttris.station_altitude = 72;
        globalAttris.parsivel_sampling_height = '200 m';
        globalAttris.parsivel_sampling_time = '60 s';
        %%
        thisH5Filepath = [ltfile,listing(lnum).name];
        h5init(thisH5Filepath);
        gAttrs = fieldnames(globalAttris);
        for iField = 1:length(gAttrs)
            fn = gAttrs{iField};
            attr_item = globalAttris.(fn);
            attr_details.Name = fn;
            attr_details.AttachedTo = '/';
            attr_details.AttachType = 'group';
            
            hdf5write(thisH5Filepath, attr_details, attr_item, 'WriteMode', 'append');
        end
        hdf5writedata(thisH5Filepath,'/Transfer_Function',TF);
        hdf5writedata(thisH5Filepath,'/Fall_Velocity',FV);
        hdf5writedata(thisH5Filepath,'/Height',HT);
        hdf5writedata(thisH5Filepath,'/Liquid_Water_Content',LWC);
        hdf5writedata(thisH5Filepath,'/Path_Integrated_Attenuation',PIA);
        hdf5writedata(thisH5Filepath,'/Radar_Reflectivity',RF);
        hdf5writedata(thisH5Filepath,'/Rain_Rate',RR);
        hdf5writedata(thisH5Filepath,'/Drop_Size',DS);
        hdf5writedata(thisH5Filepath,'/Spectral_Drop_Densities',SDD);
        hdf5writedata(thisH5Filepath,'/Spectral_Reflectivities',SR);
    end
end