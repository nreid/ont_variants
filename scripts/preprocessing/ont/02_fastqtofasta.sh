#!/bin/bash
#SBATCH --job-name=fastqtofasta.sh
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=50G
#SBATCH --partition=general
#SBATCH --qos=general
##SBATCH --mail-type=END
##SBATCH --mail-user=michelle.neitzey@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

module load python/3.8.1

python fastqtofasta.py Riftia_p1-3_combined.fastq Riftia_p1-3_combined.fasta

#python fastqtofasta.py Riftia_p1_combined.fastq Riftia_p1_combined.fasta

