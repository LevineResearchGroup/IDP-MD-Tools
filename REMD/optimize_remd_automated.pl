#!/usr/bin/perl

use warnings;
use strict;
use List::Util qw[min max sum]; # Min, Max, and Sum Functions

###############################################################################
#                                    VARS                                     #
###############################################################################

my $count = $ARGV[0]; chomp $count;

# GRAB EXISTING REMD TEMPERATURES
# shell command is: grep ref_t `ls md*.mdp | sort -V` | awk -F "= " '{print $2}' | awk '{ print $1 }'
my $temps = `grep ref_t \`find . \-name mdout.mdp \| sort \-V\` \| awk \-F \"\= \" \'\{print \$2\}\' \| awk \'\{ print \$1 \}\'`;
if($temps){} else{$temps = `grep ref-t \`find . \-name mdout.mdp \| sort \-V\` \| awk \-F \"\= \" \'\{print \$2\}\' \| awk \'\{ print \$1 \}\'`;}
chomp $temps;
my @temps = split("\n",$temps);

# GRAB TRANSITION PROBABILITIES
# Shell command is: sed -n "$[`grep -n "average probabilities" md0.log | awk -F ":" '{print $1}'` + 2]"p md0.log
my $probs = `sed \-n \"\$\[\`grep \-n \"average probabilities\" 0/md.log \| awk \-F \"\:\" \'\{print \$1\}\'\` + 2\]\"p 0/md.log`;
chomp $probs;
my @buffer = split("Repl      ",$probs);
my @probs = split("  ",$buffer[1]);

my $nr_temps = scalar(@temps);
my $nr_probs = scalar(@probs);

my $ideal_prob = 0.25;

my $a; my $b; my $origin; my $flag300=0;
my @temp_diff=(); my @prob_diff=();
my $change=0;
my $distance=1000;
my $list; my $avg; my $stdev=0; my $stdev_sum;

###############################################################################
#                                    MAIN                                     #
###############################################################################

# Open output file
open(OUT, ">>optimization_history.log");
open(OUT2, ">>optimization_prob.log");

# Keep a copy of the original temperatures.
my @orig_temps = @temps;

# Check that for N temperatures we have only N-1 transition probabilities.
if($nr_probs != $nr_temps-1){
print "\n[Error]\nFor N temperatures, please specify exactly N-1 transition probabilities.\n\n";
close (OUT);
die;
}

# Check that 300 K is one of the N temperatures.
for($a=0; $a<$nr_temps; $a++){


# Find the closest temp to 300
if(abs(300 - $temps[$a]) < $distance){
$distance = abs(300 - $temps[$a]);
$origin = $a;
}

# If it is, grab its index.
#   if(($temps[$a] >= 298) && ($temps[$a] < 301)){
#      $origin = $a;
#      $flag300 = 1;
#   }

# While we're at it build a temp_diff matrix and a prob_diff matrix where
# temp_diff = T_i+1 - T_i and prob_diff = P_i - $ideal_prob
  if ($a<$nr_temps-1){
     push(@temp_diff, $temps[$a+1] - $temps[$a]);
#         print "Temp Diff [$a] = ", $temps[$a+1] - $temps[$a], "\t";
#         print OUT "Temp Diff [$a] = ", $temps[$a+1] - $temps[$a], "\t";
     push(@prob_diff, $probs[$a] - $ideal_prob);
#         print "Prob Diff [$a] = ", $probs[$a] - $ideal_prob;
#         print OUT "Prob Diff [$a] = ", $probs[$a] - $ideal_prob;

         if(($temps[$a+1] >= 300) && ($temps[$a+1] < 301)){
#             print "\t300K Origin Left";
#             print OUT "\t300K Origin Left";
             }

         if(($temps[$a] >= 300) && ($temps[$a+1] < 301)){
#            print "\t300K Origin Right";
#            print OUT "\t300K Origin Right";
             }

#         print "\n";
#         print OUT "\n";
  }

}

# If 300 K isn't present, die.
#if($flag300 == 0){
#print "\n[Error]\nOne of the input temperatures must be equal to 300 K.\n\n";
#close (OUT);
#die;
#}

#print "\n";
#print OUT "\n";

# Now search through the the prob_diff matrix and change all |probs| >= 0.04
# i.e., for an ideal prob of 0.25, all probs outside of 0.21 and 0.29.
for($a=0; $a<scalar(@prob_diff); $a++){

# If probability is too low, shrink the temperature difference.
   if($prob_diff[$a] <= -0.04){


# If we're below 300 K...
   if($temps[$a] < 300){

# each temperature below the target is shifted up by 0.2 K.
      $change = 0.2; while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
      for($b=0; $b<=$a; $b++){


        $temps[$b] += $change;


      }


    }

# If we're above 300 K...
   elsif($temps[$a] >= 301){

# Then for each temperature

#        print "decreasing $temps[$b+1] to ";
#        print OUT "decreasing $temps[$b+1] to ";	

        if($temps[$a] <= 310){

	$change = 0.2;         
	for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] -= $change;
	}

        }

        elsif(($temps[$a] > 310) && ($temps[$a] <= 416)){

	$change = 0.5; 
        for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] -= $change; 
	}

        }

        elsif($temps[$a] > 416){

	$change = 1; 
        for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] -= $change; 
	}

        }

