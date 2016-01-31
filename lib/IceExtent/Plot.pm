package IceExtent::Plot;

use Moo;
use Types::Standard qw(ArrayRef Str);
use Chart::Gnuplot;

has 'data' => (
    is       => 'rw',
    isa      => ArrayRef,
    required => 1,
);

has 'title' => (
    is       => 'rw',
    isa      => Str,
    required => 1,
);

has 'filename' => (
    is       => 'rw',
    isa      => Str,
    required => 1,
);

has 'xlabel' => (
    is      => 'rw',
    isa     => Str,
    default => 'Year',
);

has 'time_format' => (
    is => 'rw',
    isa => Str,
    default => '%Y',
);

sub plot {
    my $self = shift;

    my $chart = Chart::Gnuplot->new(
        terminal => "png size 1024,768",
        output   => $self->filename,
        title    => $self->title,
        xlabel   => $self->xlabel,
        ylabel   => "Extent (10^6 km)",
        timeaxis => 'x',
        xtics    => {
            labelfmt => $self->time_format,
            rotate   => -90,
        },
    );

    my $data_set = Chart::Gnuplot::DataSet->new(
        xdata => $self->data->[0],
        ydata => $self->data->[1],
        style => "lines",
        timefmt => $self->time_format,
        width => 2,
    );

    $chart->plot2d($data_set);
}

1;
