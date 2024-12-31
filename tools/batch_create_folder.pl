#!/usr/bin/perl -w
use File::Spec;
use Cwd;

=pod

=head1 NAME

batch_create_folder.pl - Create folder batchly for downloading related genomes later

=head1 SYNOPSOS

  perl batch_create_folder.pl [-d|-s] <input directory list text>

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
  ...
  Create Folder: ./Abyssoviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=abyssoviridae
  + datasets download virus genome taxon abyssoviridae --refseq
  Error: The taxonomy name 'abyssoviridae' is not a recognized virus taxon.
  
  Use datasets download virus genome taxon <command> --help for detailed help about a command.

=head3 Example Case 3 - create folder (if folder is not existed), and split genome via csv file genomes_of_nidovirales.csv and tool faSomeRecords (please prepare csv and download tool first)

  $ head families_of_nidovirales.txt genomes_of_nidovirales.csv
  ==> families_of_nidovirales.txt <==
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
  
  ==> genomes_of_nidovirales.csv <==
  Accession Number,Assembly Number,Family,Genus,Species,Used To
  >NC_040711.1 ,GCF_004133285.1,Abyssoviridae,,Aplysia californica nido-like virus,"Training Set, Read-level Validation Set"
  >NC_028963.1 ,GCF_001501455.1,Arteriviridae,Betaarterivirus,Betaarterivirus chinrav 1,Genome-level Validation Set
  >NC_048210.1 ,GCF_012271595.1,Arteriviridae,,Rodent arterivirus,"Training Set, Read-level Validation Set"
  >NC_043487.1 ,GCF_003971765.1,Arteriviridae,Betaarterivirus,Betaarterivirus suid 1,"Training Set, Read-level Validation Set"
  >NC_040535.1 ,GCF_004130335.1,Arteriviridae,,Rodent arterivirus,"Training Set, Read-level Validation Set"
  >NC_038291.1 ,GCF_002816115.1,Arteriviridae,Betaarterivirus,Betaarterivirus suid 2,"Training Set, Read-level Validation Set"
  >NC_038292.1 ,GCF_002816135.1,Arteriviridae,Iotaarterivirus,Iotaarterivirus kibreg 1,"Training Set, Read-level Validation Set"
  >NC_038293.1 ,GCF_002816155.1,Arteriviridae,Epsilonarterivirus,Epsilonarterivirus hemcep,"Training Set, Read-level Validation Set"
  >NC_035127.1 ,GCF_002210535.1,Arteriviridae,Muarterivirus,Muarterivirus afrigant,"Training Set, Read-level Validation Set"
  
  $ batch_create_folder.pl -s families_of_nidovirales.txt
  Can't open -s: No such file or directory at /mnt/d/Projects/ViBE/tools/batch_create_folder.pl line 266.
  Create Folder: ./Arteriviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=Arteriviridae
  + TAXON_DIR_QFN=./Arteriviridae
  + grep 'Genome-level Validation Set' genomes_of_nidovirales.csv
  + grep Arteriviridae
  + perl -a '-F/,|>/' -e 'print @F[1]. $/;'
  + pushd ./Arteriviridae
  /mnt/d/Data/ViBE_fine_tune_family_and_genra_data/family_level/genomes/Arteriviridae /mnt/d/Data/ViBE_fine_tune_family_and_genra_data/family_level/genomes
  + faSomeRecords ncbi_dataset/data/genomic.fna genome_level_validation_ids.txt genome_level_validation_genomes.fasta
  + faSomeRecords -exclude ncbi_dataset/data/genomic.fna genome_level_validation_ids.txt read_level_genomes.fasta
  + popd
  /mnt/d/Data/ViBE_fine_tune_family_and_genra_data/family_level/genomes
  ...

=cut

my $FLAG_DOWNLOAG_GENOMES = 0;
my $FLAG_SPLIT_GENOMES = 0;

if (@ARGV < 1) {
  print "\nUsage: $0 <input directory list text>\n";
  exit;
} 
elsif ($ARGV[0] eq '-d') {
  $FLAG_DOWNLOAG_GENOMES = 1;
}
elsif ($ARGV[0] eq '-s') {
  $FLAG_SPLIT_GENOMES = 1;
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

  # Call Split Script
  if ($FLAG_SPLIT_GENOMES && -d $dir_qfn) {
    system("split_genomes_via_ids.sh", $folder_name, $dir_qfn);
  }

}
