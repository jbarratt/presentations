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
* for free: 1,230,000,000
* comment out: 879,000,000
* download: 354,000,000
* for values of: 343,000,000
* by hand: 309,000,000
* face time: 238,000,000

!SLIDE bullets
# RIP
* VAXectomy: 35
* cruftsmanship: 82
* featurectomy: 84
* Godzillagram: 85
* pseudosuit: 103
* CrApTeX: 126


