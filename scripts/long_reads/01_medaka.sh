#!/bin/bash
#SBATCH --job-name=medaka
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 12
#SBATCH --partition=xeon
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mem=60G
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date


# load software

module load medaka/1.4.3

# input/output files, directories
NPROC=$(nproc)
FASTA=../../data/longreads/fast_called.fasta
DRAFT=../../genome/coral.fasta

OUTROOT=../../results/longreads
mkdir -p $OUTROOT

OUTDIR=$OUTROOT/medaka

# run medaka
	# guppy 3.2.6
MODEL=r941_prom_high_g303
medaka_consensus -i ${FASTA} -d ${DRAFT} -o ${OUTDIR} -t ${NPROC} -m ${MODEL}