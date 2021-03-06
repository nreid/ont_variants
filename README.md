# Variant calling tests for ONT data

## Data
### Reference genome
- `/projects/EBP/Oneill/coral/primnoidae_646m/genome_assembly/m1p1-4_rmcontam/flye/750m_icov40/medaka/purge_haplotigs/purge_duplicates/curated/seqs/curated.purged.fa`

### ONT data
fast5
fastq

ont, fast base calls  
- FASTQ (includes all) `/archive/projects/EBP/roneill/reads/nanopore/minion/coral_minion/03Oct2019_Coral_MIN106_FAK10514_LSK109/fastq_pass/coral_combined_m1p1-4.fq`  
- FASTA (used for genome assembly, 2kb filter and contamination removed) `/projects/EBP/Oneill/coral/primnoidae_646m/refine_reads/combined_ont_reads/centrifuge/coral_combined_m1p1-4_2kbfilt_rmcontam.fasta`  

ont, accurate base calls  
TBD  

illumina adapter, length & quality trimmed and contamination removed
- `/projects/EBP/Oneill/coral/primnoidae_646m/genome_size_estimation/04_contamination/unclassified_1_and9606.fastq`
- `/projects/EBP/Oneill/coral/primnoidae_646m/genome_size_estimation/04_contamination/unclassified_2_and9606.fastq`

### Illumina data


## Analysis

Three data sets
- ont, fast base calls
- ont, accurate base calls
- illumina

Four variant callers
- medaka (ont)
- pepper-margin-deepvariant (ont)
- GATK (illumina)
- freebayes (illumina)

