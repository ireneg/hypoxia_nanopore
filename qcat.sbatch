#!/bin/bash

#This array script demultiplexes all reads in parallel, and puts the results into a different folder for each read.

# Partition for the job:
#SBATCH --partition=physical

# The name of the job:
#SBATCH --job-name="qcat"

# The project ID which this job should run under:
#SBATCH --account="punim0586"

# Maximum number of tasks/CPU cores used by the job:
#SBATCH --ntasks=1

# The amount of memory in megabytes per process in the job:
#SBATCH --mem-per-cpu=2000

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
#SBATCH --time=0-0:30:00

#SBATCH --array=0-632

# check that the script is launched with sbatch
if [ "x$SLURM_JOB_ID" == "x" ]; then
   echo "You need to submit your job to the queuing system with sbatch"
   exit 1
fi

source ~/virtualenv/python3.7.1/bin/activate
module load Python
qcat -f /data/cephfs/punim0586/shared/raw_data/epas_nanopore/20190613_run/test/20190613_0938_GA30000_FAK27442_7ff17c16/fastq_pass/FAK27442_f2a15073ab0d844af23d1b99ac4c3ae822951d84_${SLURM_ARRAY_TASK_ID}.fastq -b /data/cephfs/punim0586/rkano/pilotpilot/qcat/out/${SLURM_ARRAY_TASK_ID}
cd /data/cephfs/punim0586/rkano/pilotpilot/qcat/out/${SLURM_ARRAY_TASK_ID}
for i in *.fastq
do
	mv "$i" read"$SLURM_ARRAY_TASK_ID"."$i"
done
