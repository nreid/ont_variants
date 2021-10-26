#!/bin/bash 
#SBATCH --job-name=msmc2
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --mem=40G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=END
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


hostname
date

# load modules
module load bcftools/1.12
module load bedtools/2.29.0


# input/output files directories
OUTDIR=../../results/smc/msmc/
INFILEDIR=$OUTDIR/infiles
mkdir -p $OUTDIR

VCF=../../results/vcfcomparison/vcfs/pepper_targets.vcf.gz
TARGETS=../../results/vcfcomparison/targets/targets.bed.gz
FAI=../../genome/coral.fasta.fai

# make input files for msmc2
for SCAF in $(zcat $TARGETS | awk '$3 > 300000' | cut -f 1 | uniq)
do
bedtools coverage \
-a <(bcftools view -H -m2 -M2 -r $SCAF -i 'FILTER="PASS" & GT=="0/1" & TYPE=="SNP"' $VCF | awk '{ OFS="\t" } BEGIN { x=0 }{ if( $2 < x ) { x=0 } }{ b=$4$5 }{ print $1,x,$2,b }{ x=$2 }') \
-b <(zcat $TARGETS) | \
awk '{OFS="\t"}{print $1,$3,$6,$4}' \
>$INFILEDIR/${SCAF}.txt
done

# run msmc2
MSMC2=~/bin/msmc2_linux64bit


$MSMC2 -t 12 -o $OUTDIR/pepper300k $INFILEDIR/*txt