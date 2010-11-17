!SLIDE bullets
# Simple HTTP example
* How much of the "oldschool" jargon is still in play?
* [ESR's Jargon File](http://www.catb.org/jargon/)
* How many hits/word on google?
* Queue control "for free" from `AE::HTTP`

!SLIDE code small
    @@@perl
    http_get $jargon, sub {
        my ($body) = shift;
        for my $term (split(/\n/, $body)) {
            say "searching for $term";
            $cv->begin;
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
        }
    };

!SLIDE bullets
# Still going strong...
* for free: 1230000000
* comment out: 879000000
* download: 354000000
* for values of: 343000000
* by hand: 309000000
* face time: 238000000

!SLIDE bullets
# RIP
* VAXectomy: 35
* cruftsmanship: 82
* featurectomy: 84
* Godzillagram: 85
* pseudosuit: 103
* CrApTeX: 126


