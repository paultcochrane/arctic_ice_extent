use strict;
use warnings;

use lib qw(lib ../lib);
use Test::More tests => 5;
use Test::Approx;

subtest "basic object setup is correct" => sub {
    plan tests => 3;

    require_ok('IceExtent::PolyFit');
    can_ok( 'IceExtent::PolyFit', qw(a b c R2) );
    isa_ok( IceExtent::PolyFit->new( xdata => [1, 2, 3], ydata => [3, 2, 3] ),
        'IceExtent::PolyFit' );
};

subtest "fitting a second order polynomial data set gives expected fit" => sub {
    plan tests => 4;

    my @xdata = ( -9 .. 9 );
    my @ydata = map { 2 * $_ * $_ + 3 * $_ - 5 } @xdata;
    my $poly_fit =
      IceExtent::PolyFit->new( xdata => \@xdata, ydata => \@ydata );

    my $tolerance = 1e-14;
    is_approx_num $poly_fit->a, 2,
      "Fit gives correct 'a' parameter value", $tolerance;
    is_approx_num $poly_fit->b, 3,
      "Fit gives correct 'b' parameter value", $tolerance;
    is_approx_num $poly_fit->c, -5,
      "Fit gives correct 'c' parameter value", $tolerance;
    is_approx_num $poly_fit->R2, 0,
      "Fit gives correct 'R^2' parameter value", $tolerance;
};

subtest "fit data can be returned" => sub {
    plan tests => 2;

    my @xdata = ( -9 .. 9 );
    my @ydata = map { 2 * $_ * $_ + 3 * $_ - 5 } @xdata;
    my $poly_fit =
      IceExtent::PolyFit->new( xdata => \@xdata, ydata => \@ydata );

    my @fit_data = @{ $poly_fit->data };
    is @fit_data, 19, "Fit data has correct length";
    is_deeply \@fit_data, \@ydata, "Fit data agrees with original data";
};

subtest "fit equation can be returned" => sub {
    plan tests => 1;

    my @xdata = ( -9 .. 9 );
    my @ydata = map { 2 * $_ * $_ + 3 * $_ - 5 } @xdata;
    my $poly_fit =
      IceExtent::PolyFit->new( xdata => \@xdata, ydata => \@ydata );

    my $equation = $poly_fit->equation;
    is $equation, "2 x^2 + 3 x + -5", "Fit equation matches input data";
};

subtest "roots of fit can be returned" => sub {
    plan tests => 3;

    my @xdata = ( -9 .. 9 );
    my @ydata = map { 2 * $_ * $_ + 3 * $_ - 5 } @xdata;
    my $poly_fit =
      IceExtent::PolyFit->new( xdata => \@xdata, ydata => \@ydata );

    my @roots = $poly_fit->roots;
    my @expected_roots = ("-2.50", "1.00");
    is_deeply \@roots, \@expected_roots, "Roots of fit equation";

    @xdata = ( -9 .. 9 );
    @ydata = map { 2.457 * $_ * $_ + 1.932 * $_ - 5.198 } @xdata;
    $poly_fit =
      IceExtent::PolyFit->new( xdata => \@xdata, ydata => \@ydata );

    @roots = $poly_fit->roots;
    @expected_roots = ("-1.90", "1.11");
    is_deeply \@roots, \@expected_roots, "Roots of fit equation";

    my $max_root = $poly_fit->max_root;
    is $max_root, 1.11, "Report maximum root of fit equation";
};

# vim: expandtab shiftwidth=4 softtabstop=4
