# Copyright 2011, Olof Johansson <olof@ethup.se>
#
# Copying and distribution of this file, with or without 
# modification, are permitted in any medium without royalty 
# provided the copyright notice are preserved. This file is 
# offered as-is, without any warranty.

package App::apass::GenPass;
use String::MkPasswd qw/mkpasswd/;
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

	$pass = mkpasswd(-length=>$opts->{length});
	$pass =~ s/\W//g if exists $opts->{nospec};

	return $pass;
}

1;

