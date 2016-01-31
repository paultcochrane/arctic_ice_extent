use strict;
use warnings;

use lib qw(lib ../lib);
use Test::More tests => 2;
use Test::Approx;

subtest "basic object setup is correct" => sub {
    plan tests => 3;

    require_ok('IceExtent::LinearFit');
    can_ok( 'IceExtent::LinearFit', qw(a b R2) );
    isa_ok( IceExtent::LinearFit->new( xdata => [], ydata => [] ),
        'IceExtent::LinearFit' );
};

subtest "fitting a linear data set gives expected fit" => sub {
    plan tests => 3;

    my @xdata = ( 1, 2, 3, 4, 5, 6, 7, 8, 9 );
    my @ydata = map { 2 * $_ } @xdata;
    my $linear_fit =
      IceExtent::LinearFit->new( xdata => \@xdata, ydata => \@ydata );
    $linear_fit->fit;

    my $tolerance = 1e-14;
    is_approx_num $linear_fit->a, 2,
      "Fit gives correct 'a' parameter value", $tolerance;
    is_approx_num $linear_fit->b, 0,
      "Fit gives correct 'b' parameter value", $tolerance;
    is_approx_num $linear_fit->R2, 0,
      "Fit gives correct 'R^2' parameter value", $tolerance;
};

# vim: expandtab shiftwidth=4 softtabstop=4
