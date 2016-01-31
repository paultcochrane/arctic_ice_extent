package App::ArcticIceExtent;

use Moo;
use IceExtent::Data;
use IceExtent::Plot;

our $VERSION = 0.001;

sub run {
    my $data = IceExtent::Data->new;
    $data->fetch;
    $data->load;

    my ($years, $minima) = $data->extract_minima;

    my $chart = IceExtent::Plot->new(
        data => [ $years, $minima ],
        title => "Arctic Sea Ice Extent Minima",
        filename => "arctic_sea_ice_extent_minima.png",
    );
    $chart->plot;

}

1;

# vim: expandtab shiftwidth=4 softtabstop=4
