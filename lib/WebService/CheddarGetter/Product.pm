package WebService::CheddarGetter::Product;

use Any::Moose;

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
}

sub plans {
  my $self = shift;
  my $path = "plans/get/productCode/".$self->code;
  my $res = $self->client->send_request($path);
  use Data::Dumper;
  print STDERR Dumper $res;
}

1;
