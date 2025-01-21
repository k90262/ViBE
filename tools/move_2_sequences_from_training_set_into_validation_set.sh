#!/bin/bash
set -x
set -e

TAXON_NAME=${1}

tail -2 $TAXON_NAME/training_reads/data.$TAXON_NAME.paired.label.csv >> $TAXON_NAME/validation_reads/data.$TAXON_NAME.paired.label.csv
head -n -2 $TAXON_NAME/training_reads/data.$TAXON_NAME.paired.label.csv > tmp_file && mv tmp_file $TAXON_NAME/training_reads/data.$TAXON_NAME.paired.label.csv
ls -l $TAXON_NAME/*/*.paired.label.csv
