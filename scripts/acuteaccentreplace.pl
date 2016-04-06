#!/usr/bin/perl

use utf8;
use Unicode::Normalize;
use open qw(:std :utf8);

while(<>) {
    my $x=NFD($_);       #Normalization Form D (1)
    $x=~s/\x{301}/'/g;   #substitute acute accents with '
    $x=NFC($x);          #Normalization Form C (1)
    print $x;
}
