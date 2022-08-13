%Description:
%save h5 data of Calculation of DSD parameters
% History:
% 2022.07.24 by zhangtc
clear
ltfile = 'E:\DATA\MRR\h5_aveMRR_LT\';
savefile = 'E:\DATA\MRR\h5_parameters\';
listing = dir([ltfile,'*.h5']);
for lnum = 1:length(listing)
    dnm = str2double(listing(lnum).name(13:20));
    FV = h5read([ltfile,listing(lnum).name],'/Fall_Velocity');
    HT = h5read([ltfile,listing(lnum).name],'/Height');
    LWC = h5read([ltfile,listing(lnum).name],'/Liquid_Water_Content');
    RR = h5read([ltfile,listing(lnum).name],'/Rain_Rate');
    DS = h5read([ltfile,listing(lnum).name],'/Drop_Size');
    ND = h5read([ltfile,listing(lnum).name],'/Spectral_Drop_Densities');
    RF = h5read([ltfile,listing(lnum).name],'/Radar_Reflectivity');
    SR = h5read([ltfile,listing(lnum).name],'/Spectral_Reflectivities');
    
    ND(ND < 0) = 0;
    
    Dm = zeros(31,1440);
    Delt_m = zeros(31,1440);
    Nw = zeros(31,1440);
    M2 = zeros(31,1440);
    M3 = zeros(31,1440);
    M4 = zeros(31,1440);
    M6 = zeros(31,1440);
    mu1 = zeros(31,1440);
    mu2 = zeros(31,1440);
    mu = zeros(31,1440);
    lamd = zeros(31,1440);
    N0 = zeros(31,1440);
    D0 = zeros(31,1440);
    Nt = zeros(31,1440);
    
    %background of Spectral Drop Densities
    Hloc = find(sum(HT,1) > 0);
    Rloc = find(RR(1,:) < 0.01);
    DS = reshape(DS(:,:,Hloc(1)),31,64);
    DSW = DS-circshift(DS,1,2);
    DSW(DSW<0) = 0;
    for ii = 1:31
        iloc = find(DSW(ii,:) > 0);
        DSW(ii,iloc(1)) = DSW(ii,iloc(2));
    end
    for mT = 1:1440
        for hi = 1:31
            if RR(hi,mT) > 0.01
                for di = 5:50
                    if ND(hi,di,mT) > 0
                        M2(hi,mT) = M2(hi,mT) + ND(hi,di,mT) .*DS(hi,di).^2 .* DSW(hi,di);
                        M3(hi,mT) = M3(hi,mT) + ND(hi,di,mT) .*DS(hi,di).^3 .* DSW(hi,di);
                        M4(hi,mT) = M4(hi,mT) + ND(hi,di,mT) .*DS(hi,di).^4 .* DSW(hi,di);
                        M6(hi,mT) = M6(hi,mT) + ND(hi,di,mT) .*DS(hi,di).^6 .* DSW(hi,di);
                        Nt(hi,mT) = Nt(hi,mT) + ND(hi,di,mT) .*DS(hi,di).^0 .* DSW(hi,di);
                    end
                end
                if Nt(hi,mT) > 0
                    Dm(hi,mT) = M4(hi,mT)./M3(hi,mT);
                    Nw(hi,mT) = 4^4 ./ pi .* 1e3 .* LWC(hi,mT) ./ (Dm(hi,mT) .^4);
                    
                    ita =(M4(hi,mT).^2)./(M2(hi,mT) .* M6(hi,mT));
                    mu1(hi,mT) = ((11*ita-7)-sqrt(ita^.2+14*ita+1))./(2*(1-ita));
                    mu2(hi,mT) = ((11*ita-7)+sqrt(ita^.2+14*ita+1))./(2*(1-ita));
                    tmu1 = sqrt((mu1(hi,mT)+2)^2+(mu1(hi,mT)-15)^2);
                    tmu2 = sqrt((mu2(hi,mT)+2)^2+(mu2(hi,mT)-15)^2);
                    if mu1(hi,mT) < -2
                        mu(hi,mT) = mu2(hi,mT);
                    else
                        if min(tmu1,tmu2) ==tmu1
                            mu(hi,mT) = mu1(hi,mT);
                        else
                            mu(hi,mT) = mu2(hi,mT);
                        end
                    end
                    lamd(hi,mT) = sqrt((M2(hi,mT) .* gamma(mu(hi,mT)+5))./(M4(hi,mT) .* gamma(mu(hi,mT)+3)));
                    N0(hi,mT) = M6(hi,mT)*lamd(hi,mT).^(mu(hi,mT)+6+1)./gamma(mu(hi,mT)+6+1);
                    temp = 0;
                    for di = 5:50
                        temp = temp + (DS(hi,di)-Dm(hi,mT)).^2 .* ...
                            ND(hi,mT) .*DS(hi,di).^3 .* DSW(hi,di);
                    end
                    Delt_m(hi,mT) = sqrt(temp ./ M3(hi,mT));
                    D0(hi,mT) = (mu(hi,mT)+3.67)./lamd(hi,mT);
                end
            end
        end
    end
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
    thisH5Filepath = [savefile,listing(lnum).name(1:4),'Parameters_',listing(lnum).name(end-10:end)];
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
    hdf5writedata(thisH5Filepath,'/Drop_Size',DS);
    hdf5writedata(thisH5Filepath,'/Drop_Size_Width',DSW);
    hdf5writedata(thisH5Filepath,'/Dm',Dm);
    hdf5writedata(thisH5Filepath,'/Delt_m',Delt_m);
    hdf5writedata(thisH5Filepath,'/Nw',Nw);
    hdf5writedata(thisH5Filepath,'/M2',M2);
    hdf5writedata(thisH5Filepath,'/M3',M3);
    hdf5writedata(thisH5Filepath,'/M4',M4);
    hdf5writedata(thisH5Filepath,'/M6',M6);
    hdf5writedata(thisH5Filepath,'/mu',mu);
    hdf5writedata(thisH5Filepath,'/lamd',lamd);
    hdf5writedata(thisH5Filepath,'/N0',N0);
    hdf5writedata(thisH5Filepath,'/D0',D0);
    hdf5writedata(thisH5Filepath,'/Nt',Nt);
    %     loc = intersect(Hloc,Rloc);
    %     BGDD = zeros(31,64);
    %     if any(loc)
    %         BG = SDD(:,:,loc);
    %         BG(BG < 1) = 1;
    %         for ih = 1:31
    %             for id = 1:64
    %                 BGDD(ih,id) = sum(BG(ih,id,:))./length(find(BG(ih,id,:)>1));
    %             end
    %         end
    %         tBGDD = repmat(BGDD,1,1,1440);
    %         tBGDD(:,:,setdiff(1:1440,loc)) = 1;
    %         figure
    %         subplot(2,1,1)
    %         SDD(:,:,loc) = 1;
    %         %         DSD_show_MRR(DS(1,:,1),SDD(1,:,:));
    %         shading flat
    %         SDD  = SDD - tBGDD;
    %         SDD(:,:,loc) = 1;
    %         subplot(2,1,2)
    %         %         DSD_show_MRR(DS(1,:,1),SDD(1,:,:));
    %         shading flat
    %     end
    clearvars -except ltfile savefile listing lnum
end