#!/bin/bash 
#SBATCH --job-name=target_windows
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=5G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=END
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


hostname
date


# this script gets coverage stats (already calculated)
# and identifies target windows for variant comparisons
# coverage thresholds for target windows were defined by eye
# after looking at distributions for long and short reads. 

# load software
module load bedtools/2.29.0
module load htslib/1.12

# input/output
OUTDIR=../../results/vcfcomparison/targets
mkdir -p $OUTDIR

# coverage stats for long and short reads
LCOV=../../results/longreads/coverage_stats/coverage_1kb.bed.gz
SCOV=../../results/short_reads/coverage_stats/coverage_base_1kb.bed.gz

# get targets
	# > 47x coverage in long reads
	# < 80x coverage in long reads
	# < 100x coverage in short reads
paste <(zcat $LCOV) <(zcat $SCOV | cut -f 4) | \
awk '$4 > 47 && $4 < 80 && $7 < 100' | \
bedtools merge -i - | \
awk '$3-$2 >= 5000' | \
bgzip >$OUTDIR/targets.bed.gz

