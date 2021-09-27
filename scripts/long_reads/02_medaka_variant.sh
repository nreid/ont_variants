#!/bin/bash
#SBATCH --job-name=medaka_variant
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 12
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
NPROC=$(nproc)
FASTA=../../data/longreads/fast_called.fasta
GENOME=../../genome/coral.fasta

OUTROOT=../../results/longreads/
mkdir -p $OUTROOT

OUTDIR=$OUTROOT/medaka_variant
mkdir -p $OUTDIR

ALDIR=$OUTDIR/alignment
mkdir -p $ALDIR

# run medaka
bash -x medaka_variant_dontfollow \
-i $(pwd)/$ALDIR/coral.bam \
-f $(pwd)/$GENOME \
-o $(pwd)/$OUTDIR \
-s r941_prom_fast_g303 \
-m r941_prom_fast_g303 \
-t 12
