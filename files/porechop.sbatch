#!/bin/bash

# Partition for the job:
#SBATCH --partition=snowy

# The name of the job:
#SBATCH --job-name="porechop1"

# The project ID which this job should run under:
#SBATCH --account="punim0586"

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

#SBATCH --array=1-138

# check that the script is launched with sbatch
if [ "x$SLURM_JOB_ID" == "x" ]; then
   echo "You need to submit your job to the queuing system with sbatch"
   exit 1
fi

############

module load Porechop

cd /data/cephfs/punim0586/rkano/VEGFA/1_VEGFA/20191004_0505_GA20000_FAK27466_8a858d47/fastq_pass

mkdir /data/cephfs/punim0586/rkano/VEGFA/1_VEGFA/porechop/${SLURM_ARRAY_TASK_ID}

porechop -i FAK27466_b5fe787bf039178b646dc119f991ec3d3b674efc_${SLURM_ARRAY_TASK_ID}.fastq -b /data/cephfs/punim0586/rkano/VEGFA/1_VEGFA/porechop/${SLURM_ARRAY_TASK_ID}

