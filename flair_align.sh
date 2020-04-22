#!/bin/bash

#This array script makes a bam out of each read, and then makes a frequency table of read lengths.
#After using this script, proceed to freqtables.R 

# The name of the job:
#SBATCH --job-name="hif_align"

# Maximum number of tasks/CPU cores used by the job:
#SBATCH --ntasks=1

# The amount of memory in megabytes per process in the job:
#SBATCH --mem-per-cpu=25000

# Send yourself an email when the job:
# aborts abnormally (fails)
#SBATCH --mail-type=FAIL
# ends successfully
#SBATCH --mail-type=END

# Use this email address:
#SBATCH --mail-user=irene.gallego@unimelb.edu.au
# The maximum running time of the job in days-hours:mins:sec
#SBATCH --time=1:00:00

#SBATCH --array=1-3

# Output control:
#SBATCH --output="/data/cephfs/punim0586/igallego/hypoxia_nanopore/logs/mapping_%A_%a.log"

# check that the script is launched with sbatch
if [ "x$SLURM_JOB_ID" == "x" ]; then
   echo "You need to submit your job to the queuing system with sbatch"
   exit 1
fi

# Assign the right ID to slurm task manager:

sampleID=`head -n ${SLURM_ARRAY_TASK_ID} /data/cephfs/punim0586/igallego/repos/hypoxia_nanopore/demultiplexing_ids.txt | tail -n 1 | awk '{ print $1 }'`
geneID=$1  # Note that this means the user must set the gene name... 

# The actual commands
module load Cython
module load Python/2.7.13-spartan_gcc-6.2.0
module load Pysam/0.15.1-GCC-6.2.0-Python-2.7.13

source ~/virtualenv/python2.7.13/bin/activate
module load SAMtools
module load BEDTools
module load minimap2

# First, flair align
python /data/cephfs/punim0586/shared/bin/flair/flair.py align -g /data/cephfs/punim0586/shared/genomes/hg38/hg38_renamed_no_alt_analysis_set.fa -r /data/cephfs/punim0586/shared/raw_data/epas_nanopore/${geneID}/concatenated/${sampleID}.fastq -o /data/cephfs/punim0586/igallego/hypoxia_nanopore/mapped/${geneID}/${sampleID}.mapped

# Then, flair correct
python /data/cephfs/punim0586/shared/bin/flair/flair.py correct -q /data/cephfs/punim0586/igallego/hypoxia_nanopore/mapped/${geneID}/${sampleID}.mapped.bed -g //data/cephfs/punim0586/shared/genomes/hg38/hg38_renamed_no_alt_analysis_set.fa -f /data/cephfs/punim0586/igallego/hypoxia_nanopore/reference/gencode.v33.annotation.gtf -o /data/cephfs/punim0586/igallego/hypoxia_nanopore/mapped/${geneID}/${sampleID}.corrected
