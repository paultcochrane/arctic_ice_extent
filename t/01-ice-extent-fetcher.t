use v6;

use lib 'lib';
use Test;

use-ok('IceExtent::Fetcher');

use IceExtent::Fetcher;

ok(IceExtent::Fetcher.new(), "IceExtent::Fetcher instantiation");

my $fetcher = IceExtent::Fetcher.new();
is($fetcher.base-data-url,
   "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/",
   "base-data-url default path");

# check that data files exist in data directory after download

done;

# vim: expandtab shiftwidth=4 ft=perl6
