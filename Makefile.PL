use inc::Module::Install;
WriteMakefile(
    NAME                => 'Moose::Tiny',
    AUTHOR              => 'Chris Prather <perigrin@cpan.org>',
    VERSION_FROM        => 'lib/Moose/Tiny.pm',
    ABSTRACT_FROM       => 'lib/Moose/Tiny.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Moose-Tiny-*' },
);
