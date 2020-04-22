# Analysing Nanopore sequencing data of iPSC samples incubated in hypoxia for differential splicing

## Introduction
Much revised version of scripts from River Kano; fork of [his version](https://github.com/riverkano/hypoxia_nanopore).

### Software requirements
- R 3.5.2+
- Python 2.7.13 for running flair (see module list inside `flair_align.sh`)

## File locations and explanations
All raw sequencing data can be found in the Spartan computing cluster, at:

`/data/cephfs/punim0586/shared/raw_data/epas_nanopore`

### Raw sequencing data
| Directory | Notes |
|-----------|-------|
| /pilotpilot/ | pilotpilot data. Sequencing data using only four barcodes, for testing purposes. |
| /20190613_failedrun/ | A failed run, done the same time as the pilotpilot. (IGR note: unclear what this failure means) |
| /EGLN1/ | Full run. iPSC cDNA amplified with barcoded primers amplifying EGLN1, done in two batches of 50 barcodes. Already demultiplexed by the GridION. |
| /hif1a/ | Full run, early 2020. iPSC cDNA amplified with barcoded primers amplifying HIF1a, done in two batches of 50 barcodes. Already demultiplexed by the GridION. No analysis has yet been performed on it (but I'm not sure HIF1a was actually amplified that much)|
| EPAS_VEGFA | Flonge run, testing VEGFA and EPAS1. EPAS1 amplification unsuccessful. |
| VEGFA | Small full run, iPSC cDNA amplified with barcoded primers amplifying VEGFA, done in two batches. Currently processed manually by porechop, fast5 files need to be de-multiplexed on the cluster in the same way as the other two genes.|

## Barcoding:

`final_barcodes.csv` contains all the barcoding and sample metadata, on the basis of a lot of digging around by IGR (see lab notebook entries for April 19-22, and `barcode_untangling.xlsx`). Note that `BARCODES.csv` **IS INCORRECT** and should not be used. 

Columns are as follows:
Sample number, original sample code, RNA extraction batch, seq batch, barcode, O2, time, genotype, cell line

NB: I've changed the coding for time zero oxygen to ATM, as this is more accurate. 

* Seq batch: as there are more samples tham barcodes, each Nanopore run is separated into two batches.
* O2: 2.5, 5.0 or ATM (atmospheric oxygen).
* time: incubation time in hours - 4, 24 or 48.
* genotype: dai = Dai Chinese background. and = Andean background. wt = wildtype. mu = mutant.



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

