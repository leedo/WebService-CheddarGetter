package WebService::CheddarGetter::Plan;

use Moose;

has xpath => (is => 'ro', default => 'plans/plan');
has url_prefix => (is => 'ro', default=> 'plans');
has type => (is => 'ro', default => 'plan');

has product => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Product',
  required => 1,
);

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

with qw/WebService::CheddarGetter::XMLObject
        WebService::CheddarGetter::RemoteXML/;

1;
