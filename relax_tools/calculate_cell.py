#!/usr/bin/env python3

import numpy as np
from ase.io import read,write
import os
import math
import sys

mol_file = sys.argv[1]
mol = read(mol_file)

xpoints=mol.positions[:,0]
ypoints=mol.positions[:,1]
zpoints=mol.positions[:,2]

x_range = xpoints.max() - xpoints.min()
y_range = ypoints.max() - ypoints.min()
z_range = zpoints.max() - zpoints.min()

with open("tmp.txt","w") as f:
    f.writelines(str(math.ceil(x_range) + 1)+"\n")
    f.writelines(str(math.ceil(y_range) + 1)+"\n")
    f.writelines(str(math.ceil(z_range) + 1)+"\n")
