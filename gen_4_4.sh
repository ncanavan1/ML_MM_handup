#!/bin/bash

export list1=${1} #directory for 4 connections
export list2=${2} #directory for 2 connections

i=0
for l1 in ${list1}*.smi ; do
	j=0
	for l2 in ${list2}*.smi ; do
		fn1=$(basename -- "$l1")
		fn2=$(basename -- "$l2")
		while read lanth ; do
			fname=${lanth}_${fn1::-4}_${fn2::-4}.smi			
		#	echo $fname
			cat 2_Lig_template | sed "s/L1/$(cat $l1)/g;s/L2/$(cat $l2)/g;s/Ln/${lanth}/g" > full/$fname
		done < ln_list
	((j++))
	done
((i++))
done

