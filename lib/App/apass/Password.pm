package App::apass::Password;
use strict;
use warnings;
require Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/pass_read pass_create/;

use Term::ReadPassword;

sub pass_read {
	return read_password("Password: ");
}

sub pass_create {
	my $msg = "Password: ";
	for(my $i=0; $i<3; ++$i) {
		my $p1 = read_password($msg);
		my $p2 = read_password("Repeat: ");

		if($p1 and $p1 eq $p2) {
			return $p1;
		}

		$msg = "They didn't match. Try again. $msg";
	}

	return undef;
}
