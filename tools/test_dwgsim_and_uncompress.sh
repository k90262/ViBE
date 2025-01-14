#!/bin/bash

set -e
set -x

#
# uncompress and test data generated from DWGSIM
#
# Syntax
#   ./test_dwgsim_and_uncompress.sh <ouput_folder_name> <ref_genome_sequces_fasta_file_path> [number_of_read_pairs] [error_rates] [given_a_string_as_purpose_prefix]
#
# Version
#   2024121700
#
# Usage Case 1
#   $ test_dwgsim_and_uncompress.sh test_2024112104_err_rate family_level_training_genomes_sample_3.fasta 10 0.015 dev
#
#   Output 1
#     + TESTDATADIR=test_2024112104_err_rate
#     + GIVEN_GENOME_AS_REF=family_level_training_genomes_sample_3.fasta
#     + NUM_OF_READ_PAIRS=10
#     + ERROR_RATES=0.015
#     + PURPOSE_STR=dev
#     + OUTPUT_PREFIX=family_level_training_genomes_sample_3.fasta.dev
#     + mkdir -p test_2024112104_err_rate
#     + dwgsim -N 10 -e 0.015 -E 0.015 -d 500 -s 50 -r 0.0 -y 0 family_level_training_genomes_sample_3.fasta test_2024112104_err_rate/family_level_training_genomes_sample_3.fasta.dev
#     [dwgsim_core] NC_003092.2 length: 15717
#     [dwgsim_core] NC_003436.1 length: 28033
#     [dwgsim_core] NC_001639.1 length: 14104
#     [dwgsim_core] 3 sequences, total length: 57854
#     [dwgsim_core] Currently on:
#     [dwgsim_core] 10
#     [dwgsim_core] Complete!
#     + set +x
#     /mnt/d/Data/ViBE_fine_tune_family_and_genra_data/test_2024112104_err_rate /mnt/d/Data/ViBE_fine_tune_family_and_genra_data
#     
#     Validation
#     
#     Paired-end reads generated:
#     ----------------------------
#     Positive reads generated: 10
#     Negative reads generated: 10
#     Total reads generated: 20
#     
#     Checking total read number (positive + negative) from each genome in reference fasta file:
#     ----------------------------
#           4 NC_001639.1
#           6 NC_003092.2
#          10 NC_003436.1
#     
#   Result 1
#     $ ls -lat test_2024112104_err_rate/
#     total 24
#     -rwxrwxrwx 1 ycho ycho 1924 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bwa.read2.fastq
#     -rwxrwxrwx 1 ycho ycho 1924 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bwa.read1.fastq
#     -rwxrwxrwx 1 ycho ycho 3808 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bfast.fastq
#     -rwxrwxrwx 1 ycho ycho  451 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.mutations.vcf
#     -rwxrwxrwx 1 ycho ycho  846 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bwa.read2.fastq.gz
#     -rwxrwxrwx 1 ycho ycho  842 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bwa.read1.fastq.gz
#     -rwxrwxrwx 1 ycho ycho 1481 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.bfast.fastq.gz
#     -rwxrwxrwx 1 ycho ycho    0 Nov 21 21:17 family_level_training_genomes_sample_3.fasta.dev.mutations.txt
#     drwxrwxrwx 1 ycho ycho  512 Nov 21 21:12 .
#     drwxrwxrwx 1 ycho ycho  512 Nov 21 21:06 ..
#  
# Usage Case 2
#  $ test_dwgsim_and_uncompress.sh test_20241213_max_out_number_shorter_2 ex1_shorter_2.fa
#
#   Output 2
#    + TESTDATADIR=test_20241213_max_out_number_shorter_2
#    + GIVEN_GENOME_AS_REF=ex1_shorter_2.fa
#    + NUM_OF_READ_PAIRS=-1
#    + ERROR_RATES=0.0
#    + PURPOSE_STR=test
#    + OPTION_OF_NUM_OF_READ_PAIRS='-N -1'
#    + '[' -1 == -1 ']'
#    + OPTION_OF_NUM_OF_READ_PAIRS=
#    + OUTPUT_PREFIX=ex1_shorter_2.fa.test
#    + mkdir -p test_20241213_max_out_number_shorter_2
#    + dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ex1_shorter_2.fa test_20241213_max_out_number_shorter_2/ex1_shorter_2.fa.test
#    [dwgsim_core] seq1 length: 900
#    [dwgsim_core] 1 sequences, total length: 900
#    [dwgsim_core] Currently on:
#    [dwgsim_core] 179
#    [dwgsim_core] Complete!
#    + set +x
#    /mnt/d/Data/ViBE_fine_tune_family_and_genra_data/test_20241213_max_out_number_shorter_2 /mnt/d/Data/ViBE_fine_tune_family_and_genra_data
#    
#    Validation
#    
#    Paired-end reads generated:
#    ----------------------------
#    Positive reads generated: 179
#    Negative reads generated: 179
#    Total reads generated: 358
#    
#    Checking total read number (positive + negative) from each genome in reference fasta file:
#    ----------------------------
#        358 seq1
#    
#    /mnt/d/Data/ViBE_fine_tune_family_and_genra_data
#     
#    Result 2
#     $ ls -lat test_20241213_max_out_number_shorter_2
#     total 444
#     -rwxrwxrwx 1 ycho ycho  97495 Dec 13 21:45 ex1_shorter_2.fa.test.bwa.read2.fastq
#     -rwxrwxrwx 1 ycho ycho  97495 Dec 13 21:45 ex1_shorter_2.fa.test.bwa.read1.fastq
#     -rwxrwxrwx 1 ycho ycho 194274 Dec 13 21:45 ex1_shorter_2.fa.test.bfast.fastq
#     -rwxrwxrwx 1 ycho ycho    364 Dec 13 21:45 ex1_shorter_2.fa.test.mutations.vcf
#     -rwxrwxrwx 1 ycho ycho  14146 Dec 13 21:45 ex1_shorter_2.fa.test.bwa.read2.fastq.gz
#     -rwxrwxrwx 1 ycho ycho  14205 Dec 13 21:45 ex1_shorter_2.fa.test.bwa.read1.fastq.gz
#     -rwxrwxrwx 1 ycho ycho  25954 Dec 13 21:45 ex1_shorter_2.fa.test.bfast.fastq.gz
#     -rwxrwxrwx 1 ycho ycho      0 Dec 13 21:45 ex1_shorter_2.fa.test.mutations.txt
#     drwxrwxrwx 1 ycho ycho    512 Dec 13 21:39 ..
#     drwxrwxrwx 1 ycho ycho    512 Dec 13 21:23 .

