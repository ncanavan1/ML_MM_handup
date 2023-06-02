#!/bin/bash

export list1=${1} #directory for 4 connections
export list2=${2} #directory for 2 connections
export list3=${3} #directory for 2 connections

i=0
for l1 in ${list1}*.smi ; do
	j=0
	for l2 in ${list2}*.smi ; do
		k=0 
		for l3 in ${list3}*.smi ; do
			if ((k >= j)) ; then
				fn1=$(basename -- "$l1")
				fn2=$(basename -- "$l2")
				fn3=$(basename -- "$l3")
				while read lanth ; do
					fname=${lanth}_${fn1::-4}_${fn2::-4}_${fn3::-4}.smi			
					cat 3_Lig_template | sed "s/L1/$(cat $l1)/g;s/L2/$(cat $l2)/g;s/L3/$(cat $l3)/g;s/Ln/${lanth}/g" > full/$fname
				done < ln_list
			fi
			((k++))
		done	
		((j++))
	done
	((i++))
done

