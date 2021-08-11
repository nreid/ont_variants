# Variant calling tests for ONT data

## Data
### Reference genome


### ONT data
fast5
fastq

ont, fast base calls  
- `/archive/projects/EBP/roneill/reads/nanopore/minion/coral_minion/03Oct2019_Coral_MIN106_FAK10514_LSK109/fastq_pass/coral_combined_m1p1-4.fq`  

ont, accurate base calls 
TBD

illumina adapter, length & quality trimmed and contamination removed
- `/projects/EBP/Oneill/reads/illumina/coral/coral/primnoidae_646m/genome_size_estimation/04_contamination/unclassified_1_and9606.fastq`
- `/projects/EBP/Oneill/reads/illumina/coral/coral/primnoidae_646m/genome_size_estimation/04_contamination/unclassified_2_and9606.fastq`

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