#        print "$temps[$b+1], ";
#        print OUT "$temps[$b+1], ";


    }

#print "\n\n";
#print OUT "\n\n"

  }


# If probability is too high, increase the temperature difference.
  elsif(($prob_diff[$a] >= 0.04) && ($prob_diff[$a] < 0.15)){

#      print "Shrinking probability difference $prob_diff[$a] by ";
#      print OUT "Shrinking probability difference $prob_diff[$a] by ";

# If we're below 300 K...
   if($temps[$a] < 300){

# each temperature below the target is shifted up by 0.2 K.
      $change = 0.2; while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
      for($b=0; $b<=$a; $b++){

#        print "decreasing $temps[$b] to ";
#        print OUT "decreasing $temps[$b] to ";

        $temps[$b] -= $change; 

#        print "$temps[$b], ";
#        print OUT "$temps[$b], ";

      }


    }

# If we're above 300 K...
   elsif($temps[$a] >= 301){

# Then for each temperature

#        print "increasing $temps[$b+1] to ";
#        print OUT "increasing $temps[$b+1] to ";	

        if($temps[$a] <= 310){

	$change = 0.2; 
        for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] += $change;
	}
 
        }

        elsif(($temps[$a] > 310) && ($temps[$a] <= 416)){

	$change = 0.5; 
        for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] += $change;
	}

        }

        elsif($temps[$a] > 416){

	$change = 1; 
        for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] += $change; 
	}

        }

#        print "$temps[$b+1], ";
#        print OUT "$temps[$b+1], ";


    }

#print "\n\n";
#print OUT "\n\n"

  }

# If probability is too high, use larger temperature increments.
   elsif($prob_diff[$a] >= 0.15){


#      print "Shrinking probability difference $prob_diff[$a] by ";
#      print OUT "Shrinking probability difference $prob_diff[$a] by ";

# If we're below 300 K...
   if($temps[$a] < 300){

# each temperature below the target is shifted up by 0.2 K.
      $change = 0.75; while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
      for($b=0; $b<=$a; $b++){

#        print "decreasing $temps[$b] to ";
#        print OUT "decreasing $temps[$b] to ";

        $temps[$b] -= $change; 

#        print "$temps[$b], ";
#        print OUT "$temps[$b], ";

      }


    }

# If we're above 300 K...
   elsif($temps[$a] >= 301){

# Then for each temperature

#        print "increasing $temps[$b+1] to ";
#        print OUT "increasing $temps[$b+1] to ";

        if($temps[$a] <= 310){

	$change = 0.75; 
        for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] += $change;
	}

        }

	elsif(($temps[$a] > 310) && ($temps[$a] <= 416)){

	$change = 1; 
        for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] += $change; 
	}

        }

	elsif($temps[$a] > 416){

	$change = 2; 
        for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] += $change;
	}

        }

#        print "$temps[$b+1], ";
#        print OUT "$temps[$b+1], ";




    }


#print "\n\n";
#print OUT "\n\n";

#      print "[WARNING]\nSome of your transition probabilites are more than 15% off target! Using extremely large temperature increments [+/- 2 K].\n\n";

   }


   elsif($prob_diff[$a] <= -0.15){

#      print "Shrinking probability difference $prob_diff[$a] by ";
#      print OUT "Shrinking probability difference $prob_diff[$a] by ";

# If we're below 300 K...
   if($temps[$a] < 300){

# each temperature below the target is shifted up by 0.2 K.
      $change = 0.75; while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
      for($b=0; $b<=$a; $b++){

#        print "decreasing $temps[$b] to ";
#        print OUT "decreasing $temps[$b] to ";

        $temps[$b] += $change; 

#        print "$temps[$b], ";
#        print OUT "$temps[$b], ";

      }


    }

# If we're above 300 K...
   elsif($temps[$a] >= 301){

# Then for each temperature

#        print "increasing $temps[$b+1] to ";
#        print OUT "increasing $temps[$b+1] to ";

        if($temps[$a] <= 310){

	$change = 0.75; 
        for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] -= $change; 
	}
        
	}

	elsif(($temps[$a] > 310) && ($temps[$a] <= 416)){

	$change = 1; 
        for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] -= $change; 
	}        

	}

	elsif($temps[$a] > 416){

	$change = 2; 
        for($b=$a; $b<$nr_temps-1; $b++){
        while(($temps[$a+1] - $temps[$a]) < $change){ $change/=2; }
        $temps[$b+1] -= $change; 
	}

        }

