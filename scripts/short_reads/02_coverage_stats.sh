#!/bin/bash 
#SBATCH --job-name=coverage
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 7
#SBATCH --mem=5G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err



hostname
date

# load required software

module load bedtools/2.29.0
module load bamtools/2.5.1
module load htslib/1.12
module load samtools/1.12

# define and/or create input, output directories
INDIR=../../results/short_reads/alignment
OUTDIR=../../results/short_reads/coverage_stats
mkdir -p $OUTDIR

# genome index file from samtools faidx
FAI=../../genome/coral.fasta.fai

# make a "genome" file, required by bedtools makewindows command, set variable for location
GFILE=$OUTDIR/coral.genome
cut -f 1-2 $FAI > $GFILE

# make 1kb window bed file, set variable for location
WIN1KB=$OUTDIR/coral_1kb.bed
bedtools makewindows -g $GFILE -w 1000 >$WIN1KB

BAM=$INDIR/coral.bam

samtools stats $BAM >$OUTDIR/coral.stats

# summarize coverage as the number of fragments mapping to 1kb windows across the genome
# pipe:
	# 1) filter by quality and proper pairing
	# 2) convert alignments to bed format
	# 3) map alignments to 1kb windows, counting (but also getting the mean and median of the mapping quality score from column 5)

bamtools filter -in $BAM -mapQuality ">30" -isDuplicate false -isProperPair true | \
bedtools bamtobed -i stdin | \
bedtools map \
-a $WIN1KB \
-b stdin \
-c 5 -o mean,median,count \
-g $GFILE | \
bgzip >$OUTDIR/coverage_1kb.bed.gz

# bgzip compress and tabix index the resulting file
tabix -p bed $OUTDIR/coverage_1kb.bed.gz



# calculate per-base coverage as well	
bamtools filter -in $BAM -mapQuality ">30" -isDuplicate false -isProperPair true | 
samtools depth -d 20000 /dev/stdin | \
bgzip >$OUTDIR/per_base_coverage.txt.gz

# summarize per-base coverage in 1kb windows
zcat $OUTDIR/per_base_coverage.txt.gz | \
awk '{OFS="\t"}{x=$2-1}{print $1,x,$2,$3}' | \
bedtools map \
-a $WIN1KB \
-b stdin \
-c 4 -o mean,median,count \
-g $GFILE | \
bgzip >$OUTDIR/coverage_base_1kb.bed.gz

# bgzip compress and tabix index the resulting file
tabix -p bed $OUTDIR/coverage_base_1kb.bed.gz


date

