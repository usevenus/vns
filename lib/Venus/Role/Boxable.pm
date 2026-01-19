package Venus::Role::Boxable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'with';

# METHODS

sub box {
  my ($self, $method, @args) = @_;

  require Venus::Box;

  local $_ = $self;

  my $value = $method ? $self->$method(@args) : $self;

  return Venus::Box->new(value => $value);
}

sub boxed {
  my ($self, @args) = @_;

  return $self->box(@args)->unbox;
}

# EXPORTS

sub EXPORT {
  ['box', 'boxed']
}

1;
