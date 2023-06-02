#!/bin/bash
energy="$PWD/min_energy.csv"
rm $energy
touch $energy
cd xyz
for d in */ ; do
echo $d
	if [ -d "${d::-1}/prelim_energy" ] ; then
		cd ${d::-1}/prelim_energy
                f="run-7/"
		cd $f
                e=$(grep "ENERGY| Total FORCE_EVAL ( QS ) energy (a.u.):" output.out | tail -n 1 | awk '{print $(NF)}')
		if [[ ! -z "$e" ]] ; then	    
                     echo ${d::-1},$e >> $energy
	        
                else
                     f="run-6/"
                     cd ../$f
                     e=$(grep "ENERGY| Total FORCE_EVAL ( QS ) energy (a.u.):" output.out | tail -n 1 | awk '{print $(NF)}')
                     echo ${d::-1},$e >> $energy
     
                fi
                cd ..
		cd ../..
	fi
done

