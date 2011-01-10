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

has customer => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Customer',
  required => 1,
);

with "WebService::CheddarGetter::XMLObject";

sub product {
  my $self = shift;
  return $self->customer->product;
}

sub refresh {
  my $self = shift;
  $self->customer->refresh;
}

sub update {
  my ($self, %params) = @_;
  my $path = "customers/edit-subscription/productCode/"
             .$self->product->code."/code/".$self->customer->code;
  my $res = $self->product->client->send_request("post", $path, %params);
  my $element = ($res->findnodes("customers/customer"))[0];
  $self->customer->element($element);
}

1;
