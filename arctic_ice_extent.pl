#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Text::CSV_XS;
use LWP::Simple qw( getstore );
use Time::ParseDate qw( parsedate );

sub get_data_from {
    my $csv_file = shift;

    my $csv = Text::CSV_XS->new();

    my %extent_data;
    open my $csv_fh, "<", $csv_file;
    while (my $row = $csv->getline($csv_fh)) {
        $row->[0] =~ m/\d{4}/ or next;
        my $year = int $row->[0];
        my $month = int $row->[1];
        my $day = int $row->[2];
        my $date = sprintf "%04d-%02d-%02d", $year, $month, $day;
        my $ice_extent = $row->[3];
        $ice_extent =~ s/\s+//g;
        $extent_data{$date} = $ice_extent;
    }
    close $csv_fh;

    return (\%extent_data);
}

sub extract_ice_extent_data {
    my $north_daily_url = \
        "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/";
    my $extent_final_file = "NH_seaice_extent_final.csv";
    my $extent_nrt_file = "NH_seaice_extent_nrt.csv";

    # download the data files
    getstore($north_daily_url . $extent_final_file, $extent_final_file);
    getstore($north_daily_url . $extent_nrt_file, $extent_nrt_file);
    
    my $extents_ref = get_data_from($extent_final_file);
    my %extents = %$extents_ref;

    $extents_ref = get_data_from($extent_nrt_file);
    %extents = (%extents, %$extents_ref);

    open my $out_fh, ">", "extent_data.dat";
    my @dates = sort { parsedate($a) <=> parsedate($b) } keys %extents;
    for my $date ( @dates ) {
        print $out_fh $date, " ", $extents{$date}, "\n";
    }
    close $out_fh;
}

extract_ice_extent_data() unless caller();

# vim: expandtab shiftwidth=4 softtabstop=4
