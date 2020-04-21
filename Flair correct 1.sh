#!/bin/bash

#This array script makes a bam out of each read, and then makes a frequency table of read lengths.
#After using this script, proceed to freqtables.R 

# Partition for the job:
#SBATCH --partition=mig

# The name of the job:
#SBATCH --job-name="1correct"

# The project ID which this job should run under:
#SBATCH --account="punim0586"

# Maximum number of tasks/CPU cores used by the job:
#SBATCH --ntasks=1

# The amount of memory in megabytes per process in the job:
#SBATCH --mem-per-cpu=40000

# Send yourself an email when the job:
# aborts abnormally (fails)
#SBATCH --mail-type=FAIL
# begins
#SBATCH --mail-type=BEGIN
# ends successfully
#SBATCH --mail-type=END

# Use this email address:
#SBATCH --mail-user=rkano@student.unimelb.edu.au
# The maximum running time of the job in days-hours:mins:sec
#SBATCH --time=1000

#SBATCH --array=1-50

# check that the script is launched with sbatch
if [ "x$SLURM_JOB_ID" == "x" ]; then
   echo "You need to submit your job to the queuing system with sbatch"
   exit 1
fi


source ~/virtualenv/python2.7.13/bin/activate

cd /data/cephfs/punim0586/rkano/VEGFA/1_VEGFA/flair/correct

module load SAMtools
module load Python/2.7.13-spartan_gcc-6.2.0
module load BEDTools
module load minimap2


# 2 - Flair correct
python /data/cephfs/punim0586/rkano/flair/flair.py correct -c /data/cephfs/punim0586/rkano/hg38.chrom.sizes -q /data/cephfs/punim0586/rkano/VEGFA/1_VEGFA/flair/align/align.${SLURM_ARRAY_TASK_ID}.bed -g /data/cephfs/punim0586/rkano/Homo_sapiens.GRCh38.dna.primary_assembly.fa -f /data/cephfs/punim0586/rkano/Homo_sapiens.GRCh38.97.gtf -o correct.${SLURM_ARRAY_TASK_ID}

