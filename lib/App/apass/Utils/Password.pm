package App::apass::Utils::Password;
use strict;
use warnings;
use feature qw/say/;
require Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/pass_read pass_create/;
our $VERSION = 0.1;

use Term::ReadPassword;

sub pass_read {
	my $msg = shift // 'Password';
	return read_password("$msg: ");
}

sub _pass_repeat {
	my $p1 = pass_read('New password');

	return {error => 'undef'} unless defined $p1;
	my $p2 = pass_read('Repeat');

	return {error => 'nomatch'} unless $p1 eq $p2;
	return {ok => $p1 };
}


sub pass_create {
	for (0 .. 2) {
		my $pass = _pass_repeat();
		return $pass->{ok} if $pass->{ok};
		say "No match, try again." if $pass->{error} eq 'nomatch';
		say "You have to enter something. Try again." if
			$pass->{error} eq 'undef';
	}

	return undef;
}

1;
