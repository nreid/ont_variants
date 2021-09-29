#!/bin/bash
#SBATCH --job-name=medaka_variant
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 20
#SBATCH --partition=xeon
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mem=120G
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date


# load software

module load medaka/1.4.3
module load minimap2/2.18
module load samtools/1.12

# input/output files, directories
FASTA=../../data/longreads/fast_called.fasta
GENOME=../../genome/coral.fasta
FAI=../../genome/coral.fasta.fai

OUTROOT=../../results/longreads/
mkdir -p $OUTROOT

OUTDIR=$OUTROOT/medaka_variant/scaffolds
mkdir -p $OUTDIR

ALDIR=../../results/longreads/medaka_variant/alignment

# run medaka on each scaffold individually
command=$(echo bash -x medaka_variant_dontfollow \
-i $(pwd)/$ALDIR/coral.bam \
-f $(pwd)/$GENOME \
-s r941_prom_fast_g303 \
-m r941_prom_fast_g303 \
-t 2)

awk '$2 > 10000' $FAI | cut -f 1 | parallel -k -j 10 $command -r {} -o $(pwd)/$OUTDIR/{}
