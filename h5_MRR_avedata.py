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
    filelist = get_filelist('E:\DATA\MRR_AveData', [])
    savefile = r'E:\DATA\h5_aveMRR'

    for files in filelist:
        file = open(files, mode='r')
        datalines = file.readlines()

        timeloc = []
        for line in datalines:
            if line.startswith('MRR'):
                loc = mrr_timeloc(line)
                timeloc.append(loc)

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

    HH = np.array(HH, dtype=object)
    HH = HH.astype(np.float64)
    tempHH = np.zeros((31, 1440))
    tempHH[:, timeloc] = np.transpose(HH)
    TsF = np.array(TsF, dtype=object)
    TsF = TsF.astype(np.float64)
    tempTsF = np.zeros((31, 1440))
    tempTsF[:, timeloc] = np.transpose(TsF)
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
    tempFn = np.zeros((31, 64, 1440))
    tempFn[:, :, timeloc] = np.reshape(
    np.transpose(Fn), (31, 64, int(len(Fn))))
    Dn = np.array(Dn, dtype=object)
    Dn = Dn.astype(np.float64)
    tempDn = np.zeros((31, 64, 1440))
    tempDn[:, :, timeloc] = np.reshape(
    np.transpose(Dn), (31, 64, int(len(Dn))))
    Nn = np.array(Nn, dtype=object)
    Nn = Nn.astype(np.float64)
    tempNn = np.zeros((31, 64, 1440))
    tempNn[:, :, timeloc] = np.reshape(
    np.transpose(Nn), (31, 64, int(len(Nn))))

    savename = savefile + '\'+