package Venus::Role::Matchable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'with';

# METHODS

sub match {
  my ($self, $method, @args) = @_;

  require Venus::Match;

  local $_ = $self;

  my $match = Venus::Match->new($method ? scalar($self->$method(@args)) : $self);

  return $match;
}

# EXPORTS

sub EXPORT {
  ['match']
}

1;
