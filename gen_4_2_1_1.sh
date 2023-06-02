#!/bin/bash

export list1=${1} #directory for 2 connections
export list2=${2} #directory for 2 connections
export list3=${3} #directory for 2 connections
export list4=${4} #directory for 2 connections

i=0
for l1 in ${list1}*.smi ; do
	j=0
	for l2 in ${list2}*.smi ; do
		k=0
#		if ((j >= i )) ; then	
			for l3 in ${list3}*.smi ; do
				l=0
		#		if ((k >= j)) ; then
					for l4 in ${list4}*.smi ; do
						if ((l >= k )) ; then
							fn1=$(basename -- "$l1")
							fn2=$(basename -- "$l2")
							fn3=$(basename -- "$l3")
							fn4=$(basename -- "$l4")
							while read lanth ; do	
								fname=${lanth}_${fn1::-4}_${fn2::-4}_${fn3::-4}_${fn4::-4}.smi			
							#	echo $fname
								cat 4_Lig_template | sed "s/L1/$(cat $l1)/g;s/L2/$(cat $l2)/g;s/L3/$(cat $l3)/g;s/L4/$(cat $l4)/g;s/Ln/${lanth}/g" > full/$fname
					
							done < ln_list
						fi
						((l++))
					done
		#		fi
			((k++))	
			done	
#		fi
		((j++))
	done
	((i++))
done

