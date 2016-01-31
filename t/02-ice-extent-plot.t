use warnings;
use strict;

use lib qw(lib ../lib);
use Test::More tests => 6;

subtest "basic object structure set up" => sub {
    plan tests => 3;

    require_ok('IceExtent::Plot');
    can_ok( 'IceExtent::Plot', qw(plot) );
    isa_ok( IceExtent::Plot->new( data => [], title => "", filename => "" ),
        'IceExtent::Plot' );
};

subtest "plotting simple data works correctly" => sub {
    plan tests => 1;

    my @dates = qw(
      2015-12-01
      2015-12-15
      2015-12-31
      2016-01-01
      2016-01-15
      2016-01-31
    );
    my @extents = qw(
      1
      2
      3
      2.5
      1.5
      0.5
    );
    my $data = [ \@dates, \@extents ];

    my $test_plot_fname = "test_data.png";
    unlink $test_plot_fname if -f $test_plot_fname;

    my $chart = IceExtent::Plot->new(
        data     => $data,
        title    => "Test data",
        filename => $test_plot_fname,
        time_format => '%Y-%m-%d',
    );
    $chart->plot;
    qx{eog $test_plot_fname} if $ENV{RELEASE_TESTING};
    ok -f $test_plot_fname, "Test plot file created";
};

subtest "plotting sample extent data works correctly" => sub {
    plan tests => 1;

    use IceExtent::Data;
    my $data = IceExtent::Data->new;
    $data->archive_fname("test_archive_data.csv");
    $data->nrt_fname("test_nrt_data.csv");
    $data->fetch("test_data");
    $data->load;

    my $test_plot_fname = "test_data.png";
    unlink $test_plot_fname if -f $test_plot_fname;

    my $chart = IceExtent::Plot->new(
        data     => [ $data->dates, $data->extents ],
        title    => "Test data",
        filename => $test_plot_fname,
        time_format => '%Y-%m-%d',
    );
    $chart->plot;
    qx{eog $test_plot_fname} if $ENV{RELEASE_TESTING};
    ok -f $test_plot_fname, "Test plot file created";
};

subtest "plotting sample minima data works correctly" => sub {
    plan tests => 1;

    use IceExtent::Data;
    my $data = IceExtent::Data->new;
    $data->archive_fname("test_archive_data.csv");
    $data->nrt_fname("test_nrt_data.csv");
    $data->fetch("test_data");
    $data->load;
    $data->prune([1978, 2016]);
    my ($years, $minima) = $data->extract_minima;

    my $test_plot_fname = "test_data.png";
    unlink $test_plot_fname if -f $test_plot_fname;

    my $chart = IceExtent::Plot->new(
        data     => [ $years, $minima ],
        title    => "Test minima data",
        filename => $test_plot_fname,
        time_format => '%Y',
    );
    $chart->plot;
    qx{eog $test_plot_fname} if $ENV{RELEASE_TESTING};
    ok -f $test_plot_fname, "Test plot file created";
};

subtest "plot two data sets" => sub {
    plan tests => 1;

    use IceExtent::Data;
    my $data = IceExtent::Data->new;
    $data->archive_fname("test_archive_data.csv");
    $data->nrt_fname("test_nrt_data.csv");
    $data->fetch("test_data");
    $data->load;
    $data->prune([1978, 2016]);
    my ($years, $minima) = $data->extract_minima;

    use IceExtent::LinearFit;
    my $linear_fit = IceExtent::LinearFit->new( xdata => $years, ydata => $minima );
    $linear_fit->fit;

    my $test_plot_fname = "test_data.png";
    unlink $test_plot_fname if -f $test_plot_fname;

    my $chart = IceExtent::Plot->new(
        data     => [ $years, $minima, $linear_fit->data ],
        title    => "Test minima data with fit data",
        filename => $test_plot_fname,
        R2_value => $linear_fit->R2,
    );
    $chart->plot;
    qx{eog $test_plot_fname} if $ENV{RELEASE_TESTING};
    ok -f $test_plot_fname, "Test plot file created";
};

subtest "plot minima and polynomial fit" => sub {
    plan tests => 1;

    use IceExtent::Data;
    my $data = IceExtent::Data->new;
    $data->archive_fname("test_archive_data.csv");
    $data->nrt_fname("test_nrt_data.csv");
    $data->fetch("test_data");
    $data->load;
    $data->prune([1978, 2016]);
    my ($years, $minima) = $data->extract_minima;

    use IceExtent::PolyFit;
    my $poly_fit = IceExtent::PolyFit->new( xdata => $years, ydata => $minima );
    $poly_fit->fit;

    my $test_plot_fname = "test_data.png";
    unlink $test_plot_fname if -f $test_plot_fname;

    my $chart = IceExtent::Plot->new(
        data     => [ $years, $minima, $poly_fit->data ],
        title    => "Test minima data with polynomial fit data",
        filename => $test_plot_fname,
        R2_value => $poly_fit->R2,
    );
    $chart->plot;
    qx{eog $test_plot_fname} if $ENV{RELEASE_TESTING};
    ok -f $test_plot_fname, "Test plot file created";
};

# vim: expandtab shiftwidth=4 softtabstop=4
