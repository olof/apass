#!/usr/bin/perl
use warnings;
use strict;
use lib 't/lib';
use Test::More tests => 4;
use App::apass::Utils::GenPass;

ok(genpass(), "genpass() returns something");
is(length(genpass()), 16, "genpass() defaults to 16 length");
ok(
	genpass('no-special'=>1) !~ /[^a-z]/,
	"nospec should not include special chars"
);

# the value 42 is handled in mocked Crypt::GeneratePassword
is(length(genpass(length=>42)), 42, "genpass() respects length param");

