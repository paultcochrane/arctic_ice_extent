#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Text::CSV_XS;
use LWP::Simple qw( getstore is_error );
use Chart::Gnuplot;

sub download_extent_data {
    my $north_daily_url =
        "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/";
    my $extent_final_file = "NH_seaice_extent_final.csv";
    my $extent_nrt_file = "NH_seaice_extent_nrt.csv";

    my $extent_final_url = $north_daily_url . $extent_final_file;
    my $extent_nrt_url = $north_daily_url . $extent_nrt_file;
    my $response = getstore($extent_final_url, $extent_final_file);
    warn "Download of $extent_final_file failed" if is_error($response);
    $response = getstore($extent_nrt_url, $extent_nrt_file);
    warn "Download of $extent_nrt_file failed" if is_error($response);

    return ($extent_final_file, $extent_nrt_file);
}

sub get_extents_data {
    my ($extent_final_file, $extent_nrt_file) = download_extent_data();

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
        terminal => "png size 1024,768",
        output => "extents.png",
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

sub extract_minima {
    my ($dates_ref, $extents_data_ref) = @_;
    my @dates = @$dates_ref;
    my %extents_data = %$extents_data_ref;

    my %minima;
    for my $date ( @dates ) {
        $date =~ m/^(\d{4})/;
        my $year = $1;
        my $extent = $extents_data{$date};
        $minima{$year} = 100 if not defined $minima{$year};
        $minima{$year} = $extent if $extent < $minima{$year};
    }

    # the first and last minima are outliers and should be ignored
    my @years = sort keys %minima;
    delete $minima{$years[0]};
    delete $minima{$years[-1]};

    return \%minima;
}

sub save_minima_data {
    my ($years_ref, $minima_ref) = @_;
    my @years = @$years_ref;
    my %minima = %$minima_ref;

    open my $out_fh, ">", "minima.dat";
    for my $year ( @years ) {
        print $out_fh $year, " ", $minima{$year}, "\n";
    }
    close $out_fh;
}

sub plot_extent_minima {
    my ($years_ref, $minima_ref) = @_;

    my @years = @$years_ref;
    my @minima = @$minima_ref;

    my $chart = Chart::Gnuplot->new(
        terminal => "png size 1024,768",
        output => "minima.png",
        title => "Arctic sea ice extent minima over time",
        xlabel => "Year",
        ylabel => "Extent (10^6 km)",
        timeaxis => 'x',
        xtics => {
            labelfmt => "%Y",
            rotate => -90,
        },
    );

    my $data_set = Chart::Gnuplot::DataSet->new(
        xdata => \@years,
        ydata => \@minima,
        style => "lines",
        timefmt => "%Y",
    );

    $chart->plot2d($data_set);
}

sub extract_ice_extent_data {
    my $extents_data_ref = get_extents_data();
    my %extents_data = %$extents_data_ref;

    my @dates = sort {
        my ($year_a, $month_a, $day_a) = split /-/, $a;
        my ($year_b, $month_b, $day_b) = split /-/, $b;
        $year_a <=> $year_b || $month_a <=> $month_b || $day_a <=> $day_b;
        } keys %extents_data;
    save_extent_data(\@dates, \%extents_data);

    my @extents = map { $extents_data{$_} } @dates;
    plot_sea_ice_extent(\@dates, \@extents);

    my $minima_ref = extract_minima(\@dates, \%extents_data);
    my %minima = %$minima_ref;

    my @years = sort keys %minima;
    save_minima_data(\@years, \%minima);

    my @minima = map { $minima{$_} } @years;
    plot_extent_minima(\@years, \@minima);
}

extract_ice_extent_data() unless caller();

# vim: expandtab shiftwidth=4 softtabstop=4
