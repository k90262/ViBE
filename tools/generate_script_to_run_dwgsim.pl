#!/usr/bin/perl -w
use strict;
use File::Path qw(make_path);

=pod

=head1 NAME

generate_script_to_run_dwgsim.pl - Generate DWGSIM Command / Script to Batch Run

=head1 SYNOPSIS

B<generate_script_to_run_dwgsim.pl> [ -f <folder_label> [ -n <output_seq_num> ] ] <B<reference_genome_files_path>>

=head2 Usage Case 1

  $ generate_script_to_run_dwgsim.pl ../*.fa
  #!/bin/bash -x
  test_dwgsim_and_uncompress.sh ERR3994223.rdrp1 ../ERR3994223.rdrp1.mu.fa &> ERR3994223.rdrp1.log
  test_dwgsim_and_uncompress.sh SRR10402291.rdrp1 ../SRR10402291.rdrp1.mu.fa &> SRR10402291.rdrp1.log
  test_dwgsim_and_uncompress.sh SRR10917299.rdrp1 ../SRR10917299.rdrp1.mu.fa &> SRR10917299.rdrp1.log
  test_dwgsim_and_uncompress.sh SRR12184956.rdrp1 ../SRR12184956.rdrp1.mu.fa &> SRR12184956.rdrp1.log
  test_dwgsim_and_uncompress.sh SRR1324965.rdrp1 ../SRR1324965.rdrp1.mu.fa &> SRR1324965.rdrp1.log
  test_dwgsim_and_uncompress.sh SRR5997671.rdrp1 ../SRR5997671.rdrp1.mu.fa &> SRR5997671.rdrp1.log
  test_dwgsim_and_uncompress.sh SRR6788790.rdrp1 ../SRR6788790.rdrp1.mu.fa &> SRR6788790.rdrp1.log
  test_dwgsim_and_uncompress.sh SRR7507741.rdrp1 ../SRR7507741.rdrp1.mu.fa &> SRR7507741.rdrp1.log
  test_dwgsim_and_uncompress.sh SRR8389791.rdrp1 ../SRR8389791.rdrp1.mu.fa &> SRR8389791.rdrp1.log

=head2 Usage Case 2

  $ generate_script_to_run_dwgsim.pl ../*.fa > generate.sh
  $ ./generate.sh
  + test_dwgsim_and_uncompress.sh ERR3994223.rdrp1 ../ERR3994223.rdrp1.mu.fa
  + test_dwgsim_and_uncompress.sh SRR10402291.rdrp1 ../SRR10402291.rdrp1.mu.fa
  + test_dwgsim_and_uncompress.sh SRR10917299.rdrp1 ../SRR10917299.rdrp1.mu.fa
  + test_dwgsim_and_uncompress.sh SRR12184956.rdrp1 ../SRR12184956.rdrp1.mu.fa
  + test_dwgsim_and_uncompress.sh SRR1324965.rdrp1 ../SRR1324965.rdrp1.mu.fa
  + test_dwgsim_and_uncompress.sh SRR5997671.rdrp1 ../SRR5997671.rdrp1.mu.fa
  + test_dwgsim_and_uncompress.sh SRR6788790.rdrp1 ../SRR6788790.rdrp1.mu.fa
  + test_dwgsim_and_uncompress.sh SRR7507741.rdrp1 ../SRR7507741.rdrp1.mu.fa
  + test_dwgsim_and_uncompress.sh SRR8389791.rdrp1 ../SRR8389791.rdrp1.mu.fa
  $ ls *
  ERR3994223.rdrp1.log   SRR10917299.rdrp1.log  SRR1324965.rdrp1.log  SRR6788790.rdrp1.log  SRR8389791.rdrp1.log
  SRR10402291.rdrp1.log  SRR12184956.rdrp1.log  SRR5997671.rdrp1.log  SRR7507741.rdrp1.log  generate.sh
  
  ERR3994223.rdrp1:
  ERR3994223.rdrp1.mu.fa.test.bfast.fastq      ERR3994223.rdrp1.mu.fa.test.bwa.read1.fastq.gz  ERR3994223.rdrp1.mu.fa.test.mutations.txt
  ERR3994223.rdrp1.mu.fa.test.bfast.fastq.gz   ERR3994223.rdrp1.mu.fa.test.bwa.read2.fastq     ERR3994223.rdrp1.mu.fa.test.mutations.vcf
  ERR3994223.rdrp1.mu.fa.test.bwa.read1.fastq  ERR3994223.rdrp1.mu.fa.test.bwa.read2.fastq.gz
  
  SRR10402291.rdrp1:
  SRR10402291.rdrp1.mu.fa.test.bfast.fastq      SRR10402291.rdrp1.mu.fa.test.bwa.read1.fastq.gz  SRR10402291.rdrp1.mu.fa.test.mutations.txt
  SRR10402291.rdrp1.mu.fa.test.bfast.fastq.gz   SRR10402291.rdrp1.mu.fa.test.bwa.read2.fastq     SRR10402291.rdrp1.mu.fa.test.mutations.vcf
  SRR10402291.rdrp1.mu.fa.test.bwa.read1.fastq  SRR10402291.rdrp1.mu.fa.test.bwa.read2.fastq.gz
  
  SRR10917299.rdrp1:
  SRR10917299.rdrp1.mu.fa.test.bfast.fastq      SRR10917299.rdrp1.mu.fa.test.bwa.read1.fastq.gz  SRR10917299.rdrp1.mu.fa.test.mutations.txt
  SRR10917299.rdrp1.mu.fa.test.bfast.fastq.gz   SRR10917299.rdrp1.mu.fa.test.bwa.read2.fastq     SRR10917299.rdrp1.mu.fa.test.mutations.vcf
  SRR10917299.rdrp1.mu.fa.test.bwa.read1.fastq  SRR10917299.rdrp1.mu.fa.test.bwa.read2.fastq.gz
  
  SRR12184956.rdrp1:
  SRR12184956.rdrp1.mu.fa.test.bfast.fastq      SRR12184956.rdrp1.mu.fa.test.bwa.read1.fastq.gz  SRR12184956.rdrp1.mu.fa.test.mutations.txt
  SRR12184956.rdrp1.mu.fa.test.bfast.fastq.gz   SRR12184956.rdrp1.mu.fa.test.bwa.read2.fastq     SRR12184956.rdrp1.mu.fa.test.mutations.vcf
  SRR12184956.rdrp1.mu.fa.test.bwa.read1.fastq  SRR12184956.rdrp1.mu.fa.test.bwa.read2.fastq.gz
  
  SRR1324965.rdrp1:
  SRR1324965.rdrp1.mu.fa.test.bfast.fastq      SRR1324965.rdrp1.mu.fa.test.bwa.read1.fastq.gz  SRR1324965.rdrp1.mu.fa.test.mutations.txt
  SRR1324965.rdrp1.mu.fa.test.bfast.fastq.gz   SRR1324965.rdrp1.mu.fa.test.bwa.read2.fastq     SRR1324965.rdrp1.mu.fa.test.mutations.vcf
  SRR1324965.rdrp1.mu.fa.test.bwa.read1.fastq  SRR1324965.rdrp1.mu.fa.test.bwa.read2.fastq.gz
  
  SRR5997671.rdrp1:
  SRR5997671.rdrp1.mu.fa.test.bfast.fastq      SRR5997671.rdrp1.mu.fa.test.bwa.read1.fastq.gz  SRR5997671.rdrp1.mu.fa.test.mutations.txt
  SRR5997671.rdrp1.mu.fa.test.bfast.fastq.gz   SRR5997671.rdrp1.mu.fa.test.bwa.read2.fastq     SRR5997671.rdrp1.mu.fa.test.mutations.vcf
  SRR5997671.rdrp1.mu.fa.test.bwa.read1.fastq  SRR5997671.rdrp1.mu.fa.test.bwa.read2.fastq.gz
  
  SRR6788790.rdrp1:
  SRR6788790.rdrp1.mu.fa.test.bfast.fastq      SRR6788790.rdrp1.mu.fa.test.bwa.read1.fastq.gz  SRR6788790.rdrp1.mu.fa.test.mutations.txt
  SRR6788790.rdrp1.mu.fa.test.bfast.fastq.gz   SRR6788790.rdrp1.mu.fa.test.bwa.read2.fastq     SRR6788790.rdrp1.mu.fa.test.mutations.vcf
  SRR6788790.rdrp1.mu.fa.test.bwa.read1.fastq  SRR6788790.rdrp1.mu.fa.test.bwa.read2.fastq.gz
  
  SRR7507741.rdrp1:
  SRR7507741.rdrp1.mu.fa.test.bfast.fastq      SRR7507741.rdrp1.mu.fa.test.bwa.read1.fastq.gz  SRR7507741.rdrp1.mu.fa.test.mutations.txt
  SRR7507741.rdrp1.mu.fa.test.bfast.fastq.gz   SRR7507741.rdrp1.mu.fa.test.bwa.read2.fastq     SRR7507741.rdrp1.mu.fa.test.mutations.vcf
  SRR7507741.rdrp1.mu.fa.test.bwa.read1.fastq  SRR7507741.rdrp1.mu.fa.test.bwa.read2.fastq.gz
  
  SRR8389791.rdrp1:
  SRR8389791.rdrp1.mu.fa.test.bfast.fastq      SRR8389791.rdrp1.mu.fa.test.bwa.read1.fastq.gz  SRR8389791.rdrp1.mu.fa.test.mutations.txt
  SRR8389791.rdrp1.mu.fa.test.bfast.fastq.gz   SRR8389791.rdrp1.mu.fa.test.bwa.read2.fastq     SRR8389791.rdrp1.mu.fa.test.mutations.vcf
  SRR8389791.rdrp1.mu.fa.test.bwa.read1.fastq  SRR8389791.rdrp1.mu.fa.test.bwa.read2.fastq.gz
  $ tail *.log
  ==> ERR3994223.rdrp1.log <==
  Paired-end reads generated:
  ----------------------------
  Positive reads generated: 328
  Negative reads generated: 328
  Total reads generated: 656
  
  Checking total read number (positive + negative) from each genome in reference fasta file:
  ----------------------------
  
  /mnt/d/Data/new_novel_coronaviruses_found_on_2022_Robert_paper/RdRP/simulated_ngs_sequences
  
  ==> SRR10402291.rdrp1.log <==
  Paired-end reads generated:
  ----------------------------
  Positive reads generated: 360
  Negative reads generated: 360
  Total reads generated: 720
  
  Checking total read number (positive + negative) from each genome in reference fasta file:
  ----------------------------
  
  /mnt/d/Data/new_novel_coronaviruses_found_on_2022_Robert_paper/RdRP/simulated_ngs_sequences
  
  ==> SRR10917299.rdrp1.log <==
  Paired-end reads generated:
  ----------------------------
  Positive reads generated: 312
  Negative reads generated: 312
  Total reads generated: 624
  
  Checking total read number (positive + negative) from each genome in reference fasta file:
  ----------------------------
  
  /mnt/d/Data/new_novel_coronaviruses_found_on_2022_Robert_paper/RdRP/simulated_ngs_sequences
  
  ==> SRR12184956.rdrp1.log <==
  Paired-end reads generated:
  ----------------------------
  Positive reads generated: 585
  Negative reads generated: 585
  Total reads generated: 1170
  
  Checking total read number (positive + negative) from each genome in reference fasta file:
  ----------------------------
  
  /mnt/d/Data/new_novel_coronaviruses_found_on_2022_Robert_paper/RdRP/simulated_ngs_sequences
  
  ==> SRR1324965.rdrp1.log <==
  Paired-end reads generated:
  ----------------------------
  Positive reads generated: 594
  Negative reads generated: 594
  Total reads generated: 1188
  
  Checking total read number (positive + negative) from each genome in reference fasta file:
  ----------------------------
  
  /mnt/d/Data/new_novel_coronaviruses_found_on_2022_Robert_paper/RdRP/simulated_ngs_sequences
  
  ==> SRR5997671.rdrp1.log <==
  Paired-end reads generated:
  ----------------------------
  Positive reads generated: 298
  Negative reads generated: 298
  Total reads generated: 596
  
  Checking total read number (positive + negative) from each genome in reference fasta file:
  ----------------------------
  
  /mnt/d/Data/new_novel_coronaviruses_found_on_2022_Robert_paper/RdRP/simulated_ngs_sequences
  
  ==> SRR6788790.rdrp1.log <==
  Paired-end reads generated:
  ----------------------------
  Positive reads generated: 373
  Negative reads generated: 373
  Total reads generated: 746
  
  Checking total read number (positive + negative) from each genome in reference fasta file:
  ----------------------------
  
  /mnt/d/Data/new_novel_coronaviruses_found_on_2022_Robert_paper/RdRP/simulated_ngs_sequences
  
  ==> SRR7507741.rdrp1.log <==
  Paired-end reads generated:
  ----------------------------
  Positive reads generated: 363
  Negative reads generated: 363
  Total reads generated: 726
  
  Checking total read number (positive + negative) from each genome in reference fasta file:
  ----------------------------
  
  /mnt/d/Data/new_novel_coronaviruses_found_on_2022_Robert_paper/RdRP/simulated_ngs_sequences
  
  ==> SRR8389791.rdrp1.log <==
  Paired-end reads generated:
  ----------------------------
  Positive reads generated: 311
  Negative reads generated: 311
  Total reads generated: 622
  
  Checking total read number (positive + negative) from each genome in reference fasta file:
  ----------------------------

=head2 Usage Case 3 - Simple Run DWGSIM Batchly

=head3 1. Modify Flag First

Update C<my $TEST_AND_UNCOMPRESS = 1;> to C<my $TEST_AND_UNCOMPRESS = 0;>.

=head3 2. Run This Script

  $ generate_script_to_run_dwgsim.pl ../*.fa > generate.sh
  $ head ./generate.sh
  #!/bin/bash -x
  dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../ERR3994223.rdrp1.mu.fa ERR3994223.rdrp1/ERR3994223.rdrp1 &> ERR3994223.rdrp1.log
  dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR10402291.rdrp1.mu.fa SRR10402291.rdrp1/SRR10402291.rdrp1 &> SRR10402291.rdrp1.log
  dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR10917299.rdrp1.mu.fa SRR10917299.rdrp1/SRR10917299.rdrp1 &> SRR10917299.rdrp1.log
  dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR12184956.rdrp1.mu.fa SRR12184956.rdrp1/SRR12184956.rdrp1 &> SRR12184956.rdrp1.log
  dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR1324965.rdrp1.mu.fa SRR1324965.rdrp1/SRR1324965.rdrp1 &> SRR1324965.rdrp1.log
  dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR5997671.rdrp1.mu.fa SRR5997671.rdrp1/SRR5997671.rdrp1 &> SRR5997671.rdrp1.log
  dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR6788790.rdrp1.mu.fa SRR6788790.rdrp1/SRR6788790.rdrp1 &> SRR6788790.rdrp1.log
  dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR7507741.rdrp1.mu.fa SRR7507741.rdrp1/SRR7507741.rdrp1 &> SRR7507741.rdrp1.log
  dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR8389791.rdrp1.mu.fa SRR8389791.rdrp1/SRR8389791.rdrp1 &> SRR8389791.rdrp1.log
  $ ./generate.sh
  + dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../ERR3994223.rdrp1.mu.fa ERR3994223.rdrp1/ERR3994223.rdrp1
  + dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR10402291.rdrp1.mu.fa SRR10402291.rdrp1/SRR10402291.rdrp1
  + dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR10917299.rdrp1.mu.fa SRR10917299.rdrp1/SRR10917299.rdrp1
  + dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR12184956.rdrp1.mu.fa SRR12184956.rdrp1/SRR12184956.rdrp1
  + dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR1324965.rdrp1.mu.fa SRR1324965.rdrp1/SRR1324965.rdrp1
  + dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR5997671.rdrp1.mu.fa SRR5997671.rdrp1/SRR5997671.rdrp1
  + dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR6788790.rdrp1.mu.fa SRR6788790.rdrp1/SRR6788790.rdrp1
  + dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR7507741.rdrp1.mu.fa SRR7507741.rdrp1/SRR7507741.rdrp1
  + dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ../SRR8389791.rdrp1.mu.fa SRR8389791.rdrp1/SRR8389791.rdrp1
  $ ls *
  ERR3994223.rdrp1.log   SRR10917299.rdrp1.log  SRR1324965.rdrp1.log  SRR6788790.rdrp1.log  SRR8389791.rdrp1.log
  SRR10402291.rdrp1.log  SRR12184956.rdrp1.log  SRR5997671.rdrp1.log  SRR7507741.rdrp1.log  generate.sh
  
  ERR3994223.rdrp1:
  ERR3994223.rdrp1.bfast.fastq.gz      ERR3994223.rdrp1.bwa.read2.fastq.gz  ERR3994223.rdrp1.mutations.vcf
  ERR3994223.rdrp1.bwa.read1.fastq.gz  ERR3994223.rdrp1.mutations.txt
  
  SRR10402291.rdrp1:
  SRR10402291.rdrp1.bfast.fastq.gz      SRR10402291.rdrp1.bwa.read2.fastq.gz  SRR10402291.rdrp1.mutations.vcf
  SRR10402291.rdrp1.bwa.read1.fastq.gz  SRR10402291.rdrp1.mutations.txt
  
  SRR10917299.rdrp1:
  SRR10917299.rdrp1.bfast.fastq.gz      SRR10917299.rdrp1.bwa.read2.fastq.gz  SRR10917299.rdrp1.mutations.vcf
  SRR10917299.rdrp1.bwa.read1.fastq.gz  SRR10917299.rdrp1.mutations.txt
  
  SRR12184956.rdrp1:
  SRR12184956.rdrp1.bfast.fastq.gz      SRR12184956.rdrp1.bwa.read2.fastq.gz  SRR12184956.rdrp1.mutations.vcf
  SRR12184956.rdrp1.bwa.read1.fastq.gz  SRR12184956.rdrp1.mutations.txt
  
  SRR1324965.rdrp1:
  SRR1324965.rdrp1.bfast.fastq.gz      SRR1324965.rdrp1.bwa.read2.fastq.gz  SRR1324965.rdrp1.mutations.vcf
  SRR1324965.rdrp1.bwa.read1.fastq.gz  SRR1324965.rdrp1.mutations.txt
  
  SRR5997671.rdrp1:
  SRR5997671.rdrp1.bfast.fastq.gz      SRR5997671.rdrp1.bwa.read2.fastq.gz  SRR5997671.rdrp1.mutations.vcf
  SRR5997671.rdrp1.bwa.read1.fastq.gz  SRR5997671.rdrp1.mutations.txt
  
  SRR6788790.rdrp1:
  SRR6788790.rdrp1.bfast.fastq.gz      SRR6788790.rdrp1.bwa.read2.fastq.gz  SRR6788790.rdrp1.mutations.vcf
  SRR6788790.rdrp1.bwa.read1.fastq.gz  SRR6788790.rdrp1.mutations.txt
  
  SRR7507741.rdrp1:
  SRR7507741.rdrp1.bfast.fastq.gz      SRR7507741.rdrp1.bwa.read2.fastq.gz  SRR7507741.rdrp1.mutations.vcf
  SRR7507741.rdrp1.bwa.read1.fastq.gz  SRR7507741.rdrp1.mutations.txt
  
  SRR8389791.rdrp1:
  SRR8389791.rdrp1.bfast.fastq.gz      SRR8389791.rdrp1.bwa.read2.fastq.gz  SRR8389791.rdrp1.mutations.vcf
  SRR8389791.rdrp1.bwa.read1.fastq.gz  SRR8389791.rdrp1.mutations.txt
  $ head *.log
  ==> ERR3994223.rdrp1.log <==
  [dwgsim_core] ERR3994223 length: 1648
  [dwgsim_core] 1 sequences, total length: 1648
  [dwgsim_core] Currently on:
  [dwgsim_core] 328
  [dwgsim_core] Complete!
  
  ==> SRR10402291.rdrp1.log <==
  [dwgsim_core] SRR10402291 length: 1806
  [dwgsim_core] SRR10402291 length: 256
  [dwgsim_core] SRR10402291 length: 235
  [dwgsim_core] SRR10402291 length: 234
  [dwgsim_core] SRR10402291 length: 234
  [dwgsim_core] SRR10402291 length: 234
  [dwgsim_core] SRR10402291 length: 228
  [dwgsim_core] SRR10402291 length: 225
  [dwgsim_core] 8 sequences, total length: 3452
  [dwgsim_core] Currently on:
  
  ==> SRR10917299.rdrp1.log <==
  [dwgsim_core] SRR10917299 length: 1565
  [dwgsim_core] SRR10917299 length: 368
  [dwgsim_core] SRR10917299 length: 257
  [dwgsim_core] SRR10917299 length: 251
  [dwgsim_core] SRR10917299 length: 242
  [dwgsim_core] SRR10917299 length: 238
  [dwgsim_core] SRR10917299 length: 238
  [dwgsim_core] SRR10917299 length: 235
  [dwgsim_core] 8 sequences, total length: 3394
  [dwgsim_core] Currently on:
  
  ==> SRR12184956.rdrp1.log <==
  [dwgsim_core] SRR12184956 length: 1542
  [dwgsim_core] SRR12184956 length: 715
  [dwgsim_core] SRR12184956 length: 681
  [dwgsim_core] SRR12184956 length: 233
  [dwgsim_core] SRR12184956 length: 232
  [dwgsim_core] SRR12184956 length: 227
  [dwgsim_core] SRR12184956 length: 225
  [dwgsim_core] 7 sequences, total length: 3855
  [dwgsim_core] Currently on:
  [dwgsim_core] 585
  
  ==> SRR1324965.rdrp1.log <==
  [dwgsim_core] SRR1324965 length: 1644
  [dwgsim_core] SRR1324965 length: 683
  [dwgsim_core] SRR1324965 length: 660
  [dwgsim_core] SRR1324965 length: 632
  [dwgsim_core] 4 sequences, total length: 3619
  [dwgsim_core] Currently on:
  [dwgsim_core] 594
  [dwgsim_core] #3 skip sequence 'SRR1324965' as it is shorter than 650.000000!
  
  [dwgsim_core] Complete!
  
  ==> SRR5997671.rdrp1.log <==
  [dwgsim_core] SRR5997671 length: 1494
  [dwgsim_core] 1 sequences, total length: 1494
  [dwgsim_core] Currently on:
  [dwgsim_core] 298
  [dwgsim_core] Complete!
  
  ==> SRR6788790.rdrp1.log <==
  [dwgsim_core] SRR6788790 length: 1874
  [dwgsim_core] SRR6788790 length: 240
  [dwgsim_core] SRR6788790 length: 237
  [dwgsim_core] SRR6788790 length: 235
  [dwgsim_core] SRR6788790 length: 232
  [dwgsim_core] 5 sequences, total length: 2818
  [dwgsim_core] Currently on:
  [dwgsim_core] 373
  [dwgsim_core] #3 skip sequence 'SRR6788790' as it is shorter than 650.000000!
  [dwgsim_core] #3 skip sequence 'SRR6788790' as it is shorter than 650.000000!
  
  ==> SRR7507741.rdrp1.log <==
  [dwgsim_core] SRR7507741 length: 1821
  [dwgsim_core] SRR7507741 length: 269
  [dwgsim_core] SRR7507741 length: 251
  [dwgsim_core] SRR7507741 length: 249
  [dwgsim_core] SRR7507741 length: 228
  [dwgsim_core] 5 sequences, total length: 2818
  [dwgsim_core] Currently on:
  [dwgsim_core] 363
  [dwgsim_core] #3 skip sequence 'SRR7507741' as it is shorter than 650.000000!
  [dwgsim_core] #3 skip sequence 'SRR7507741' as it is shorter than 650.000000!
  
  ==> SRR8389791.rdrp1.log <==
  [dwgsim_core] SRR8389791 length: 1561
  [dwgsim_core] 1 sequences, total length: 1561
  [dwgsim_core] Currently on:
  [dwgsim_core] 311
  [dwgsim_core] Complete!

=head2 Usage Case 4 - choose regex pattern in order to generate script for training data

  $ generate_script_to_run_dwgsim.pl -f training_reads genomes/*/read_level_genomes.fasta
  #!/bin/bash -x
  test_dwgsim_and_uncompress.sh Abyssoviridae/training_reads genomes/Abyssoviridae/read_level_genomes.fasta  &> Abyssoviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Arteriviridae/training_reads genomes/Arteriviridae/read_level_genomes.fasta  &> Arteriviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Coronaviridae/training_reads genomes/Coronaviridae/read_level_genomes.fasta  &> Coronaviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Cremegaviridae/training_reads genomes/Cremegaviridae/read_level_genomes.fasta  &> Cremegaviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Euroniviridae/training_reads genomes/Euroniviridae/read_level_genomes.fasta  &> Euroniviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Gresnaviridae/training_reads genomes/Gresnaviridae/read_level_genomes.fasta  &> Gresnaviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Medioniviridae/training_reads genomes/Medioniviridae/read_level_genomes.fasta  &> Medioniviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Mesoniviridae/training_reads genomes/Mesoniviridae/read_level_genomes.fasta  &> Mesoniviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Mononiviridae/training_reads genomes/Mononiviridae/read_level_genomes.fasta  &> Mononiviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Nanghoshaviridae/training_reads genomes/Nanghoshaviridae/read_level_genomes.fasta  &> Nanghoshaviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Nanhypoviridae/training_reads genomes/Nanhypoviridae/read_level_genomes.fasta  &> Nanhypoviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Olifoviridae/training_reads genomes/Olifoviridae/read_level_genomes.fasta  &> Olifoviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Roniviridae/training_reads genomes/Roniviridae/read_level_genomes.fasta  &> Roniviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Tobaniviridae/training_reads genomes/Tobaniviridae/read_level_genomes.fasta  &> Tobaniviridae/training_reads.log

