package Term::ReadPassword;
use warnings;
use strict;
use feature qw/say/;
use Carp;
require Exporter;
our @ISA = 'Exporter';
our @EXPORT = 'read_password';

my @passwords;

sub test_data {
	push @passwords, @_;
	return @passwords;
}

sub read_password {
	carp("No passwords left in mock Term::ReadPassword. Resupply!")
		unless @passwords;

	return shift @passwords;
}

1;
