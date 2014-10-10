use strict;
use warnings;
use autodie;

use Test::More;

require_ok("IceExtentData");

{
    # check default attributes
    my $ice_extent_data = IceExtentData->new();
    is($ice_extent_data->north_daily_url(),
        "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/");
    is($ice_extent_data->extent_final_file(), "NH_seaice_extent_final.csv");
    is($ice_extent_data->extent_nrt_file(), "NH_seaice_extent_nrt.csv");
    isa_ok($ice_extent_data->final_data(), 'ARRAY');
    isa_ok($ice_extent_data->nrt_data(), 'ARRAY');
}

{
    my $ice_extent_data = IceExtentData->new();
    my $url = "file:///home/cochrane/Projekte/OSSProjekte/arctic_ice_extent/t/data/";
    $ice_extent_data->north_daily_url($url);
    $ice_extent_data->retrieve();
    ok(@{$ice_extent_data->final_data()} > 0, "Retrieved 'Final' data nonzero");
    ok(@{$ice_extent_data->nrt_data()} > 0, "Retrieved 'NRT' data nonzero");
}

{
    my $ice_extent_data = IceExtentData->new();
    my $url = "file:///home/cochrane/Projekte/OSSProjekte/arctic_ice_extent/t/data/";
    $ice_extent_data->north_daily_url($url);
    $ice_extent_data->retrieve();

    my @data = @{$ice_extent_data->final_data()};
    my $header = 'Year,\s+Month,\s+Day,\s+Extent,\s+Missing,\s+Source Data';
    ok(@data > 0, "data received from final_data()");
    like($data[0], qr/$header/, "final data file header");

    @data = @{$ice_extent_data->nrt_data()};
    ok(@data > 0, "data received from nrt_data()");
    like($data[0], qr/$header/, "nrt data file header");
}

done_testing();

# vim: expandtab shiftwidth=4 softtabstop=4
