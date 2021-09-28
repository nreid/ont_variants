#!/bin/bash
#SBATCH --job-name=getdata
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 10
#SBATCH --mem=5G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


hostname
date

# load software

module load bwa/0.7.17	
module load samtools/1.10


# symlink and index the genome

GENOMEDIR=../genome
mkdir -p $GENOMEDIR

GENOME=/core/projects/EBP/Oneill/coral/primnoidae_646m/genome_assembly/m1p1-4_rmcontam/flye/750m_icov40/medaka/purge_haplotigs/purge_duplicates/curated/seqs/curated.purged.fa

cp $GENOME $GENOMEDIR/coral.fasta

# index the genome using bwa
bwa index \
-p $GENOMEDIR/coral \
$GENOMEDIR/coral.fasta

# index the genome using samtools
samtools faidx $GENOMEDIR/coral.fasta


# symlink the illumina data

SHORTDIR=../data/shortreads
mkdir -p $SHORTDIR

R1=/core/projects/EBP/Oneill/coral/primnoidae_646m/genome_size_estimation/04_contamination/unclassified_1_and9606.fastq
R2=/core/projects/EBP/Oneill/coral/primnoidae_646m/genome_size_estimation/04_contamination/unclassified_2_and9606.fastq

ln -s $R1 $SHORTDIR/r1.fastq
ln -s $R2 $SHORTDIR/r2.fastq


# symlink the ONT fasta/q data

LONGDIR=../data/longreads
mkdir -p $LONGDIR

# fast base-called data, fasta
FA=/core/projects/EBP/Oneill/coral/primnoidae_646m/refine_reads/combined_ont_reads/centrifuge/coral_combined_m1p1-4_2kbfilt_rmcontam.fasta

ln -s $FA $LONGDIR/fast_called.fasta

# fast base-called data, fastq. copied because it lives in archive currently.
FQ=/archive/projects/EBP/roneill/reads/nanopore/minion/coral_minion/03Oct2019_Coral_MIN106_FAK10514_LSK109/fastq_pass/coral_combined_m1p1-4.fq

cp $FQ $LONGDIR/

# re-base-called data
#TBD
