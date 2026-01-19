package Venus::Data;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base', 'mask';

# INHERITS

base 'Venus::Kind::Utility';

# ATTRIBUTES

mask 'issues';
mask 'ruleset';
mask 'validated';
mask 'value';

# BUILDERS

sub build_self {
  my ($self, $data) = @_;

  my $value = delete $data->{value};

  my $ruleset = delete $data->{ruleset};

  $value = {%{$data}} if !$value && keys %{$data};

  require Venus;

  $self->value(Venus::clone($value));

  $self->ruleset(Venus::clone($ruleset));

  delete $self->{$_} for keys %{$self};

  return $self;
}

# METHODS

sub error {
  my ($self) = @_;

  my $errors = $self->errors;

  return $errors->[0];
}

sub errors {
  my ($self) = @_;

  require Venus;

  my $issues = $self->issues;

  return Venus::clone($issues);
}

sub renew {
  my ($self, @args) = @_;

  my $data = $self->ARGS(@args);

  $data->{ruleset} = $self->ruleset;

  return $self->class->new($data);
}

sub shorthand {
  my ($self, $data) = @_;

  require Venus::Schema;

  my $ruleset = Venus::Schema->shorthand($data);

  $self->ruleset($ruleset);

  return $self;
}

sub valid {
  my ($self) = @_;

  $self->validate if !defined $self->validated;

  return $self->validated;
}

sub validate {
  my ($self) = @_;

  require Venus;

  return $self->validated
    ? Venus::clone($self->value)
    : undef
    if defined $self->validated;

  require Venus::Schema;

  my $schema = Venus::Schema->new->rules(
    $self->ruleset
    ? @{$self->ruleset}
    : ()
  );

  my ($errors, $value) = $schema->validate($self->value);

  if (@{$errors}) {
    $self->validated(false);
    $self->issues($errors);
    $self->value($value);
    return undef;
  }
  else {
    $self->validated(true);
    $self->issues([]);
    $self->value($value);
    return Venus::clone($value);
  }

  return $self;
}

1;