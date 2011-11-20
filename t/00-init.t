#!/usr/bin/perl
use warnings;
use strict;
use File::Path qw/remove_tree/;
use Test::More tests => 2;

BAIL_OUT('t/data is something, but not a directory!')
	if -e 't/data' and not -d 't/data';

if(-e 't/data') {
	BAIL_OUT('Failed removing t/data')
		unless ok(remove_tree('t/data'), 'cleaning up old t/data');
} else {
	pass("t/data doesn't exist");
}

BAIL_OUT('Failed creating t/data')
	unless ok(mkdir('t/data'), 'creating initial test data directory');

