use strict;
use warnings;

use lib qw(lib ../lib);
use Test::More import => [qw( can_ok is is_deeply isa_ok ok plan require_ok subtest )];

use List::MoreUtils qw( none only_index );

my $num_tests = 7;
$num_tests = $ENV{RELEASE_TESTING} ? ( $num_tests + 1 ) : $num_tests;
plan tests => $num_tests;

require_ok('IceExtent::Data');

subtest "basic object structure set up" => sub {
    plan tests => 3;

    my $data = IceExtent::Data->new;
    isa_ok( $data, 'IceExtent::Data' );
    can_ok( $data, qw(fetch load extract_minima) );

    is $data->archive_fname, "N_seaice_extent_daily_v3.0.csv",
      "Default archive filename is correct";
};

subtest "local data can be fetched correctly" => sub {
    plan tests => 3;

    my $data = IceExtent::Data->new;
    $data->archive_fname("test_archive_data.csv");
    $data->fetch("test_data");

    ok -f $data->archive_fname, "archive extent data file exists";

    my @archive_stat  = stat $data->archive_fname;
    my $archive_size  = $archive_stat[7];
    my $archive_mtime = $archive_stat[9];
    ok $archive_size > 0, "archive extent data file has nonzero size";
    ok time - $archive_mtime < 60, "archive extent data file is recent";
};

if ( $ENV{RELEASE_TESTING} ) {
    subtest "remote data can be fetched correctly" => sub {
        plan tests => 3;

        my $data = IceExtent::Data->new;
        $data->fetch;

        ok -f $data->archive_fname, "archive extent data file exists";

        my @archive_stat  = stat $data->archive_fname;
        my $archive_size  = $archive_stat[7];
        my $archive_mtime = $archive_stat[9];
        ok $archive_size > 0, "archive extent data file has nonzero size";
        ok time - $archive_mtime < 60, "archive extent data file is recent";
    };
}

subtest "data can be loaded from file correctly" => sub {
    plan tests => 4;

    my $data = IceExtent::Data->new;
    $data->archive_fname("test_archive_data.csv");
    $data->fetch("test_data");

    is_deeply $data->extents, [], "Extents array is empty before loading data";
    is_deeply $data->dates,   [], "Dates array is empty before loading data";
    $data->load;

    my @expected_dates   = ( '1978-10-26', '1978-10-28' );
    my @expected_extents = ( 10.231,       10.42 );
    my @range            = 0 .. 1;
    my @dates            = @{ $data->dates }[@range];
    my @extents          = @{ $data->extents }[@range];
    is_deeply \@dates, \@expected_dates, "Dates info contains expected data";
    is_deeply \@extents, \@expected_extents,
      "Extents info contains expected data";
};

subtest "minima can be extracted from extents data" => sub {
    plan tests => 5;

    my $data = IceExtent::Data->new;
    $data->archive_fname("test_archive_data.csv");
    $data->fetch("test_data");
    $data->load;

    my ( $years, $minima ) = $data->extract_minima;
    ok @{$years} > 0,  "Years data extracted for minima";
    ok @{$minima} > 0, "Minima data extracted";

    is $years->[0],  1978,   "First year is correct";
    is $minima->[0], 10.231, "First minimum value is correct";

    my $minimum_2013_index = only_index { $_ == 2013 } @{$years};
    is $minima->[$minimum_2013_index], 5.040, "Minimum for 2013 correct";
};

subtest "pruning superfluous data works correctly" => sub {
    plan tests => 1;

    my $data = IceExtent::Data->new;
    $data->archive_fname("test_archive_data.csv");
    $data->fetch("test_data");
    $data->load;
    $data->prune( [ 1978, 2014 ] );

    my $dates_are_pruned = none { $_ =~ /^(1978|2014)/ } @{ $data->dates };
    ok $dates_are_pruned,
      "Data from the years 1978 and 2014 successfully pruned";
};

subtest "current year can be found from data" => sub {
    plan tests => 1;

    my $data = IceExtent::Data->new;
    $data->archive_fname("test_archive_data.csv");
    $data->fetch("test_data");
    $data->load;
    my $current_year = $data->current_year;

    is $current_year, 2014, "Current year value is correct";
};

# vim: expandtab shiftwidth=4 softtabstop=4
