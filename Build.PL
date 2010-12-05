use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'URI::Encode',
    license           => 'perl',
    dist_author       => 'Mithun Ayachit <mithun@cpan.org>',
    dist_version_from => 'lib/URI/Encode.pm',
    requires          => {
        'perl'       => '5.8.1',    # for Unicode support
        'Test::More' => 0,
        'version'    => 0,
        'Encode'     => '2.12',
    },
    add_to_cleanup => ['URI-Encode-*'],
    meta_merge     => {
        resources => {
            homepage   => 'http://search.cpan.org/dist/URI-Encode/',
            repository => 'http://github.com/mithun/perl-uri-encode',
        },
    },
);

$builder->create_build_script();
