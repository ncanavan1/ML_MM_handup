#!/bin/bash

export base=${1}
export LType=${2}

cp $LType ./Ltemp.smi

L=$(basename -- "$LType")

cat $base > $L

counter=1
while [ $counter -le 5 ]
do
	rep=$(head -$counter Ltemp.smi | tail -1)
	sed -i "s/R$counter/$rep/g" $L
	((counter++))
done

sed -i "s/(H)//g" $L

rm Ltemp.smi
