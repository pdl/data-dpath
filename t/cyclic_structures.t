#! /usr/bin/env perl

use 5.010;
use strict;
use warnings;
use Test::More tests => 3;
use Test::Deep;
use Data::DPath::Fast 'dpath';
use Data::Dumper;

# local $Data::DPath::Fast::DEBUG = 1;

BEGIN {
	use_ok( 'Data::DPath::Fast' );
}

my $data = {};

$data->{AAA} = { BBB   => { CCC  => [ qw/ XXX YYY ZZZ / ] },
                 RRR   => { CCC  => [ qw/ RR1 RR2 RR3 / ] },
                 DDD   => { EEE  => [ qw/ uuu vvv www / ] },
               };
$data->{point} = { to => { ourself => $data } };

my @resultlist;
my $resultlist;
my $context;

# trivial matching

@resultlist = dpath('/AAA/BBB/CCC')->match($data);
cmp_bag(\@resultlist, [ ['XXX', 'YYY', 'ZZZ'] ], "ROOT + KEYs in cyclic structure" );

SKIP:
{
        skip "No recursion detection yet.", 1;
        @resultlist = dpath('//AAA/BBB/CCC')->match($data);
        cmp_bag(\@resultlist, [ ['XXX', 'YYY', 'ZZZ'] ], "ANYWHERE + KEYs in cyclic structure" );
}

