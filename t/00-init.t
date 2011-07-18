#!/usr/bin/perl
use warnings;
use strict;
use File::Path qw/remove_tree/;
use Test::More tests => 2;

if(-e 't/data') {
	if(-d 't/data') {
		ok(remove_tree('t/data'), 'cleaning up old t/data');
		ok(mkdir('t/data'), 'creating initial test data directory');
	} else {
		BAIL_OUT('t/data is something, but not a directory!');
	}
}

