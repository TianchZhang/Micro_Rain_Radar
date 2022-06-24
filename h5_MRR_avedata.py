import string
from tempfile import tempdir
from unittest import result
import numpy as np
from tqdm import tqdm

#read record time,and transformed to 60*hh+min+1
def mrr_timeloc(temphd):
    mrrheader = temphd[4:14]
    timeloc = int(mrrheader[6:8])*60 + int(mrrheader[8:10])
    return timeloc

def to_list(string):
    tempcont = string
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


if __name__ == '__main__':
    datafile = r'E:\DATA\MRR_AveData\2022\202201\0101.ave'
    file = open(datafile, mode='r')
    datalines = file.readlines()

    timeloc = []
    for line in datalines:
        if line.startswith('MRR'):
            loc = mrr_timeloc(line)
            timeloc.append(loc)

    result = []
    for line in datalines:
        if line.startswith('F'):
            s = to_list(line)
            result.append(s)

    result

    for ik in range(len(result)):
        if len(result[ik][:]) == 31:
            pass
        else:
            print(ik, result[ik][:])

result = np.array(result,dtype=object)
result = result.astype(np.float64)