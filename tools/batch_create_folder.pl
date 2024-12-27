#!/usr/bin/perl -w
use File::Spec;
use Cwd;

=pod

=head1 NAME

batch_create_folder.pl - Create folder batchly for downloading related genomes later

=head1 SYNOPSOS

  perl batch_create_folder.pl [-d] <input directory list text>

=head2 Example:

  $ cat families_of_nidovirales.txt
  Arteriviridae
  Coronaviridae
  Cremegaviridae
  Euroniviridae
  Gresnaviridae
  Medioniviridae
  Mesoniviridae
  Mononiviridae
  Nanghoshaviridae
  Nanhypoviridae
  Olifoviridae
  Roniviridae
  Tobaniviridae
  Abyssoviridae

  $ batch_create_folder.pl families_of_nidovirales.txt
  Create Folder: ./Arteriviridae ...Skipped. Reason:File exists
  Create Folder: ./Coronaviridae ...Skipped. Reason:File exists
  Create Folder: ./Cremegaviridae ...Skipped. Reason:File exists
  Create Folder: ./Euroniviridae ...Skipped. Reason:File exists
  Create Folder: ./Gresnaviridae ...Skipped. Reason:File exists
  Create Folder: ./Medioniviridae ...Skipped. Reason:File exists
  Create Folder: ./Mesoniviridae ...Skipped. Reason:File exists
  Create Folder: ./Mononiviridae ...Skipped. Reason:File exists
  Create Folder: ./Nanghoshaviridae ...Skipped. Reason:File exists
  Create Folder: ./Nanhypoviridae ...Skipped. Reason:File exists
  Create Folder: ./Olifoviridae ...Skipped. Reason:File exists
  Create Folder: ./Roniviridae ...Skipped. Reason:File exists
  Create Folder: ./Tobaniviridae ...Skipped. Reason:File exists
  Create Folder: ./Abyssoviridae ...Skipped. Reason:File exists

=head2 Example 2 - create folder and download genome:

  $ perl batch_create_folder.pl -d families_of_nidovirales.txt
  Create Folder: ./Arteriviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=arteriviridae
  + datasets download virus genome taxon arteriviridae --refseq
  Downloading: ncbi_dataset.zip    144kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Coronaviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=coronaviridae
  + datasets download virus genome taxon coronaviridae --refseq
  Downloading: ncbi_dataset.zip    771kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Cremegaviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=cremegaviridae
  + datasets download virus genome taxon cremegaviridae --refseq
  Downloading: ncbi_dataset.zip    16.6kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Euroniviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=euroniviridae
  + datasets download virus genome taxon euroniviridae --refseq
  Downloading: ncbi_dataset.zip    32.8kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Gresnaviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=gresnaviridae
  + datasets download virus genome taxon gresnaviridae --refseq
  Downloading: ncbi_dataset.zip    11.2kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Medioniviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=medioniviridae
  + datasets download virus genome taxon medioniviridae --refseq
  Downloading: ncbi_dataset.zip    20.7kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Mesoniviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=mesoniviridae
  + datasets download virus genome taxon mesoniviridae --refseq
  Downloading: ncbi_dataset.zip    114kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Mononiviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=mononiviridae
  + datasets download virus genome taxon mononiviridae --refseq
  Downloading: ncbi_dataset.zip    18.6kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Nanghoshaviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=nanghoshaviridae
  + datasets download virus genome taxon nanghoshaviridae --refseq
  Downloading: ncbi_dataset.zip    9.13kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Nanhypoviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=nanhypoviridae
  + datasets download virus genome taxon nanhypoviridae --refseq
  Downloading: ncbi_dataset.zip    11.1kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Olifoviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=olifoviridae
  + datasets download virus genome taxon olifoviridae --refseq
  Downloading: ncbi_dataset.zip    10kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Roniviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=roniviridae
  + datasets download virus genome taxon roniviridae --refseq
  Downloading: ncbi_dataset.zip    43.6kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
    inflating: README.md
    inflating: ncbi_dataset/data/data_report.jsonl
    inflating: ncbi_dataset/data/genomic.fna
    inflating: ncbi_dataset/data/virus_dataset.md
    inflating: ncbi_dataset/data/dataset_catalog.json
    inflating: md5sum.txt
  Create Folder: ./Tobaniviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=tobaniviridae
  + datasets download virus genome taxon tobaniviridae --refseq
  Downloading: ncbi_dataset.zip    242kB valid data package
  Validating package files [================================================] 100% 6/6
  + unzip ncbi_dataset.zip
  Archive:  ncbi_dataset.zip
  replace README.md? [y]es, [n]o, [A]ll, [N]one, [r]ename: y
    inflating: README.md
  replace ncbi_dataset/data/data_report.jsonl? [y]es, [n]o, [A]ll, [N]one, [r]ename: y
    inflating: ncbi_dataset/data/data_report.jsonl
  replace ncbi_dataset/data/genomic.fna? [y]es, [n]o, [A]ll, [N]one, [r]ename: y
    inflating: ncbi_dataset/data/genomic.fna
  replace ncbi_dataset/data/virus_dataset.md? [y]es, [n]o, [A]ll, [N]one, [r]ename: y
    inflating: ncbi_dataset/data/virus_dataset.md
  replace ncbi_dataset/data/dataset_catalog.json? [y]es, [n]o, [A]ll, [N]one, [r]ename: y
    inflating: ncbi_dataset/data/dataset_catalog.json
  replace md5sum.txt? [y]es, [n]o, [A]ll, [N]one, [r]ename: A
    inflating: md5sum.txt
  Create Folder: ./Abyssoviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=abyssoviridae
  + datasets download virus genome taxon abyssoviridae --refseq
  Error: The taxonomy name 'abyssoviridae' is not a recognized virus taxon.
  
  Use datasets download virus genome taxon <command> --help for detailed help about a command.

=cut

my $FLAG_DOWNLOAG_GENOMES = 0;

if (@ARGV < 1) {
  print "\nUsage: $0 <input directory list text>\n";
  exit;
} 
elsif ($ARGV[0] eq '-d') {
  $FLAG_DOWNLOAG_GENOMES = 1;
}

my $orig_cwd = cwd;

while(<>) {
  chomp;
  my $folder_name = $_;
  my $curdir = File::Spec->curdir();
  my $dir_qfn = File::Spec->catfile($curdir, $folder_name);
  print "Create Folder: $dir_qfn ...";
  mkdir($dir_qfn)
     or $!{EEXIST}   # Don't die if $dir_qfn exists.
     or die("Can't create directory \"$dir_qfn\": $!\n");

  if ($!) {
    print "Skipped. Reason:", $!, $/;
    undef $!;
  } else {
    print "Done.", $/;
  }

  # Call Download Script
  if ($FLAG_DOWNLOAG_GENOMES && -d $dir_qfn) {
    chdir $dir_qfn;
    system("download_genomes_via_taxon_name.sh", lc($folder_name));
    chdir $orig_cwd;
  }

}
