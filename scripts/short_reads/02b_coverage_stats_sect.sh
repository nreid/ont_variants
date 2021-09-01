#!/bin/bash
#SBATCH --job-name=katsect
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 10
#SBATCH --mem=30G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# load software
module load bedtools
module load htslib

# kat installed in my local directory in a python environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate kat

# input/output files, directories
OUTDIR=../../results/short_reads/coverage_stats
mkdir -p $OUTDIR

FAI=../../genome/coral.fasta.fai

FQ1=../../data/shortreads/r1.fastq
FQ2=../../data/shortreads/r2.fastq

# run kat sect
	# kat doesn't seem to work unless the extension is .fa, not .fna so copy the genome then delete the copy
cp ../../genome/coral.fasta ../../genome/coral.fa
kat sect -t 10 -E -F -o $OUTDIR/sect_shortreads ../../genome/coral.fa $FQ1 $FQ2
kat sect -t 10 -E -F -o $OUTDIR/sect_genome ../../genome/coral.fa ../../genome/coral.fa
rm ../../genome/coral.fa

# FOR SHORTREADS
# kmer coverage by position into a bed file
	# kmer coverage contig lengths are contig_length - kmer_length + 1
		# must adjust accordingly
paste \
<(bedtools makewindows -g <(cat $FAI | awk '{OFS="\t"}{d=$2-26}{print $1,d}') -w 1 -s 1) \
<(grep -v "^>" $OUTDIR/sect_shortreads-counts.cvg | tr " " "\n") | \
bgzip >$OUTDIR/sect_shortreads-counts.bed.gz

# summarize kmer coverage in 1kb windows. median is maybe most useful?
bedtools map \
-a ../../results/short_reads/coverage_stats/coral_1kb.bed \
-b <(zcat $OUTDIR/sect_shortreads-counts.bed.gz) \
-c 4 \
-o count,mean,median,max \
-g ../../genome/GCF_011125445.2_MU-UCD_Fhet_4.1_genomic.fna.fai | \
bgzip >$OUTDIR/sect_shortreads-counts-1kbwin.bed.gz

# index the window file
tabix -p bed $OUTDIR/sect_shortreads-counts-1kbwin.bed.gz


# FOR GENOME
# kmer coverage by position into a bed file
	# kmer coverage contig lengths are contig_length - kmer_length + 1
		# must adjust accordingly
paste \
<(bedtools makewindows -g <(cat $FAI | awk '{OFS="\t"}{d=$2-26}{print $1,d}') -w 1 -s 1) \
<(grep -v "^>" $OUTDIR/sect_genome-counts.cvg | tr " " "\n") | \
bgzip >$OUTDIR/sect_genome-counts.bed.gz

# summarize kmer coverage in 1kb windows. median is maybe most useful?
bedtools map \
-a ../../results/short_reads/coverage_stats/coral_1kb.bed \
-b <(zcat $OUTDIR/sect_genome-counts.bed.gz) \
-c 4 \
-o count,mean,median,max \
-g ../../genome/GCF_011125445.2_MU-UCD_Fhet_4.1_genomic.fna.fai | \
bgzip >$OUTDIR/sect_genome-counts-1kbwin.bed.gz

# index the window file
tabix -p bed $OUTDIR/sect_genome-counts-1kbwin.bed.gz

