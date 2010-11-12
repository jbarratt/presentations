!SLIDE 
# Simple Transactions with '**`begin`**' and '**`end`**' #

!SLIDE code
    @@@perl
    my @tld = qw(com net org mp ly cc co info 
        biz mobi name pro);
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

!SLIDE code
    @@@perl
    my @tld = qw(com net org mp ly cc co info 
        biz mobi name pro);
    # the sync variable
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

!SLIDE code
    @@@perl
    my @tld = qw(com net org mp ly cc co info 
        biz mobi name pro);
    my $cv = AnyEvent->condvar;

    for my $tld (@tld) {
        # outstanding++
        $cv->begin;
        my $zone = "$name.$tld";
        # ... create a callback
        AnyEvent::DNS::a $zone, sub {
            my $ip = shift || "NONE";
            say "$zone => $ip";
            $cv->end;
        };
    }

    $cv->wait;
    say "Transaction complete!";

!SLIDE code
    @@@perl
    my @tld = qw(com net org mp ly cc co info 
        biz mobi name pro);
    my $cv = AnyEvent->condvar;

    for my $tld (@tld) {
        $cv->begin;
        my $zone = "$name.$tld";
        AnyEvent::DNS::a $zone, sub {
            my $ip = shift || "NONE";
            # $zone is in our closure
            say "$zone => $ip";
            # outstanding--
            $cv->end;
        };
    }

    $cv->wait;
    say "Transaction complete!";

!SLIDE code
    @@@perl
    my @tld = qw(com net org mp ly cc co info 
        biz mobi name pro);
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
    # block until outstanding = 0
    $cv->wait;
    say "Transaction complete!";

!SLIDE commandline
    $ ./02_transaction.pl anyevent
    anyevent.mobi => NONE
    anyevent.org => 207.46.222.11
    anyevent.cc => NONE
    anyevent.pro => NONE
    anyevent.name => NONE
    anyevent.co => NONE
    anyevent.com => 97.74.144.133
    anyevent.mp => 199.34.127.242
    anyevent.ly => NONE
    anyevent.net => 193.93.174.26
    anyevent.info => 213.171.192.98
    anyevent.biz => 213.171.195.53
    Transaction complete!

