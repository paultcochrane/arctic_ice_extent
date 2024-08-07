package IceExtent::Data;

use Moo;
use Types::Standard qw(ArrayRef);
use LWP::Simple qw( getstore is_error );
use Path::Class qw( file );
use Cwd qw( abs_path );
use File::Copy qw( copy );
use Text::CSV_XS ();
use List::MoreUtils qw( any each_array );

has archive_fname => (
    is      => 'rw',
    default => "N_seaice_extent_daily_v3.0.csv",
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

    my $response = getstore( $archive_url, $self->archive_fname );
    warn "Download of ", $self->archive_fname, " failed" if is_error($response);
}

sub _fetch_local {
    my $self      = shift;
    my $base_path = shift;

    my $archive_file = file( $base_path, $self->archive_fname );

    copy( $archive_file, $self->archive_fname )
      unless (abs_path($archive_file) eq abs_path($self->archive_fname));
}

sub load {
    my $self = shift;

    $self->_read_csv_data($self->archive_fname);
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
    my $self = shift;

    my @dates = @{$self->dates};
    my @extents = @{$self->extents};

    my $ea = each_array(@dates, @extents);
    # initial value chosen higher than all measured extents so that first
    # collected value will definitely be a minium
    my $previous_extent = 100;
    my %minima_data;
    while ( my ($date, $extent) = $ea->() ) {
        $date =~ m/^(\d{4})/ or die "Unable to extract year from date information";
        my $year = $1;

        my $previous_year = (sort keys %minima_data)[-1];
        if ( $extent < $previous_extent || $year > $previous_year ) {
            $minima_data{$year} = $extent;
            $previous_extent = $extent;
        }
    }

    my @years = sort keys %minima_data;
    my @minima = map { $minima_data{$_} } @years;

    return (\@years, \@minima);
}

sub prune {
    my $self = shift;
    my $years_to_prune = shift;

    my $ea = each_array(@{$self->dates}, @{$self->extents});
    my @pruned_extents;
    my @pruned_dates;
    while ( my ($date, $extent) = $ea->() ) {
        $date =~ m/^(\d{4})/ or die "Unable to extract year from date information";
        my $year = $1;

        next if any { $_ == $year } @{$years_to_prune};
        push @pruned_dates, $date;
        push @pruned_extents, $extent;
    }
    $self->dates(\@pruned_dates);
    $self->extents(\@pruned_extents);
}

sub current_year {
    my $self = shift;

    my $last_date = ${$self->dates}[-1];
    $last_date =~ m/^(\d{4})-/ or die "Unable to extract year from date information";
    my $year = $1;

    return $year;
}

1;
