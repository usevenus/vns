package Venus::Result;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Buildable';
with 'Venus::Role::Tryable';
with 'Venus::Role::Catchable';

# ATTRIBUTES

attr 'issue';
attr 'value';

# BUILDERS

sub build_self {
  my ($self, $data) = @_;

  return $self;
}

# METHODS

sub attest {
  my ($self, $from, $accept) = @_;

  $from ||= 'value';

  my $value = $self->$from;

  require Venus::Assert;

  my $assert = Venus::Assert->new;

  $assert->name("Venus::Result#$from");

  $assert->expression($accept || 'any');

  return $assert->result($value);
}

sub check {
  my ($self, $from, $accept) = @_;

  $from ||= 'value';

  my $value = $self->$from;

  require Venus::Assert;

  my $assert = Venus::Assert->new;

  $assert->name("Venus::Result#$from");

  $assert->expression($accept || 'any');

  return $assert->valid($value);
}

sub invalid {
  my ($self, $issue) = @_;

  my $result = $self->class->new(issue => $issue);

  return $result;
}

sub is_invalid {
  my ($self) = @_;

  my $invalid = $self->is_valid ? false : true;

  return $invalid;
}

sub is_valid {
  my ($self) = @_;

  my $valid = $self->issue ? false : true;

  return $valid;
}

sub on_invalid {
  my ($self, $code, @args) = @_;

  return $self if !$code || !$self->issue;

  my ($issue, $value) = $self->catch($code, @args);

  my $result = $self->class->new($issue ? (issue => $issue) : (value => $value));

  return $result;
}

sub on_valid {
  my ($self, $code, @args) = @_;

  return $self if !$code || $self->issue;

  my ($issue, $value) = $self->catch($code, @args);

  my $result = $self->class->new($issue ? (issue => $issue) : (value => $value));

  return $result;
}

sub then {
  my ($self, $code, @args) = @_;

  return $self if !$code;

  my $method = $self->issue ? 'on_invalid' : 'on_valid';

  return $self->$method($code, @args);
}

sub valid {
  my ($self, $value) = @_;

  my $result = $self->class->new(value => $value);

  return $result;
}

1;
