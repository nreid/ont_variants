#!/bin/bash 
#SBATCH --job-name=gatk
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 7
#SBATCH --mem=10G
#SBATCH --qos=general
#SBATCH --partition=xeon
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


hostname
date

# load required software

module load bedtools
module load bamtools
module load htslib
module load freebayes


# make a directory for results if it doesn't exist
OUTDIR=../../results/short_reads/gatk
mkdir -p $OUTDIR 

# make a list of bam files

# set a variable for the reference genome location
GEN=../../genome/coral.fasta

# BAM file
BAM=../../results/short_reads/alignment/coral.bam

# call freebayes
	# coverage limits defined by looking at the distribution of per base coverage

gatk --java-options "-Xmx10g" HaplotypeCaller  \
   -R $GEN \
   -I $BAM \
   -O $OUTDIR/coral_gatk.vcf.gz

tabix -p vcf $OUTDIR/coral_gatk.vcf.gz

date
