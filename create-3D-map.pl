#!/usr/bin/perl -w

use strict;

my $basename='map_2D_z_';
my $basesuff='_EField.dat';

my $outputFileName="EField-3D-map-rd53a-50x50-100um-fl0-50V-noedge.txt";

open(OUTPUT,">$outputFileName") || die "Unable to open outputFileName file $outputFileName: $?\n";

for ( my $z = 1; $z<100; $z++ ) {
  my $Slice2D = $basename.$z.$basesuff;
  print "$z\t$Slice2D\n";
  open(DATA,"$Slice2D") || die "Unable to open the Slice2D file $Slice2D: $?\n";
  my @Slice2DLines = <DATA>;
  for my $Slice2DLine (@Slice2DLines) {
    chomp( $Slice2DLine );
    my @buff = split( /\s+/, $Slice2DLine );
    my $x = $buff[0];
    my $y = $buff[1];
    my $E = $buff[2];
    print OUTPUT "$x $y $z $E\n";
  }
}
close (OUTPUT);
