#!/bin/bash
#SBATCH --job-name=edit.sh
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=END
#SBATCH --mem=10G
#SBATCH --mail-user=michelle.neitzey@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

awk '/^>/ { print (NR==1 ? "" : RS) $0; next } { printf "%s", $0 } END { printf RS }' /projects/EBP/Oneill/reads/nanopore/promethion/DOG/2021Jan11_ROneill_DOG_Worms/2021Jan11_ROneill_DOG_Riftia_PAG06574/20210111_2218_1C_PAG06574_ab860f71/fastq_pass/Riftia_p1_combined.fasta > Riftia_p1_combined_edit.fasta
