#!/usr/bin/perl

use warnings;
use strict;

# Usage: perl continue_remd.pl
# Output: optimization_history.log and optimization_prob.log
#
# Note: Only run continue_remd.pl one directory below template run-input files.
# e.g. in /<template_files_here>/continue_remd.pl
#
# Template files are just one set of standard run-input files. Good only for
# simulations with one temperature-coupling group (e.g. System).

###############################################################################
#                                    VARS                                     #
###############################################################################

#`source ~/.bashrc`;

# If you like you can manually enter REMD temperatures (in K) here.
my @temps = ( 289.45, 292.05, 294.8, 297.4, 300, 302, 304.6, 307.4, 310.4, 313.4, 316.4, 319.4, 322.9, 326.4, 329.4, 332.4, 335.9, 338.9, 342.4, 345.4, 348.4, 352.4, 355.4, 358.4, 362.4, 365.9, 369.4, 373.4, 377.4, 381.4, 385.4, 389.4, 393.4, 397.9, 401.9, 406.4, 410.9, 415.4, 419.9, 424.4, 429.4, 434.4, 439.4, 443.4, 448.4, 453.4, 458.4, 464.4, 469.4, 474.4, 479.4, 485.4, 491.4, 498.4, 503.4, 509.4, 515.4, 521.4, 527.4, 534.4, 540.4, 547.4, 554.4, 561.4, 569.4, 576.4, 584.4, 592.4 );

my $nr_temps = scalar(@temps);
my $a;
my $temp;

my @dirs = ("../6_heating");

my $nr_dirs = scalar(@dirs);

# Specify the absolute path to grompp_mpi
my $grompp = "gmx grompp";

#my $gro_file;
my $rand;

###############################################################################
#                                    MAIN                                     #
###############################################################################

# Return an error if you only enter one temperature.
if($nr_temps == 1){
  print "\n[Error] Only one temperature specified! Please specify at least two temperatures.\n\n";
  die;
}

# Open output file
open(OUT, ">setup_remd.log");

# If multiple temperatures are entered, display them.
if($nr_temps > 1){
  print "\nSetting up REMD with Temperatures:\n";
  print OUT "\nSetting up REMD with Temperatures:\n";
  for($a=0; $a<$nr_temps; $a++){
  print "$temps[$a] K\n";
  print OUT "$temps[$a] K\n";
  }
  print "\n\n";
  print OUT "\n\n";
}

# Else, generate temperatures by asking the user.
else{

  print "\nNo pre-selected temperatures found.\n\n";
  print "Please enter the lowest temperature (in K) you would like:\n";
  my $lower_temp = <STDIN>;
  chomp $lower_temp;
  exit 0 if ($lower_temp eq "");
  print "Please enter the highest temperature (in K) you would like:\n";
  my $upper_temp = <STDIN>;
  chomp $lower_temp;
  exit 0 if ($lower_temp eq "");
  print "Please enter the temperature difference (in K) you would like:\n";
  my $diff_temp = <STDIN>;
  chomp $lower_temp;
  exit 0 if ($lower_temp eq "");
  
  $nr_temps = (($upper_temp-$lower_temp)/$diff_temp)+1;
  @temps=(); $a=0;
  
  while($a<=$upper_temp){
  $temp = $lower_temp+$a;
  push(@temps, $temp);
  $a+=$diff_temp 
  }

  print "\nSetting up REMD with Temperatures:\n";
  print OUT "\nSetting up REMD with Temperatures:\n";
  for($a=0; $a<$nr_temps; $a++){
  print "$temps[$a] K\n";
  print OUT "$temps[$a] K\n";
  }
  print "\n\n";
  print OUT "\n\n";
}


print "Creating REMD mdp files...\n\n";
print OUT "Creating REMD mdp files...\n\n";

print "Copying files over to new directories yeeet yeeet :)...\n\n";

#`cp $dirs[0]/index.ndx ./index.ndx` ;
#`cp $dirs[0]/topol.top ./topol.top` ;
#`cp -r $dirs[0]/charmm36-jul2021.ff ./` ;
#`cp $dirs[0]/*.itp ./` ;
#`cp $dirs[0]/*.prm ./` ;
#`cp $dirs[0]/grompp$a\.mdp ./grompp$a\.mdp`;

# Now grab the mdp file and edit them sequentially.
for($a=0; $a<$nr_temps; $a++){

#`mkdir $a` ;
#`cp $dirs[0]/$a/grompp$a\.mdp ./$a/grompp$a\.mdp` ;
##`cp $dirs[0]/$a/traj_comp.xtc ./$a/traj_comp.xtc` ;
#`cp $dirs[0]/$a/confout.gro ./$a/confout.gro` ;
#`cp grompp.mdp $a/grompp$a\.mdp` ;

`perl -pi -e 's/^ref_t.*/ref-t                    = $temps[$a] $temps[$a] $temps[$a]/g' $a/grompp$a\.mdp`;
`perl -pi -e 's/^ref-t.*/ref-t                    = $temps[$a] $temps[$a] $temps[$a]/g' $a/grompp$a\.mdp`;
`perl -pi -e 's/^gen_vel.*/gen-vel                    = no/g' $a/grompp$a\.mdp`;
`perl -pi -e 's/^gen-vel.*/gen-vel                    = no/g' $a/grompp$a\.mdp`;
`perl -pi -e 's/^nsteps.*/nsteps                    = 500000/g' $a/grompp$a\.mdp`;
`perl -pi -e 's/^Pcoupl .*/Pcoupl                   = No/g' $a/grompp$a\.mdp` ;
`perl -pi -e 's/^gen_temp.*/gen_temp                 = $temps[$a]/g' $a/grompp$a\.mdp`;
`perl -pi -e 's/^nstxout-compressed.*/nstxout-compressed	 = 0/g' $a/grompp$a\.mdp`;
`perl -pi -e 's/^tcoupl.*/tcoupl                   = nose-hoover/g' $a/grompp$a\.mdp`;
`perl -pi -e 's/^nstcomm.*/nstcomm                  = 1500/g' $a/grompp$a\.mdp`;
`perl -pi -e 's/^nstlog.*/nstlog                   = 3000/g' $a/grompp$a\.mdp`;
`perl -pi -e 's/^nstcalcenergy.*/nstcalcenergy            = 1500/g' $a/grompp$a\.mdp`;
`perl -pi -e 's/^nstenergy.*/nstenergy                = 3000/g' $a/grompp$a\.mdp`;
#`perl -pi -e 's/^nstlist.*/nstlist                  = 10/g' $a/grompp$a\.mdp`;

}

print "Running grompp at each temperature...\n\n";
print OUT "Running grompp at each temperature...\n\n";

my $name;
# Run grompp_mpi
for($a=0; $a<$nr_temps; $a++){

#`mkdir $a`;
`$grompp -f $a/grompp$a\.mdp -p topol.top -c $a/confout.gro -n index.ndx -o $a/topol.tpr -po $a/mdout.mdp`;
}

# Remove temporary files
`rm *.*# 2>&1`;
`rm *.*~ 2>&1`;
`rm mdout.mdp 2>&1`;
close (OUT);

