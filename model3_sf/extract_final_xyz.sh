#!/bin/bash

xyzfile="dy_complex-pos-1.xyz"

cd ../xyz/
for d in */ ; do
    if [ ${d:0:2} == "Dy" ] ; then
        cd $d
        cd geometry_optimisation_2
        for f in */ ; do
                cd $f
                if [ -f $xyzfile ] ;  then
        		##get from last i= to end of xyz file
	   		line_no=$(grep -n "i =" $xyzfile | tail -n 1 | cut -d: -f1)
                        ((line_no--))
                        if [ ${f::-1} == "run-0" ] ; then
                        	tail -n +${line_no} $xyzfile > ../../${d::-1}_MLTP_MIN.xyz
                        else
                                tail -n +${line_no} $xyzfile > ../../${d::-1}_MLTP_MAX.xyz
                        fi
                fi
                cd ..
	done
        cd ..
        cd ..
    fi 
done
