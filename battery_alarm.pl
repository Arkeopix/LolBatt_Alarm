#! /usr/bin/perl
# Battery_alarm.pl - A silly script that plays an awful noise when 
# battery charge is under 10%.  

use Modern::Perl;
use Audio::Beep;

#while (42) {
    my @paths = ("/sys/class/power_supply/BAT0/charge_now", 
		 "/sys/class/power_supply/BAT0/charge_full");
    my @values;
    
    for (my $x = 1; $x < 3; $x++) {
	open(BATT, $paths[$x -1]) or die "Battery File not found\n";
	while (<BATT>) {
	    $values[$x -1] = $_;
	}
	close(BATT);
    }
    
    my $res = ($values[0] / $values[1]) * 100;
    print $res, "\n";

    if (($values[0] / $values[1]) * 100 <= 10) {
	my $beeper = Audio::Beep->new();
	my $music = q|
	g g g d|; 
	$beeper->play($music);
}
 #   sleep(60);
#}
    
