package IceExtent::Data;

use Moo;
use Types::Standard qw(ArrayRef);
use LWP::Simple qw( getstore is_error );
use Path::Class;
use File::Copy;
use Text::CSV_XS;

has archive_fname => (
    is      => 'rw',
    default => "NH_seaice_extent_final.csv",
);

has nrt_fname => (
    is      => 'rw',
    default => "NH_seaice_extent_nrt.csv",
);

has extents => (
    is      => 'rw',
    isa     => ArrayRef,
    default => sub { return [] },
);

has dates => (
    is      => 'rw',
    isa     => ArrayRef,
    default => sub { return [] },
);

sub fetch {
    my $self     = shift;
    my $base_url = shift
      // "ftp://sidads.colorado.edu/DATASETS/NOAA/G02135/north/daily/data/";

    $base_url =~ qr{(ht|f)tp://}
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
    my $nrt_file     = file( $base_path, $self->nrt_fname );

    copy( $archive_file, $self->archive_fname );
    copy( $nrt_file,     $self->nrt_fname );
}

sub load {
    my $self = shift;

    $self->_read_csv_data($self->archive_fname);
    $self->_read_csv_data($self->nrt_fname);
}

sub _read_csv_data {
    my ($self, $csv_file) = @_;

    my $csv = Text::CSV_XS->new;
    open my $csv_fh, "<", $csv_file or die "$!";
    while (my $row = $csv->getline($csv_fh)) {
        next unless $row->[0] =~ m/\d{4}/;  # skip non-data rows
        # force numeric context due to leading whitespace
        my $year = $row->[0] + 0;
        my $month = $row->[1] + 0;
        my $day = $row->[2] + 0;
        my $date = sprintf "%04d-%02d-%02d", $year, $month, $day;
        my $ice_extent = $row->[3] + 0;
        push @{$self->dates}, $date;
        push @{$self->extents}, $ice_extent;
    }
    close $csv_fh;
}

sub extract_minima {
    die "not implemented";
}

1;
