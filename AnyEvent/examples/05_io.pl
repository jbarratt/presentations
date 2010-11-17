#!/usr/bin/perl

use Modern::Perl;
use autodie;
use AnyEvent::DNS;

my $cv = AE::cv;

open(my $fh, "<", '/usr/share/dict/words');

my $w; $w = AE::io $fh, 0, sub {
    my $name = <$fh>;
    $name = lc($name);
    $name =~ s/[^a-z]//g;
    return unless length($name) == 2;
    my $zone = "$name.com";
    AnyEvent::DNS::a $zone, sub {
        my $ip = shift;
        if(!defined($ip)) {
            $cv->send($zone);
        }
    }
};

my $goodzone = $cv->recv;
say "First unresolvable .com in input: $goodzone.com";
