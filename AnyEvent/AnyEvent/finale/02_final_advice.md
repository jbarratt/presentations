!SLIDE
# Things To Keep In Mind when using AnyEvent

!SLIDE bullets
# **Never** wait the old way
* A single sync wait will stall the event loop

!SLIDE code
    @@@perl
    # Fire every second...?
    my $t = AE::timer 0, 1,
        sub { 
            sleep(3);
            say "nice nap!";
        };
    # NOPE!
    # Whole loop is stalled

!SLIDE bullets
# Protect your RAM
* What can queue, in what conditions?
* What callbacks are you creating and how long will they live?
* What needs to be limited?
* What can you `undef` (shut down) and when?
