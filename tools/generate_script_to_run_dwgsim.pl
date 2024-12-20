#!/usr/bin/perl -w
use strict;
use File::Path qw(make_path);

=pod

=head1 NAME

generate_script_to_run_dwgsim.pl - Generate DWGSIM Command / Script to Batch Run

=head1 SYNOPSIS

B<generate_script_to_run_dwgsim.pl> <B<reference_genome_files_path>>

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

=head1 VERSION

20241220 01

=cut

my $TEST_AND_UNCOMPRESS = 1;
my @path_rdrp_files = map { glob($_) } @ARGV;
# print @path_rdrp_files, $/;

if (@path_rdrp_files > 0) {
  print "#!/bin/bash -x$/";
}

foreach my $reference_genome_path (@path_rdrp_files) {
  my ($genome_label) = $reference_genome_path =~ /(\w+\.rdrp1).mu.fa/;
  my $output_folder  = $genome_label;

  if ($TEST_AND_UNCOMPRESS) {
    my $test_scrip_command = "test_dwgsim_and_uncompress.sh $output_folder $reference_genome_path &> $output_folder.log";
    print "$test_scrip_command$/";
  } 
  else {
    make_path($output_folder);
    my $output_file_prefix = $output_folder . '/' . $genome_label;
    my $dwgsim_command = "dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 $reference_genome_path $output_file_prefix &> $output_folder.log";
    print "$dwgsim_command$/";
  }
}
