package App::ArcticIceExtent;

use Moo;
use IceExtent::Data;
use IceExtent::Plot;

our $VERSION = 0.001;

sub run {
    my $data = IceExtent::Data->new;
    $data->fetch;
    $data->load;

    my $chart = IceExtent::Plot->new(
        data => [ $data->dates, $data->extents ],
        title => "Extents",
        filename => "blah.png",
        time_format => '%Y-%m-%d',
    );
    $chart->plot;

}

1;

# vim: expandtab shiftwidth=4 softtabstop=4
