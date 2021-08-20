#!/bin/bash
#SBATCH --job-name=coral_reads_filter2kb
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mem=100G
#SBATCH --mail-user=michelle.neitzey@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.er

awk '!/^>/ { next } { getline seq } length(seq) >= 2000 { print $0 "\n" seq }' coral_combined_edit.fasta > coral_combined_limit2kb.fasta
