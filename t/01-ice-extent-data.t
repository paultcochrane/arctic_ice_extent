use strict;
use warnings;

use lib qw(lib ../lib);
use Test::More tests => 3;

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

subtest "data can be downloaded correctly" => sub {
    plan tests => 6;

    my $data = IceExtent::Data->new;
    $data->fetch;

    ok -f "NH_seaice_extent_final.csv", "final extent data file exists";
    ok -f "NH_seaice_extent_nrt.csv",   "nrt extent data file exists";

    my @final_stat  = stat "NH_seaice_extent_final.csv";
    my $final_size  = $final_stat[7];
    my $final_mtime = $final_stat[9];
    ok $final_size > 0, "final extent data file has nonzero size";
    ok time - $final_mtime < 60, "final extent data file is recent";

    my @nrt_stat  = stat "NH_seaice_extent_nrt.csv";
    my $nrt_size  = $nrt_stat[7];
    my $nrt_mtime = $nrt_stat[9];
    ok $nrt_size > 0, "nrt extent data file has nonzero size";
    ok time - $nrt_mtime < 60, "nrt extent data file is recent";
};

# vim: expandtab shiftwidth=4 softtabstop=4
