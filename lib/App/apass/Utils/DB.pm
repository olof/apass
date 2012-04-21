package App::apass::Utils::DB;
our $VERSION = 0.2;

=head1 NAME

App::apass::Utils::DB, the database object

=head1 DESCRIPTION

The core of apass is its encrypted flatfile database. This module
takes care of loading, dumping and keeping the database in memory
during a session.

=cut

use feature qw/say/;
use warnings FATAL => 'all'; 
use strict;
use Carp;

use App::apass::Utils::Crypt;
use App::apass::Utils::Password;

=head1 CONSTRUCTOR

 App::apass::Utils::DB->new( file => '/path/to/db/file' )

Using the constructor you can either load an existing database, or
initialize a new one. The parameters file and cipher are required.

=over

=item file

Path to the file storing the database file.

=item init

If init is set to a true value the file pointed to by file parameter
will be initialized as a new database. If the file exists, the module
will carp and die.

=item cipher

Specify a cipher other than the defaut (AES, Rijndael (as defined in
App::apass::Utils::Crypt). Requires you to have the required module(s)
for the specified cipher.

=back

=cut

sub new {
	my $class = shift;
	my $self = { @_, };

	croak "No file specified to load/init DB" unless defined $self->{file};
	bless $self, $class;
	return $self->_init if $self->{init};

	for my $try (1 .. 3) {
		my $key = pass_read();

		$self->{crypt} = App::apass::Utils::Crypt->new(
			key => $key,
			cipher => $self->{cipher},
		) or carp("Could not create a App::apass::Utils::Crypt object");

		$self->{db} = $self->_load;

		if($self->status eq 'badpass') {
			if($try < 3) {
				say 'Wrong password (?). Try again.';
			} else {
				say 'Wrong password (?)';
			}
		} else {
			last
		}
	}

	return $self if $self->status eq 'ok';
	return undef;
}

=head1 METHODS

=head2 set

=cut

sub set {
	my $self = shift;
	my $tag = shift;
	my $pass = shift;

	$self->{db}->{$tag} = $pass;
	$self->_dump;
}

=head2 get

=cut

sub get {
	my $self = shift;
	my $tag = shift;
	return $self->{db}->{$tag};
}

=head2 remove

=cut

sub remove {
	my $self = shift;
	my $tag = shift;
	delete $self->{db}->{$tag};
	$self->_dump;
}

=head2 list

=cut

sub list {
	my $self = shift;
	return keys %{$self->{db}};
}

=head2 status

=cut

sub status {
	my $self = shift;
	return $self->{status};
}

# Internal methods, unstable api

sub _load {
	my $self = shift;
	my $crypt = $self->{crypt};

	open my $fh, '<', $self->{file} or croak($!);
	my $enc = join '', <$fh>;
	close $fh;

	my $dec = $crypt->decrypt($enc);

	if( $dec =~ s/^##apass\n//s ) {
		$self->{status} = 'ok';
		return { map {split /,/, $_, 2} split /\n/s, $dec };
	}

	$self->{status} = 'badpass'; # assume failures are caused by bad pass 
}

sub _dump {
	my $self = shift;

	my $db = $self->{db};
	my $crypt = $self->{crypt};
	my $file = $self->{file};

	my $str = "##apass\n";
	foreach my $k (keys %$db) {
		$str .= "$k,$db->{$k}\n";
	}
	my $enc = $crypt->encrypt($str);

	open my $fh, '>', $file or 
		die("Could not open $file for writing: $!");	
	print $fh $enc;
	close $fh;
}

sub _init {
	my $self = shift;

	croak "'$self->{file}' already exists" if -e $self->{file};

	my $pass = pass_create();
	$self->{crypt} = App::apass::Utils::Crypt->new(
		key => $pass,
		cipher => $self->{cipher},
	);

	open my $fh, '>', $self->{file};
	print $fh $self->{crypt}->encrypt("##apass\n");
	close $fh;

	return $self;
}

1;
