#!/bin/bash
unfinishedfile=$PWD/unfinished.txt
rm $unfinishedfile
touch $unfinishedfile
cd xyz
for d in */ ; do
	cd $d
	if [ -d "prelim_energy" ] ; then
		cd prelim_energy
		for f in */ ; do
			cd $f
			if [[ $(cat output.out | tail -1) ==  *"DUE TO TIME LIMIT"* ]] ; then
				echo "$d $f" >> $unfinishedfile
			fi
			cd ..
		done	
		cd ..
	fi
	cd ..
done

