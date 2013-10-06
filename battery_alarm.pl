#! /usr/bin/perl
# Battery_alarm.pl - A silly script that plays an awful noise when 
# battery charge is under 10%.  

use Modern::Perl;
use Audio::Beep;

while (42) {
    my @paths = ("/sys/class/power_supply/BAT0/charge_now", 
		 "/sys/class/power_supply/BAT0/charge_full",
		 "/sys/class/power_supply/BAT0/status");
    my @values;
    
    for (my $x = 1; $x < 4;  $x++) {
	open(BATT, $paths[$x -1]) 
	    or die "Battery File ($paths[$x -1])not found\n";
	while (<BATT>) {
	    $values[$x -1] = $_;
	}
	close(BATT);
    }
    
    if (($values[0] / $values[1]) * 100 <= 10 && values[2] ne "Charging") {
	my $pid = fork();
	if ($pid == 0) {
	    my $beeper = Audio::Beep->new();
	    my $music = q|
	      g g g dis ais' g dis ais' g e' e e f ais, fis dis ais' 
              g c g'1 g c
              b a g f g gis d c b ais a ais g ais e c g g c b a g f g gis
              |; 
	    $beeper->play($music);
	} else {
	    my $done = 0;
	    my $str;
	    while ($done == 0) {
		open(STATUS, $paths[2]) or die "Could not open $paths[2]\n"; 
		while (<STATUS>) {
		    $str = $_;
		}
		close(STATUS);
		if ($str eq "Unknown\n") {
		    kill 9, $pid;
		    $done = 1;
		}
	    }
	}
    }
    sleep(60);
}

