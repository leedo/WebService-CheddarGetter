#!perl

use Test::More tests => 1;

BEGIN {
    use_ok( 'WebService::CheddarGetter' ) || print "Bail out!
";
}

diag( "Testing WebService::CheddarGetter $WebService::CheddarGetter::VERSION, Perl $], $^X" );
