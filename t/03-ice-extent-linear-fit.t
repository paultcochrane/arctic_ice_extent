use strict;
use warnings;

use lib qw(lib ../lib);
use Test::More tests => 1;

subtest "basic object setup is correct" => sub {
    plan tests => 3;

    require_ok('IceExtent::LinearFit');
    can_ok('IceExtent::LinearFit', qw(params));
    isa_ok(IceExtent::LinearFit->new, 'IceExtent::LinearFit');
};

# vim: expandtab shiftwidth=4 softtabstop=4
