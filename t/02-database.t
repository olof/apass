#!/usr/bin/perl
use warnings;
use strict;
use Test::More tests => 6;
use App::apass::Database;
use App::apass::Crypt;
use Crypt::CBC;

my $crypt = mkcrypt( key => 'password' );

db_init(file=>'t/data/t1.db', crypt=>$crypt);
ok(-e 't/data/t1.db', 'db_init creates a new file');

is(
	db_load(file=>'t/data/t1.does.not.exist.db', crypt=>$crypt),
	undef,
	'db_load with bad path is undef'
);

{
	my $mode = (stat 't/data/t1.db')[2];
	chmod 0, 't/data/t1.db';
	undef $@;
	eval { db_load(file=>'t/data/t1.db', crypt=>$crypt) };
	ok(
		$@,
		'db_load without permission dies()'
	);
	chmod $mode, 't/data/t1.db';
}

{
	undef $@;
	eval { db_load(file=>'t/02-database.t', crypt=>$crypt) };
	ok(
		$@,
		'non decryptable file dies()',
	);
}

my $dbref = db_load(file=>'t/data/t1.db', crypt=>$crypt);

is(ref $dbref, 'HASH', 'db_load returns hashref');

$dbref->{foo} = 'bar';
db_dump(db=>$dbref, file=>'t/data/t1.db.dyn', crypt=>$crypt);

my $new_dbref = db_load(file=>'t/data/t1.db.dyn', crypt=>$crypt);
is($new_dbref->{foo}, 'bar', 'Database can restore correct data');
