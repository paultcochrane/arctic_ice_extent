package IceExtentData;

use Moose;

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

    my @data = (1, 2, 3, 4);
    $self->final_data(\@data);
    $self->nrt_data(\@data);
}

1;

# vim: expandtab shiftwidth=4 softtabstop=4
