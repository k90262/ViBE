#!/usr/bin/perl -w
use Test::Simple tests => 1;

system("perl ./batch_create_folder.pl test_folder_list.txt");
ok(-d "test_folder_1" && -d "test_folder_2");

rmdir("test_folder_1") or die $!;
rmdir("test_folder_2") or die $!;
