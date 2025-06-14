#!/bin/bash

#SBATCH --nodes=1                                 # Requests a specific node to run the job.
#SBATCH --time=07:05:00                           # Specifies the maximum time the job can run.
#SBATCH --partition=debug		                  # Requests a particuar partition for the job.
#SBATCH --ntasks-per-node=8                       # Requests a certain number of task per node.
#SBATCH --job-name=Kraken2Script                  # Specifies the name of the job.
#SBATCH --output=kraken2_status_update.%j.out     # Specifies where the job output goes.
#SBATCH --mem=64GB                                # Specifies a memory limit for the job.

# This script builds a reference database for the Kraken2
# metagenomic classifier. It will subsequently use the same 
# program to analyze the short-read data from CIAN Diagnosics
# and generate a kreport file specifiying both the species
# present and their abundance estimations.

# Makes the script exits if an error occurs, specified with -e.
set -e

# Downloads the standard reference database for Kraken2, specified with --standard.
# The --db is where the files go. And the &> errorDownload.txt will generate a special
# error file for this specific command if something goes wrong.
# kraken2-build --standard --db /BIODATA/jjs14_capstone/kraken2 &> errorDownload.txt

# Sets a confidence interval to reduce false positive, specified with --confidence.
# The --db is where the database is located. And the &> errorConfidence.txt will generate
# a special error file for this specific command if something goes wrong.
kraken2 --confidence 0.2 --db /BIODATA/jjs14_capstone/kraken2/ seqs.fasta &> errorConfidence.txt

# Classifies the data indicated. The --paired indicates we have paired end sequences,
# specified sequentically after --classified-out, which indicates how the output files
# will be named. The order is confusing, but this is the correct way to to do.
# The --db is where the database is located. And the &> errorClassify.txt will generate
# a special error file for this specific command if something goes wrong.
kraken2 --db /BIODATA/jjs14_capstone/kraken2/ --paired --classified-out /BIODATA/jjs14_capstone/kraken2/cseqs#.fastq \
 /BIODATA/CIAN_DIAG/R9-ZymoMCS_S46_L001_R2_001.fastq.gz /BIODATA/CIAN_DIAG/R9-ZymoMCS_S46_L001_R2_002.fastq.gz &> errorClassify.txt