#!/usr/bin/perl

use Modern::Perl;
use AnyEvent::DNS;

my @tld = qw(com net org mp ly cc co info biz mobi name pro);

my $name = $ARGV[0] || die "Usage: [domain name prefix]\n";

my $cv = AnyEvent->condvar;

for my $tld (@tld) {
    $cv->begin;
    my $zone = "$name.$tld";
    AnyEvent::DNS::a $zone, sub {
        my $ip = shift || "NONE";
        say "$zone => $ip";
        $cv->end;
    };
}

$cv->wait;
say "Transaction complete!";
