use strict;
use warnings;

use lib qw(lib ../lib);
use Test::More tests => 2;

require_ok('IceExtent::Data');

subtest "basic object structure set up" => sub {
    plan tests => 4;

    my $data = IceExtent::Data->new;
    isa_ok( $data, 'IceExtent::Data' );
    can_ok( $data, qw(fetch load extract_minima) );

    is $data->archive_fname, "NH_seaice_extent_final.csv",
      "Default archive filename is correct";
    is $data->nrt_fname, "NH_seaice_extent_nrt.csv",
      "Default NRT filename is correct";
};



# vim: expandtab shiftwidth=4 softtabstop=4
