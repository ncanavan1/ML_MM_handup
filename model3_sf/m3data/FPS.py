#!/usr/bin/env python3

import numpy as np
import sys
import csv
import pandas as pd


csvfile1 = sys.argv[1]
csvfile2 = sys.argv[2]
energycsv = sys.argv[3]
d = int(sys.argv[4])

print("Read Start")

x = []
names = []
datafile = open(csvfile1,"r")
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


x_pruned = np.zeros([x.shape[0],len(y)])
j=0

for i in range(0,x.shape[1]):
    if i in y:
       x_pruned[:,j] = x[:,i]
       j = j+1



x2 = []
datafile2 = open(csvfile2,"r")
lines2= datafile2.readlines()
names2 = []
for line in lines2:
     xline = line.split(",")
     names2.append(xline[0][:-9])
     xline = xline[1:]
     x2.append(xline)

x2 = np.array(x2,dtype="float")

j=0
x2_pruned = np.zeros([x2.shape[0],len(y)])
for i in range(0,x2.shape[1]):
    if i in y:
        x2_pruned[:,j] = x2[:,i]
        j = j + 1


print(names)

with open("fps_min_mltp.csv", "w") as csvfile:
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



with open("fps_max_mltp.csv", "w") as csvfile:
    writer=csv.writer(csvfile)

    header = []
    header.append("Molecule")
    for i in range(0,d):
        header.append("SF"+str(i))
    header.append("Energy")
    writer.writerow(header)

    for e_row in range(0,energydf.shape[0]):
        for i_row in range(0, x2_pruned.shape[0]):
            if energydf[e_row,0] == names2[i_row]:
                info = []
                info.append(names2[i_row])
                info.extend(x2_pruned[i_row].tolist())
                info.append(energydf[e_row,1])
                writer.writerow(info)
    csvfile.flush()

