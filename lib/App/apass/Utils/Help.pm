package App::apass::Utils::Help;
require Exporter;
use Pod::Usage;
our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/help error version/;
our $VERSION = 0.2;
use Data::Dumper;

=head1 SUBROUTINES

=head2 help

Prints usage information. Pass a fh ref to it (e.g. \*DATA).
Dies with exit value 0.

=cut

sub help {
	my $fh = shift;

	pod2usage(
		-verbose => 99,
		-input => $fh,
		-sections => [qw/SYNOPSIS/],
		-message => shift,
		-exitval => 0,
	);
}

=head2 error

Prints error to stderr and dies with exit value 1.

=cut

sub error {
	say STDERR "Error: @_";
	exit 1;
}

=head2 version

Prints version and copyright information and exits with 0.

=cut

sub version {
	printf << 'EOF', $main::APP, $main::VERSION;
%s v%s, (a pass)word manager and generator

Copyright 2011 -- 2012, Olof Johansson <olof@ethup.se>

Copying and distribution of this file, with or without 
modification, are permitted in any medium without royalty 
provided the copyright notice are preserved. This file is 
offered as-is, without any warranty.
EOF
	exit 0;
}

1;

