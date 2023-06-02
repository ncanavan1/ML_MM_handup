#!/bin/bash

rm mol_list
touch mol_list

cd full
count=0
for d in * ; do

	if ! grep -q ${d:3} ../mol_list ; then
		echo ${d:3} >> ../mol_list
		echo $count
		((count++))
	fi

done
