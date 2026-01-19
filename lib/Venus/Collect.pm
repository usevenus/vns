package Venus::Collect;

use 5.018;

use strict;
use warnings;

# VENUS

use Venus::Class 'base', 'with';

# IMPORTS

use Venus 'list', 'pairs';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Valuable';

# METHODS

sub execute {
  my ($self, $code) = @_;

  require Scalar::Util;

  my $value = $self->value;

  return $value if !$code;

  my $blessed = !!Scalar::Util::blessed($value);

  if (!$blessed && ref $value eq 'ARRAY') {
    return $self->iterate_over_unblessed_arrayref($code, $value);
  }

  if (!$blessed && ref $value eq 'HASH') {
    return $self->iterate_over_unblessed_hashref($code, $value);
  }

  if ($blessed && $value->isa('Venus::Array')) {
    return $self->iterate_over_venus_array_object($code, $value);
  }

  if ($blessed && $value->isa('Venus::Set')) {
    return $self->iterate_over_venus_set_object($code, $value);
  }

  if ($blessed && $value->isa('Venus::Hash')) {
    return $self->iterate_over_venus_hash_object($code, $value);
  }

  if ($blessed && $value->isa('Venus::Map')) {
    return $self->iterate_over_venus_map_object($code, $value);
  }

  if ($blessed && UNIVERSAL::isa($value, 'ARRAY')) {
    return $self->iterate_over_blessed_arrayref($code, $value);
  }

  if ($blessed && UNIVERSAL::isa($value, 'HASH')) {
    return $self->iterate_over_blessed_hashref($code, $value);
  }

  return $value;
}

sub iterate {
  my ($self, $code, $pairs) = @_;

  my $result = [];

  for my $pair (list $pairs) {
    my ($key, $value) = (list $pair);

    local $_ = $value;

    my @returned = list $code->($key, $value);

    push @{$result}, [@returned] if @returned == 2;
  }

  return wantarray ? @{$result} : $result;
}

sub iterate_over_blessed_arrayref {
  my ($self, $code, $value) = @_;

  my @results = $self->iterate($code, scalar pairs [@{$value}]);

  @results = map {$$_[1]} sort {$$a[0] <=> $$b[0]} @results;

  return bless [@results], ref $value;
}

sub iterate_over_blessed_hashref {
  my ($self, $code, $value) = @_;

  my @results = $self->iterate($code, scalar pairs {%{$value}});

  @results = map +($$_[0], $$_[1]), @results;

  return bless {@results}, ref $value;
}

sub iterate_over_unblessed_arrayref {
  my ($self, $code, $value) = @_;

  my @results = $self->iterate($code, scalar pairs $value);

  @results = map {$$_[1]} sort {$$a[0] <=> $$b[0]} @results;

  return [@results];
}

sub iterate_over_unblessed_hashref {
  my ($self, $code, $value) = @_;

  my @results = $self->iterate($code, scalar pairs $value);

  @results = map +($$_[0], $$_[1]), @results;

  return {@results};
}

sub iterate_over_venus_array_object {
  my ($self, $code, $value) = @_;

  my @results = $self->iterate($code, scalar $value->pairs);

  @results = map {$$_[1]} sort {$$a[0] <=> $$b[0]} @results;

  return $value->new(value => [@results]);
}

sub iterate_over_venus_hash_object {
  my ($self, $code, $value) = @_;

  my @results = $self->iterate($code, scalar $value->pairs);

  @results = map +($$_[0], $$_[1]), @results;

  return $value->new(value => {@results});
}

sub iterate_over_venus_map_object {
  my ($self, $code, $value) = @_;

  my @results = $self->iterate($code, scalar $value->pairs);

  @results = map +($$_[0], $$_[1]), @results;

  return $value->renew(value => {@results});
}

sub iterate_over_venus_set_object {
  my ($self, $code, $value) = @_;

  my @results = $self->iterate($code, scalar $value->pairs);

  @results = map {$$_[1]} sort {$$a[0] <=> $$b[0]} @results;

  return $value->renew(value => [@results]);
}

1;
