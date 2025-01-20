#!/bin/bash
set -x
set -e

#
# NAME
#  download_genomes_via_taxon_name.sh - download genome via NCBI CLI
#
# SYNOPSIS
#  download_genomes_via_taxon_name.sh <taxon_name>
#
# Usage Case:
#  $ download_genomes_via_taxon_name.sh Tobaniviridae
#  + set -e
#  + TAXON_NAME=Tobaniviridae
#  + datasets download virus genome taxon Tobaniviridae --refseq
#  Downloading: ncbi_dataset.zip    242kB valid data package
#  Validating package files [================================================] 100% 6/6
#  + unzip ncbi_dataset.zip
#  Archive:  ncbi_dataset.zip
#    inflating: README.md
#    inflating: ncbi_dataset/data/data_report.jsonl
#    inflating: ncbi_dataset/data/genomic.fna
#    inflating: ncbi_dataset/data/virus_dataset.md
#    inflating: ncbi_dataset/data/dataset_catalog.json
#    inflating: md5sum.txt
#

TAXON_NAME=${1} 

datasets download virus genome taxon $TAXON_NAME --refseq
unzip ncbi_dataset.zip
