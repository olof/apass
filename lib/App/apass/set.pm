package App::apass::set;
use warnings;
use strict;
use feature qw/say/;
use Getopt::Long qw/GetOptionsFromArray/;
use App::apass::Utils::Help qw/help error version/;
use App::apass::Utils::DB;
use App::apass::Utils::Output qw/output_pass/;
use App::apass::Utils::Password qw/pass_create/;
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
		'no-special',
		'length=i',
		'stdout',
		'select-ttl=i',
		'version',
		'help',
	) or exit 1;
	my $tag = shift or error('No tag supplied');

	my $db = App::apass::Utils::DB->new(%$gopts) or
		error 'Could not load DB';

	set($opts, $db, $tag);
}

sub set {
	my $opts = shift;
	my $db = shift;
	my $tag = shift;

	my $pass = pass_create();
	$db->set($tag, $pass);
	output_pass($opts, $pass);
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
