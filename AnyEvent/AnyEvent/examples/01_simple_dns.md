!SLIDE
# ENUF TALK
# MOAR CODE

!SLIDE bullets
# Async DNS lookups

* All of the 4 char domains are taken
* How many of the 6 chars are?

!SLIDE code small
# Synchronous Code
    @@@perl
    my $t_start = AE::time;
    my $live = 0;
    for ( 1 .. $count ) {
        my $random_zone = random_string($zone_size) . ".com";
        my $address = inet_ntoa( 
            inet_aton($random_zone) || INADDR_ANY 
        );
        if ( $address ne "0.0.0.0" ) {
            $live++;
        }
    }
    my $t_sync = AE::time;

!SLIDE code small
# AnyEvent Code
    @@@perl
    my $cv        = AE::cv;
    my $processed = 0;  
    for ( 1 .. $count ) {
        my $zone = random_string($zone_size) . ".com";
        AnyEvent::DNS::a $zone, sub {
            my $ip = shift;
            if ( defined($ip) ) { $live++; }
            $processed++;
            if ( $processed == $count ) {
                $cv->send;
            }
        };
    }
    $cv->recv;
 
!SLIDE code small
# AnyEvent Code
    @@@perl
    my $cv        = AE::cv; #Condition=false
    my $processed = 0; 
    for ( 1 .. $count ) {
        my $zone = random_string($zone_size) . ".com";
        AnyEvent::DNS::a $zone, sub {
            my $ip = shift;
            if ( defined($ip) ) { $live++; }
            $processed++;
            if ( $processed == $count ) {
                $cv->send;
            }
        };
    }
    $cv->recv; #Run event loop until "true" (->send)
   
!SLIDE commandline
# Results

    $ ./01_dns.pl
    Synchronous code did 6.3983 lookups/second
    Async code: 179.2940 lookups/second.
    Overall, for 6 character domains, 0.50% resolved. 
