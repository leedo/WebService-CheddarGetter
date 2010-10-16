package WebService::CheddarGetter::Product::Plan;

use Any::Moose;

has product => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Product',
  required => 1,
);

has client => (
  is => 'ro',
  isa => 'WebService::CheddarGetter::Client',
  lazy => 1,
  default => sub {$_[0]->product->client}
);

has element => (
  is => 'ro',
  required => 1,
);

our $AUTOLOAD;

sub AUTOLOAD {
  my $method = $AUTOLOAD;
  $method =~ s/.*://;
  my $self = shift;
  my @args = @_;
  
  my $value = eval { $self->element->findvalue("//$method"); };
  if ($@) { die "$method is not a valid ".__PACKAGE__." method\n" }

  return $value;
}

1;
