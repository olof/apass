package App::apass::Utils::Output;
use strict;
use warnings;
use feature qw/say/;
our $VERSION = 0.2;
use App::apass::Utils::Help qw/error/;
use Carp;
require Exporter;
our @ISA = 'Exporter';
our @EXPORT_OK = 'output_pass';


sub output_pass {
	my $opts = shift;
	my $password = shift;

	return stdout($opts, $password) if $opts->{stdout};
	return selection($opts, $password);
}

sub stdout {
	my $opts = shift;
	my $pass = shift;
	say $pass;
}

sub selection {
	my $opts = shift;
	my $password = shift;

	my $ttl = $opts->{'select-ttl'};

	my $selectionf = \&xclip;
	eval { require Clipboard };
	$selectionf = \&clipboard unless $@;

	if($selectionf->($password)) {
		say 'The password should now be in the selection buffer';
	} else {
		error "Couldn't load passowrd into selection buffer";
	}

	if($ttl) {
		say "Will sleep for $ttl seconds and then clear passowrd";
		sleep $ttl;
		$selectionf->('');
	}
}

sub clipboard {
	Clipboard->copy(shift);
}

sub xclip {
	my $password = shift;
	$password =~ s/'/'\\'¨/g;
	return system("printf '%s' '$password' | xclip -in") == 0;
}

1;

