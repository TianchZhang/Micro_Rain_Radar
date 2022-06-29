from ast import comprehension
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
    filelist = get_filelist('E:\\DATA\MRR_AveData_raw\\202203', [])
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
        #HH = np.int16(np.array(HH, dtype=object))
        # tempHH = np.zeros((1440,31))
        # tempHH[timeloc,:] = HH
        # TsF = np.float64(np.array(TsF, dtype=object))
        # tempTsF = np.zeros((1440, 31))
        # tempTsF[timeloc,: ] = np.round(TsF,4)
        # Pia = np.float64(np.array(Pia, dtype=object))
        # tempPia = np.zeros((1440, 31))
        # tempPia[timeloc, :] = np.round(Pia,3)
        # ZZ = np.float64(np.array(ZZ, dtype=object))
        # tempZZ = np.zeros((1440, 31))
        # tempZZ[timeloc, :] = np.round(ZZ,2)
        RR = np.float64(np.array(RR))
        tempRR = np.zeros((1440, 31))
        tempRR[timeloc, :] = np.round(RR,2)
        tempRR = tempRR
        # LWC = np.float64(np.array(LWC, dtype=object))
        # tempLWC = np.zeros((1440, 31))
        # tempLWC[timeloc, :] = np.round(LWC,2)
        # VV = np.float64(np.array(VV, dtype=object))
        # tempVV = np.zeros((1440, 31))
        # tempVV[timeloc, :] = np.round(VV,2)
        # Fn = np.float64(np.array(Fn, dtype=object))
        # tempFn = np.zeros((1440,64,31))
        # tempFn[timeloc,:, : ] = np.reshape(np.round(Fn,2), (len(Fn)//64,64,31))
        # Dn = np.float64(np.array(Dn, dtype=object))
        # tempDn = np.zeros(( 1440,64,31))
        # tempDn[timeloc,:, : ] = np.reshape(np.round(Dn,4), (len(Dn)//64, 64, 31))
        # Nn = np.float64(np.array(Nn, dtype=object))
        # tempNn = np.zeros((1440,64,31))
        # tempNn[timeloc,:, : ] = np.reshape((Nn), (len(Nn)//64, 64, 31))

        savename = savefile + 'MRR_AveData_' + get_mrr_filetime(files) + '.h5'
        if os.path.exists(savename):
            os.remove(savename)
        f = h5py.File(savename,"w")
        # f.create_dataset("Height",data = tempHH,
        #     compression = 'gzip',compression_opts = 7)
        # f.create_dataset("Transfer_Function",data = tempTsF,
        #     compression = 'gzip',compression_opts = 7)
        # f.create_dataset("Path_Integrated_Attenuation",data = tempPia,
        #     compression = 'gzip',compression_opts = 7)
        # f.create_dataset("Radar_Reflectivity",data = tempZZ,
        #     compression = 'gzip',compression_opts = 7)
        f.create_dataset("Rain_Rate",data = tempRR,
            compression = 'gzip',compression_opts = 7)
        # f.create_dataset("Fall_Velocity",data = tempVV,
        #     compression = 'gzip',compression_opts = 7)
        # f.create_dataset("Liquid_Water_Content",data = tempLWC,
        #     compression = 'gzip',compression_opts = 7)
        # f.create_dataset("Spectral_Reflectivities",data = tempFn,
        #     compression = 'gzip',compression_opts = 7)
        # f.create_dataset("Drop_Size",data = tempDn,
        #     compression = 'gzip',compression_opts = 7)
        # f.create_dataset("Spectral_Drop_Densities",data = tempNn,
        #     compression = 'gzip',compression_opts = 7)
        f.close()