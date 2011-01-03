package WebService::CheddarGetter::Customer;

use Moose;
use WebService::CheddarGetter::Subscription;

has xpath => (is => 'ro', default => 'customers/customer');
has url_prefix => (is => 'ro', default=> 'customers');
has type => (is => 'ro', default => 'customer');

has product => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Product',
  required => 1,
);

has attributes => (
  is => 'ro',
  default => sub {
    [qw/firstName lastName company email gatewayToken
        isVatExempt
    /]
  }
);

with qw/WebService::CheddarGetter::XMLObject
        WebService::CheddarGetter::RemoteXML/;

sub subscriptions {
  my $self = shift;
  return map {
    WebService::CheddarGetter::Subscription->new(
      element  => $_,
      customer => $self,
    )
  } $self->find("subscriptions/subscription");
}

1;
