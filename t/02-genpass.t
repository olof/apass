#!/usr/bin/perl
use Test::More tests => 3;
use App::apass::GenPass;

ok(genpass(), "genpass() returns something");
ok(length(genpass()) == 16, "genpass() defaults to 16 length");
ok(length(genpass(length=>42)) == 42, "genpass() respects length param");

