#!/bin/bash

#This array script makes a bam out of each read in a barcode, and then makes a frequency table of read lengths.
#After using this script, proceed to freqtables.R 

# Partition for the job:
#SBATCH --partition=physical

# The name of the job:
#SBATCH --job-name="rdk_pilotpilot_sam"

# The project ID which this job should run under:
#SBATCH --account="punim0586"

# Maximum number of tasks/CPU cores used by the job:
#SBATCH --ntasks=1

# The amount of memory in megabytes per process in the job:
#SBATCH --mem-per-cpu=20480

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

module load minimap2 
module load SAMtools

mkdir /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/slurmouts
mkdir /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/sams
mkdir /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/bams
mkdir /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/sortedbams
mkdir /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/freqtables/

#Here, choose which barcode you're looking for
bc=01

#Takes each fastq file and maps it to human genome 38 into a sam file

minimap2 -ax splice /data/projects/punim0586/shared/genomes/hg38/Homo_sapiens.GRCh38.dna.primary_assembly.fa /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/read${SLURM_ARRAY_TASK_ID}.barcode${bc}.fastq > /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/sams/read${SLURM_ARRAY_TASK_ID}.barcode${bc}.sam

#Takes each sam file, creates a BAM file, and sorts it
samtools view -S -b /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/sams/read${SLURM_ARRAY_TASK_ID}.barcode${bc}.sam > /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/bams/read${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam
samtools sort /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/bams/read${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam -o /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/sortedbams/sort${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam

#Makes a BAI file
samtools index -b /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/sortedbams/sort${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/sortedbams/sort${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam.bai

#Makes a frequency table of read lengths
samtools view /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/sortedbams/sort${SLURM_ARRAY_TASK_ID}.barcode${bc}.bam | cut -f 10 | perl -ne 'chomp;print length($_) . "\n"' | sort | uniq -c >> /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/freqtables/sort${SLURM_ARRAY_TASK_ID}.barcode${bc}.csv

#deletes the SAM file
rm /data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode${bc}/sams/read${SLURM_ARRAY_TASK_ID}.barcode${bc}.sam