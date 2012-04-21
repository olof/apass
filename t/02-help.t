#!/usr/bin/perl
use warnings;
use strict;
use Test::More tests=>7;
use Test::Trap;
use App::apass::Utils::Help qw/help error version/;

our $APP = 'test';
our $VERSION = 42;

my @r = trap { help(\*DATA) };
is($trap->exit, 0, "Help exiting with 0");
is($trap->stdout, "Usage:\n    test\n\n", "POD from callers __DATA__");

@r = trap { error("test") };
is($trap->exit, 1, "error() exiting with 1");
is($trap->stderr, "Error: test\n", "error() output");

@r = trap { version() };
is($trap->exit, 0, "Help exiting with 0");
like(
	$trap->stdout, qr/^test v42/,
	'Output from version() should follow expected format',
);
like(
	$trap->stdout,
	qr/Copyright 2011 -- 20[1-9][0-9], Olof Johansson <olof\@ethup.se>/,
	'version() should include a copyright notice',
);


__DATA__

=head1 NAME

02-help.t, test for App::apass::Utils::Help

=head1 SYNOPSIS

test
