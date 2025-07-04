package Venus::Kind::Value;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base', 'with';

# INHERITS

base 'Venus::Kind';

# INTEGRATES

with 'Venus::Role::Valuable';
with 'Venus::Role::Buildable';
with 'Venus::Role::Accessible';
with 'Venus::Role::Explainable';
with 'Venus::Role::Proxyable';
with 'Venus::Role::Pluggable';

# OVERLOADS

use overload (
  '""' => 'explain',
  '~~' => 'explain',
  fallback => 1,
);

# BUILDERS

sub build_arg {
  my ($self, $data) = @_;

  return {
    value => $data,
  };
}

# METHODS

sub cast {
  my ($self, @args) = @_;

  require Venus::What;

  my $value = $self->can('value') ? $self->value : $self;

  return Venus::What->new(value => $value)->cast(@args);
}

sub defined {
  my ($self) = @_;

  return CORE::defined($self->get) ? true : false;
}

sub explain {
  my ($self) = @_;

  return $self->get;
}

sub mutate {
  my ($self, $code, @args) = @_;

  return $self->set($self->$code(@args));
}

sub TO_JSON {
  my ($self) = @_;

  return $self->get;
}

1;
