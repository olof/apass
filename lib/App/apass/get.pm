package App::apass::get;
use warnings;
use strict;
use feature qw/say/;
use Getopt::Long qw/GetOptionsFromArray/;
use App::apass::Utils::Help qw/help error version/;
use App::apass::Utils::DB;
use App::apass::Utils::Output qw/output_pass/;
require Exporter;
use Data::Dumper;
our $VERSION = 0.2;
our @ISA = 'Exporter';
our @EXPORT_OK = 'invoke';

sub invoke {
	my $gopts = shift;

	my $opts = {
		version => sub { version() },
		help => sub { help(\*DATA) },
	};

	GetOptionsFromArray(\@_, $opts,
		'stdout',
		'select-ttl=i',
		'version',
		'help',
	);
	my $tag = shift or error('No tag supplied');

	my $db = App::apass::Utils::DB->new(%$gopts) or
		error 'Could not load DB';

	pass($opts, $db, $tag);
}

sub pass {
	my $opts = shift;
	my $db = shift;
	my $tag = shift;

	if(my $pass = $db->get($tag)) {
		output_pass($opts, $pass);
		return 0;
	} else {
		error "Tag '$tag' does not exist";
		return 1;
	}
}

1;

__DATA__

=head1 SYNOPSIS

 apass [global opts] get [opts] <tag>

 --stdout             output the password on stdout
 --select-ttl n       clear selection buffer after n seconds (default: off)

 --version            display version information
 --help               display this help
