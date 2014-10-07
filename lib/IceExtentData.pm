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

1;

# vim: expandtab shiftwidth=4 softtabstop=4
