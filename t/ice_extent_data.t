use strict;
use warnings;
use autodie;

use Test::More;

require_ok("IceExtentData");

{
    my $ice_extent_data = IceExtentData->new();
    is($ice_extent_data->extent_final_file(), "NH_seaice_extent_final.csv");
}

done_testing();

# vim: expandtab shiftwidth=4 softtabstop=4
