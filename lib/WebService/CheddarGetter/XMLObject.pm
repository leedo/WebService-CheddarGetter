package WebService::CheddarGetter::XMLObject;

use Moose::Role;

requires qw/xpath attributes/;

has element => (
  is => 'rw',
);

has [qw/id code/] => (
  is => 'rw',
);

sub BUILD {
  my $self = shift;

  die "No element!" unless $self->element;

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


sub _process_element {
  my $self = shift;

  for my $node ($self->element->nonBlankChildNodes) {
    my $name = $node->nodeName;
    $self->$name($node->textContent) if $self->meta->has_attribute($name);
  }
}

sub find {
  my ($self, $query) = @_;
  my $xpath = XML::LibXML::XPathContext->new($self->element);
  return $xpath->findnodes($query);
}

1;
