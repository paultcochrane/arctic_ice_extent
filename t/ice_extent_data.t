use strict;
use warnings;
use autodie;

use Test::More;

require_ok("IceExtentData");

{
    my $ice_extent_data = IceExtentData->new();
    is($ice_extent_data->extent_final_file(), "NH_seaice_extent_final.csv");
    is($ice_extent_data->extent_nrt_file(), "NH_seaice_extent_nrt.csv");
    isa_ok($ice_extent_data->final_data(), 'ARRAY');
}

done_testing();

# vim: expandtab shiftwidth=4 softtabstop=4
