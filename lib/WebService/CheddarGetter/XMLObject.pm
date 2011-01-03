package WebService::CheddarGetter::XMLObject;

use Moose::Role;

requires qw/xpath url_prefix type/;

has product => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Product',
  required => 1,
);

has element => (
  is => 'rw',
);

has [qw/id code/] => (
  is => 'rw',
);

has attributes => (
  is => 'rw',
  default => sub {[]},
);

sub BUILD {
  my $self = shift;

  if (!$self->element) {
    if (!$self->code) {
      die "Need either code or element option!";
    }
    $self->_refresh_element;
  }

  $self->_add_attributes;
  $self->_process_element;

  my $id = $self->element->findvalue('@id', $self->element);
  my $code = $self->element->findvalue('@code', $self->element);
  $self->id($id);
  $self->code($code);
}

sub _add_attributes {
  my $self = shift;
  for my $attr (@{ $self->attributes }) {
    $self->meta->add_attribute($attr, {is => 'rw'});
  }
}

sub _refresh_element {
  my $self = shift;

  my $path = $self->url_prefix."/get/productCode/".$self->product->code."/code/".$self->code;
  my $res = $self->product->client->send_request('get', $path);
  my @nodes = $res->findnodes($self->xpath);

  if (!@nodes) {
    die "Couldn't get ".$self->type." data for: ".$self->code;
  }

  $self->element($nodes[0]);
}

sub _process_element {
  my $self = shift;

  for my $node ($self->element->nonBlankChildNodes) {
    my $name = $node->nodeName;
    $self->$name($node->textContent) if $self->meta->has_attribute($name);
  }
}

1;
