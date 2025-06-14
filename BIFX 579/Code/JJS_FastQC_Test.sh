#!/bin/bash

#SBATCH --nodes=1                              # --node this allows the user to request a specific host to run the job.
#SBATCH --time=07:05:00                        # --time	parameter set the total	time limit the job is allowed to run.
#SBATCH --partition=debug		               # --pertition parameter request a particuar partition for the resource allocation. 
#SBATCH --ntasks-per-node=6                    # --n-tasks-per-node this specifies the number of task requested per node.
#SBATCH --job-name=FasqcScript                 # --job-name parameter is for giving name to the job. 
#SBATCH --output=fastqc_status_update.%j.out   # --ouput parameter is used to define the file which output of the job must be directed to.

# This script will run fastqc on the sample data
# in order to assess the read quality and put the output 
# in the directory that are specified for the file type.
# This workflow is well accepted in the bioinformatics 
# community because the output of one tool can easily be
# used as an input for another tool without any immense 
# configurations. The fastqc results will be moved to the
# specified directories after the fastqc program finishes 
#running on each sample.

# This is code made by Essome that has been modified for Jedediah.


########### Running Fastqc on Sample_1_WT1_27081 #####################

# The flag (-e) ensures that our script will exit if an error occurs
# it is generally wise to add it at the beginning of your
# scripts

set -e

# This command will move me into the rawReads directory
# when I run this script.

cd /BIODATA/mouseDataForSplicingProject/mouseFastqs/Sample_1_WT1_27081

# This line of code gives me status update message telling
# me that FastQC is currently running in the specified
# directory.

echo "Running FastQC on Sample_1_WT1_27081..."

# This is the actual command that runs fastqc on the files
# with extention .fastq.gz.
# It will save all output to my directories instead of Essome's.

fastqc -o /home/jjs14/capstone *.fastq.gz

# remove the annoying question mark directory.
rm -R ?