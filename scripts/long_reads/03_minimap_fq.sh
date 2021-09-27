#!/bin/bash
#SBATCH --job-name=minimap_fq
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 14
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
module load bioawk

# input/output files, directories
NPROC=$(nproc)
FASTQ=../../data/longreads/coral_combined_m1p1-4.fq
GENOME=../../genome/coral.fasta

OUTROOT=../../results/longreads/
mkdir -p $OUTROOT

ALDIR=$OUTROOT/alignment
mkdir -p $ALDIR


# run minimap
bioawk -c fastx '{if (length($seq) > 2000) print "@"$name"\n"$seq"\n+\n"$qual}' $FASTQ | \
minimap2 -2 -c --MD -ax map-ont -t 10 $GENOME - | \
samtools sort -@ 5 -T $ALDIR/coral.temp -O BAM \
>$ALDIR/coral_fq.bam

samtools index $ALDIR/coral_fq.bam
