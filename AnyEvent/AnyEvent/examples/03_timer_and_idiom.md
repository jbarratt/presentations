!SLIDE
# Timers

!SLIDE code
    @@@perl
    my $cv = AE::cv;
    my $spoke = 0;

    my $t1 = AE::timer 0, 2, 
    sub { 
        say "2 second timer"; 
        if($spoke++ > 10) { $cv->send; }
    };

    my $t2; $t2 = AE::timer 0, .5,
    sub { 
        say "1/2 second timer";
        if($spoke++ > 5) { undef $t2; }
    };

    $cv->recv;

!SLIDE commandline
    $ ./04_timer.pl
    2 second timer
    1/2 second timer
    1/2 second timer
    1/2 second timer
    1/2 second timer
    2 second timer
    1/2 second timer
    2 second timer
    2 second timer
    2 second timer
    2 second timer
    2 second timer 

!SLIDE
# Why does the 1/2 second stop?

!SLIDE code
    @@@perl
    # Turn 1 statement into two
    # my $t2 = AE::timer becomes...
    my $t2; $t2 = AE::timer 0, .5,
    sub { 
        say "1/2 second timer";
        if($spoke++ > 5) { 
            # undef'ing AnyEvent objects
            # deletes the event
            undef $t2; 

            # If the callback needs to stop it
            # Needs to be able to refer to it
            # declare in a different statement
        }
    };
    
!SLIDE
# Very common (but confusing) idiom 
