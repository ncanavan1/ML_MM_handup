#!/usr/bin/env python3


import csv
import numpy as np

filename = "energy.txt"
#filename="relaxed_energy.txt"
csvfilename = "min_energy_dy.csv"

with open(filename) as file:
    lines = file.readlines()
    prevmol = lines[0].split()[0]
    min_e = 0

    w = open(csvfilename, 'w')
    writer = csv.writer(w)

    for line in lines:
        arr = line.split()
#        if len(arr) == 3:
        currmol = arr[0]
        try:
            energy = float(arr[2])

            if currmol == prevmol:
                if energy < min_e:
                    min_e = energy

            else:
               if min_e != 0:
                   writer.writerow([prevmol,min_e])
               prevmol = currmol
               min=0
        except:
            dummy=0

        if line==lines[-1]:
           writer.writerow([currmol,min])

