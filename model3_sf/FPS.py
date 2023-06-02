#!/usr/bin/env python3

import numpy as np
import sys
import csv
import pandas as pd
csvfile = sys.argv[1]
energycsv = sys.argv[2]
d = int(sys.argv[3])

print("Read Start")

x = []
names = []
datafile = open(csvfile,"r")
lines= datafile.readlines()

for line in lines:
     xline = line.split(",")
     names.append(xline[0][:-9])
     xline = xline[1:]
     x.append(xline)

x = np.array(x,dtype="float")
print("Read End")


energydf = pd.read_csv(energycsv,header=None)
energydf = energydf.values



def do_fps(x, d=0,initial=-1):
    # Code from Giulio Imbalzano

    if d == 0 : d = len(x)
    n = len(x)
    iy = np.zeros(d,int)
    if (initial == -1):
        iy[0] = np.random.randint(0,n)
    else:
        iy[0] = initial
    # Faster evaluation of Euclidean distance
    # Here we fill the n2 array in this way because it halves the memory cost of this routine
    n2 = np.array([np.sum(x[i] * np.conj([x[i]])) for i in range(len(x))])
    print(n2.shape)
    dl = n2 + n2[iy[0]] - 2*np.real(np.dot(x,np.conj(x[iy[0]])))
    #print(n2)
    #print(dl)
   # print(n2.real)
   # print(n2.imag)
#    print(n2[0])
    for i in range(1,d):
        print("Doing ",i," of ",d," dist = ",max(dl))
        iy[i] = np.argmax(dl)
        nd = n2 + n2[iy[i]] - 2*np.real(np.dot(x,np.conj(x[iy[i]])))
        dl = np.minimum(dl,nd)
    return iy

y = do_fps(x.transpose(),d)
print(y)

x_pruned = np.zeros([x.shape[0],len(y)])
print(x.shape)
print(x_pruned.shape)
j=0
for i in range(0,x.shape[1]):
    if i in y:
       x_pruned[:,j] = x[:,i]
       j = j+1

#print(energydf[1,0])
print(names)

"""
with open("fps_diff.csv", "w") as csvfile:
    writer=csv.writer(csvfile)
    for row in range(0,x_pruned.shape[0]):
        info=[names[row]]
        info = info + x_pruned[row].tolist() 	
        for m in range(0,energydf.shape[0]):
            m_curr = energydf[m,0]
            if m_curr == names[row]:
                info = info + [energydf[m,1]]
        writer.writerow(info)
    csvfile.flush()
"""


with open("fps_min_e.csv", "w") as csvfile:
    writer=csv.writer(csvfile)

    header = []
    header.append("Molecule")
    for i in range(0,d):
        header.append("SF"+str(i))
    header.append("Energy")
    writer.writerow(header)

    for e_row in range(0,energydf.shape[0]):
        for i_row in range(0, x_pruned.shape[0]):
            if energydf[e_row,0] == names[i_row]:
                info = []
                info.append(names[i_row])
                info.extend(x_pruned[i_row].tolist())
                info.append(energydf[e_row,1])
                writer.writerow(info)
    csvfile.flush()
