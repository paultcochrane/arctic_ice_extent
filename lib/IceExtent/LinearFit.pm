package IceExtent::LinearFit;

use Moo;
use Types::Standard qw(ArrayRef HashRef);

has xdata => (
    is => 'rw',
    isa => ArrayRef,
    required => 1,
);

has ydata => (
    is => 'rw',
    isa => ArrayRef,
    required => 1,
);

has params => (
    is => 'rw',
    isa => HashRef,
);

1;

# vim: expandtab shiftwidth=4 softtabstop=4
