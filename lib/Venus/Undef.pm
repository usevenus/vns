package Venus::Undef;

use 5.018;

use strict;
use warnings;

use Venus::Class 'base';

base 'Venus::Kind::Value';

no overloading;

# BUILDERS

sub build_self {
  my ($self, $data) = @_;

  $self->{value} = undef;

  return $self;
}

# METHODS

sub assertion {
  my ($self) = @_;

  my $assertion = $self->SUPER::assertion;

  $assertion->match('undef')->format(sub{
    (ref $self || $self)->new
  });

  return $assertion;
}

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
