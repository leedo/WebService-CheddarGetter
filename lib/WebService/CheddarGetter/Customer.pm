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

has _subscription => (
  is => 'rw',
  isa => 'WebService::CheddarGetter::Subscription',
);

with qw/WebService::CheddarGetter::XMLObject
        WebService::CheddarGetter::RemoteXML/;

after element => sub {
  my $self = shift;
  if (@_ and $self->_subscription) {
    if (my $element = $self->subscription_element) {
      $self->subscription->element($element);
    }
  }
};

sub subscription {
  my $self = shift;
  return $self->_subscription if $self->_subscription;

  if (my $element = $self->subscription_element) {
    my $sub = WebService::CheddarGetter::Subscription->new(
      element => $element,
      customer => $self,
    );
    $self->_subscription($sub);
    return $sub;
  }
}

sub subscription_element {
  my $self = shift;
  my @nodes = $self->element->findnodes("subscriptions/subscription");
  return $nodes[0] if @nodes;
}

sub delete {
  my $self = shift;
  $self->product->delete_customer($self->code);
}

sub update {
  my ($self, %params) = @_;
  my $path = "customers/edit-customer/productCode/"
             .$self->product->code."/code/".$self->code;
  my $res = $self->product->client->send_request("post", $path, %params);
  my $element = ($res->findnodes($self->xpath))[0];
  $self->element($element);
}

1;
