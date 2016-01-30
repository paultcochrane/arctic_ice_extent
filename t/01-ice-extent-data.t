use strict;
use warnings;

use lib qw(lib ../lib);
use Test::More tests => 2;

require_ok('IceExtent::Data');

subtest "basic object structure set up" => sub {
    my $data = IceExtent::Data->new;
    isa_ok($data, 'IceExtent::Data');

    can_ok($data, qw(fetch load extract_minima));
}

# vim: expandtab shiftwidth=4 softtabstop=4
