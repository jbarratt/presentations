!SLIDE bullets
# Common Async Gotchas
* RAM Tradeoff
* All those active conns need to live somewhere
* How many reqs do you send out @ once?
* "Quality Problem"

!SLIDE bullets
# Example: DNS lookups (again)
* 2 Letter domains are rare
* Especially 2 letters + real word
* Who has one but isn't using it?

!SLIDE code small
# What's wrong here?
    @@@perl
    my $cv = AE::cv;

    open(my $fh, "<", '/usr/share/dict/words');

    my $w; $w = AE::io $fh, 0, sub {
        my $name = <$fh>; $name = lc($name);
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
    say "First unresolvable .com in dict: $goodzone";

!SLIDE commandline
# RAM ASPLODE
    $ top
    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
    6141 jbarratt  18  -2  668m 441m  796 D  4.4 88.5   0:14.58 05_handle.pl
    23098 jbarratt  18  -2 28588 1280  472 R  0.5  0.3   0:21.20 screen
    5323 jbarratt  18  -2 29176 1256 1252 S  0.0  0.2   0:13.26 vi                                                                                                    
!SLIDE bullets
* Reading Disk faster than DNS
* Queue DNS lookups
* Connections **and** Callbacks
* Normal (Read, then lookup, then read) avoids
* Solution: **Manage Outstanding Work**

!SLIDE code small
    @@@perl
    my $t; $t = AE::timer 0, 1,
    sub {
        if($outstanding <= MAX_OUTSTANDING/2) {
            say "NEW Watcher on \$fh at byte " . tell($fh);
                   
            my $w; $w = AE::io $fh, 0, sub {
                my $name = <$fh>; $name = lc($name);
                if($outstanding > MAX_OUTSTANDING) {
                    undef $w;
                    say "UNDEF watcher";
                }
                $name =~ s/[^a-z]//g;
                return unless length($name) == 2;
                my $zone = "$name.com";
                $outstanding++;
                AnyEvent::DNS::a $zone, sub {
                    my $ip = shift;
                    $outstanding--;
                    if(!defined($ip)) {
                        $cv->send($zone);
                    }
                }
            };
        } 
    };

!SLIDE commandline
    $ ./06_throttle_io.pl
    NEW Watcher on $fh at byte 0
    UNDEF watcher
    NEW Watcher on $fh at byte 1794
    ... [SNIP]...
    UNDEF watcher
    NEW Watcher on $fh at byte 111833
    UNDEF watcher
    NEW Watcher on $fh at byte 125110
    UNDEF watcher
    First unresolvable .com in input: ds.com

!SLIDE bullets
# Don't Reinvent the Wheel
* Many Core modules have this "for free"
* `AnyEvent::DNS::resolver->max_outstanding(...)`
* `$AnyEvent::HTTP::ACTIVE`
