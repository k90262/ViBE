#!/bin/bash

set -e
set -x

#
# test and compress data generated from DWGSIM
#
# Syntax
#   ./test_dwgsim_and_uncompress.sh <folder_name_to_save_this_generated_data> <ref_genome_sequces> [number_of_read_pairs] [error_rates] [purpose prefix]
#
# Usage Case
#   $ test_dwgsim_and_uncompress.sh test_2024112104_err_rate family_level_training_genomes_sample_3.fasta 10 0.015 dev
#   + TESTDATADIR=test_2024112104_err_rate
#   + GIVEN_GENOME_AS_REF=family_level_training_genomes_sample_3.fasta
#   + NUM_OF_READ_PAIRS=10
#   + ERROR_RATES=0.015
#   + PURPOSE_STR=dev
#   + OUTPUT_PREFIX=family_level_training_genomes_sample_3.fasta.dev
#   + mkdir -p test_2024112104_err_rate
#   + dwgsim -N 10 -e 0.015 -E 0.015 -d 500 -s 50 -r 0.0 -y 0 family_level_training_genomes_sample_3.fasta test_2024112104_err_rate/family_level_training_genomes_sample_3.fasta.dev
#   [dwgsim_core] NC_003092.2 length: 15717
#   [dwgsim_core] NC_003436.1 length: 28033
#   [dwgsim_core] NC_001639.1 length: 14104
#   [dwgsim_core] 3 sequences, total length: 57854
#   [dwgsim_core] Currently on:
#   [dwgsim_core] 10
#   [dwgsim_core] Complete!
#   + set +x
#   /mnt/d/Data/ViBE_fine_tune_family_and_genra_data/test_2024112104_err_rate /mnt/d/Data/ViBE_fine_tune_family_and_genra_data
#   
#   Validation
#   
#   Paired-end reads generated:
#   ----------------------------
#   Positive reads generated: 10
#   Negative reads generated: 10
#   Total reads generated: 20
#   
#   Checking read number from each genome in reference fasta file:
#   ----------------------------
#         4 NC_001639.1
#         6 NC_003092.2
#        10 NC_003436.1
#   
# Output
#   $ ls -lat test_2024112104_err_rate/
#   total 24
#   -rwxrwxrwx 1 ycho ycho 1924 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bwa.read2.fastq
#   -rwxrwxrwx 1 ycho ycho 1924 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bwa.read1.fastq
#   -rwxrwxrwx 1 ycho ycho 3808 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bfast.fastq
#   -rwxrwxrwx 1 ycho ycho  451 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.mutations.vcf
#   -rwxrwxrwx 1 ycho ycho  846 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bwa.read2.fastq.gz
#   -rwxrwxrwx 1 ycho ycho  842 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bwa.read1.fastq.gz
#   -rwxrwxrwx 1 ycho ycho 1481 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bfast.fastq.gz
#   -rwxrwxrwx 1 ycho ycho    0 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.mutations.txt
#   drwxrwxrwx 1 ycho ycho  512 Nov 21 21:12 .
#   drwxrwxrwx 1 ycho ycho  512 Nov 21 21:06 ..

TESTDATADIR=${1};
GIVEN_GENOME_AS_REF=${2}
NUM_OF_READ_PAIRS=${3:-10}
ERROR_RATES=${4:-0.0}
PURPOSE_STR=${5:-test}

OUTPUT_PREFIX=${GIVEN_GENOME_AS_REF}.${PURPOSE_STR}
mkdir -p ${TESTDATADIR}
#mkdir tmp

# Generate the new test data
#dwgsim -z 13 -N 10 ${2} ${TESTDATADIR}/example.test	# testing case
#dwgsim -N 10 ${2} ${TESTDATADIR}/${2}.test	    	# simple case
dwgsim  -N ${NUM_OF_READ_PAIRS} \
	-e ${ERROR_RATES} -E ${ERROR_RATES} \
	-d 500 -s 50 -r 0.0 -y 0 \
	${GIVEN_GENOME_AS_REF} ${TESTDATADIR}/${OUTPUT_PREFIX}


set +x
# Decompress the test data
pushd $TESTDATADIR;
for FILE in $(ls -1 *gz)
do 
	gunzip -c ${FILE} > $(basename ${FILE} .gz);
done
echo
echo "Validation"
echo
perl -e 'print "Paired-end reads generated: \n"'
perl -e 'print "----------------------------\n"'
perl -e 'print "Positive reads generated: "'
grep -r "^@" ${OUTPUT_PREFIX}.bwa.read1.fastq | wc -l
perl -e 'print "Negative reads generated: "'
grep -r "^@" ${OUTPUT_PREFIX}.bwa.read1.fastq | wc -l
perl -e 'print "Total reads generated: "'
grep -r "^@" ${OUTPUT_PREFIX}.bfast.fastq | wc -l
echo
perl -e 'print "Checking read number from each genome in reference fasta file: \n"'
perl -e 'print "----------------------------\n"'
perl -ne 'print "$1\n" if /^@(\w+?\.\d|rand)/' ${OUTPUT_PREFIX}.bfast.fastq \
	| sort \
	| uniq -c
echo
popd

# Clean up the testdata
#find ${TESTDATADIR} \! -name "*gz" -type f | grep -v sh$ | xargs rm; 
#find ${TESTDATADIR} -name "*gz" -type f | grep -v sh$ | xargs rm; 

#rm -r tmp
