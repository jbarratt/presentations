!SLIDE 
# Simple Transactions with **`begin`** and **`end`** #

!SLIDE bullets
# For a given name, which TLD's are resolving?
* Want to do a bunch of DNS lookups
* Transaction "complete" when all are done 
* `begin` @ callback creation
* `end` when work is done

!SLIDE code
    @@@perl
    my @tld = qw(com net org mp ly cc co info 
        biz mobi name pro);
    my $cv = AE::cv;

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
    my $cv = AE::cv;

    for my $tld (@tld) {
        $cv->begin; # outstanding++
        my $zone = "$name.$tld"; # create cb
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
    my $cv = AE::cv;

    for my $tld (@tld) {
        $cv->begin;
        my $zone = "$name.$tld";
        AnyEvent::DNS::a $zone, sub {
            my $ip = shift || "NONE";
            say "$zone => $ip"; # in closure
            $cv->end; # outstanding--
        };
    }

    $cv->wait;
    say "Transaction complete!";

!SLIDE code
    @@@perl
    my @tld = qw(com net org mp ly cc co info 
        biz mobi name pro);
    my $cv = AE::cv;

    for my $tld (@tld) {
        $cv->begin;
        my $zone = "$name.$tld";
        AnyEvent::DNS::a $zone, sub {
            my $ip = shift || "NONE";
            say "$zone => $ip";
            $cv->end;
        };
    }

    $cv->wait; # block until outstanding = 0
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

!SLIDE code small
# This works for any batch work
## First Example again...
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

!SLIDE code
# First Example Refactor
    @@@diff
    32d31
    < my $processed = 0;
    34a34
    >     $cv->begin;
    40,43c40
    <         $processed++;
    <         if ( $processed == $count ) {
    <             $cv->send;
    <         }
    ---
    >         $cv->end;
    
