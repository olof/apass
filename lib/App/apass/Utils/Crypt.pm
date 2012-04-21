package App::apass::Utils::Crypt;
use strict;
use warnings;
use Carp;
our $VERSION = 0.2;
use Data::Dumper;

use Crypt::CBC;

sub new {
	my $class = shift;

	my $opts = {
		@_,
	};

	$opts->{cipher} = 'Rijndael' unless $opts->{cipher};

	if(not defined $opts->{key}) {
		carp 'No key supplied';
		return undef;
	}
	
	return Crypt::CBC->new(
		-cipher => $opts->{cipher},
		-key => $opts->{key},
	);
}

1;

