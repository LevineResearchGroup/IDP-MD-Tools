#!/usr/bin/perl

use warnings;
use strict;

###############################################################################
#                                    VARS                                     #
###############################################################################

# NOTE: DO_DSSP YIELDS REVERSE SS! THIS SCRIPT CORRECTS THIS AND
# SUMMARIZES THE OUTPUT (5/13/19).
# Example Usage 'perl analyze_ss.pl ss.xpm [starting_structure].pdb'

my $file = $ARGV[0]; chomp $file;
my $file2 = $ARGV[1]; chomp $file2; # ANY .PDB file to retain original res nrs.

# Quickly grab initial res nrs.
`\$DSSP -i $ARGV[1] -o tmp`; #Set alias for dssp
my $dssp_line_nr = `grep \"\#\" tmp \-n \| awk \'\{print \$1\}\'`;
$dssp_line_nr =~ s/://g; $dssp_line_nr++;
my %resnr; my $counter=0; my $min; my $max;
my $buffer = `tail \-n \+$dssp_line_nr tmp`; `rm tmp`;
my @buffer2 = split(/\n/, $buffer); my $res1; my $res2; my $scratch; my $tmp;
my $dssp_template = "A5 A5 A1000";
foreach(@buffer2){
   ($res1, $res2, $scratch) = unpack($dssp_template,$_);
if(($res1) && ($res2)){
$res1+=0; $res2+=0; $tmp=$res2;
$resnr{$res1} = $res2; if($counter==0){$min=$res2;} elsif($counter>0){$max=$res2;}
}
#elsif(($res1) && !($res2)){
#$res1+=0;
#$resnr{$res1} = $tmp+1;
#}
$counter++;
}

my $cache = `grep -v "\*" $file`;
my @line = split("\n",$cache);
my @characters;
my @ss;
open(OUT, ">dssp_old_reversed.txt");
open(OUT2, ">dssp_old_reversed_summary.txt");
open(OUT3, ">dssp.txt");
open(OUT4, ">dssp_summary.txt");
print OUT "@    world $min, 0, $max, 1\n#Res.\t~\tE\tB\tS\tT\tH\tI\tG\n";
print OUT2 "@    world $min, 0, $max, 1\n#Res.\tIDR\tAlpha\tBeta\n";
print OUT3 "@    world $min, 0, $max, 1\n#Res.\t~\tE\tB\tS\tT\tH\tI\tG\n";
print OUT4 "@    world $min, 0, $max, 1\n#Res.\tIDR\tAlpha\tBeta\n";
my $a; my $z; my $c; my $dis; my $E; my $B; my $S; my $T; my $H; my $I; my $G; my $EQ; my $idr; my $alpha; my $beta; my $count;

for($a=1; $a<scalar(@line); $a++){

$line[$a] =~ s/"//g;
$line[$a] =~ s/,//g;

@characters = split("",$line[$a]);
$dis=0; $E=0; $B=0; $S=0; $T=0; $H=0; $I=0; $G=0; $idr=0; $alpha=0; $beta=0; $count=0;

for($c=0; $c<scalar(@characters); $c++){

if($characters[$c] =~ /~/){ $dis++; $count++;}
if($characters[$c] =~ /E/){   $E++; $count++;}
if($characters[$c] =~ /B/){   $B++; $count++;}
if($characters[$c] =~ /S/){   $S++; $count++;}
if($characters[$c] =~ /T/){   $T++; $count++;}
if($characters[$c] =~ /H/){   $H++; $count++;}
if($characters[$c] =~ /I/){   $I++; $count++;}
if($characters[$c] =~ /G/){   $G++; $count++;}
if($characters[$c] =~ /=/){   $EQ++; $count++;}

}

$ss[$a][0] = $a;
$ss[$a][1] = $dis/$count;
$ss[$a][2] = $E/$count;
$ss[$a][3] = $B/$count;
$ss[$a][4] = $S/$count;
$ss[$a][5] = $T/$count;
$ss[$a][6] = $H/$count;
$ss[$a][7] = $I/$count;
$ss[$a][8] = $G/$count;

$ss[$a][9] = ($dis+$S+$T)/$count;
$ss[$a][10] = ($H+$I+$G)/$count;
$ss[$a][11] = ($E+$B)/$count;

if($resnr{$a}){
printf OUT "%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n##\t%s\n",$resnr{$a},$dis/$count,$E/$count,$B/$count,$S/$count,$T/$count,$H/$count,$I/$count,$G/$count,$a;
printf OUT2 "%s\t%.2f\t%.2f\t%.2f\n##\t%s\n",$resnr{$a},($dis+$S+$T)/$count,($H+$I+$G)/$count,($E+$B)/$count,$a;
}
else{
printf OUT "&\n";
printf OUT2 "&\n";
}

}

for($z=$a-1; $z>0; $z--){
if($resnr{$ss[$a-$z][0]}){
printf OUT3 "%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n##\t%s\n",$resnr{$ss[$a-$z][0]},$ss[$z][1],$ss[$z][2],$ss[$z][3],$ss[$z][4],$ss[$z][5],$ss[$z][6],$ss[$z][7],$ss[$z][8],$ss[$a-$z][0];
printf OUT4 "%s\t%.2f\t%.2f\t%.2f\n##\t%s\n",$resnr{$ss[$a-$z][0]},$ss[$z][9],$ss[$z][10],$ss[$z][11],$ss[$a-$z][0];
}
else{
printf OUT3 "&\n";
printf OUT4 "&\n";
}

}

close(OUT);
close(OUT2);
close(OUT3);
close(OUT4);
