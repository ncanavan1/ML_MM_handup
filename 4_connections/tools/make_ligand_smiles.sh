#!/bin/bash

export base=${1}
export LType=${2}
export no=${3}

cat $base > L${no}.smi

counter=1
while [ $counter -le 5 ]
do
	rep=$(head -$counter $LType | tail -1)
	sed -i "s/R$counter/$rep/g" L${no}.smi
	((counter++))
done

sed -i "s/(H)//g" L${no}.smi
