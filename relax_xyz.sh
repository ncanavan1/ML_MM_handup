#!/bin/bash


cd xyz
for d in * ; do

if [[ ${d:0:2} == "Dy" ]] ; then

#="Dy_L25_L23_DMF_DMF_O_O"

cd $d    
mkdir geometry_optimisation_2
cd geometry_optimisation_2

cp ~/sharedscratch/MSc_ML_MM/ln_replacements/relax_tools/run-cp2k-relax.sh .
cp ~/sharedscratch/MSc_ML_MM/ln_replacements/relax_tools/cp2k-relax.job .
cp ~/sharedscratch/MSc_ML_MM/ln_replacements/relax_tools/geo-opt-relax_gpt.inp .
cp ~/sharedscratch/MSc_ML_MM/ln_replacements/relax_tools/calculate_cell.py .
cp ~/sharedscratch/MSc_ML_MM/ln_replacements/relax_tools/get_energies.sh .
#
sed -i "s/frame.xyz/${d}.xyz/g" geo-opt-relax_gpt.inp
sed -i "s/frame.xyz/${d}.xyz/g" cp2k-relax.job
sed -i "s/frame.xyz/${d}.xyz/g" run-cp2k-relax.sh

sbatch cp2k-relax.job

cd ../..

fi

#done < "/users/40265864/sharedscratch/MSc_ML_MM/ln_replacements/relax_tools/relax_subset.txt"

done
