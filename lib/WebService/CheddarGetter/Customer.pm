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
  } $self->element->findnodes("subscriptions/subscription");
}

sub delete {
  my $self = shift;
  $self->product->delete_customer($self->code);
}

sub update_info {
  my ($self, %params) = @_;
  my $path = "customers/edit-customer/productCode/"
             .$self->product->code."/code/".$self->code;
  my $res = $self->product->client->send_request("post", $path, %params);
  my $element = ($res->findnodes($self->xpath))[0];
  $self->element($element);
}

1;
