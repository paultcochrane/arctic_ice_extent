package IceExtent::PolyFit;

use Moo;
use Types::Standard qw(ArrayRef Num);
use Algorithm::CurveFit;
use Math::Complex;
use Math::Polynomial::Solve qw(:classical);

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

has c => (
    is => 'rw',
    isa => Num,
);

has R2 => (
    is => 'rw',
    isa => Num,
);

sub fit {
    my $self = shift;

    my $formula = 'c + b * x + a * x^2';
    my $variable = 'x';

    my @parameters = (
        # Name    Guess   Accuracy
        ['a',     1,     0.00001],
        ['b',     1,     0.00001],
        ['c',     1,     0.00001],
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
    $self->c($parameters[2][1]);
    $self->R2($square_residual);
}

sub data {
    my $self = shift;

    my @ydata = map { $self->a*$_*$_ + $self->b*$_ + $self->c } @{$self->xdata};

    return \@ydata;
}

sub equation {
    my $self = shift;

    return sprintf "%.4g x^2 + %.4g x + %.4g", $self->a, $self->b, $self->c;
}

sub roots {
    my $self = shift;

    my @roots = quadratic_roots($self->a, $self->b, $self->c);
    return @roots;
}

1;

# vim: expandtab shiftwidth=4 softtabstop=4
