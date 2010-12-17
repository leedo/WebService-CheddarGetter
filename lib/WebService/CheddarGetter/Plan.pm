package WebService::CheddarGetter::Plan;

use Moose;

has xpath => (is => 'ro', default => 'plans/plan');
has url_prefix => (is => 'ro', default=> 'plans');
has type => (is => 'ro', default => 'plan');

with "WebService::CheddarGetter::CachedXML";

1;
