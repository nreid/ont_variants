#!/bin/bash
#SBATCH --job-name=cutadapt.sh
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=50G
#SBATCH --mail-user=michelle.neitzey@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


hostname
date


# set variables
adapter=CTGTCTCTTATACACATCT
forwardInput=/projects/EBP/Oneill/reads/illumina/coral/primnoidae_646m/WGS_2021Apr08/Coral-WGS_S14_L002_R1_001.fastq.gz
reverseInput=/projects/EBP/Oneill/reads/illumina/coral/primnoidae_646m/WGS_2021Apr08/Coral-WGS_S14_L002_R2_001.fastq.gz
forwardOutput=cutadapt_output/Coral-WGS_S14_L002_R1_001_adapt.fastq.gz
reverseOutput=cutadapt_output/Coral-WGS_S14_L002_R2_001_adapt.fastq.gz
fastqcOutput=cutadapt_output/qc


#################################################################
# Trim adapter
#################################################################

# Illumina Stranded mRNA adapter based on https://support.illumina.com/bulletins/2016/12/what-sequences-do-i-use-for-adapter-trimming.html
# Added A to beginning of adapter, per recommendations of previous cutadapt run

module load cutadapt/2.7
module load pigz/2.2.3


# forward
cutadapt -j 4 -a $adapter -o $forwardOutput $forwardInput

# reverse
cutadapt -j 4 -a $adapter -o $reverseOutput $reverseInput


#################################################################
# FastQC adapter-trimmed reads
#################################################################

module load fastqc/0.11.7


fastqc -o $fastqcOutput $forwardOutput $reverseOutput
