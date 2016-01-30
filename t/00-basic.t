use strict;
use warnings;

use Test::More tests => 2;

use lib qw(lib ../lib);

require_ok('App::ArcticIceExtent');

can_ok('App::ArcticIceExtent', qw(run));

# vim: expandtab shiftwidth=4 softtabstop=4
