use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'URI::Encode',
    AUTHOR        => 'Mithun Ayachit <mithun@cpan.org>',
    VERSION_FROM  => 'lib/URI/Encode.pm',
    ABSTRACT_FROM => 'lib/URI/Encode.pm',
    PL_FILES      => {},
    PREREQ_PM     => {
        'Test::More' => 0,
        'version'    => 0,
        'Encode'     => '2.12',
    },
    LICENSE    => 'perl',
    META_MERGE => {
        resources => {
            homepage   => 'http://search.cpan.org/dist/URI-Encode/',
            repository => 'http://github.com/mithun/perl-uri-encode',
        },
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'URI-Encode-*' },
);
