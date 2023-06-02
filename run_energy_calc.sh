#!/bin/bash

export ln=${1}
ln="Tm"
cd xyz
for d in * ; do
if [ ${d:0:2} == $ln ] ; then
#	if [ ${d} == "Dy_L9_MeO_MeO_N_O" ] ; then 
	echo $d
	cd $d
	rm -r prelim_energy
	mkdir prelim_energy
	cd prelim_energy

	cp ~/sharedscratch/MSc_ML_MM/ln_replacements/relax_tools/* .

	sed -i "s/frame.xyz/${d}.xyz/g;s/molecule_name/${d}/g" geo-opt.inp
	sed -i "s/frame.xyz/${d}.xyz/g" cp2k.job
	sed -i "s/frame.xyz/${d}.xyz/g" run-cp2k.sh

	sbatch cp2k.job

	cd ..
	cd ..
#	fi
fi
done
