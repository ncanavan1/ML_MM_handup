#!/bin/bash

while read p; do
	cd xyz/$p/prelim_energy

	cp ~/sharedscratch/MSc_ML_MM/ln_replacements/relax_tools/run-restart.sh .
        cp ~/sharedscratch/MSc_ML_MM/ln_replacements/relax_tools/cp2k-restart.job .
	cp ~/sharedscratch/MSc_ML_MM/ln_replacements/relax_tools/geo-opt-restart.inp .

        sed -i "s/frame.xyz/${p}.xyz/g;s/molecule_name/${p}/g" geo-opt-restart.inp
        sed -i "s/frame.xyz/${p}.xyz/g" cp2k-restart.job
        sed -i "s/frame.xyz/${p}.xyz/g" run-restart.sh

	sbatch cp2k-restart.job

	cd ..
	cd ..
	cd ..

done < re-run-list.txt
