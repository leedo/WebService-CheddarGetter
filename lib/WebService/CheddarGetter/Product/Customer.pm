package WebService::CheddarGetter::Product::Customer;

use Any::Moose;

has product => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Product',
  required => 1,
);

has element => (
  is => 'rw',
  required => 1,
);

has cache => (
  is => 'rw',
  default => sub {{}},
);

has [qw/id code/] => (
  is => 'rw',
);

our $AUTOLOAD;

sub BUILD {
  my $self = shift;
  my $id = $self->element->findvalue('@id', $self->element);
  my $code = $self->element->findvalue('@code', $self->element);
  $self->id($id);
  $self->code($code);
}

sub AUTOLOAD {
  my $method = $AUTOLOAD;
  $method =~ s/.*://;
  my $self = shift;
  my @args = @_;

  if (!$self->cache->{$method}) {
    my $value = $self->element->findvalue("$method", $self->element);
    $self->cache->{$method} = $value;
  }

  return $self->cache->{$method};
}

sub _refresh {
  my $self = shift;
  $self->cache({});

  my $path = "customers/get/productCode/".$self->product->code."/code/".$self->code;
  my $res = $self->product->client->send_request('get', $path);
  my @customers = $res->findnodes("customers/customer");

  if (@customers) {
    $self->element($customers[0]);
  }
  else {
    die "Couldn't get customer data for: ".$self->code;
  }
}

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
