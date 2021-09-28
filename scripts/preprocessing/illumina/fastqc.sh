#!/bin/bash
#SBATCH --job-name=fastqc.sh
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 5
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=50G
#SBATCH --mail-user=michelle.neitzey@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

forward=/core/projects/EBP/Oneill/reads/illumina/coral/primnoidae_646m/WGS_2021Apr08/Coral-WGS_S14_L002_R1_001.fastq.gz
reverse=/core/projects/EBP/Oneill/reads/illumina/coral/primnoidae_646m/WGS_2021Apr08/Coral-WGS_S14_L002_R2_001.fastq.gz

##########################################################
## FASTQC Raw Reads                                     ##
##########################################################

module load fastqc/0.11.7

fastqc -o . $forward $reverse
