#!/usr/bin/perl -w

use strict;

use File::Basename;

my $debugLevel = 0;

my $z = 0;
my $yMin = -1;
my $yMax = +1;
my $zMax=100;
my $zMin=0;

my @ext = ('.set');

if ( $#ARGV != 3 ) {die "Usage: $0 <set template file> <set file name> <2d map file name> <3d map file name>\n";}

my $fullname=$ARGV[0];
my $baseSetFileName=$ARGV[1];
my $map2Dname=$ARGV[2];
my $map3Dname=$ARGV[3];

my $filename;
my $path;
my $suffix;

my $pointHeader = "point_";
my $ELEVHeader = "ELEV";

($filename,$path,$suffix) = fileparse($fullname,@ext);
if ($debugLevel > 0 ) {
  print "Filename = $filename\nPath = $path\nSuffix = $suffix\n";
}

open(TEMPLATE,"$fullname") || die "Unable to open template file $fullname: $?\n";

my @templateLines=<TEMPLATE>;

print "#File produced using the following command:\n";
print "#perl $0 $fullname $baseSetFileName $map2Dname $map3Dname\n";

for $z (0..100) {
  if ($debugLevel > 0 ) {
    print $z."\n";
  }
  my $setFileName = $path.$baseSetFileName."$z".$suffix;
  if ($debugLevel > 0 ) {
    print $setFileName."\n";
  }
  open(SET,">$setFileName") || die "Unable to open set file $setFileName: $?\n";
  for my $templateLine  (@templateLines) {
    chomp $templateLine;
    if ($debugLevel > 0 ) {
      print $templateLine."\n";
    }
    if ( $templateLine =~ $pointHeader ) {
      print SET $templateLine." $z\n";
    } elsif ( $templateLine =~ $ELEVHeader ) {
      my $y = ($yMax-$yMin)*($z-$zMin)/($zMax-$zMin) + $yMin;
      print SET $templateLine." $y\n";
    } else {
      print SET $templateLine."\n";
    }
  
  }
  close (SET);
  print "tonyplot3d -nohw $map3Dname -set $setFileName -cut $map2Dname"."$z".".str\n";
}  
  
close(TEMPLATE);
