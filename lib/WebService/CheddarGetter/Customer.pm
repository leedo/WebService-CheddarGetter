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
  isa => 'WebService::CheddarGetter::Subscription|Undef',
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

sub active_subscription {
  my $self = shift;

  my ($element) = $self->subscription_elements;
  if ($element) {
    return WebService::CheddarGetter::Subscription->new(
      element => $element,
      customer => $self,
    );
  }
}

sub subscriptions {
  my $self = shift;
  
  return map {
    WebService::CheddarGetter::Subscription->new(
      element => $element,
      customer => $self,
    );
  } $self->subscription_elements;
}

sub subscription_elements {
  my $self = shift;
  my @nodes = $self->element->findnodes("subscriptions/subscription");
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
  my @nodes = $res->findnodes($self->xpath);
  $self->element($nodes[0]) if @nodes;
}

sub update_with_subscription {
  my ($self, %params) = @_;
  my $path = "customers/edit/productCode/"
             .$self->product->code."/code/".$self->code;
  my $res = $self->product->client->send_request("post", $path, %params);
  my @nodes = $res->findnodes($self->xpath);
  $self->element($nodes[0]) if @nodes;
}

sub cancel_subscription {
  my $self = shift;
  my $path = "customers/cancel/productCode/"
             .$self->product->code."/code/".$self->code;
  my $res = $self->product->client->send_request("get", $path);
  $self->_subscription(undef);
}

1;
