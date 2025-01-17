#!/bin/bash
set -x
set -e

TAXON_NAME=${1}
TAXON_DIR_QFN=${2}

grep 'Genome-level Validation Set' marked_genomes.csv | grep $TAXON_NAME | perl -a -F'/,|>/' -e 'print @F[1]. $/;' > $TAXON_DIR_QFN/genome_level_validation_ids.txt

pushd $TAXON_DIR_QFN;
faSomeRecords ncbi_dataset/data/genomic.fna genome_level_validation_ids.txt genome_level_validation_genomes.fasta
faSomeRecords -exclude ncbi_dataset/data/genomic.fna genome_level_validation_ids.txt read_level_genomes.fasta
popd
