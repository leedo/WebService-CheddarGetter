package WebService::CheddarGetter::Plan;

use Any::Moose;

has product => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Product',
  required => 1,
);

has client => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Client',
  lazy => 1,
  default => sub {$_[0]->product->client}
);

has [qw/billingFrequencyQuantity id code name
        billingFrequencyUnit recurringChargeCode
        description billingFrequencyPer
        billingFrequency/] => (
  is => 'rw',
  required => 1,
  isa => 'Str',
);

has [qw/recurringChargeAmount billingFrequencyQuantity
        setupChargeAmount trialDays/] => (
  is => 'rw',
  required => 1,
  isa => 'Number',
);

has [qw/isActive isFree/] => (
  is => 'rw',
  required => 1,
  isa => 'Bool',
);

1;
