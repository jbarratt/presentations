!SLIDE 
# AnyEvent #

!SLIDE 
# "DBI for Events"

!SLIDE
# TMTOWTDI Redux

# POE, IO::Async, Danga::Socket, IO::Lambda, Event, Event::Lib, EV, Glib, Qt, Tk

!SLIDE
# Remember the "main loop"?
# You only get one.

!SLIDE bullets
# AnyEvent

* Use any loaded event loop
* No loop? Start an [EV](http://search.cpan.org/perldoc?EV)
* Very fast, very memory efficient
* Perl wrapper on `libev`

!SLIDE
# One Module, 2 APIs

!SLIDE bullets
# AnyEvent

* The original
* More Verbose
* Uses methods vs functions
* (nominally) Slower

!SLIDE code
    @@@perl
    $w = AnyEvent->timer (
        after    => <fractional_seconds>,
        interval => <fractional_seconds>,
        cb       => <callback>,
    );

!SLIDE bullets
# AE

* Functions = static type checking
* Less verbose
* Faster (2x)
* Incomplete (barely.)

!SLIDE code
    @@@perl
    $w = AE::timer $seconds, $interval, 
        sub { ... };

!SLIDE
# I will use AE today.
### (*Fits on slides better.*)

!SLIDE bullets
# AnyEvent Basics

* Fancy Event Tracking system
* i/o, timers, signals, processes (fork, etc)
* API = how to create/manage these


!SLIDE bullets
# Concept: Condition Variables

* "Condition that's initially false"
* Merge Points, Sync Points
* Basic Messaging
* `AnyEvent->condvar` or `AE::cv`
