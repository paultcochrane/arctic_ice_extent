use v6;

use lib 'lib';
use Test;

use-ok('IceExtent::Fetcher');

use IceExtent::Fetcher;

ok(IceExtent::Fetcher.new(), "IceExtent::Fetcher instantiation");

done;

# vim: expandtab shiftwidth=4 ft=perl6
