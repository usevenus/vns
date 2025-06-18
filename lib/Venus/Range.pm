package Venus::Range;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Valuable';

# ATTRIBUTES

attr 'start';
attr 'stop';
attr 'step';

# BUILDERS

sub build_data {
  my ($self, $data) = @_;

  $data->{value} = [] if !$data->{value} || !ref $data->{value} || ref $data->{value} ne 'ARRAY';
  $data->{start} //= 0;
  $data->{stop} //= $#{$data->{value}};
  $data->{step} //= 1;

  return $data;
}

# METHODS

sub after {
  my ($self, $pos) = @_;

  my $tail = $#{$self->value};

  my ($start, $stop) = defined $pos && $pos < $tail ? (($pos + 1), $tail) : (-1, 0);

  return $self->parse("${start}:${stop}", $self->value)->select;
}

sub before {
  my ($self, $pos) = @_;

  my $head = 0;

  my ($start, $stop) = defined $pos && $pos > $head ? ($head, ($pos - 1)) : (-1, 0);

  return $self->parse("${start}:${stop}", $self->value)->select;
}

sub compute {
  my ($self) = @_;

  my $start = $self->start;
  my $stop = $self->stop;
  my $step = $self->step;
  my $length = $self->length;

  $start += $length if $start < 0;
  $stop += $length if defined $stop && $stop < 0;

  $stop = $length - 1 unless defined $stop;

  return [] if $start > $stop;

  $step = 1 unless $step;

  $step = $step * -1 if $step < 0;

  my $range = [];

  for (my $i = $start; $i <= $stop; $i += $step) {
    push @{$range}, $i if $i >= 0 && $i < $length;
  }

  return $range;
}

sub iterate {
  my ($self) = @_;

  my $range = $self->compute;

  my $result = [@{$self->value}[@{$range}]];

  my $i = 0;

  return sub {
    return if $i >= @{$result};
    return $result->[$i++];
  };
}

sub length {
  my ($self) = @_;

  my $length = scalar @{$self->value};

  return $length;
}

sub parse {
  my ($self, $expr, $data) = @_;

  $expr //= '';

  my ($start, $stop, $step) = (0, undef, 1);

  if ($expr =~ /^(-?\d*):(-?\d*)(?::(-?\d+))?$/) {
    $start = $1 if CORE::length($1);
    $stop = CORE::length($2) ? $2 : undef;
    $step = $3 if defined $3;
  }
  elsif ($expr =~ /^(-?\d+)$/) {
    $start = $1;
    $stop = $start;
  }

  return $self->class->new(value => $data || [], start => $start, stop => $stop, step => $step);
}

sub partition {
  my ($self, $pos) = @_;

  my $result = [[], []];

  $pos = 0 if !defined $pos;

  push @{$result->[0]}, $self->before($pos);
  push @{$result->[1]}, $self->after($pos - 1);

  return wantarray ? (@{$result}) : $result;
}

sub select {
  my ($self) = @_;

  my $range = $self->compute;

  my $result = [@{$self->value}[@{$range}]];

  return wantarray ? (@{$result}) : $result;
}

sub split {
  my ($self, $pos) = @_;

  my $result = [[], []];

  $pos = 0 if !defined $pos;

  push @{$result->[0]}, $self->before($pos);
  push @{$result->[1]}, $self->after($pos);

  return wantarray ? (@{$result}) : $result;
}

1;
