!SLIDE
# Basic Usages

!SLIDE code
# i/o
    @@@perl
    # $w = AE::io $fh_or_fd, $watch_write, $cb
    my $w = AE::io $fh, 0,
        sub { warn '$fh is readable; };
    my $w = AE::io $fh, 1,
        sub { warn '$fh is writable'; };
 
!SLIDE code
# Timers
    @@@perl
    # $w = AE::timer $after, $interval, $cb
    # If $interval is 0, then the callback 
    # will only be invoked once
    my $w = AE::timer 1,0,
        sub { warn 'every 1 second'; };
    my $w = AE::timer 0,1,
        sub { warn 'every 1 second'; };

!SLIDE code
# Signals and Condvars
    @@@perl
    # $w = AE::signal $signame, $cb
    my $w = AE::signal
        TERM => sub { warn 'TERM received'; };

    $cv = AE::cv;
    # $cv = AE::cv { BLOCK }

!SLIDE code
# Time and Idle
    @@@perl
    # Return the current time 
    say "At the tone, " . AE::time;

    my $w = AE::idle {
        warn 'Event loop is idle';
    };

!SLIDE bullets
# Other Powertools
* `AnyEvent::DNS`
* `AnyEvent::HTTP`
* `AnyEvent::Handle`
* `AnyEvent::Socket`

!SLIDE code
    @@@perl
    # From AnyEvent::Socket
    tcp_connect localhost => 22, sub {
      my $fh = shift
         or die "unable to connect: $!";
      # do something
    };
