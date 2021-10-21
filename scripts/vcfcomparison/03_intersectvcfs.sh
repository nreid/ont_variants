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

# create target VCF files
bcftools view -T $TARGETS -i 'TYPE="SNP"' $INDIR/fb.vcf.gz | bgzip >$INDIR/fb_targets.vcf.gz
tabix -p vcf $INDIR/fb_targets.vcf.gz
bcftools view -T $TARGETS -i 'TYPE="SNP"' $INDIR/gt.vcf.gz | bgzip >$INDIR/gt_targets.vcf.gz
tabix -p vcf $INDIR/gt_targets.vcf.gz
bcftools view -T $TARGETS -i 'TYPE="SNP"' $INDIR/pepper.vcf.gz | bgzip >$INDIR/pepper_targets.vcf.gz
tabix -p vcf $INDIR/pepper_targets.vcf.gz

# create tables of relevant data from VCFs with bcftools query

(echo -e "CHROM\tPOS\tREF\tALT\tQUAL\tFILTER\tGT\tDP\tAD"
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%FILTER\t[%GT]\t[%DP]\t[%AD]\n' $INDIR/fb_targets.vcf.gz) | bgzip >$INDIR/fb_table.txt.gz

(echo -e "CHROM\tPOS\tREF\tALT\tQUAL\tFILTER\tGT\tDP\tAD"
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%FILTER\t[%GT]\t[%DP]\t[%AD]\n' $INDIR/gt_targets.vcf.gz) | bgzip >$INDIR/gt_table.txt.gz

(echo -e "CHROM\tPOS\tREF\tALT\tQUAL\tFILTER\tGT\tDP\tAD"
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%FILTER\t[%GT]\t[%DP]\t[%AD]\n' $INDIR/pepper_targets.vcf.gz) | bgzip >$INDIR/pepper_table.txt.gz


# create intersections
bcftools isec -p $OUTDIR/fb_gt -T $TARGETS -i 'TYPE="SNP"' $INDIR/fb.vcf.gz $INDIR/gt.vcf.gz

bcftools isec -p $OUTDIR/fb_pp -T $TARGETS -i 'TYPE="SNP"' $INDIR/fb.vcf.gz $INDIR/pepper.vcf.gz

bcftools isec -p $OUTDIR/gt_pp -T $TARGETS -i 'TYPE="SNP"' $INDIR/gt.vcf.gz $INDIR/pepper.vcf.gz