package WebService::CheddarGetter::Product;

use Moose;
use WebService::CheddarGetter::Plan;
use WebService::CheddarGetter::Customer;

has client => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Client',
  required => 1,
);

has code => (
  is => 'ro',
  required => 1,
);

sub customers {
  my $self = shift;

  my $path = "customers/get/productCode/".$self->code;
  my $res = $self->client->send_request('get', $path);
  return () unless $res;

  return map {
    WebService::CheddarGetter::Customer->new(
      element => $_,
      product => $self,
    )
  } $res->findnodes("/customers/customer");

}

sub get_customer {
  my ($self, $code) = @_;
  return WebService::CheddarGetter::Customer->new(
    code    => $code,
    product => $self,
  );
}

sub plans {
  my $self = shift;

  my $path = "plans/get/productCode/".$self->code;
  my $res = $self->client->send_request('get', $path);
  return () unless $res;

  return map {
    WebService::CheddarGetter::Plan->new(
      element => $_,
      product => $self,
    )
  } $res->findnodes("/plans/plan");
}

sub get_plan {
  my ($self, $code) = @_;
  return WebService::CheddarGetter::Plan->new(
    code    => $code,
    product => $self,
  );
}

sub create_customer {
  my ($self, %params) = @_;

  my $path = "customers/new/productCode/".$self->code;
  my $res = $self->client->send_request('post', $path, %params);
  die "Could not create customer" unless $res;

  return WebService::CheddarGetter::Customer->new(
    element => $res,
    product => $self,
  );
}

1;
