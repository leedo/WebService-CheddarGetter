package WebService::CheddarGetter::XMLObject;

use Moose::Role;

requires qw/xpath attributes/;

has element => (
  is => 'rw',
);

has [qw/id code/] => (
  is => 'rw',
);

after element => sub {
  my $self = shift;
  $self->_process_element if @_;
};

sub BUILD {
  my $self = shift;
  for my $attr (@{ $self->attributes }) {
    $self->meta->add_attribute($attr, {is => 'rw'});
  }
  $self->_process_element if $self->element;
}

sub _process_element {
  my $self = shift;

  for my $node ($self->element->nonBlankChildNodes) {
    my $name = $node->nodeName;
    $self->$name($node->textContent) if $self->meta->has_attribute($name);
  }

  my $id = $self->element->findvalue('@id', $self->element);
  my $code = $self->element->findvalue('@code', $self->element);
  $self->id($id);
  $self->code($code);
}

1;
