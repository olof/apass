#!/usr/bin/perl
use warnings;
use strict;
use Test::More tests => 4;
use App::apass::GenPass;

ok(genpass(), "genpass() returns something");
is(length(genpass()), 16, "genpass() defaults to 16 length");
is(length(genpass(length=>42)), 42, "genpass() respects length param");
ok(genpass(nospec=>1) !~ /\W/, "nospec should not include special chars");

