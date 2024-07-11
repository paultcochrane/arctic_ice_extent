package IceExtent::LinearFit;

use Moo;
use Types::Standard qw(ArrayRef Num);
use Algorithm::CurveFit ();

has xdata => (
    is       => 'rw',
    isa      => ArrayRef,
    required => 1,
);

has ydata => (
    is       => 'rw',
    isa      => ArrayRef,
    required => 1,
);

has a => (
    is => 'rw',
    isa => Num,
);

has b => (
    is => 'rw',
    isa => Num,
);

has R2 => (
    is => 'rw',
    isa => Num,
);

sub BUILD {
    my ($self, $args) = @_;
    $self->_fit;
}

sub _fit {
    my $self = shift;

    my $formula = 'b + a * x';
    my $variable = 'x';

    my @parameters = (
        # Name    Guess   Accuracy
        ['a',     1,     0.00001],
        ['b',     1,     0.00001],
    );
    my $max_iter = 1000; # maximum iterations

    my $square_residual = Algorithm::CurveFit->curve_fit(
        formula            => $formula,
        params             => \@parameters,
        variable           => $variable,
        xdata              => $self->xdata,
        ydata              => $self->ydata,
        maximum_iterations => $max_iter,
    );

    $self->a($parameters[0][1]);
    $self->b($parameters[1][1]);
    $self->R2($square_residual);
}

sub data {
    my $self = shift;

    my @ydata = map { $self->a*$_ + $self->b } @{$self->xdata};

    return \@ydata;
}

1;

# vim: expandtab shiftwidth=4 softtabstop=4
