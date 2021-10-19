#!/bin/bash 
#SBATCH --job-name=concat_pepper
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=5G
#SBATCH --qos=general
#SBATCH --partition=xeon
#SBATCH --mail-user=
#SBATCH --mail-type=END
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# load software
module load vcflib/1.0.0-rc1
module load htslib/htslib/1.12


# input/output, necessary directories
OUTFILE=../../results/longreads/pepper_deepvariant/pepper.vcf.gz

FAI=../../genome/coral.fasta.fai
BASE=../../results/longreads/pepper_deepvariant/scaffolds/

# concatenate scaffold vcf files
(for FILE in $(cut -f 1 $FAI)
do
	if test -f "${BASE}/${FILE}/${FILE}.vcf.gz"; then
	    echo "$FILE exists." >&2
	    zcat ${BASE}/${FILE}/${FILE}.vcf.gz
	else
		echo "$FILE DOES NOT EXIST"	>&2
	fi
done) | \
vcffirstheader | \
bgzip >$OUTFILE

tabix -p vcf $OUTFILE