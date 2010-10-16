#!perl

use Test::More; 

BEGIN {
    use_ok( 'WebService::CheddarGetter::Client' ) || print "Bail out!
";
}

my $cg = WebService::CheddarGetter::Client->new(
  email => $ENV{CHEDDARGETTER_EMAIL},
  password => $ENV{CHEDDARGETTER_PASS},
);

my $product = $cg->get_product($ENV{CHEDDARGETTER_PRODUCT});

my $plan = ($product->plans)[0];
is $plan->code, "BASIC_CHAT";
is $plan->isActive, 1;
is $plan->name, "Basic Chat";
is $plan->isFree, 0;
is $plan->trialDays, 0;
is $plan->billingFrequency, "monthly";
is $plan->billingFrequencyPer, "month";
is $plan->billingFrequencyUnit, "months";
is $plan->billingFrequencyQuantity, 1;
is $plan->setupChargeAmount, "0.00";
is $plan->recurringChargeCode, "BASIC_CHAT_RECURRING";
is $plan->recurringChargeAmount, "6.00";

my $customer = ($product->customers)[0];
is $customer->firstName, "Lee";
is $customer->lastName, "Aylward";
is $customer->company, "ServerCentral";
is $customer->email, 'laylward@gmail.com';
is $customer->gatewayToken, "SIMULATED";
is $customer->isVatExempt, 0,

done_testing();
