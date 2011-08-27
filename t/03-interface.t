#!/usr/bin/perl
use warnings;
use strict;
use Test::More tests => 5;
use Clipboard;

sub system_success {
	my $cmd = shift;
	my $ret = shift // 0;
	my $e = system($cmd) >> 8;

	is($e, $ret, "$cmd should exit with $ret");
}

my $old_paste_content = Clipboard->paste;

my $dbfile = 't/data/iface.db';
my $pass = 'foobar';
my $cmd = "perl bin/apass -f $dbfile";

system_success("$cmd --dbpass $pass init");
ok(-e $dbfile, "initialization should create db file");
system_success("$cmd --dbpass $pass add example.com");
system_success("$cmd --dbpass $pass get example.com");
isnt(Clipboard->paste, $old_paste_content, "get should update copy buffer");

Clipboard->copy($old_paste_content);
