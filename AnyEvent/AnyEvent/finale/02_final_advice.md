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

!SLIDE bullets
# Testing == HARD(er)
* `say` and `print`
* "integration" testing
* Factor 'work' out of 'events'
* Local state in modules

!SLIDE code small
    @@@perl
    http_get "https://ajax.googleapis.com/ajax/" . 
    "services/search/web?v=1.0&q=" . 
        uri_escape($term),
    sub {
        my ($body) = shift;
        my $data = from_json($body);
        my $results 
            = $data->{responseData} 
                {cursor}{estimatedResultCount};
        if(defined($results)) {
            $terms{$term} = $results;
            say "\t$term => $results";
        }
        $cv->end;
    };

!SLIDE code
    @@@perl
    http_get google_search_uri($term),
        sub {
            my($body) = shift;
            handle_search_res($body);
            $cv->end;
        };

!SLIDE
# Avoid Callback Spaghetti

!SLIDE code
    @@@perl
    http_get $uri,
        sub {
            my ($body) = shift;
            for $link (parse($body)->links) {
                http_get $link,
                    sub {
                        my ($body) = shift;
                        ....
                    };
            }
        };
