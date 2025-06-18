package Venus::Role::Explainable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'fault';

# AUDITS

sub AUDIT {
  my ($self, $from) = @_;

  my $name = ref $self || $self;

  if (!$from->can('explain')) {
    fault "${from} requires 'explain' to consume ${name}";
  }

  return $self;
}

1;
