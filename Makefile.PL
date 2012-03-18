#!/usr/bin/perl
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => 'apass',
	VERSION_FROM => 'bin/apass',
	ABSTRACT_FROM => 'bin/apass',
	EXE_FILES => ['bin/apass'],

	PREREQ_PM => {
		'Crypt::CBC' => 0,
		'Crypt::GeneratePassword' => 0,
		'Term::ReadPassword' => 0,
	},
);

