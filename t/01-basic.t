#!perl

use Test::More; 

BEGIN {
    use_ok( 'WebService::CheddarGetter' ) || print "Bail out!
";
}

my $cg = WebService::CheddarGetter->new(
  email => $ENV{CHEDDARGETTER_EMAIL},
  password => $ENV{CHEDDARGETTER_PASS},
  product_code => $ENV{CHEDDARGETTER_PRODUCT},
);

done_testing();
