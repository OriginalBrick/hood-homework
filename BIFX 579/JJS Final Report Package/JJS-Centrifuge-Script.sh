#!/bin/bash

#SBATCH --nodes=1                                 # Requests a specific node to run the job.
#SBATCH --time=07:05:00                           # Specifies the maximum time the job can run.
#SBATCH --partition=debug		                  # Requests a particuar partition for the job.
#SBATCH --ntasks-per-node=6                       # Requests a certain number of task per node.
#SBATCH --job-name=CCMetagenScript                # Specifies the name of the job.
#SBATCH --output=ccmetagen_status_update.%j.out   # Specifies where the job output goes.
#SBATCH --mem=64GB                                # Specifies a memory limit for the job.

# This script builds a reference database for the Centrifuge
# metagenomic classifier. It will subsequently use the same 
# program to analyze the short-read data from CIAN Diagnosics
# and generate a kreport file specifiying both the species
# present and their abundance estimations.

# Makes the script exits if an error occurs, specified with -e
set -e

# Downloads NCBI taxonomy
# -o specifies location
# &> will generate a special error file for this specific command if something goes wrong
centrifuge-download -o /BIODATA/jjs14_capstone/centrifuge/taxonomy taxonomy &> errorTaxonomy.txt

# Downloads the NCBI genome libraries
# -o specifies location
# -d indicates desired libraries
# -m masks low complexity regions
# refseq > seqid2taxid.map ensures output is in the right format 
# &> will generate a special error file for this specific command if something goes wrong
centrifuge-download -o /BIODATA/jjs14_capstone/centrifuge/library -m -d "archaea,bacteria,viral" refseq > seqid2taxid.map &> errorLibrary.txt

# Concatenates the downloaded library sequences into single files.
# Specifies library location and what file they are turned into
# &> will generate a special error file for this specific command if something goes wrong
cat /BIODATA/jjs14_capstone/centrifuge/library/*/*.fna > input-sequences.fna &> errorConcat.txt

# Actually build index database using previously assembled files.
# -p indicates the number of threads
# --conversion-table will list taxonomic IDs from the specified file along with the output
# --taxonomy-tree and --name-table tell it where to look for taxonomic names and tree nodes
# &> will generate a special error file for this specific command if something goes wrong
centrifuge-build -p 4 --conversion-table seqid2taxid.map \
                 --taxonomy-tree /BIODATA/jjs14_capstone/centrifuge/taxonomy/nodes.dmp \
                 --name-table /BIODATA/jjs14_capstone/centrifuge/taxonomy/names.dmp \
                 input-sequences.fna abv &> errorBuild.txt

# Performs the classification.
# -x specifies the reference database
# -1 and -2 specify the paried end sequence data
# &> will generate a special error file for this specific command if something goes wrong
centrifuge -x /BIODATA/jjs14_capstone/centrifuge/ex.*.cf \
 -1 /BIODATA/CIAN_DIAG/R9-ZymoMCS_S46_L001_R2_001.fastq.gz \
 -2 /BIODATA/CIAN_DIAG/R9-ZymoMCS_S46_L001_R2_002.fastq.gz &> errorClassify.txt 