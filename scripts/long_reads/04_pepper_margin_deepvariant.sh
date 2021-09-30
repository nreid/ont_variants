#!/bin/bash 
#SBATCH --job-name=pepper
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 20
#SBATCH --mem=180G
#SBATCH --qos=general
#SBATCH --partition=xeon
#SBATCH --mail-user=
#SBATCH --mail-type=END
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

module load singularity/3.7.1
module load vcflib/1.0.0-rc1 
module load parallel/20180122

# Set the number of CPUs to use
THREADS="1"

# input/output files, directories
OUTDIR=../../results/longreads/pepper_deepvariant
mkdir -p $OUTDIR

SCAFDIR=../../results/longreads/pepper_deepvariant/scaffolds
mkdir -p $OUTDIR

export TMPDIR=/scratch/$USER
export SINGULARITY_TMPDIR=/scratch/$USER
mkdir -p $TMPDIR

BAM=../../results/longreads/alignment/coral_fq.bam
GENOME=../../genome/coral.fasta
FAI=../../genome/coral.fasta.fai


# Pull the docker images
singularity pull --dir $OUTDIR docker://jmcdani20/hap.py:v0.3.12
singularity pull --dir $OUTDIR docker://kishwars/pepper_deepvariant:r0.5


# command for PEPPER-Margin-DeepVariant
command=$(echo singularity exec --bind /usr/lib/locale/ --bind $(pwd) \
$OUTDIR/pepper_deepvariant_r0.5.sif \
run_pepper_margin_deepvariant call_variant \
-b $BAM \
-f $GENOME \
-o $SCAFDIR \
-t $THREADS \
--ont)


# run pepper on each scaffold separately
cut -f 1 $FAI | parallel -k -j 10 "mkdir $SCAFDIR/{}; $command -r {} -p {}"
