#!/bin/bash
#SBATCH --job-name=sickle.sh
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=100G
#SBATCH --mail-user=michelle.neitzey@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


hostname
date


# set variables
#forwardInput=/projects/EBP/Oneill/reads/illumina/coral/coral/primnoidae_646m/genome_size_estimation/02_trim_adapter/cutadapt_output/Coral-WGS_S14_L002_R1_001_adapt.fastq.gz
#reverseInput=/projects/EBP/Oneill/reads/illumina/coral/coral/primnoidae_646m/genome_size_estimation/02_trim_adapter/cutadapt_output/Coral-WGS_S14_L002_R2_001_adapt.fastq.gz
forwardOutput=sickle_output/Coral-WGS_S14_L002_R1_001_adapt_sickle.fastq
reverseOutput=sickle_output/Coral-WGS_S14_L002_R2_001_adapt_sickle.fastq
singlesOutput=sickle_output/Coral-WGS_S14_L002_singles_adapt_sickle.fastq
fastqcOutput=sickle_output/qc


#################################################################
# Trim quality and length with sickle
#################################################################

#module load sickle/1.33


#sickle pe -f $forwardInput -r $reverseInput -t sanger \
#-o $forwardOutput -p $reverseOutput \
#-s $singlesOutput -q 30 -l 45


#################################################################
# FastQC quality and length trimmed reads
#################################################################

module load fastqc/0.11.7


fastqc -o $fastqcOutput $forwardOutput $reverseOutput $singlesOutput
