use strict;
use warnings;

use lib qw(lib ../lib);
use Test::More tests => 1;

subtest "basic object setup is correct" => sub {
    require_ok('IceExtent::LinearFit');
};

# vim: expandtab shiftwidth=4 softtabstop=4
