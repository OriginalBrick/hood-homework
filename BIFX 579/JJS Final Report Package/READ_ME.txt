### READ ME ###
This is a brief overview of the different files of my capstone project.

This is my SBATCH code. Please note the first three files don't run to completion.
- JJS-CCMetagen-Script: SBATCH file used to set up reference database and run CCMetagen.
- JJS-Centrifuge-Script: SBATCH file used to set up reference database and run Centrifuge.
- JJS-Kraken2-Script: SBATCH file used to set up reference database and run Kraken2.
- JJS-Downsample-Script: SBATCH file used to produce downsampled short-read data to test.

These are the BugSeq results I recieved. The kreport abundance estimation files I used for analysis can be found in each folder under "metagenomic_classification." The quality control chart is in "summary_reports" as part of the auto-generated report.
- Illumina BugSeq Results: BugSeq results of the short-read data.
- ONT BugSeq Results: BugSeq results of the long-read data.

This is where my input data is located on the Hood server, provided by CIAN Diagnostics.
- Long-Read Data:   /BIODATA/FASTQ_ONT/fastq_shotgun
- Short-Read Data:  /BIODATA/CIAN_DIAG/ZymoMCS_P2_300cycles

This is where my downsampled short-read data is on the Hood server.
- Downsampled Data: /BIODATA/jjs14_capstone/