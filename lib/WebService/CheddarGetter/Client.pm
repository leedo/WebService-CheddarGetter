package WebService::CheddarGetter::Client;

use warnings;
use strict;

use Moose;
use LWP::UserAgent;
use WebService::CheddarGetter::Product;
use XML::LibXML;

our $VERSION = '0.01';

has email => (
  isa => 'Str',
  is => 'rw',
  required => 1,
);

has password => (
  isa => 'Str',
  is => 'rw',
  required => 1,
);

has ua => (
  is => 'ro',
  isa => 'LWP::UserAgent',
  default => sub {LWP::UserAgent->new},
);

has api_host => (
  is => 'ro',
  isa => 'Str',
  default => "cheddargetter.com",
);

has api_base => (
  is => 'ro',
  isa => 'Str',
  default => "/xml/",
);

has products => (
  is => 'rw',
  isa => 'HashRef[WebService::CheddarGetter::Products]',
  required => 1,
  default => sub {{}},
);

sub set_credentials {
  my $self = shift;
  $self->ua->credentials(
    $self->api_host.":443", "CheddarGetter API", $self->email, $self->password
  );
}

sub product {
  my ($self, $product_code) = @_;

  if (!$self->products->{$product_code}) {
    $self->products->{$product_code} = WebService::CheddarGetter::Product->new(
      code => $product_code,
      client => $self,
    );
  }

  return $self->products->{$product_code};
}

sub send_request {
  my ($self, $path, %params) = @_;

  $self->set_credentials;

  my $uri = "https://".$self->api_host . $self->api_base . $path;
  my $res = $self->ua->get($uri, %params);

  if ($res->is_success) {
    my $data = eval { XML::LibXML->load_xml(string => $res->content) };
    if (!$@ and $data) {
      return $data;
    }
    die $@;
  }
  else {
    die $res->status_line;
  }
}

=head1 NAME

WebService::CheddarGetter - Interact with the CheddarGetter.com API

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use WebService::CheddarGetter;

    my $foo = WebService::CheddarGetter->new();
    ...


=head1 AUTHOR

Lee Aylward, C<< <leedo at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-cheddargetter at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-CheddarGetter>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::CheddarGetter


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-CheddarGetter>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-CheddarGetter>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-CheddarGetter>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-CheddarGetter/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Lee Aylward.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of WebService::CheddarGetter
