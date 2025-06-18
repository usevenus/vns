package Venus::Undef;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base';

# INHERITS

base 'Venus::Kind::Value';

no overloading;

# BUILDERS

sub build_self {
  my ($self, $data) = @_;

  $self->{value} = undef;

  return $self;
}

# METHODS

sub comparer {
  my ($self) = @_;

  return 'numified';
}

sub default {

  return undef;
}

sub numified {
  my ($self) = @_;

  return 0;
}

sub stringified {
  my ($self) = @_;

  return '';
}

1;