=head2 Usage Case 5 - choose regex pattern in order to generate script for training data (with seq_num argument -n )

  $ generate_script_to_run_dwgsim.pl -f training_reads -n 2622 genomes/*/read_level_genomes.fasta
  #!/bin/bash -x
  test_dwgsim_and_uncompress.sh Abyssoviridae/training_reads genomes/Abyssoviridae/read_level_genomes.fasta 2622 &> Abyssoviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Arteriviridae/training_reads genomes/Arteriviridae/read_level_genomes.fasta 2622 &> Arteriviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Coronaviridae/training_reads genomes/Coronaviridae/read_level_genomes.fasta 2622 &> Coronaviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Cremegaviridae/training_reads genomes/Cremegaviridae/read_level_genomes.fasta 2622 &> Cremegaviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Euroniviridae/training_reads genomes/Euroniviridae/read_level_genomes.fasta 2622 &> Euroniviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Gresnaviridae/training_reads genomes/Gresnaviridae/read_level_genomes.fasta 2622 &> Gresnaviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Medioniviridae/training_reads genomes/Medioniviridae/read_level_genomes.fasta 2622 &> Medioniviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Mesoniviridae/training_reads genomes/Mesoniviridae/read_level_genomes.fasta 2622 &> Mesoniviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Mononiviridae/training_reads genomes/Mononiviridae/read_level_genomes.fasta 2622 &> Mononiviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Nanghoshaviridae/training_reads genomes/Nanghoshaviridae/read_level_genomes.fasta 2622 &> Nanghoshaviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Nanhypoviridae/training_reads genomes/Nanhypoviridae/read_level_genomes.fasta 2622 &> Nanhypoviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Olifoviridae/training_reads genomes/Olifoviridae/read_level_genomes.fasta 2622 &> Olifoviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Roniviridae/training_reads genomes/Roniviridae/read_level_genomes.fasta 2622 &> Roniviridae/training_reads.log
  test_dwgsim_and_uncompress.sh Tobaniviridae/training_reads genomes/Tobaniviridae/read_level_genomes.fasta 2622 &> Tobaniviridae/training_reads.log

=head1 VERSION

20241231 00

=cut

my $TEST_AND_UNCOMPRESS = 1;
my $RDRP_LABEL_REGEX = qr/(\w+\.rdrp1).mu.fa/;
my $FOLDER_LABEL_REGEX = qr/(\w+\/)\w+.fasta/;
my $genome_label_regex = $RDRP_LABEL_REGEX;
my $label_suffix = '';
my $output_seq_num = '';

if ($ARGV[0] eq '-f') {
  $genome_label_regex = $FOLDER_LABEL_REGEX;
  shift;
  $label_suffix = shift;
  if ($ARGV[0] eq '-n') {
    shift;
    $output_seq_num = shift;
  }
}

my @path_rdrp_files = map { glob($_) } @ARGV;
# print @path_rdrp_files, $/;

if (@path_rdrp_files > 0) {
  print "#!/bin/bash -x$/";
}


foreach my $reference_genome_path (@path_rdrp_files) {
  my ($genome_label) = $reference_genome_path =~ $genome_label_regex;
  my $output_folder  = $genome_label.$label_suffix;

  if ($TEST_AND_UNCOMPRESS) {
    my $test_scrip_command = "test_dwgsim_and_uncompress.sh $output_folder $reference_genome_path $output_seq_num &> $output_folder.log";
    print "$test_scrip_command$/";
  } 
  else {
    make_path($output_folder);
    my $output_file_prefix = $output_folder . '/' . $genome_label;
    my $dwgsim_command = "dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 $reference_genome_path $output_file_prefix &> $output_folder.log";
    print "$dwgsim_command$/";
  }
}

__END__

=head1 AUTHORS

Bill Ho E<lt>ycho.bill.lab@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2024 by Bill Ho E<lt>ycho.bill.lab@gmail.comE<gt>.

This software is released under the MIT license cited below.

=head2 The "MIT" License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

=cut
