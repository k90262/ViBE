#!/usr/bin/perl -w
use File::Spec;
use Cwd;

=pod

=head1 NAME

batch_create_folder.pl - Create folder batchly for downloading related genomes later or other tasks

=head1 SYNOPSIS

  perl batch_create_folder.pl [-d|-s|-p] <input directory list text>

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

=head2 Example 3 - create folder (if folder is not existed), and split genome via csv file genomes_of_nidovirales.csv and tool faSomeRecords:

=head3 NOTE: Please prepare csv, download tool from http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/faSomeRecords and add it into your PATH environment first.

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

=head2 Example 4 - create folder (if folder is not existed), and preprocess data from multiple folders (e.g. training_reads, validation_reads, validation_reads_read_level):

  $ batch_create_folder.pl -p demo_families_of_nidovirales.txt
  Create Folder: ./Abyssoviridae ...Skipped. Reason:File exists
  + set -e
  + TAXON_NAME=Abyssoviridae
  + TAXON_SUB_DIR_QFN=Abyssoviridae/training_reads
  ++ realpath /mnt/d/Projects/ViBE/tools/preprocess_and_label.sh
  + SCRIPT=/mnt/d/Projects/ViBE/tools/preprocess_and_label.sh
  ++ dirname /mnt/d/Projects/ViBE/tools/preprocess_and_label.sh
  + SCRIPTPATH=/mnt/d/Projects/ViBE/tools
  + conda run -n vibe --live-stream python /mnt/d/Projects/ViBE/tools/../scripts/seq2kmer_doc.py -i Abyssoviridae/training_reads/read_level_genomes.fasta.test.bwa.read1.fastq -p Abyssoviridae/training_reads/read_level_genomes.fasta.test.bwa.read2.fastq -o Abyssoviridae/training_reads/data.Abyssoviridae.paired.csv -k 4 -f fastq --min-length 150 --max-length 251
  100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 2622/2622 [00:00<00:00, 6214.92it/s]
  + cat Abyssoviridae/training_reads/data.Abyssoviridae.paired.csv
  + perl -pe 'if (! /^forward,backward,seqid/) {s/\n/,Abyssoviridae\n/} else {s/\n/,label\n/}'
  + head -2 Abyssoviridae/training_reads/data.Abyssoviridae.paired.label.csv
  forward,backward,seqid,label
  CGTT GTTT TTTT TTTT TTTC TTCC TCCA CCAT CATT ATTG TTGT TGTG GTGA TGAG GAGA AGAG GAGT AGTT GTTC TTCC TCCT CCTC CTCT TCTG CTGG TGGC GGCC GCCT CCTA CTAT TATT ATTT TTTG TTGT TGTT GTTG TTGA TGAG GAGG AGGT GGTA GTAT TATA ATAC TACG ACGT CGTG GTGG TGGT GGTA GTAT TATT ATTT TTTG TTGT TGTT GTTT TTTT TTTG TTGT TGTA GTAT TATT ATTC TTCC TCCT CCTC CTCC TCCA CCAT CATG ATGG TGGA GGAA GAAA AAAT AATA ATAC TACA ACAC CACT ACTC CTCA TCAT CATC ATCT TCTT CTTG TTGT TGTT GTTT TTTC TTCA TCAG CAGT AGTG GTGG TGGA GGAA GAAG AAGA AGAG GAGG AGGC GGCT GCTT CTTA TTAT TATT ATTT TTTG TTGC TGCA GCAC CACT ACTT CTTG TTGC TGCC GCCA CCAC CACT ACTT CTTA TTAT TATT ATTA TTAG TAGT AGTT GTTT TTTG TTGG TGGA GGAT GATG ATGA TGAT GATA ATAA TAAT AATG ATGC TGCT GCTA CTAT TATG ATGT TGTT GTTG TTGA TGAG GAGT AGTT GTTA TTAT TATG ATGG TGGA GGAC GACA ACAT CATG ATGT TGTT GTTT TTTG TTGT TGTT GTTC TTCT TCTA CTAC TACT ACTT CTTG TTGT TGTA GTAT TATT ATTA TTAA TAAC AACA ACAA CAAG AAGG AGGA GGAT GATG ATGA TGAG GAGA AGAG GAGT AGTA GTAC TACT ACTT CTTT TTTC TTCT TCTT CTTT TTTT TTTG TTGG TGGG GGGC GGCA GCAA CAAC AACT ACTA CTAC TACA ACAA CAAC AACG ACGG CGGG GGGG GGGG GGGG GGGC GGCC GCCG CCGT CGTA GTAA TAAG AAGA AGAA GAAT AATG ATGA TGAA GAAG AAGC AGCA GCAA CAAT AATG ATGC TGCT GCTT CTTG TTGA,GAGA AGAG GAGC AGCT GCTC CTCT TCTC CTCC TCCC CCCT CCTT CTTA TTAC TACT ACTA CTAG TAGC AGCC GCCA CCAA CAAG AAGG AGGC GGCA GCAG CAGC AGCA GCAA CAAT AATG ATGT TGTC GTCA TCAC CACG ACGC CGCT GCTC CTCC TCCA CCAT CATA ATAG TAGC AGCG GCGG CGGC GGCA GCAT CATA ATAT TATG ATGC TGCC GCCT CCTG CTGC TGCG GCGT CGTG GTGT TGTT GTTG TTGC TGCC GCCA CCAG CAGA AGAC GACG ACGT CGTT GTTA TTAA TAAA AAAA AAAA AAAC AACA ACAG CAGA AGAT GATG ATGA TGAC GACG ACGT CGTG GTGG TGGA GGAA GAAC AACA ACAA CAAC AACA ACAA CAAT AATA ATAG TAGT AGTG GTGA TGAA GAAC AACA ACAT CATA ATAG TAGA AGAA GAAA AAAC AACA ACAA CAAT AATC ATCA TCAC CACA ACAC CACC ACCA CCAT CATT ATTC TTCA TCAT CATG ATGT TGTT GTTA TTAA TAAC AACA ACAC CACT ACTT CTTG TTGT TGTA GTAC TACT ACTA CTAG TAGA AGAG GAGC AGCC GCCA CCAT CATA ATAC TACG ACGA CGAC GACA ACAC CACA ACAG CAGT AGTT GTTA TTAC TACC ACCA CCAG CAGA AGAG GAGA AGAA GAAC AACC ACCA CCAA CAAA AAAC AACA ACAC CACA ACAT CATC ATCA TCAG CAGA AGAA GAAA AAAA AAAC AACA ACAA CAAA AAAT AATT ATTT TTTG TTGC TGCA GCAT CATC ATCA TCAG CAGA AGAC GACT ACTG CTGC TGCA GCAA CAAC AACA ACAC CACC ACCC CCCT CCTT CTTT TTTT TTTC TTCC TCCC CCCA CCAC CACG ACGC CGCT GCTG CTGA TGAG GAGA AGAT GATT ATTC TTCA TCAA CAAG AAGC AGCA GCAT CATT ATTG TTGC TGCT GCTT CTTC TTCA TCAT CATT,NC_040711.1_12953_13187_0_1_0_0_0:0:0_0:0:0_0/1,Abyssoviridae
  + set -e
  + TAXON_NAME=Abyssoviridae
  + TAXON_SUB_DIR_QFN=Abyssoviridae/validation_reads
  ++ realpath /mnt/d/Projects/ViBE/tools/preprocess_and_label.sh
  + SCRIPT=/mnt/d/Projects/ViBE/tools/preprocess_and_label.sh
  ++ dirname /mnt/d/Projects/ViBE/tools/preprocess_and_label.sh
  + SCRIPTPATH=/mnt/d/Projects/ViBE/tools
  + conda run -n vibe --live-stream python /mnt/d/Projects/ViBE/tools/../scripts/seq2kmer_doc.py -i Abyssoviridae/validation_reads/genome_level_validation_genomes.fasta.test.bwa.read1.fastq -p Abyssoviridae/validation_reads/genome_level_validation_genomes.fasta.test.bwa.read2.fastq -o Abyssoviridae/validation_reads/data.Abyssoviridae.paired.csv -k 4 -f fastq --min-length 150 --max-length 251
  0it [00:00, ?it/s]
  + cat Abyssoviridae/validation_reads/data.Abyssoviridae.paired.csv
  + perl -pe 'if (! /^forward,backward,seqid/) {s/\n/,Abyssoviridae\n/} else {s/\n/,label\n/}'
  + head -2 Abyssoviridae/validation_reads/data.Abyssoviridae.paired.label.csv
  forward,backward,seqid,label
  ...

