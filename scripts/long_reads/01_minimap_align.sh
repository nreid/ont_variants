#!/bin/bash
#SBATCH --job-name=minimap_fa
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 12
#SBATCH --partition=xeon
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mem=100G
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date


# load software

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

# run minimap
minimap2 -c --MD -ax map-ont -t 10 $GENOME $FASTA | \
samtools sort -@ 5 -T $ALDIR/coral.temp -O BAM \
>$ALDIR/coral.bam

samtools index $ALDIR/coral.bam
