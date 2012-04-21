#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use Test::More tests => 1;
use Test::Output;
use App::apass::Utils::Output qw/output_pass/;

# XXX:
#  missing tests using Clipboard and xclip
stdout_is(
	sub { output_pass( { stdout => 1 }, 'foo' ) },
	"foo\n",
	'output_pass, output to stdout'
);

