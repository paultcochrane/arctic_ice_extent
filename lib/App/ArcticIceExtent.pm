package App::ArcticIceExtent;

use Moo;
use IceExtent::Data;
use IceExtent::Plot;
use IceExtent::LinearFit;

our $VERSION = 0.001;

sub run {
    my $data = IceExtent::Data->new;
    $data->fetch;
    $data->load;
    $data->prune( [ 1978, 2016 ] );

    my ( $years, $minima ) = $data->extract_minima;

    my $chart = IceExtent::Plot->new(
        data     => [ $years, $minima ],
        title    => "Arctic Sea Ice Extent Minima",
        filename => "arctic_sea_ice_extent_minima.png",
    );
    $chart->plot;

    my $linear_fit = IceExtent::LinearFit->new( xdata => $years, ydata => $minima);
    $linear_fit->fit;

    my $linear_chart = IceExtent::Plot->new(
        data     => [ $years, $minima, $linear_fit->data ],
        title    => "Linear fit",
        filename => "linear_fit.png",
    );
    $linear_chart->plot;
}

1;

# vim: expandtab shiftwidth=4 softtabstop=4
