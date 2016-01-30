use strict;
use warnings;

use lib qw(lib ../lib);
use Test::More;

my $num_tests = 3;
$num_tests = $ENV{RELEASE_TESTING} ? ($num_tests+1) : $num_tests;
plan tests => $num_tests;

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

subtest "local data can be fetched correctly" => sub {
    plan tests => 6;

    my $data = IceExtent::Data->new;
    $data->archive_fname("test_archive_data.csv");
    $data->nrt_fname("test_nrt_data.csv");
    $data->fetch("test_data");

    ok -f $data->archive_fname, "archive extent data file exists";
    ok -f $data->nrt_fname,     "nrt extent data file exists";

    my @archive_stat  = stat $data->archive_fname;
    my $archive_size  = $archive_stat[7];
    my $archive_mtime = $archive_stat[9];
    ok $archive_size > 0, "archive extent data file has nonzero size";
    ok time - $archive_mtime < 60, "archive extent data file is recent";

    my @nrt_stat  = stat $data->nrt_fname;
    my $nrt_size  = $nrt_stat[7];
    my $nrt_mtime = $nrt_stat[9];
    ok $nrt_size > 0, "nrt extent data file has nonzero size";
    ok time - $nrt_mtime < 60, "nrt extent data file is recent";
};

if ($ENV{RELEASE_TESTING}) {
    subtest "remote data can be fetched correctly" => sub {
        plan tests => 6;

        my $data = IceExtent::Data->new;
        $data->fetch;

        ok -f $data->archive_fname, "archive extent data file exists";
        ok -f $data->nrt_fname,     "nrt extent data file exists";

        my @archive_stat  = stat $data->archive_fname;
        my $archive_size  = $archive_stat[7];
        my $archive_mtime = $archive_stat[9];
        ok $archive_size > 0, "archive extent data file has nonzero size";
        ok time - $archive_mtime < 60, "archive extent data file is recent";

        my @nrt_stat  = stat $data->nrt_fname;
        my $nrt_size  = $nrt_stat[7];
        my $nrt_mtime = $nrt_stat[9];
        ok $nrt_size > 0, "nrt extent data file has nonzero size";
        ok time - $nrt_mtime < 60, "nrt extent data file is recent";
    };
}

# vim: expandtab shiftwidth=4 softtabstop=4