#        print "$temps[$b+1], ";
#        print OUT "$temps[$b+1], ";


    }

#print "\n\n";
#print OUT "\n\n";

#      print "[WARNING]\nSome of your transition probabilites are more than 15% off target! Using extremely large temperature increments [+/- 4 K].\n\n";

   }

}

# Keep a copy of the original temperature differences.
my @orig_temp_diff = @temp_diff;

# Clear current temp_diff array
@temp_diff=();

# And write new temperature differences to the array
for($a=0; $a<$nr_temps; $a++){
  if ($a<$nr_temps-1){
#print "a = $a,\t$temps[$a+1] - $temps[$a]\n";
#     if(($temps[$a+1]-$temps[$a]) <= 0){
#print "Negative or Zero...\n";
#     if($a>$origin){
#print "over\n";
#      for($b=$a+1; $b<$nr_temps; $b++){
#       $temps[$b]-=$orig_temp_diff[$b];
#      }
#     }
#     elsif($a<$origin){
#print "under\n";
#      for($b=0; $b<=$a; $b++){
#       $temps[$b]+=$orig_temp_diff[$b];
#      }
#     }
#     }
#
     push(@temp_diff, sprintf("%.1f", $temps[$a+1]-$temps[$a]));
     }
}


# Now list old values versus new values.

# Header
#print "\nOld_Temp\tOld_Diff\t Prob\t\tNew_Temp\tNew_Diff\n--------\t--------\t ----\t\t--------\t--------\n";
#print OUT "\nOld_Temp\tOld_Diff\t Prob\t\tNew_Temp\tNew_Diff\n--------\t--------\t ----\t\t--------\t--------\n";

# Values
#for($a=0; $a<$nr_temps; $a++){

#if($a==0){
#printf sprintf("%.1f\t\t\t\t\t\t%.1f\t\t", $orig_temps[$a],$temps[$a]);
#printf OUT sprintf("%.1f\t\t\t\t\t\t%.1f\t\t", $orig_temps[$a],$temps[$a]);
#}

#else{
#printf sprintf("%.1f\t\t%.1f\t\t%5.2f\t\t%.1f\t\t%.1f", $orig_temps[$a],$orig_temp_diff[$a-1],$prob_diff[$a-1],$temps[$a],$temp_diff[$a-1]);
#printf OUT sprintf("%.1f\t\t%.1f\t\t%5.2f\t\t%.1f\t\t%.1f", $orig_temps[$a],$orig_temp_diff[$a-1],$prob_diff[$a-1],$temps[$a],$temp_diff[$a-1]);
#}

#print "\n";
#print OUT "\n";

#}

print OUT "\n$count Temps \= ";
for($a=0; $a<$nr_temps; $a++){
 if($a<$nr_temps-1){
  $orig_temps[$a] =~ s/^\s+|\s+$//g;
  printf OUT '%3.2f ',$orig_temps[$a];
 }
 else{
  $orig_temps[$a] =~ s/^\s+|\s+$//g;
  printf OUT '%3.2f ',$orig_temps[$a]; print OUT "\n";
 }
}

$avg = sum(@probs)/scalar(@probs);

print OUT "$count Probs = ";
for($a=0; $a<$nr_temps-1; $a++){
 if($a<$nr_temps-2){
  print OUT "$probs[$a]\t";
  $stdev_sum += ($avg-$probs[$a])**2;
 }
 else{
  print OUT "$probs[$a]\n";
  $stdev_sum += ($avg-$probs[$a])**2;
 }
}

 $stdev = ($stdev_sum/(scalar(@probs)-1))**0.5;
 print OUT2 "$count\t";
 printf OUT2 "%.2f\t%.2f\n", $avg, $stdev; print OUT "\n";

# Finally, write out the new temperature array in Perlspeak...
#print OUT "NEW Temps \= ";
#$list = "my \@temps \= \(";

$list = join ', ', @temps;

for($a=0; $a<$nr_temps; $a++){
 if($a<$nr_temps-1){
  $temps[$a] =~ s/^\s+|\s+$//g;
#  printf OUT '%3.2f ',$temps[$a];
#  $list .= "$temps[$a], ";
 }
 else{
  $temps[$a] =~ s/^\s+|\s+$//g;
#  printf OUT '%3.2f ',$temps[$a];
#  $list	.= "$temps[$a]";
 }
}

#$list = $list . "\)\;";

#print $list,"\n";

close (OUT);
close (OUT2);

system("perl -pi -e 's/^my \\\@temps.*/my \\\@temps \= \( $list \)\;/g' continue_remd.pl");

# END
