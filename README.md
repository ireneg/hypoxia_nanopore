# Analysing Nanopore sequencing data of iPSC samples incubated in hypoxia for differential splicing

## Introduction
These are the scripts used for my thesis, "*Investigating the effect of genetic variation near EPAS1 on differential expression and splicing of genes in the hypoxia response pathway*".

**Note** that although I have made every effort to ensure the code in here is understandable and actually works, a lot of it is still hot garbage. Much of the earlier and later (i.e. last minute) stuff is written in a way that will fall apart at the slightest touch. Sorry.

### Software requirements
- R 3.5.2 (or higher, I guess)

### Before starting dry lab
1. Obtain cDNA from iPSC samples
1. Amplify the transcript of interest using primers with added tails for Nanopore sequencing
1. Perform the barcoding reaction
1. Perform Nanopore sequencing. The Nanopore software MinKNOW now has the ability to demultiplex (sort reads by barcode) natively, but this feature is new. Below are instructions for two genes, one which does not make use of this feature (instead using qcat, or later, Porechop) and one which does make use of this feature.
1. Import data into Spartan computing complex. File paths in these scripts refer to the Spartan computing cluster, and batch scripts are written specifically for the Slurm workload manager, which Spartan uses.

## File locations and explanations
All raw sequencing data can be found in the Spartan computing cluster, at:
	/data/cephfs/punim0586/shared/raw_data/epas_nanopore
Below is an explanation of the folders within
### Raw sequencing data
| Directory | Notes |
|-----------|-------|
| /pilotpilot/ | pilotpilot data. Sequencing data using only four barcodes, for testing purposes. You probably don't need it. |
| /20190613_failedrun/ | A failed run, done the same time as the pilotpilot. You definitely don't need this. |
| /EGLN1/ | Full run. iPSC cDNA amplified with barcoded primers amplifying EGLN1, done in two batches of 50 barcodes. Already demultiplexed by the GridION. |
| /EGLN1/cat/ | The above, with all reads from the same barcode concatenated into a single file each. cat1 and cat2 denote whether the reads are from batch 1 or 2 - important for figuring out actual identity of the reads|
| /hif1a/ | Full run, early 2020. iPSC cDNA amplified with barcoded primers amplifying HIF1a, done in two batches of 50 barcodes. Already demultiplexed by the GridION. No analysis has yet been performed on it (but I'm not sure HIF1a was actually amplified that much)|
| EPAS_VEGFA | Full run. iPSC cDNA amplified with barcoded primers amplifying both VEGFA and EPAS1 at the same time, done in two batches (batches separated for first 50 barcodes and second 50 barcodes - the genes are all mixed together). EPAS1 amplification unsuccessful. |

## pilotpilot
*This section was done as a test of the Nanopore system. It takes reads from four barcodes and two genes that were all sequenced together, demultiplexes them, sorts them by gene, calculates the lengths of the reads, and creates a histogram for each gene giving the distribution of read lengths. This gives a bit of an indication of splice isoforms.*

1. qcat.sbatch
	- Demultiplexes reads using qcat
1. minimap.sbatch
	- Maps reads to the genome
1. freq_table.sbatch
	- Creates frequency tables of read length for a given gene.
1. length_freq_histo.R
	- Creates R data frame of read lengths of a given gene. Allows you to find number of reads within a given window. Creates histogram of read lengths.

## Differential expression - with Porechop (deprecated)
*This section is the main part of my thesis. It takes raw Nanopore sequencing data, demultiplexs them, sorts them by gene, and then uses Flair to count splice isoform expression*

1. porechop.sbatch
	- Demultiplexes reads using Porechop
1. concat.sh
	- Concatonates reads from each barcode into one long fastq
1. flair align 1.sh, flair correct 1.sh, flair quantify.sh
	- Uses Flair to perform differential splicing analysis

*New data obtained using the MinKNOW software is already demultiplexed, and doesn't need to go through Porechop. This inclides HIF1a data from early 2020.*

## Statistical analysis of differential expression
*This section is the R script I used to see if there are statistically significant differences in isoform expression between conditions. It's pretty ugly, so unless you are as talentless in R as I am, I recommend you rewrite this part for yourself. It performs pairwise t-tests on isoform TPMs between samples with identical conditions (i.e. cell line, incubation time) but differing oxygen concentrations.

The section requires a file referred to as VEGFA_counts.tsv - this will be the tsv that the previous Flair scripts spits out at the end, with the counts of reads of each isoform it found.*

1. 1_panels_is_oxygen.R
	- Creates graphs of the differences in expression for a given isoform. If you were redoing this, I'd make one script that can do all the isoforms in order, rather than changing the isoform manually and doing it over and over, which is what I did.
1. t-test.R
	- Performs pairwise t-tests to see if there are statistically significant differences in isoform expression between conditions.

## Barcode key
The file barcodes.csv has the key to the barcodes. Columns are as follows:

Sample number, sample code, RNA extraction batch, lot, barcode, O2, time, genotype, cell line

Lot: as there are more samples tham barcodes, each Nanopore run is separated into two lots.
O2: atm = atmospheric oxygen. 0 = time zero, so oxygen is irrelevant.
time: incubation time in hours.
genotype: dai = Dai Chinese background. and = Andean background. wt = wildtype. mu = mutant.