=head1 VERSION

20250107 00

=cut

my $FLAG_DOWNLOAG_GENOMES = 0;
my $FLAG_SPLIT_GENOMES = 0;
my $FLAG_PREPROCESS_AND_LABEL = 0;

my @preprocess_subfolder_name = qw(training_reads validation_reads validation_reads_read_level);

if (@ARGV < 1) {
  print "\nUsage: $0 <input directory list text>\n";
  exit;
} 
elsif ($ARGV[0] eq '-d') {
  $FLAG_DOWNLOAG_GENOMES = 1;
  shift;
}
elsif ($ARGV[0] eq '-s') {
  $FLAG_SPLIT_GENOMES = 1;
  shift;
}
elsif ($ARGV[0] eq '-p') {
  $FLAG_PREPROCESS_AND_LABEL = 1;
  shift;
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

  # Call Preprocess and Label Script
  if ($FLAG_PREPROCESS_AND_LABEL && -d $dir_qfn) {
    for my $sub_dir_name (@preprocess_subfolder_name) {
      my $sub_dir_qfn = File::Spec->catfile($curdir, $folder_name, $sub_dir_name);
      system("preprocess_and_label.sh", $folder_name, $sub_dir_qfn) 
        if -d $sub_dir_qfn;
    }
  }

}

__END__

=head1 AUTHORS

Bill Ho E<lt>ycho.bill.lab@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2024-2025 by Bill Ho E<lt>ycho.bill.lab@gmail.comE<gt>.

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
