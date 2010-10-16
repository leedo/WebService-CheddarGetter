use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WebService::CheddarGetter',
    AUTHOR              => q{Lee Aylward <leedo@cpan.org>},
    VERSION_FROM        => 'lib/WebService/CheddarGetter.pm',
    ABSTRACT_FROM       => 'lib/WebService/CheddarGetter.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'XML::LibXML' => 0,
        'LWP::UserAgent' => 0,
        'Any::Moose' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WebService-CheddarGetter-*' },
);
