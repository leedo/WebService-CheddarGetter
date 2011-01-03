package WebService::CheddarGetter::Subscription;

use Moose;

has xpath => (is => 'ro', default => 'subscriptions/subscription');

has attributes => (
  is => 'ro',
  default => sub {[]}
);

with "WebService::CheddarGetter::XMLObject";

1;
