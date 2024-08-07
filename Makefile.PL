use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'App::ArcticIceExtent',
    ABSTRACT     => 'Display Arctic sea ice extent over time',
    AUTHOR       => 'Paul Cochrane <paul@peateasea.de>',
    VERSION_FROM => 'lib/App/ArcticIceExtent.pm',
    LICENSE      => 'perl_5',

    BUILD_REQUIRES => {
        "Algorithm::CurveFit" => "0",
        "Chart::Gnuplot"  => "0",
        "Cwd"             => "0",
        "File::Copy"      => "0",
        "List::Util"      => "0",
        "List::MoreUtils" => "0",
        "LWP::Simple"     => "0",
        "Math::Polynomial::Solve" => 0,
        "Moo"             => "0",
        "Path::Class"     => "0",
        "Pod::Usage"      => "0",
        "Text::CSV_XS"    => "0",
        "Types::Standard" => "0",
    },

    TEST_REQUIRES => {
        "Capture::Tiny" => "0",
        "List::MoreUtils" => "0",
        "Test::Approx" => "0",
        "Test::More" => "0",
        "Devel::Cover" => "0",
    },

    clean => {
        FILES => q(
          test_data.png
          NH_seaice_extent_final.csv
          test_archive_data.csv
          ),
    },
);

# specify additional testing targets
package MY;

sub MY::postamble {
    return <<'MAKE_COVER'
cover :: pure_all
	cover -test

MAKE_COVER
}

# vim: expandtab shiftwidth=4 softtabstop=4
