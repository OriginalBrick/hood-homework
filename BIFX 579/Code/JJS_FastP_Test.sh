#!/usr/bin/env bash
for f1 in *1_001.fastq.gz
do
  f0=${f1%%1_001.fastq.gz}
  f2=$f0"2_001.fastq.gz"
  /home/ld15/fastp -i /BIODATA/mouseDataForSplicingProject/mouseFastqs/Sample_1_WT1_27081/$f1 -I /BIODATA/mouseDataForSplicingProject/mouseFastqs/Sample_1_WT1_27081/$f2 -o /home/jjs14/capstone/trimmed-$f1 -0 /home/jjs14/capstone/trimmed-$f2 -h "$f0.html" -j "$f0.json"
done