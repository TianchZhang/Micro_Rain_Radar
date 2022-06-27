from uuid import RESERVED_FUTURE
import numpy as np
import os
from os import path 
temp = np.zeros((20,15))

#tempt = np.arange(20)
#temptt = np.delete(tempt,[5,10],None)
#temp[temptt-1]=temptt

#ntemp = np.random.rand(20,15)
#nntemp = np.delete(ntemp,[5,10],0)
#temp[temptt,:]= nntemp
#print(nntemp)
#print(np.transpose(temp))
#print(len(temp))


 
 
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
    list = get_filelist('E:\DATA\MRR_AveData', [])
    print(len(list))
    for s in list:
        filet = get_mrr_filetime(s)
        print(filet)