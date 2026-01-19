package Venus::Role::Stashable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'mask';

# ATTRIBUTES

mask 'private';

# BUILDERS

sub BUILD {
  my ($self, $data) = @_;

  $self->private({}) if !$self->private;

  return $self;
};

# METHODS

sub stash {
  my ($self, $key, $value) = @_;

  return $self->private if !exists $_[1];

  return $self->private->{$key} if !exists $_[2];

  $self->private->{$key} = $value;

  return $value;
}

# EXPORTS

sub EXPORT {
  ['stash', 'private']
}

1;
