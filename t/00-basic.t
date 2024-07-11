use strict;
use warnings;

use Test::More import => [qw( can_ok is like plan require_ok subtest use_ok )];
use Capture::Tiny qw(capture);

use lib qw(lib ../lib);

my $num_tests = 5;
$num_tests = $ENV{RELEASE_TESTING} ? ($num_tests + 1) : $num_tests;
plan tests => $num_tests;

require_ok('App::ArcticIceExtent');

can_ok('App::ArcticIceExtent', qw(run));

use_ok('App::ArcticIceExtent');

subtest "App::ArcticIceExtent attribute default values" => sub {
    plan tests => 2;

    my $ice_extent = App::ArcticIceExtent->new;
    is $ice_extent->use_local_data, 0, "use-local-data default value";
    is $ice_extent->prune_current_year, 0, "prune-current-year default value";
};

subtest "setting App::ArcticIceExtent attributes" => sub {
    plan tests => 2;

    my $ice_extent = App::ArcticIceExtent->new;

    $ice_extent->use_local_data(1);
    is $ice_extent->use_local_data, 1, "use-local-data value";

    $ice_extent->prune_current_year(1);
    is $ice_extent->prune_current_year, 1, "prune-current-year value";
};

if ( $ENV{RELEASE_TESTING} ) {
    subtest "run routine" => sub {
        plan tests => 3;

        my $ice_extent = App::ArcticIceExtent->new;
        $ice_extent->use_local_data(1);

        my ($stdout, $stderr, @result) = capture {
            $ice_extent->run;
        };

        like $stdout, qr/Equation of fit/, "equation of fit";
        like $stdout, qr/Roots of fit equation/, "roots of fit equation";

        is $stderr, "", "stderr is empty";
    };
}

# vim: expandtab shiftwidth=4 softtabstop=4
