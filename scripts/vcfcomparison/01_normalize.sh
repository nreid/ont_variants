#!/bin/bash 
#SBATCH --job-name=normalize_vcfs
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

# load software
module load vcflib/1.0.0-rc1
module load htslib/1.12
module load bcftools/1.12
module load vt/0.57721

# First step:
	# allelic primitives, normalize variants from freebayes, gatk

# input/output directories, files

OUTDIR=../../results/vcfcomparison/vcfs
mkdir -p $OUTDIR

# ref genome
GENOME=../../genome/coral.fasta

# vcf files
fbvcf=../../results/short_reads/freebayes/coral_fb.vcf.gz
gtvcf=../../results/short_reads/gatk/coral_gatk.vcf.gz
ppvcf=../../results/longreads/pepper_deepvariant/pepper.vcf.gz

# freebayes
vt normalize -r $GENOME $fbvcf | vcfallelicprimitives -k -g | bgzip >$OUTDIR/fb.vcf.gz
tabix -p vcf $OUTDIR/fb.vcf.gz
# gatk
vt normalize -r $GENOME $gtvcf | vcfallelicprimitives -k -g | bgzip >$OUTDIR/gt.vcf.gz
tabix -p vcf $OUTDIR/gt.vcf.gz

cp ${ppvcf}* $OUTDIR

