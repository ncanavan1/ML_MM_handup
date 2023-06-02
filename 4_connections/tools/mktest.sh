#!/bin/bash

export lig1=${1}
d=$(cat $lig1)
rm test.smi
touch test.smi
echo "[Dy+3]L1" > test.smi
sed -i "s/L1/$d/g" test.smi
