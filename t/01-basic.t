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
is $plan->code, "BASIC_CHAT", "code";
is $plan->isActive, 1, "active";
is $plan->name, "Basic Chat", "name";
is $plan->isFree, 0, "is free";
is $plan->trialDays, 0, "trial days";
is $plan->billingFrequency, "monthly", "billing frequency";
is $plan->billingFrequencyPer, "month", "frequency per";
is $plan->billingFrequencyUnit, "months", "frequency unit";
is $plan->billingFrequencyQuantity, 1, "frequency quantity";
is $plan->setupChargeAmount, "0.00", "setup amount";
is $plan->recurringChargeCode, "BASIC_CHAT_RECURRING", "charge code";
is $plan->recurringChargeAmount, "6.00", "charge amount";

my $plan2 = $product->get_plan($plan->code);
is $plan->id, $plan2->id, "get_plan";

my $customer = ($product->customers)[0];
is $customer->firstName, "Lee", "first name";
is $customer->lastName, "Aylward", "last name";
is $customer->company, "ServerCentral", "company";
is $customer->email, 'laylward@gmail.com', "email";
is $customer->gatewayToken, "SIMULATED", "token";
is $customer->isVatExempt, 0, "VAT exempt";

my $customer2 = $product->get_customer($customer->code);
is $customer->id, $customer2->id, "get_customer";

my $sub = ($customer->subscriptions)[0];
is $sub->ccCountry, "US", "cc country";
is $sub->ccFirstName, "Lee", "cc first name";
is $sub->ccLastName, "Aylward", "cc last name";

$product->delete_customer('testuser');

my $customer3 = $product->create_customer(
  code => "testuser",
  firstName => "Test",
  lastName => "User",
  email => 'testuser@example.com',
  'subscription[planCode]' => 'BASIC_CHAT',
  'subscription[ccNumber]' => '5555555555554444',
  'subscription[ccExpiration]' => '12/2012',
  'subscription[ccFirstName]' => 'Test',
  'subscription[ccLastName]' => 'User',
);

my $customer4 = $product->get_customer($customer3->code);
is $customer3->id, $customer4->id, "get_customer on testuser";
$product->delete_customer('testuser');

done_testing();
