use strict;
use warnings;

use lib qw(lib ../lib);
use Test::More tests => 3;

BEGIN { use_ok('IceExtent::Fetcher'); }

ok(IceExtent::Fetcher->new, "IceExtent::Fetcher instantiation");

my $fetcher = IceExtent::Fetcher->new;
is($fetcher->base_data_url,
   "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/",
   "base_data_url default path");

# check that data files exist in data directory after download

# vim: expandtab shiftwidth=4 softtabstop=4
