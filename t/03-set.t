#!/usr/bin/perl
use warnings;
use strict;
use lib 't/lib';
use Test::More tests => 4;
use App::apass::Utils::Password qw/pass_read pass_create/;
use Term::ReadPassword;

Term::ReadPassword::test_data('password');
is(pass_read(), 'password', "pass_read");

Term::ReadPassword::test_data('foobar', 'foobar');
is(pass_create(), 'foobar', "pass_create");

Term::ReadPassword::test_data(('foobar', 'foo')x3);
is(pass_create(), undef, "pass_create, no repeat match");

Term::ReadPassword::test_data((undef)x3);
is(pass_create(), undef, "pass_create, undef as password");

