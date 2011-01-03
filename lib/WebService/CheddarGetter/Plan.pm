package WebService::CheddarGetter::Plan;

use Moose;

has xpath => (is => 'ro', default => 'plans/plan');
has url_prefix => (is => 'ro', default=> 'plans');
has type => (is => 'ro', default => 'plan');

has attributes => (
  is => 'ro',
  default => sub {
    [qw/isActive name isFree trialDays billingFrequency
       billingFrequencyPer billingFrequencyUnit
       billingFrequencyQuantity setupChargeAmount
       recurringChargeCode recurringChargeAmount
    /]
  }
);

with "WebService::CheddarGetter::XMLObject";

1;
