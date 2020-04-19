#!/bin/bash

#This array script makes new bams that only contain reads within certain genes. Searches 100,000 bp up and downstream. Frequency tables can then be re-R'd.

# Partition for the job:
#SBATCH --partition=physical

# The name of the job:
#SBATCH --job-name="EPAS1-bc01.sbatch"

# The project ID which this job should run under:
#SBATCH --account="punim0586"

# Maximum number of tasks/CPU cores used by the job:
#SBATCH --ntasks=1

# The amount of memory in megabytes per process in the job:
#SBATCH --mem-per-cpu=2048

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
#SBATCH --time=0-10:0:00

#SBATCH --array=0-632

# check that the script is launched with sbatch
if [ "x$SLURM_JOB_ID" == "x" ]; then
   echo "You need to submit your job to the queuing system with sbatch"
   exit 1
fi

###########################                                                                                            
module load SAMtools


#Set your gene name and coordinates here:                                                                              
gene=EPAS1
coor=2:46191807-46488557
#And your barcode number
bc=01

cd /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/sortedbams


mkdir /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/
mkdir /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/$gene
mkdir /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/$gene/bams
mkdir /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/$gene/sortedbams
mkdir /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/$gene/freqtables

samtools view -b sort${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam $coor > /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/$gene/bams/read${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam

#Everything from here on is the same as the previous one                                                               

samtools sort /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/$gene/bams/read${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam -o /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/$gene/sortedbams/sort${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam

#Makes a BAI file                                                                                                      
samtools index -b /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/$gene/sortedbams/sort${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/$gene/sortedbams/sort${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam.bai

#Makes a frequency table of read lengths                                                                               
samtools view /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/$gene/sortedbams/sort${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam | cut -f 10 | perl -ne 'chomp;print length($_) . "\n"' | sort | uniq -c >> /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/genes/$gene/freqtables/sort${SLURM_ARRAY_TASK_ID}.csv

#deletes the SAM file                                                                                                  


