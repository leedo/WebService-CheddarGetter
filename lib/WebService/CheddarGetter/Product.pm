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

  my $element = ($res->findnodes("customers/customer"))[0];

  return WebService::CheddarGetter::Customer->new(
    element => $element,
    product => $self,
  );
}

sub delete_customer {
  my ($self, $code) = @_;

  if (ref $code eq 'WebService::CheddarGetter::Customer') {
    $code = $code->code;
  }

  my $path = "customers/delete/productCode/".$self->code."/code/$code";
  $self->client->send_request('post', $path, productCode => $self->code);
}

sub delete_all_customers {
  my $self = shift;
  my $path = "customers/delete-all/confirm/1/productCode/".$self->code;
  $self->client->send_request('post', $path, productCode => $self->code);
}

1;
