package WebService::CheddarGetter::Customer;

use Moose;

has xpath => (is => 'ro', default => 'customers/customer');
has url_prefix => (is => 'ro', default=> 'customers');
has type => (is => 'ro', default => 'customer');

with "WebService::CheddarGetter::XMLObject";

has attributes => (
  is => 'ro',
  default => sub {
    [qw/firstName lastName company email gatewayToken
        isVatExempt
    /]
  }
);

sub subscriptions {
  my $self = shift;
  return map {
    WebService::Cheddargetter::Product::Customer::Subscription->new(
      element  => $_,
      customer => $self,
    )
  } $self->element->findNodes("/subscriptions/subscription", $self->element);
}

1;
