#!/usr/bin/env perl

use strict;
use warnings;

use lib qw(lib);
use App::ArcticIceExtent;

App::ArcticIceExtent->new->run;

__END__

use Chart::Gnuplot;

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
