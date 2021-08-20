#!/bin/bash
#SBATCH --job-name=kraken.sh
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=200G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=michelle.neitzey@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date


forwardInput=/projects/EBP/Oneill/reads/illumina/coral/coral/primnoidae_646m/genome_size_estimation/03_quality_trim/sickle_output/Coral-WGS_S14_L002_R1_001_adapt_sickle.fastq
reverseInput=/projects/EBP/Oneill/reads/illumina/coral/coral/primnoidae_646m/genome_size_estimation/03_quality_trim/sickle_output/Coral-WGS_S14_L002_R2_001_adapt_sickle.fastq


#################################################################
# Identify contamination
#################################################################

module load kraken/2.0.8-beta
module load jellyfish/2.2.6

kraken2 -db /isg/shared/databases/kraken2/Standard \
        --paired $forwardInput $reverseInput \
        --use-names \
        --threads 16 \
        --output kraken_general.out \
        --unclassified-out unclassified#.fastq \
        --classified-out classified#.fastq      \
        --report kraken_report.txt \
        --use-mpa-style

date
