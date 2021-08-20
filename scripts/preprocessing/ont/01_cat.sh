#!/bin/bash
#SBATCH --job-name=cat.sh
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=10G
#SBATCH --partition=general
#SBATCH --qos=general
##SBATCH --mail-type=END
##SBATCH --mail-user=michelle.neitzey@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

cat PAG01892_pass_90cf20ef_* >> Riftia_p2_combined.fastq

