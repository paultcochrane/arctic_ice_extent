#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Text::CSV_XS;
use LWP::Simple qw( getstore );
use Time::ParseDate qw( parsedate );
use Chart::Gnuplot;

sub download_extent_data {
    my $north_daily_url = \
        "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/";
    my $extent_final_file = "NH_seaice_extent_final.csv";
    my $extent_nrt_file = "NH_seaice_extent_nrt.csv";

    my $extent_final_url = $north_daily_url . $extent_final_file;
    my $extent_nrt_url = $north_daily_url . $extent_nrt_file;
    my $response = getstore($extent_final_url, $extent_final_file);
    $response = getstore($extent_nrt_url, $extent_nrt_file);

    return ($extent_final_file, $extent_nrt_file);
}

sub get_extents_data {
    my ($extent_final_file, $extent_nrt_file) = @_;

    my $extents_ref = get_data_from($extent_final_file);
    my %extents = %$extents_ref;

    $extents_ref = get_data_from($extent_nrt_file);
    %extents = (%extents, %$extents_ref);

    return \%extents;
}

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

sub save_extent_data {
    my ($dates_ref, $extents_ref) = @_;
    my @dates = @$dates_ref;
    my %extents = %$extents_ref;

    open my $out_fh, ">", "extent_data.dat";
    for my $date ( @dates ) {
        print $out_fh $date, " ", $extents{$date}, "\n";
    }
    close $out_fh;
}

sub plot_sea_ice_extent {
    my ($dates_ref, $extents_ref) = @_;

    my @dates = @$dates_ref;
    my @extents = @$extents_ref;

    my $chart = Chart::Gnuplot->new(
        output => "extents.eps",
        title => "Arctic sea ice extent over time",
        xlabel => "Date",
        ylabel => "Extent (10^6 km)",
        timeaxis => 'x',
        xtics => {
            labelfmt => "%Y-%m-%d",
            rotate => -90,
        },
    );

    my $data_set = Chart::Gnuplot::DataSet->new(
        xdata => \@dates,
        ydata => \@extents,
        style => "lines",
        timefmt => "%Y-%m-%d",
    );

    $chart->plot2d($data_set);
}

sub extract_ice_extent_data {
    my @data_files = download_extent_data();
   
    my $extents_data_ref = get_extents_data(@data_files);
    my %extents_data = %$extents_data_ref;

    my @dates = sort { parsedate($a) <=> parsedate($b) } keys %extents_data;
    save_extent_data(\@dates, \%extents_data);

    my @extents = map { $extents_data{$_} } @dates;
    plot_sea_ice_extent(\@dates, \@extents);
}

extract_ice_extent_data() unless caller();

# vim: expandtab shiftwidth=4 softtabstop=4
