package App::apass::list;
use warnings;
use strict;
use feature qw/say/;
use Getopt::Long qw/GetOptionsFromArray/;
use App::apass::Utils::Help qw/help error version/;
use App::apass::Utils::Crypt;
use App::apass::Utils::DB;
use App::apass::Utils::Output qw/output_pass/;
use App::apass::Utils::Password qw/pass_read/;
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
	my $re = shift // '.*';

	my $db = App::apass::Utils::DB->new(%$gopts) or
		error 'Could not load DB';

	list($db, qr/$re/);
}

sub list {
	my $db = shift;
	my $re = shift;

	for (grep /$re/, $db->list) {
		say;
	}
}

1;

__DATA__

=head1 SYNOPSIS

 apass [global opts] list [regexp]

 Optionally limit list to only show those tags matching regexp.

 --version            display version information
 --help               display this help
