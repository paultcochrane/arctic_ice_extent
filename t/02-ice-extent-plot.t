use warnings;
use strict;

use lib qw(lib ../lib);
use Test::More tests => 1;

subtest "basic object structure set up" => sub {
    plan tests => 2;

    require_ok('IceExtent::Plot');
    can_ok('IceExtent::Plot', qw(plot save));
};

# vim: expandtab shiftwidth=4 softtabstop=4
