#!/usr/bin/perl
use Test::More tests => 3;
use App::apass::Database;
use App::apass::Crypt;
use Crypt::CBC;

my $crypt = mkcrypt( key => 'password' );

db_init(file=>'t/data/t1.db', crypt=>$crypt);
ok(-e 't/data/t1.db', 'db_init creates a new file');

$dbref = db_load(file=>'t/data/t1.db', crypt=>$crypt);
is(ref $dbref, 'HASH', 'db_load returns hashref');

$dbref->{foo} = 'bar';
db_dump(db=>$dbref, file=>'t/data/t1.db.dyn', crypt=>$crypt);
my $new_dbref = db_load(file=>'t/data/t1.db.dyn', crypt=>$crypt);
is($new_dbref->{foo}, 'bar', 'Database can restore correct data');
