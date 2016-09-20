use strict;
use warnings;

use lib qw(lib ../lib);
use Test::More tests => 3;
use Test::Approx;

subtest "basic object setup is correct" => sub {
    plan tests => 3;

    require_ok('IceExtent::LinearFit');
    can_ok( 'IceExtent::LinearFit', qw(a b R2) );
    isa_ok( IceExtent::LinearFit->new( xdata => [1, 2, 3], ydata => [3, 2, 3] ),
        'IceExtent::LinearFit' );
};

subtest "fitting a linear data set gives expected fit" => sub {
    plan tests => 3;

    my @xdata = ( 1, 2, 3, 4, 5, 6, 7, 8, 9 );
    my @ydata = map { 2 * $_ } @xdata;
    my $linear_fit =
      IceExtent::LinearFit->new( xdata => \@xdata, ydata => \@ydata );

    my $tolerance = 1e-14;
    is_approx_num $linear_fit->a, 2,
      "Fit gives correct 'a' parameter value", $tolerance;
    is_approx_num $linear_fit->b, 0,
      "Fit gives correct 'b' parameter value", $tolerance;
    is_approx_num $linear_fit->R2, 0,
      "Fit gives correct 'R^2' parameter value", $tolerance;
};

subtest "fit data can be returned" => sub {
    plan tests => 2;

    my @xdata = ( 1, 2, 3, 4, 5, 6, 7, 8, 9 );
    my @ydata = map { 2 * $_ } @xdata;
    my $linear_fit =
      IceExtent::LinearFit->new( xdata => \@xdata, ydata => \@ydata );

    my @fit_data = @{$linear_fit->data};
    is @fit_data, 9, "Fit data has correct length";
    is_deeply \@fit_data, \@ydata, "Fit data agrees with original data";
};

# vim: expandtab shiftwidth=4 softtabstop=4
