#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;

use lib qw(lib);
use App::ArcticIceExtent;

my $result = GetOptions(
    "prune-current-year" => \my $prune_current_year,
    "use-local-data"     => \my $use_local_data,
) or pod2usage(1);

my $ice_extent = App::ArcticIceExtent->new;
$ice_extent->use_local_data($use_local_data);
$ice_extent->prune_current_year($prune_current_year);
$ice_extent->run;

=head1 NAME

arctic_ice_extent

=head1 SYNOPSIS

    arctic_ice_extent [--use-local-data] [--prune-current-year]

=head1 OPTIONS

=over 4

=item --use-local-data

Only use local data for the analysis; don't download new data from the
remote FTP server.

=item --prune-current-year

Prune the data for the current year.  This is necessary when the minimum for
the current year has not yet happened and the last data point should be
ignored for the purposes of generating a fit equation.

=back

=cut

# vim: expandtab shiftwidth=4 softtabstop=4
