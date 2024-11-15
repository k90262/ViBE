#!/bin/bash

set -e
set -x

#
# test and compress data generated from DWGSIM
#
# Syntax
# ./test_dwgsim_and_uncompress.sh <folder_name_to_save_this_generated_data> <ref_genome_sequces>
#
# Usage Case
# ./test_dwgsim_and_uncompress.sh /mnt/d/Data/ViBE_fine_tune_family_and_genra_data/test_2024111403 /mnt/d/Data/ViBE_fine_tune_family_and_genra_data/ex1.fa
#
# Output
# $ ls -lat /mnt/d/Data/ViBE_fine_tune_family_and_genra_data/test_2024111403/
# total 13
# drwxrwxrwx 1 ycho ycho  512 Nov 14 22:42 .
# -rwxrwxrwx 1 ycho ycho 1825 Nov 14 22:42 example.test.bwa.read2.fastq
# -rwxrwxrwx 1 ycho ycho 1825 Nov 14 22:42 example.test.bwa.read1.fastq
# -rwxrwxrwx 1 ycho ycho 3610 Nov 14 22:42 example.test.bfast.fastq
# -rwxrwxrwx 1 ycho ycho  594 Nov 14 22:42 example.test.mutations.vcf
# -rwxrwxrwx 1 ycho ycho   61 Nov 14 22:42 example.test.mutations.txt
# drwxrwxrwx 1 ycho ycho  512 Nov 14 22:34 ..
#

TESTDATADIR=${1};

mkdir -p ${TESTDATADIR}
#mkdir tmp

# Generate the new test data
#dwgsim -z 13 -N 10 ${2} ${TESTDATADIR}/example.test
dwgsim -N 10 ${2} ${TESTDATADIR}/example.test


# Decompress the test data
pushd $TESTDATADIR;
for FILE in $(ls -1 *gz)
do 
	gunzip -c ${FILE} > $(basename ${FILE} .gz);
done
popd

# Clean up the testdata
#find ${TESTDATADIR} \! -name "*gz" -type f | grep -v sh$ | xargs rm; 
find ${TESTDATADIR} -name "*gz" -type f | grep -v sh$ | xargs rm; 

#rm -r tmp
