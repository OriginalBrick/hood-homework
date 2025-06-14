#!/bin/bash

#SBATCH --nodes=1                                 # Requests a specific node to run the job. (Would not work with 8?)
#SBATCH --time=07:05:00                           # Specifies the maximum time the job can run.
#SBATCH --partition=debug		                  # Requests a particuar partition for the job.
#SBATCH --ntasks-per-node=8                       # Requests a certain number of task per node.
#SBATCH --job-name=CCMetagenScript                # Specifies the name of the job.
#SBATCH --output=ccmetagen_status_update.%j.out   # Specifies where the job output goes.
#SBATCH --mem=64GB                                # Specifies a memory limit for the job.


# This script builds a reference database for the CCMetagen
# metagenomic classifier. It will subsequently use the same 
# program to analyze the short-read data from CIAN Diagnosics
# and generate a report file specifiying both the species
# present and their abundance estimations.

# Makes the script exits if an error occurs, specified with -e.
set -e

# Downloads the reference database. The -P specifies the location.
# This is followed by a link to the online file. And &> errorDownload.txt
# will generate a special error file for this specific command if something goes wrong.
# wget -P /BIODATA/jjs14_capstone/ccmetagen https://cloudstor.aarnet.edu.au/plus/s/vfKH9S8c5FVGBjV/download?path=%2F&files=ncbi_nt_kma.zip &> errorDownload.txt

# Unzips the downloaded file so it can be accessed. Just specifies the file
# and the &> errorUnzip.txt generates a special error file for this specific
# command if something goes wrong.
# unzip /BIODATA/jjs14_capstone/ccmetagen/ncbi_nt_kma.zip &> errorUnzip.txt

# Maps sequences to reference database. The -ipe indicates paired sequence locations are to follow,
# while -o specifies output location. The -t_db directs to the database location. The -t indicates
# the number of threads. And the &> errorMap.txt generates a special error file for this
# specific command if something goes wrong.
# kma -ipe /BIODATA/CIAN_DIAG/ZymoMCS_P2_300cycles/R9-ZymoMCS_S46_L001_R1_001.fastq.gz /BIODATA/CIAN_DIAG/ZymoMCS_P2_300cycles/R9-ZymoMCS_S46_L001_R2_001.fastq.gz \
#  -o /BIODATA/jjs14_capstone/ccmetagen/sample_out_kma -t_db /BIODATA/jjs14_capstone/ccmetagen/compress_ncbi_nt/ncbi_nt \
#  -t 1 -1t1 -mem_mode -and -apm f -ef &> errorMap.txt

# Produces the final CCMetagen report. The -i indicates the mapped input data, while -o
# indicates the output location. And the &> errorAnalysis.txt generates a special error
# file for this specific command if something goes wrong.
# CCMetagen.py -i /BIODATA/jjs14_capstone/ccmetagen/sample_out_kma.res -o /BIODATA/jjs14_capstone/ccmetagen/results &> errorAnalysis.txt



# Redo of the last two steps using the downsampled data.
kma -ipe /BIODATA/jjs14_capstone/sub1.fa /BIODATA/jjs14_capstone/sub2.fa \
 -o /BIODATA/jjs14_capstone/ccmetagen/sample_out_kma -t_db /BIODATA/jjs14_capstone/ccmetagen/compress_ncbi_nt/ncbi_nt \
 -t 1 -1t1 -mem_mode -and -apm f -ef &> errorMap.txt

CCMetagen.py -i /BIODATA/jjs14_capstone/ccmetagen/sample_out_kma.res -o /BIODATA/jjs14_capstone/ccmetagen/results &> errorAnalysis.txt