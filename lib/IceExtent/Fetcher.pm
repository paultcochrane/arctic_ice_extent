package IceExtent::Fetcher;

use Moo;

has base_data_url => (
    is => 'ro',
    default => "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/",
);

1;

# vim: expandtab shiftwidth=4 softtabstop=4
