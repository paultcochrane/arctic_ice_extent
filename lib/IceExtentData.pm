package IceExtentData;

use Moose;

has 'extent_final_file' => (
    is => "rw",
    isa => "Str",
    default => "NH_seaice_extent_final.csv",
);

1;

# vim: expandtab shiftwidth=4 softtabstop=4
