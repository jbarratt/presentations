#!/usr/bin/perl

use Modern::Perl;
use autodie;
use AnyEvent::DNS;

# stupid-low to prove a point
use constant MAX_OUTSTANDING => 4;

my $cv = AE::cv;


open(my $fh, "<", '/usr/share/dict/words');
my $outstanding = 0;

my $t; $t = AE::timer 0, 1,
    sub {
        if($outstanding <= MAX_OUTSTANDING/2) {
            say "NEW Watcher on \$fh at byte " . tell($fh);
                   
            my $w; $w = AE::io $fh, 0, sub {
                my $name = <$fh>;
                if($outstanding > MAX_OUTSTANDING) {
                    undef $w;
                    say "UNDEF watcher";
                }
                $name = lc($name);
                $name =~ s/[^a-z]//g;
                return unless length($name) == 2;
                my $zone = "$name.com";
                $outstanding++;
                AnyEvent::DNS::a $zone, sub {
                    my $ip = shift;
                    $outstanding--;
                    #say "$zone => $ip";
                    if(!defined($ip)) {
                        $cv->send($zone);
                    }
                }
            };
        } 
    };

my $goodzone = $cv->recv;
say "First unresolvable .com in input: $goodzone";
