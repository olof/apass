#!/usr/bin/perl
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => 'apass',
	VERSION_FROM => 'bin/apass',
	ABSTRACT_FROM => 'bin/apass',
	EXE_FILES => ['bin/apass'],
);

