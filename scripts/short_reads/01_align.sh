#!/bin/bash 
#SBATCH --job-name=align_pipe
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 10
#SBATCH --mem=20G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# load required software
module load samtools
module load samblaster
module load bwa/0.7.17

# raw data directory
INDIR=../../data/shortreads

# specify and create output directory
OUTDIR=../../results/short_reads/alignment
mkdir -p $OUTDIR

# set a variable 'GEN' that gives the location and base name of the reference genome:
GEN=../../genome/coral

# read fastqs
FQ1=$INDIR/r1.fastq
FQ2=$INDIR/r2.fastq

# execute the pipe:
bwa mem -t 7 -R '@RG\tID:coral\tSM:coral' $GEN $FQ1 $FQ2 | \
samblaster | \
samtools view -S -h -u - | \
samtools sort -T /scratch/$USER - >$OUTDIR/coral.bam

samtools index $OUTDIR/coral.bam

date

