#!/usr/bin/perl -w
use strict;

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

=head1 VERSION

20241220 00

=cut

my @path_rdrp_files = map { glob($_) } @ARGV;
# print @path_rdrp_files, $/;

if (@path_rdrp_files > 0) {
  print "#!/bin/bash -x$/";
}

foreach my $reference_genome_path (@path_rdrp_files) {
  my ($genome_label) = $reference_genome_path =~ /(\w+\.rdrp1).mu.fa/;
  my $output_folder  = $genome_label;
  #my $output_file_prefix = $output_folder . '/' . $genome_label;
  #my $dwgsim_command = "dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 $reference_genome_path $output_file_prefix &> $output_file_prefix.log";
  my $test_scrip_command = "test_dwgsim_and_uncompress.sh $output_folder $reference_genome_path &> $output_folder.log";
  #print "$dwgsim_command$/";
  print "$test_scrip_command$/";
}
