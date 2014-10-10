package IceExtentData;

use Moose;
use LWP::Simple qw(get);

has 'north_daily_url' => (
    is => "rw",
    isa => "Str",
    default => "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/",
);

has 'extent_final_file' => (
    is => "rw",
    isa => "Str",
    default => "NH_seaice_extent_final.csv",
);

has 'extent_nrt_file' => (
    is => "rw",
    isa => "Str",
    default => "NH_seaice_extent_nrt.csv",
);

has 'final_data' => (
    is => "rw",
    isa => "ArrayRef",
    default => sub { [] },
);

has 'nrt_data' => (
    is => "rw",
    isa => "ArrayRef",
    default => sub { [] },
);

sub retrieve {
    my $self = shift;

    $self->retrieve_final_data();
    $self->retrieve_nrt_data();
}

sub retrieve_final_data {
    my $self = shift;

    my $raw_data = get($self->north_daily_url . $self->extent_final_file);
    die "No final data available" unless $raw_data;
    my @data = split '\n', $raw_data;

    $self->final_data(\@data);
}

sub retrieve_nrt_data {
    my $self = shift;

    my $raw_data = get($self->north_daily_url . $self->extent_nrt_file);
    die "No nrt data available" unless $raw_data;
    my @data = split '\n', $raw_data;

    $self->nrt_data(\@data);
}

1;

# vim: expandtab shiftwidth=4 softtabstop=4
