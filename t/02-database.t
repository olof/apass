#!/usr/bin/perl
use warnings;
use strict;
use lib 't/lib';
use Test::More tests => 28;
use Test::Trap;
use App::apass::Utils::DB;
use Term::ReadPassword;

Term::ReadPassword::test_data('password', 'password');
my $db = new_ok(
	'App::apass::Utils::DB' => [ file => 't/data/t1.db', init => 1 ],
	'App::apass::Utils::DB->new(file=>"t/data/t1.db", init=>1)'
);
ok(-e 't/data/t1.db', "DB init should create t/data/t1.db");

ok($db->set('test', 'qwerty'), 'Adding new entry');
is($db->get('test'), 'qwerty', 'Retrieveing entry');
is(Term::ReadPassword::test_data(), 0, 'All test data should be consumed');

Term::ReadPassword::test_data('password');
$db = new_ok(
	'App::apass::Utils::DB' => [ file => 't/data/t1.db' ],
	'App::apass::Utils::DB->new(file=>"t/data/t1.db")'
);

is($db->get('test'), 'qwerty', 'Retrieveing entry after reload');
is_deeply([$db->list], ['test'], 'Retrieveing list of entries');
is(Term::ReadPassword::test_data(), 0, 'All test data should be consumed');

Term::ReadPassword::test_data('pass', 'word', 'sswo');
is(
	App::apass::Utils::DB->new(file => 't/data/t1.db'),
	undef,
	'Bad password three times'
);
is(Term::ReadPassword::test_data(), 0, 'All test data should be consumed');

Term::ReadPassword::test_data('pass', 'word', 'password');
$db = new_ok(
	'App::apass::Utils::DB' => [ file => 't/data/t1.db' ],
	'Bad password two times'
);

is($db->get('test'), 'qwerty', 'Retrieveing entry after reload');
ok($db->remove('test'), 'removing entry "test"');
ok(!$db->get('test'), 'Entry "test" should be removed');
is_deeply([$db->list], [], 'List of entries should be empty');
is(Term::ReadPassword::test_data(), 0, 'All test data should be consumed');

Term::ReadPassword::test_data('password');
$db = new_ok(
	'App::apass::Utils::DB' => [ file => 't/data/t1.db' ],
	'Loading empty database'
);

ok($db->set('test1', 'password1'), 'adding entries');
ok($db->set('test2', 'password2'), 'adding entries');
ok($db->set('test3', 'password3'), 'adding entries');
ok($db->set('test4', 'password4'), 'adding entries');

is_deeply([sort $db->list], [qw/test1 test2 test3 test4/], 'Listing entries');
is(Term::ReadPassword::test_data(), 0, 'All test data should be consumed');

trap { App::apass::Utils::DB->new() };
is($trap->leaveby, 'die', 'Loading DB without file param should die');
like(
	$trap->die,
	qr;^No file specified to load/init DB;,
	'error message when trying to load db with no file param'
);

trap { App::apass::Utils::DB->new(file => 't/data/t1.db', init => 1) };
is($trap->leaveby, 'die', 'Initialize db in existing file should die');
like(
	$trap->die,
	qr;^\Q't/data/t1.db' already exists\E;,
	'error message when trying to init db on existing file'
);

