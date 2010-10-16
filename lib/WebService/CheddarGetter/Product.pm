package WebService::CheddarGetter::Product;

use Any::Moose;
use WebService::CheddarGetter::Product::Plan;

has client => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Client',
  required => 1,
);

has code => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

sub customers {
  my $self = shift;

  my $path = "customers/get/productCode/".$self->code;
  my $res = $self->client->send_request($path);
  return () unless $res;

  return map {
    WebService::CheddarGetter::Product::Customer->new(
      element => $_,
      product => $self,
    )
  } $res->findnodes("//customers/customer");

}

sub plans {
  my $self = shift;

  my $path = "plans/get/productCode/".$self->code;
  my $res = $self->client->send_request($path);
  return () unless $res;

  return map {
    WebService::CheddarGetter::Product::Plan->new(
      element => $_,
      product => $self,
    )
  } $res->findnodes("//plans/plan");
}

1;
