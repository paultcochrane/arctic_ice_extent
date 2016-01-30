use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'App::ArcticIceExtent',
    ABSTRACT     => 'Display Arctic sea ice extent over time',
    AUTHOR       => 'Paul Cochrane <paul@liekut.de>',
    VERSION_FROM => 'lib/App/ArcticIceExtent.pm',
    LICENSE      => 'perl_5',

    BUILD_REQUIRES => {
        "Text::CSV_XS"   => "0",
        "LWP::Simple"    => "0",
        "Chart::Gnuplot" => "0",
    },

    TEST_REQUIRES => {
        "Test::More" => "0",
    },
);

# vim: expandtab shiftwidth=4 softtabstop=4
