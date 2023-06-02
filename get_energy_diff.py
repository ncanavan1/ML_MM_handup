#!/usr/bin/env python3

import csv
import numpy as np

filename = "energy.txt"
csvfilename = "diff_energy_full.csv"



with open(filename) as file:
    lines = file.readlines()
    prevmol = lines[0].split()[0]
    energies = []

    w = open(csvfilename, 'w')
    writer = csv.writer(w)
    print(lines[-1])
    count=0
    for line in lines:
        arr = line.split()
        currmol = arr[0]
        if len(arr) == 3 or len(arr) == 4:
            try:
                energy = float(arr[2])
                if currmol == prevmol:
                    energies.append(energy)

                else:
                    min_e = min(energies)
                    max_e = max(energies)
                    diff = abs(min_e-max_e)
                    if (diff != 0):
                        writer.writerow([prevmol,diff])
                    prevmol = currmol
                    energies = []
                    energies.append(float(arr[2]))
            except:
                dummy=0
    print("end")
    min_e = min(energies)
    max_e = max(energies)
    diff = abs(min_e-max_e)
    if ( diff != 0):
        writer.writerow([currmol,diff])

