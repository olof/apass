package Crypt::GeneratePassword;
use warnings;
use strict;
require Exporter;

our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/word chars/;

sub word($$) {
	my ($min, $max) = @_;
	return 'ncaiazealladeira' if $min == 16; # 16 value is default
}

sub chars($$) {
	my ($min, $max) = @_;
	return 'xK3Crt-&OTJOMnpM' if $min == 16; # 16 value is default

	# 42 value corresponds to test in t/02-genpass.t
	return 'rqOOzk0xhjcf$&cPw18rB_HGOguX3ypBbDO!SZKCQ/' if $min == 42;

}

1;
