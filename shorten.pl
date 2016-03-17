#!/usr/bin/perl -w
use strict;
if ($#ARGV != 1 ) {
  die "Usage: $0 <file name> <new file name>\n";
}
my $filename = $ARGV[0];
my $newfilename = $ARGV[1];
print "File to modify is $filename\n";
print "New file is $newfilename\n";

open(INPUT,"$filename") || die "Unable to open input file $filename: $?\n";
open(OUTPUT,">$newfilename") || die "Unable to open output file $newfilename: $?\n";

my @inputlines = <INPUT>;

foreach my $inputline (@inputlines) {
  chomp $inputline;
  if ( $inputline =~ /polygon/ ) {
    print "$inputline\n";
    my @tmpbuff=split(/"/,$inputline);
    my $tmpbuffentries=$#tmpbuff;
    #print $tmpbuffentries." entries\n";
    #print "@tmpbuff\n";
    my $polygonline=$tmpbuff[1];
    my $newline="polygon = \"";
    my @pointsbuff=split(/\s/,$polygonline);
    foreach my $point( @pointsbuff ) {
      my @coordinates = split(/,/,$point);
      my $x=$coordinates[0];
      my $y=$coordinates[1];
      $y *=5/8.;;
      $newline = $newline.$x.",".$y." ";
    }
    chop($newline);
    $newline = $newline."\"";
    print OUTPUT "$newline\n";
  } elsif ( $inputline =~ /y(1|2)/ ) {
    print "$inputline\n";
    my @y1buff=split(/y1=/,$inputline);
    @y1buff=split(/\s+/,$y1buff[1]);
    print "y1=$y1buff[0]\n";
    my $y1val=$y1buff[0];
    my @y2buff=split(/y2=/,$inputline);
    @y2buff=split(/\s+/,$y2buff[1]);
    print "y2=$y2buff[0]\n";
    my $y2val=$y2buff[0];
    my $newy1val=$y1val*5/8.;
    my $newy2val=$y2val*5/8.;
    my $newline=$inputline;
    my $find="y1=$y1val";
    my $replace="y1=$newy1val";
    $newline =~ s/$find/$replace/;
    print "$inputline\n";
    print "$newline\n";
    $find="y2=$y2val";
    $replace="y2=$newy2val";
    $newline =~ s/$find/$replace/;
    print OUTPUT "$newline\n";
  } else {
    print OUTPUT "$inputline\n";
  }
}

close INPUT;
close OUTPUT;
