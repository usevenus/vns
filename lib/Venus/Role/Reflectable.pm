package Venus::Role::Reflectable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'with';

# METHODS

sub class {
  my ($self) = @_;

  return ref($self) || $self;
}

sub clone {
  my ($self) = @_;

  require Storable;

  local $Storable::Deparse = 1;

  local $Storable::Eval = 1;

  return Storable::dclone($self);
}

sub meta {
  my ($self) = @_;

  require Venus::Meta;

  return Venus::Meta->new(name => $self->class);
}

sub reify {
  my ($self, $method, @args) = @_;

  return $self->what($method, @args)->deduce;
}

sub space {
  my ($self) = @_;

  require Venus::Space;

  return Venus::Space->new($self->class);
}

sub what {
  my ($self, $method, @args) = @_;

  require Venus::What;

  local $_ = $self;

  my $value = $method
    ? $self->$method(@args) : $self->can('value') ? $self->value : $self;

  return Venus::What->new(value => $value);
}

# EXPORTS

sub EXPORT {
  ['class', 'clone', 'meta', 'reify', 'space', 'what']
}

1;
