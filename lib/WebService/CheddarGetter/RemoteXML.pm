package WebService::CheddarGetter::RemoteXML;

use Moose::Role;

requires qw/url_prefix type product/;

before BUILD => sub {
  my $self = shift;
  $self->refresh unless $self->element;
};

sub refresh {
  my $self = shift;

  my $path = $self->url_prefix."/get/productCode/".$self->product->code."/code/".$self->code;
  my $res = $self->product->client->send_request('get', $path);
  my @nodes = $res->findnodes($self->xpath);

  if (!@nodes) {
    die "Couldn't get ".$self->type." data for: ".$self->code;
  }

  $self->element($nodes[0]);
}

1;
