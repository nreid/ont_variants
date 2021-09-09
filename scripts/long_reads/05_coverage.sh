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
INDIR=../../results/longreads/medaka_variant/alignment/
OUTDIR=../../results/longreads/coverage_stats
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


# calculate per-base coverage
samtools depth -d 20000 $BAM | \
bgzip >$OUTDIR/per_base_coverage.txt.gz

# summarize per-base coverage in 1kb windows
zcat $OUTDIR/per_base_coverage.txt.gz | \
awk '{OFS="\t"}{x=$2-1}{print $1,x,$2,$3}' | \
bedtools map \
-a $WIN1KB \
-b stdin \
-c 4 -o mean,median,count \
-g $GFILE | \
bgzip >$OUTDIR/coverage_1kb.bed.gz

# bgzip compress and tabix index the resulting file
tabix -p bed $OUTDIR/coverage_1kb.bed.gz

date

