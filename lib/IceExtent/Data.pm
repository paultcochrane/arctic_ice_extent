package IceExtent::Data;

use Moo;
use LWP::Simple qw( getstore is_error );

has archive_fname => (
    is      => 'ro',
    default => "NH_seaice_extent_final.csv",
);

has nrt_fname => (
    is      => 'ro',
    default => "NH_seaice_extent_nrt.csv",
);

sub fetch {
    my $self     = shift;
    my $base_url = shift
      // "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/";

    my $archive_url = $base_url . $self->archive_fname;
    my $nrt_url     = $base_url . $self->nrt_fname;

    my $response = getstore( $archive_url, $self->archive_fname );
    warn "Download of ", $self->archive_fname, " failed" if is_error($response);
    $response = getstore( $nrt_url, $self->nrt_fname );
    warn "Download of ", $self->nrt_fname, " failed" if is_error($response);
}

sub load {
    die "not implemented";
}

sub extract_minima {
    die "not implemented";
}

1;
