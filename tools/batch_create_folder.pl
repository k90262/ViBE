#!/usr/bin/perl -w
use File::Spec;

=pod

=head1 batch_create_folder.pl

=head2 Syntax

  Usage: perl batch_create_folder.pl <input directory list text>

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
  $ perl batch_create_folder.pl families_of_nidovirales.txt
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
  Create Folder: ./Roniviridae ...Done.
  Create Folder: ./Tobaniviridae ...Skipped. Reason:File exists
  Create Folder: ./Abyssoviridae ...Skipped. Reason:File exists
  
=cut

if (@ARGV != 1) {
   print "\nUsage: $0 <input directory list text>\n";
   exit;
}

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

}
