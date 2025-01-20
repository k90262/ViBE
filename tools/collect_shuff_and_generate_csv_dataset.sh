#!/bin/bash
set -x
set -e

#
# Usage: collect_shuff_and_generate_csv_dataset.sh
#

declare -a PREPROCESS_SUBFOLDER_NAMES=("training_reads" "validation_reads" "validation_reads_read_level")

for PREPROCESS_SUBFOLDER_NAME in "${PREPROCESS_SUBFOLDER_NAMES[@]}"
do
  # Collection
  head -q -n 1 */$PREPROCESS_SUBFOLDER_NAME/*.paired.label.csv | head -1 > $PREPROCESS_SUBFOLDER_NAME.dataset.header.csv
  tail -q -n +2 */$PREPROCESS_SUBFOLDER_NAME/*.paired.label.csv > $PREPROCESS_SUBFOLDER_NAME.dataset.body.csv	# https://stackoverflow.com/questions/339483/how-can-i-remove-the-first-line-of-a-text-file-using-bash-sed-script
  
  # Shuffle
  shuf $PREPROCESS_SUBFOLDER_NAME.dataset.body.csv > $PREPROCESS_SUBFOLDER_NAME.dataset.body.shuff.csv
  
  # Generate CSV
  cat $PREPROCESS_SUBFOLDER_NAME.dataset.header.csv $PREPROCESS_SUBFOLDER_NAME.dataset.body.shuff.csv > $PREPROCESS_SUBFOLDER_NAME.dataset.csv
done

# Validate
head -2 *.dataset.csv
