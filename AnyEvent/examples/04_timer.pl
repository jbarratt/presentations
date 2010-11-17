#!/usr/bin/perl

use Modern::Perl;

use AE;


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
