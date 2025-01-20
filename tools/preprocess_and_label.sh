#!/bin/bash 
set -x
set -e

TAXON_NAME=${1}
TAXON_SUB_DIR_QFN=${2}
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

conda run -n vibe --live-stream python $SCRIPTPATH/../scripts/seq2kmer_doc.py \
	-i $TAXON_SUB_DIR_QFN/*_genomes.fasta.test.bwa.read1.fastq \
	-p $TAXON_SUB_DIR_QFN/*_genomes.fasta.test.bwa.read2.fastq \
	-o $TAXON_SUB_DIR_QFN/data.$TAXON_NAME.paired.csv \
	-k 4 \
	-f fastq \
	--min-length 150 \
	--max-length 251

cat $TAXON_SUB_DIR_QFN/data.$TAXON_NAME.paired.csv \
	| perl -pe "if (! /^forward,backward,seqid/) {s/\n/,$TAXON_NAME\n/} else {s/\n/,label\n/}" \
	> $TAXON_SUB_DIR_QFN/data.$TAXON_NAME.paired.label.csv

head -2 $TAXON_SUB_DIR_QFN/data.$TAXON_NAME.paired.label.csv
