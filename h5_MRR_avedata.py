import h5py
import os
from os import path
import numpy as np
from tqdm import tqdm

# read record time,and transformed to 60*hh+min+1


def mrr_timeloc(temphd):
    mrrheader = temphd[4:14]
    timeloc = int(mrrheader[6:8])*60 + int(mrrheader[8:10])
    return timeloc


def to_list(strings):
    tempcont = strings
    tempdata = []
    for ik in range(31):
        mline = tempcont[3 + ik * 7:10 + ik * 7]
        if mline == '       ':
            mline = np.zeros(1)
            tempdata.append(mline)
        else:
            mline = mline.strip()
            tempdata.append(mline)
    return tempdata


def get_filelist(dir, Filelist):
    newDir = dir
    if os.path.isfile(dir):
        Filelist.append(dir)
    elif os.path.isdir(dir):
        for s in os.listdir(dir):
            newDir = os.path.join(dir, s)
            get_filelist(newDir, Filelist)
    return Filelist


def get_mrr_filetime(filen):
    filet = filen[-15:-11]+filen[-8:-4]
    return filet


if __name__ == '__main__':
    filelist = get_filelist('E:\\DATA\MRR_AveData\\202107', [])
    savefile = 'E:\\DATA\\h5_aveMRR\\'

    
    
    
    for files in filelist:
        file = open(files, mode='r')
        datalines = file.readlines()

        timeloc = []
        HH = []
        TsF = []
        Fn = []
        Dn = []
        Nn = []
        Pia = []
        ZZ = []
        RR = []
        LWC = []
        VV = []
        for line in datalines:
            if line.startswith('MRR'):
                loc = mrr_timeloc(line)
                timeloc.append(loc)

        for line in datalines:
            if line.startswith('H'):
                s = to_list(line)
                HH.append(s)
            elif line.startswith('TF'):
                s = to_list(line)
                TsF.append(s)
            elif line.startswith('PIA'):
                s = to_list(line)
                Pia.append(s)
            elif line.startswith('Z'):
                s = to_list(line)
                ZZ.append(s)
            elif line.startswith('RR'):
                s = to_list(line)
                RR.append(s)
            elif line.startswith('LWC'):
                s = to_list(line)
                LWC.append(s)
            elif line.startswith('W'):
                s = to_list(line)
                VV.append(s)
            elif line.startswith('F'):
                s = to_list(line)
                Fn.append(s)
            elif line.startswith('D'):
                s = to_list(line)
                Dn.append(s)
            elif line.startswith('N'):
                s = to_list(line)
                Nn.append(s)

        HH = np.int16(np.array(HH))
        tempHH = np.zeros((1440,31))
        tempHH[timeloc,:] = HH
        TsF = np.float32(np.array(TsF))
        tempTsF = np.zeros((1440, 31))
        tempTsF[timeloc,: ] = TsF
        Pia = np.array(Pia, dtype=object)
        Pia = Pia.astype(np.float64)
        tempPia = np.zeros((31, 1440))
        tempPia[:, timeloc] = np.transpose(Pia)
        ZZ = np.array(ZZ, dtype=object)
        ZZ = ZZ.astype(np.float64)
        tempZZ = np.zeros((31, 1440))
        tempZZ[:, timeloc] = np.transpose(ZZ)
        RR = np.array(RR, dtype=object)
        RR = RR.astype(np.float64)
        tempRR = np.zeros((31, 1440))
        tempRR[:, timeloc] = np.transpose(RR)
        tempRR = np.round(tempRR)
        LWC = np.array(LWC, dtype=object)
        LWC = LWC.astype(np.float64)
        tempLWC = np.zeros((31, 1440))
        tempLWC[:, timeloc] = np.transpose(LWC)
        VV = np.array(VV, dtype=object)
        VV = VV.astype(np.float64)
        tempVV = np.zeros((31, 1440))
        tempVV[:, timeloc] = np.transpose(VV)
        Fn = np.array(Fn, dtype=object)
        Fn = Fn.astype(np.float64)
        tempFn = np.zeros((1440,31, 64))
        tempFn[timeloc,:, : ] = np.reshape(np.transpose(Fn), (len(Fn)//64,31, 64))
        Dn = np.array(Dn, dtype=object)
        Dn = Dn.astype(np.float64)
        tempDn = np.zeros(( 1440,31,64))
        tempDn[timeloc,:, : ] = np.reshape(np.transpose(Dn), (len(Dn)//64, 31, 64))
        Nn = np.array(Nn, dtype=object)
        Nn = Nn.astype(np.float64)
        tempNn = np.zeros((1440,31,64))
        tempNn[timeloc,:, : ] = np.reshape(np.transpose(Nn), (len(Nn)//64, 31, 64))

        savename = savefile + 'MRR_AveData_' + get_mrr_filetime(files) + '.h5'
        if os.path.exists(savename):
            os.remove(savename)
        f = h5py.File(savename,"w")
        f["Height"] = tempHH
        f["Transfer_Function"] = tempTsF
        f["Path_Integrated_Attenuation"] = tempPia
        f["Radar_Reflectivity"] = tempZZ
        f["Rain_Rate"] = tempRR
        f["Liquid_Water_Content"] = tempLWC
        f["Fall_Velocity"] = tempVV
        f["Spectral_Reflectivities"] = tempFn
        f["Drop_Size"] = tempDn
        f["Spectral_Drop_Densities"] = tempNn
        f.close()