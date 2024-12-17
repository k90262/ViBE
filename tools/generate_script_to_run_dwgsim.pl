#!/usr/bin/perl -w
use strict;

=pod

=head1 generate_script_to_run_dwgsim.pl

=head2 Usage Case

  $ perl generate_script_to_run_dwgsim.pl
  test_dwgsim_and_uncompress.sh ERR3994223.rdrp1 ../ERR3994223.rdrp1.mu.fa &> ERR3994223.rdrp1/script.log
  test_dwgsim_and_uncompress.sh SRR10402291.rdrp1 ../SRR10402291.rdrp1.mu.fa &> SRR10402291.rdrp1/script.log
  test_dwgsim_and_uncompress.sh SRR10917299.rdrp1 ../SRR10917299.rdrp1.mu.fa &> SRR10917299.rdrp1/script.log
  test_dwgsim_and_uncompress.sh SRR12184956.rdrp1 ../SRR12184956.rdrp1.mu.fa &> SRR12184956.rdrp1/script.log
  test_dwgsim_and_uncompress.sh SRR1324965.rdrp1 ../SRR1324965.rdrp1.mu.fa &> SRR1324965.rdrp1/script.log
  test_dwgsim_and_uncompress.sh SRR5997671.rdrp1 ../SRR5997671.rdrp1.mu.fa &> SRR5997671.rdrp1/script.log
  test_dwgsim_and_uncompress.sh SRR6788790.rdrp1 ../SRR6788790.rdrp1.mu.fa &> SRR6788790.rdrp1/script.log
  test_dwgsim_and_uncompress.sh SRR7507741.rdrp1 ../SRR7507741.rdrp1.mu.fa &> SRR7507741.rdrp1/script.log
  test_dwgsim_and_uncompress.sh SRR8389791.rdrp1 ../SRR8389791.rdrp1.mu.fa &> SRR8389791.rdrp1/script.log

=cut

#dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 ex1_shorter_2.fa test_20241213_max_out_number_shorter_2/ex1_shorter_2.fa.test

# my @raw_sra_id = qw(
# SRR6788790
# SRR7507741
# SRR1324965
# ERR3994223
# SRR10917299
# SRR5997671
# SRR12184956
# SRR10402291
# SRR8389791
# );
# 
# print "$raw_sra_id[0], $raw_sra_id[-1]", $/; 

my $path_rdrp_files = '/mnt/d/Data/new_novel_coronaviruses_found_on_2022_Robert_paper/RdRP/*.fa';
my @path_rdrp_files = glob($path_rdrp_files);
# print @path_rdrp_files, $/;

foreach my $reference_genome_path (@path_rdrp_files) {
  my ($genome_label) = $reference_genome_path =~ /(\w+\.rdrp1).mu.fa/;
  my $output_folder  = $genome_label;
  my $output_file_prefix = $output_folder . '/' . $genome_label;
  #my $dwgsim_command = "dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 $reference_genome_path $output_file_prefix > $output_file_prefix.log";
  my $test_scrip_command = "test_dwgsim_and_uncompress.sh $output_folder $reference_genome_path &> $output_folder/script.log";
  #print "$dwgsim_command$/";
  print "$test_scrip_command$/";
}
