#!/bin/bash

set -e
set -x

#
# test and compress data generated from DWGSIM
#
# Syntax
#   ./test_dwgsim_and_uncompress.sh <folder_name_to_save_this_generated_data> <ref_genome_sequces>
#
# Usage Case
#   $ test_dwgsim_and_uncompress.sh test_2024111502 sequences.3_samples.fasta
#   + TESTDATADIR=test_2024111502
#   + mkdir -p test_2024111502
#   + dwgsim -N 10 sequences.3_samples.fasta test_2024111502/sequences.3_samples.fasta.test
#   [dwgsim_core] NC_054003.1 length: 28170
#   [dwgsim_core] NC_054004.1 length: 28169
#   [dwgsim_core] NC_054015.1 length: 27636
#   [dwgsim_core] 3 sequences, total length: 83975
#   [dwgsim_core] Currently on:
#   [dwgsim_core] 10
#   [dwgsim_core] Complete!
#   + set +x
#   /mnt/d/Data/ViBE_fine_tune_family_and_genra_data/test_2024111502 /mnt/d/Data/ViBE_fine_tune_family_and_genra_data
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
#         6 NC_054003.1
#         4 NC_054004.1
#         8 NC_054015.1
#         2 rand
#
#   /mnt/d/Data/ViBE_fine_tune_family_and_genra_data
#  
# Output
#   $ ls -lat /mnt/d/Data/ViBE_fine_tune_family_and_genra_data/test_2024111403/
#   total 13
#   drwxrwxrwx 1 ycho ycho  512 Nov 14 22:42 .
#   -rwxrwxrwx 1 ycho ycho 1825 Nov 14 22:42 example.test.bwa.read2.fastq
#   -rwxrwxrwx 1 ycho ycho 1825 Nov 14 22:42 example.test.bwa.read1.fastq
#   -rwxrwxrwx 1 ycho ycho 3610 Nov 14 22:42 example.test.bfast.fastq
#   -rwxrwxrwx 1 ycho ycho  594 Nov 14 22:42 example.test.mutations.vcf
#   -rwxrwxrwx 1 ycho ycho   61 Nov 14 22:42 example.test.mutations.txt
#   drwxrwxrwx 1 ycho ycho  512 Nov 14 22:34 ..
#  

TESTDATADIR=${1};

mkdir -p ${TESTDATADIR}
#mkdir tmp

# Generate the new test data
#dwgsim -z 13 -N 10 ${2} ${TESTDATADIR}/example.test	# testing case
dwgsim -N 10 ${2} ${TESTDATADIR}/${2}.test	    	# simple case


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
grep -r "^@" ${2}.test.bwa.read1.fastq | wc -l
perl -e 'print "Negative reads generated: "'
grep -r "^@" ${2}.test.bwa.read1.fastq | wc -l
perl -e 'print "Total reads generated: "'
grep -r "^@" ${2}.test.bfast.fastq | wc -l
echo
perl -e 'print "Checking read number from each genome in reference fasta file: \n"'
perl -e 'print "----------------------------\n"'
perl -ne 'print "$1\n" if /^@(\w+?\.\d|rand)/' ${2}.test.bfast.fastq | sort | uniq -c
echo
popd

# Clean up the testdata
#find ${TESTDATADIR} \! -name "*gz" -type f | grep -v sh$ | xargs rm; 
find ${TESTDATADIR} -name "*gz" -type f | grep -v sh$ | xargs rm; 

#rm -r tmp
