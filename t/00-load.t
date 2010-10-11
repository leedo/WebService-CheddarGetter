#!perl

use Test::More tests => 1;

BEGIN {
    use_ok( 'WebService::CheddarGetter::Client' ) || print "Bail out!
";
}

diag( "Testing WebService::CheddarGetter::Client $WebService::CheddarGetter::Client::VERSION, Perl $], $^X" );
