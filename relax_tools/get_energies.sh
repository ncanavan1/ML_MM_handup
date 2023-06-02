#!/bin/bash

rm energy.txt
touch energy.txt
grep "ENERGY| Total FORCE_EVAL ( QS ) energy (a.u.):" output.out | awk '{print $(NF)}' | awk 'BEGIN{en=0}{if (en==0){en=$1};print $1,$1-en;en=$1}' | awk 'BEGIN{n=0}{n++;print n,$0}' > energy.txt
