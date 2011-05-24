package App::apass::Crypt;
use strict;
use warnings;
require Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/mkcrypt/;

use Crypt::CBC;

sub mkcrypt {
	my $opts = {
		cipher => 'Rijndael',
		@_,
	};
	
	return Crypt::CBC->new(
		-cipher => $opts->{cipher},
		-key => $opts->{key},
	);
}

1;

