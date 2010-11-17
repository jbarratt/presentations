#!/usr/bin/perl

use Modern::Perl;

use JSON;
use AnyEvent::HTTP;
use URI::Escape;
use Data::Dumper;

my $cv = AE::cv;
my $jargon = "http://www.catb.org/~esr/jargon/oldversions/wordlist2912";

my %terms = ();

http_get $jargon, sub {
    my ($body) = shift;
    for my $term (split(/\n/, $body)) {
        say "searching for $term";
        $cv->begin;
        http_get "https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=" . uri_escape($term),
            sub {
                my ($body) = shift;
                my $data = from_json($body);
                my $results = $data->{responseData}{cursor}{estimatedResultCount};
                if(defined($results)) {
                    $terms{$term} = $results;
                    say "\t$term => $results";
                }
                $cv->end;
            };
    }
};

$cv->recv;

print "Top 20:\n";
print join("\n", 
    map { "$_: $terms{$_}" }
    (sort { $terms{$b} <=> $terms{$a} } keys %terms)[0 .. 20]
) . "\n\n";

print "Bottom 20:\n";
print join("\n", 
    map { "$_: $terms{$_}" }
    (sort { $terms{$a} <=> $terms{$b} } keys %terms)[0 .. 20]
) . "\n";
