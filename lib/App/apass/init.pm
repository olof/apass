package App::apass::init;
use warnings;
use strict;
use feature qw/say/;
use Getopt::Long qw/GetOptionsFromArray/;
use App::apass::Utils::Help qw/help error version/;
use App::apass::Utils::DB;
use App::apass::Utils::Output qw/output_pass/;
use App::apass::Utils::GenPass qw/genpass/;
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
		'version',
		'help',
	);

	init($gopts);
}

sub init {
	my $gopts = shift;

	my $db = App::apass::Utils::DB->new(%$gopts, init=>1) or
		error 'Could not initialize DB';

	say "Initialization of $gopts->{file} is complete!";
	return 0;
}

1;

__DATA__

=head1 SYNOPSIS

 apass [global opts] init [opts] <tag>

 --version            display version information
 --help               display this help
