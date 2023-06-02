#!/bin/bash

ln_list=(Pm Gd Tb Dy Tm Lu)

rm -r xyz
mkdir xyz

rm tmp
touch tmp
shuf -n 500 mol_list > tmp

while read mol ; do
	for ln in "${ln_list[@]}"; do
		fullmol=${ln}_${mol}
		cd xyz
		mkdir ${fullmol::-4}
		cd ${fullmol::-4}
		cp /users/40265864/sharedscratch/MSc_ML_MM/ln_replacements/full/${fullmol} .
		obabel -ismi ${fullmol} -ocan > ${fullmol::-4}_can.smi
		molconvert -3 PDB:H ${fullmol::-4}_can.smi -o ${fullmol::-4}.pdb
		obabel -ipdb ${fullmol::-4}.pdb -oxyz > ${fullmol::-4}.xyz
		cd ../../	
	done
done < tmp
rm tmp

echo ALL DONE :\)

#for d in *.smi; do
#ls |sort -R |tail -1000 |while read d; do
#cd xyz_fixed
#for d in */ ; do
#cd  $d
#obabel -ipdb ${d::-1}.pdb -c -oxyz > ${d::-1}.xyz
#cd ~/sharedscratch/MSc_ML_MM/SMILES/xyz_fixed/
#mkdir ../xyz_fixed/${d::-4}
#cp $d ../xyz_fixed/${d::-4}
#cd ../xyz_fixed/${d::-4}
#echo ${d::-4}
#obabel -ismi $d -ocan > ${d::-4}_can.smi
#obabel -isdf ${file::-4}.sdf -O frame.xyz
#molconvert -3 PDB:H ${d::-4}_can.smi -o ${d::-4}.pdb
#obabel -ipdb ${d::-4}.pdb -oxyz > ${d::-4}.xyz
#cd ../../full
#done
