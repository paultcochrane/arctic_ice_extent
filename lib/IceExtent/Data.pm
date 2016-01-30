package IceExtent::Data;

use Moo;
use LWP::Simple qw( getstore is_error );
use Path::Class;
use File::Copy;

has archive_fname => (
    is      => 'rw',
    default => "NH_seaice_extent_final.csv",
);

has nrt_fname => (
    is      => 'rw',
    default => "NH_seaice_extent_nrt.csv",
);

sub fetch {
    my $self     = shift;
    my $base_url = shift
      // "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/";

    $base_url =~
      qr{(ht|f)tp://}
      ? $self->_fetch_remote($base_url)
      : $self->_fetch_local($base_url);
}

sub _fetch_remote {
    my $self     = shift;
    my $base_url = shift;

    my $archive_url = $base_url . $self->archive_fname;
    my $nrt_url     = $base_url . $self->nrt_fname;

    my $response = getstore( $archive_url, $self->archive_fname );
    warn "Download of ", $self->archive_fname, " failed" if is_error($response);
    $response = getstore( $nrt_url, $self->nrt_fname );
    warn "Download of ", $self->nrt_fname, " failed" if is_error($response);
}

sub _fetch_local {
    my $self      = shift;
    my $base_path = shift;

    my $archive_file = file( $base_path, $self->archive_fname );
    my $nrt_file = file( $base_path, $self->nrt_fname );

    copy( $archive_file, $self->archive_fname );
    copy( $nrt_file, $self->nrt_fname );
}

sub load {
    die "not implemented";
}

sub extract_minima {
    die "not implemented";
}

1;
