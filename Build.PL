use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'URI::Encode',
    license             => 'perl',
    dist_author         => 'Mithun Ayachit <mithun@cpan.org>',
    dist_version_from   => 'lib/URI/Encode.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'URI-Encode-*' ],
);

$builder->create_build_script();
