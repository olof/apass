package App::apass::rm;
use warnings;
use strict;
use feature qw/say/;
use Getopt::Long qw/GetOptionsFromArray/;
use App::apass::Utils::Help qw/help error version/;
use App::apass::Utils::DB;
require Exporter;
use Data::Dumper;
our $VERSION = 0.2;
our @ISA = 'Exporter';
our @EXPORT_OK = 'invoke';

sub invoke {
	my $gopts = shift;

	my $opts = {
		length => 16,

		version => sub { version() },
		help => sub { help(\*DATA) },
	};

	GetOptionsFromArray(\@_, $opts,
		'version',
		'help',
	);
	my $tag = shift or error('No tag supplied');

	my $db = App::apass::Utils::DB->new(%$gopts) or
		error 'Could not load DB';

	rm($opts, $db, $tag);
}

sub rm {
	my $opts = shift;
	my $db = shift;
	my $tag = shift;

	error "Tag '$tag' doesn't exists!" unless $db->get($tag);
	$db->remove($tag);
	return 0;
}

1;

__DATA__

=head1 SYNOPSIS

 apass [global opts] add [opts] <tag>

 --length n           create a password of length n chars (default: 16)
 --no-special         only use [a-z]
 --stdout             print the generated password to stdout
 --select-ttl n       clear selection buffer after n seconds (default: off)

 --version            display version information
 --help               display this help