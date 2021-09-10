#!/bin/bash 
#SBATCH --job-name=pepper
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=125G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=END
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

module load singularity/3.7.1

# Set the number of CPUs to use
THREADS="1"

# input/output files, directories
OUTDIR=$(pwd)/../../results/longreads/pepper_deepvariant
mkdir -p $OUTDIR

export TMPDIR=/scratch/$USER
export SINGULARITY_TMPDIR=/scratch/$USER
mkdir -p $TMPDIR

BAM=../../results/longreads/pepper_deepvariant/alignment/coral_fq.bam
GENOME=../../genome/coral.fasta

OUTPRE=coral_test
VCF=coral_test.vcf.gz

# Pull the docker images
singularity pull --dir $OUTDIR docker://jmcdani20/hap.py:v0.3.12
singularity pull --dir $OUTDIR docker://kishwars/pepper_deepvariant:r0.5

# Run PEPPER-Margin-DeepVariant
singularity exec --bind /usr/lib/locale/ \
$OUTDIR/pepper_deepvariant_r0.5.sif \
run_pepper_margin_deepvariant call_variant \
-b $BAM \
-f $GENOME \
-o $OUTDIR \
-p $OUTPRE \
-t $THREADS \
--ont

