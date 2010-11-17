#!/usr/bin/perl

use Modern::Perl;
use Socket;    # for inet_ntoa
use AnyEvent::DNS;

my $count     = 1_000;
my $zone_size = 6;

say "Testing Synch/Async Lookups of $count random $zone_size character .com domains";

my $t_start = AE::time;

my $live = 0;
for ( 1 .. $count ) {
    my $random_zone = random_string($zone_size) . ".com";
    my $address = inet_ntoa( inet_aton($random_zone) || INADDR_ANY );
    if ( $address ne "0.0.0.0" ) {
        $live++;
    }
}
my $t_sync = AE::time;
printf( "Synchronous code did %0.4f lookups/second\n",
    $count / ( $t_sync - $t_start ) );

AnyEvent::DNS::resolver->max_outstanding($count)
    ;    # excessive, but should find the upper bound

$t_sync = AE::time;

my $cv        = AE::cv;
for ( 1 .. $count ) {
    my $zone = random_string($zone_size) . ".com";
    $cv->begin;
    AnyEvent::DNS::a $zone, sub {
        my $ip = shift;
        if ( defined($ip) ) {
            $live++;
        }
        $cv->end;
    };
}

$cv->recv;

my $t_async = AE::time;
printf(
    "Async code: %0.4f lookups/second.\nOverall, for %d character domains, %0.2f%% were valid.\n",
    $count / ( $t_async - $t_sync ),
    $zone_size, ( $live / ( $count * 2 ) ) * 100
);

sub random_string {
    return join( "", map { chr( int( rand(26) ) + 97 ) } ( 1 .. $_[0] ) );
}

