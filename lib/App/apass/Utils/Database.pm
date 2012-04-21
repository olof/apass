package App::apass::Utils::Database;

use warnings; 
use strict;

require Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/
	db_load db_dump db_init
/;
our $VERSION = 0.2;

sub db_load {
	my $opts = { 
		file => "$ENV{HOME}/.apass", 
		@_,
	};
	
	my $file = $opts->{file};
	my $crypt = $opts->{crypt};

	return unless -f $file;

	open my $fh, '<', $file or die($!);
	my $enc = join '', <$fh>;
	close $fh;

	my $dec = $crypt->decrypt($enc);

	if( $dec =~ s/^##apass\n//s ) {
		my %db = map {split /,/, $_, 2} split /\n/s, $dec;
		return \%db;
	}

	return undef;
}

sub db_dump {
	my $opts = { @_ };

	my $db = $opts->{db};
	my $crypt = $opts->{crypt};
	my $file = $opts->{file};

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

sub db_init {
	my $opts = {
		@_,
	};

	open my $fh, '>', $opts->{file};
	print $fh $opts->{crypt}->encrypt("##apass\n");
	close $fh;
}

sub db_get {
	
}

sub db_set {
}

sub db_add {
}

sub db_rm {
}

1;

