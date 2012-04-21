# Copyright 2011, Olof Johansson <olof@ethup.se>
#
# Copying and distribution of this file, with or without 
# modification, are permitted in any medium without royalty 
# provided the copyright notice are preserved. This file is 
# offered as-is, without any warranty.

package App::apass::Utils::GenPass;
use Crypt::GeneratePassword qw/word chars/;
require Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/genpass/;
our $VERSION = 0.1;

sub genpass {
	my $opts = { 
		length => 16,
		@_ 
	};
	my $pass;

	return word($opts->{length}, $opts->{length}) if $opts->{'no-special'};
	return chars($opts->{length}, $opts->{length});
}

1;

