#!/bin/bash 
#SBATCH --job-name=isec_vcfs
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

module load bcftools/1.12
module load htslib/1.12
module load vt/0.57721

INDIR=../../results/vcfcomparison/vcfs/
OUTDIR=../../results/vcfcomparison/isec
mkdir -p $OUTDIR

TARGETS=../../results/vcfcomparison/targets/targets.bed.gz

bcftools isec -p $INDIR/fb_gt -T $TARGETS -i 'TYPE="SNP"' $INDIR/fb.vcf.gz $INDIR/gt.vcf.gz

bcftools isec -p $INDIR/fb_pp -T $TARGETS -i 'TYPE="SNP"' $INDIR/fb.vcf.gz $INDIR/pepper.vcf.gz

bcftools isec -p $INDIR/gt_pp -T $TARGETS -i 'TYPE="SNP"' $INDIR/gt.vcf.gz $INDIR/pepper.vcf.gz