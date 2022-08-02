%Description:
%save h5 data of Calculation of DSD parameters
% History:
% 2022.07.24 by zhangtc
clear
ltfile = 'E:\DATA\MRR\h5_aveMRR_LT\';
savefile = 'E:\DATA\MRR\h5_parameters\';
listing = dir([ltfile,'*.h5']);
for lnum = 116:116%length(listing)
    dnm = str2double(listing(lnum).name(13:20));
    FV = h5read([ltfile,listing(lnum).name],'/Fall_Velocity');
    HT = h5read([ltfile,listing(lnum).name],'/Height');
    LWC = h5read([ltfile,listing(lnum).name],'/Liquid_Water_Content');
    RR = h5read([ltfile,listing(lnum).name],'/Rain_Rate');
    DS = h5read([ltfile,listing(lnum).name],'/Drop_Size');
    SDD = h5read([ltfile,listing(lnum).name],'/Spectral_Drop_Densities');
    RF = h5read([ltfile,listing(lnum).name],'/Radar_Reflectivity');
    SR = h5read([ltfile,listing(lnum).name],'/Spectral_Reflectivities');
    
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
    
    BGDDflag = 0;
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
    for hi = 1:31
        for di = 3:23
            M2(mTime_putu) = M2(mTime_putu) + ND(mTime_putu,di) .*central_diameter(di).^2 .* diameter_bandwidth(di);
            M3(mTime_putu) = M3(mTime_putu) + ND(mTime_putu,di) .*central_diameter(di).^3 .* diameter_bandwidth(di);
            M4(mTime_putu) = M4(mTime_putu) + ND(mTime_putu,di) .*central_diameter(di).^4 .* diameter_bandwidth(di);
            M6(mTime_putu) = M6(mTime_putu) + ND(mTime_putu,di) .*central_diameter(di).^6 .* diameter_bandwidth(di);
            Nt(mTime_putu) = Nt(mTime_putu) + ND(mTime_putu,di) .*central_diameter(di).^0 .* diameter_bandwidth(di);
        end
        
        Dm(mTime_putu) = M4(mTime_putu)./M3(mTime_putu);
        Z(mTime_putu) = M6(mTime_putu);
        Nw(mTime_putu) = 4^4 ./ pi .* 1e3 .* LWC(mTime_putu) ./ (Dm(mTime_putu) .^4);
        
        ita =(M4(mTime_putu).^2)./(M2(mTime_putu) .* M6(mTime_putu));
        mu1(mTime_putu) = ((11*ita-7)-sqrt(ita^.2+14*ita+1))./(2*(1-ita));
        mu2(mTime_putu) = ((11*ita-7)+sqrt(ita^.2+14*ita+1))./(2*(1-ita));
        tmu1 = sqrt((mu1(mTime_putu)+2)^2+(mu1(mTime_putu)-15)^2);
        tmu2 = sqrt((mu2(mTime_putu)+2)^2+(mu2(mTime_putu)-15)^2);
        if mu1(mTime_putu) < -2
            mu(mTime_putu) = mu2(mTime_putu);
        else
            if min(tmu1,tmu2) ==tmu1
                mu(mTime_putu) = mu1(mTime_putu);
            else
                mu(mTime_putu) = mu2(mTime_putu);
            end
        end
        lamd(mTime_putu) = sqrt((M2(mTime_putu) .* gamma(mu(mTime_putu)+5))./(M4(mTime_putu) .* gamma(mu(mTime_putu)+3)));
        N0(mTime_putu) = M6(mTime_putu)*lamd(mTime_putu).^(mu(mTime_putu)+6+1)./gamma(mu(mTime_putu)+6+1);
    end
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
    
    
    
    %     clearvars -except ltfile savefile listing lnum
end