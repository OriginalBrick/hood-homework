#!/bin/bash

#SBATCH --nodes=2 1                               # Requests a specific node to run the job.
#SBATCH --time=07:05:00                           # Specifies the maximum time the job can run.
#SBATCH --partition=debug		                  # Requests a particuar partition for the job.
#SBATCH --ntasks-per-node=8                       # Requests a certain number of task per node.
#SBATCH --job-name=Downsample                     # Specifies the name of the job.
#SBATCH --output=downsample_status_update.%j.out  # Specifies where the job output goes.

# This script downsamples the short-read data. The hope
# is to classify this data instead of the full dataset
# to help reduce the memory use of our classifiers.

# Splits up the indicated files.
# sample indicates where the data is located
# 0.2 > indicates what percent of the original data is going and what it will be called
seqtk sample /BIODATA/CIAN_DIAG/ZymoMCS_P2_300cycles/R9-ZymoMCS_S46_L001_R1_001.fastq.gz 0.2 > /BIODATA/jjs14_capstone/sub1.fa
seqtk sample /BIODATA/CIAN_DIAG/ZymoMCS_P2_300cycles/R9-ZymoMCS_S46_L001_R2_001.fastq.gz 0.2 > /BIODATA/jjs14_capstone/sub2.fa