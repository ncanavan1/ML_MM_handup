#!/bin/bash
export maxmultiplicity=${1}

./calculate_cell.py ../frame.xyz
line_no=0
while read -r line; do
        if ((line_no == 0)) ; then
                xr=$line
        fi
        if ((line_no == 1)) ; then
                yr=$line
        fi
        if ((line_no == 2)) ; then
                zr=$line
        fi
        ((line_no++))
done < tmp.txt
cell="ABC ${xr} ${yr} ${zr}"
#echo $cell
sed -i "s/ABC 25.0 25.0 25.0/${cell}/g" geo-opt-restart.inp
rm tmp.txt


for multiplicity in $(seq ${maxmultiplicity} -1 0);do
	if [[ -d "run-${multiplicity}" ]] ; then
		cd run-${multiplicity}
		if [[ $(cat output.out | tail -1) ==  *"DUE TO TIME LIMIT"* ]] ; then
			##Run restarts
			cat ../geo-opt-restart.inp | sed "s/MLTP/${multiplicity}/" > geo-opt-restart.inp
			source ~/source/cp2k/tools/toolchain/install/setup
			mpirun -np 121 ~/source/cp2k/exe/local/cp2k.popt geo-opt-restart.inp &> output.out
		fi
		cd ../
	else 
 		mkdir -p run-${multiplicity}
 		cd run-${multiplicity}
		cat ../geo-opt-restart.inp | sed "s/MLTP/${multiplicity}/" > geo-opt-restart.inp 
		source ~/source/cp2k/tools/toolchain/install/setup
		mpirun -np 121 ~/source/cp2k/exe/local/cp2k.popt geo-opt-restart.inp &> output.out
		cd ../
	fi
done
