package WebService::CheddarGetter::CachedXML;

use Moose::Role;

requires "xpath";
requires "url_prefix";

has product => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Product',
  required => 1,
);

has element => (
  is => 'rw',
);

has cache => (
  is => 'rw',
  default => sub {{}},
);

has [qw/id code/] => (
  is => 'rw',
);

sub BUILD {
  my $self = shift;

  if (!$self->element) {
    if (!$self->code) {
      die "Need either code or element option!";
    }
    $self->_refresh;
  }

  my $id = $self->element->findvalue('@id', $self->element);
  my $code = $self->element->findvalue('@code', $self->element);
  $self->id($id);
  $self->code($code);
}

our $AUTOLOAD;

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

  my $path = $self->url_prefix."/get/productCode/".$self->product->code."/code/".$self->code;
  my $res = $self->product->client->send_request('get', $path);
  my @nodes = $res->findnodes($self->xpath);

  if (@nodes) {
    $self->element($nodes[0]);
  }
  else {
    die "Couldn't get ".$self->type." data for: ".$self->code;
  }
}

1;
