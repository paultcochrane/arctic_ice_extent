package App::ArcticIceExtent;

use Moo;
use Types::Standard qw(Bool);
use IceExtent::Data;
use IceExtent::Plot;
use IceExtent::LinearFit;
use IceExtent::PolyFit;

our $VERSION = 0.001;

has use_local_data => (
    is      => 'rw',
    isa     => Bool,
    default => 0,
);

has prune_current_year => (
    is      => 'rw',
    isa     => Bool,
    default => 0,
);

sub run {
    my $self = shift;

    my $data = IceExtent::Data->new;
    $self->use_local_data
      ? $data->fetch('./')
      : $data->fetch;
    $data->load;
    $self->prune_current_year
      ? $data->prune( [ 1978, $data->current_year ] )
      : $data->prune( [1978] );

    my ( $years, $minima ) = $data->extract_minima;

    my $chart = IceExtent::Plot->new(
        data     => [ $years, $minima ],
        title    => "Arctic Sea Ice Extent Minima",
        filename => "arctic_sea_ice_extent_minima.png",
    );
    $chart->plot;

    my $linear_fit = IceExtent::LinearFit->new( xdata => $years, ydata => $minima);

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
    print "Max root of fit equation: ", $poly_fit->max_root, "\n";

    my @prediction_years;
    my @predicted_years;
    for (my $i = 20; $i < scalar @$years; $i++) {
        my $poly_fit = IceExtent::PolyFit->new(
            xdata => [@$years[0..$i]], ydata => [@$minima[0..$i]] );
        print "Max root for ", @$years[$i], " = ", $poly_fit->max_root, "\n";
        if ($poly_fit->max_root < 2100) {
            push @prediction_years, @$years[$i];
            push @predicted_years, $poly_fit->max_root;
        }
    }

    my $prediction_chart = IceExtent::Plot->new(
        data => [ \@prediction_years, \@predicted_years ],
        title => "Predicted year variation",
        filename => "predicted_year_variation.png",
    );
    $prediction_chart->plot;
}

1;

# vim: expandtab shiftwidth=4 softtabstop=4
