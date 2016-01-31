package IceExtent::LinearFit;

use Moo;
use Types::Standard qw(HashRef);

has params => (
    is => 'rw',
    isa => HashRef,
);

1;

# vim: expandtab shiftwidth=4 softtabstop=4
