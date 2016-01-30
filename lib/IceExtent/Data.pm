package IceExtent::Data;

use Moo;

has archive_fname => (
    is      => 'ro',
    default => "NH_seaice_extent_final.csv",
);

has nrt_fname => (
    is      => 'ro',
    default => "NH_seaice_extent_nrt.csv",
);

sub fetch {
    die "not implemented";
}

sub load {
    die "not implemented";
}

sub extract_minima {
    die "not implemented";
}

1;