TESTDATADIR=${1};
GIVEN_GENOME_AS_REF=${2}
NUM_OF_READ_PAIRS=${3:--1}
ERROR_RATES=${4:-0.0}
PURPOSE_STR=${5:-test}

OPTION_OF_NUM_OF_READ_PAIRS="-N ${NUM_OF_READ_PAIRS}"
if [ $NUM_OF_READ_PAIRS == -1 ]; then
  OPTION_OF_NUM_OF_READ_PAIRS=""
fi

OUTPUT_PREFIX=${GIVEN_GENOME_AS_REF##*/}.${PURPOSE_STR}
mkdir -p ${TESTDATADIR}
#mkdir tmp

# Generate the new test data
#dwgsim -z 13 -N 10 ${2} ${TESTDATADIR}/example.test	# testing case
#dwgsim -N 10 ${2} ${TESTDATADIR}/${2}.test	    	# simple case
dwgsim ${OPTION_OF_NUM_OF_READ_PAIRS} \
	-e ${ERROR_RATES} -E ${ERROR_RATES} \
	-d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 \
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
perl -e 'print "Checking total read number (positive + negative) from each genome in reference fasta file: \n"'
perl -e 'print "----------------------------\n"'
perl -ne 'print "$1\n" if /^@(\w+?\.\d|rand|seq\d)_/' ${OUTPUT_PREFIX}.bfast.fastq \
	| sort \
	| uniq -c
echo
popd

# Clean up the testdata
#find ${TESTDATADIR} \! -name "*gz" -type f | grep -v sh$ | xargs rm; 
#find ${TESTDATADIR} -name "*gz" -type f | grep -v sh$ | xargs rm; 

#rm -r tmp
