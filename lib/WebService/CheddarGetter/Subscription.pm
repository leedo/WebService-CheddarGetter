package WebService::CheddarGetter::Subscription;

use Moose;

has xpath => (is => 'ro', default => 'subscriptions/subscription');

has attributes => (
  is => 'ro',
  default => sub {
    [qw/gatewayToken ccFirstName ccLastName ccCompany ccCountry
       ccAddress ccCity ccState ccZip ccType ccLastFour 
       ccExpirationDate canceledDatetime createdDatetime
    /]
  }
);

with "WebService::CheddarGetter::XMLObject";

1;
