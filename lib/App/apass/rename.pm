package App::apass::rename;
use warnings;
use strict;
use Getopt::Long qw/GetOptionsFromArray/;
use App::apass::Utils::Help qw/help error version/;
use App::apass::Utils::DB;
require Exporter;
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
	) or exit 1;
	my $old_tag = shift or error('No tags supplied');
	my $new_tag = shift or error('No destination tag supplied');

	my $db = App::apass::Utils::DB->new(%$gopts) or
		error 'Could not load DB';
	my $pass = $db->get($old_tag) or error("Tag '$old_tag' does not exist");
	error("Tag '$new_tag' already exists") if $db->get($new_tag);

	$db->set($new_tag, $db->get($old_tag)) and $db->remove($old_tag);
}

1;

__DATA__

=head1 SYNOPSIS

 apass [global opts] rename [opts] <old tag> <new tag>

 --version            display version information
 --help               display this help
