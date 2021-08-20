#!/bin/bash
#SBATCH --job-name=Nanoplot_coral_combined
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mem=50G
#SBATCH --mail-user=michelle.neitzey@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -o %x_%j.err

module load NanoPlot/1.21.0

NanoPlot --fasta coral_combined.fasta \
    -o Nanoplot_coral_combined \
    -p Nanoplot_coral_combined \
    -t 8 \

