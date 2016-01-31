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

    my @line_colours = qw(midnight-blue orange-red);

    my @data_sets;
    my $xdata = shift @{$self->data};
    for (my $i=0; $i<@{$self->data}; $i++) {
        my $ydata = $self->data->[$i];
        my $data_set = Chart::Gnuplot::DataSet->new(
            xdata => $xdata,
            ydata => $ydata,
            style => "lines",
            timefmt => $self->time_format,
            width => 2,
            color => $line_colours[$i],
        );
        push @data_sets, $data_set;
    }

    $chart->plot2d(@data_sets);
}

1;
