package App::ArcticIceExtent;

use Moo;
use IceExtent::Data;
use IceExtent::Plot;
use IceExtent::LinearFit;
use IceExtent::PolyFit;

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
        R2_value => $linear_fit->R2,
    );
    $linear_chart->plot;

    my $poly_fit = IceExtent::PolyFit->new( xdata => $years, ydata => $minima);

    my $poly_chart = IceExtent::Plot->new(
        data  => [ $years, $minima, $poly_fit->data ],
        title => "Polynomial fit",
        filename => "poly_fit.png",
        R2_value => $poly_fit->R2,
    );
    $poly_chart->plot;

    print "Equation of fit: ", $poly_fit->equation, "\n";
    print "Roots of fit equation: ", join(", ", $poly_fit->roots), "\n";
}

1;

# vim: expandtab shiftwidth=4 softtabstop=4
