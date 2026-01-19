package Venus::Validate;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Buildable';
with 'Venus::Role::Encaseable';

# ATTRIBUTES

attr 'input';
attr 'issue';
attr 'path';

# BUILDERS

sub build_arg {
  my ($self, $data) = @_;

  return {
    input => [$data],
  };
}

sub build_args {
  my ($self, $data) = @_;

  if (!grep CORE::exists $data->{$_}, qw(input issue path)) {
    $data = {input => [$data]} if keys %{$data};
  }

  if (CORE::exists $data->{input}) {
    $data->{input} = ref $data->{input} eq 'ARRAY'
      ? ((@{$data->{input}} > 1) ? [$data->{input}] : $data->{input})
      : [$data->{input}];
  }
  else {
    $data->{input} = [];
  }

  return $data;
}

# METHODS

sub arrayref {
  my ($self) = @_;

  $self->type('arrayref');

  return $self;
}

sub boolean {
  my ($self) = @_;

  $self->type('boolean');

  return $self;
}

sub check {
  my ($self, $type, $name, $code, @args) = @_;

  return $self if $self->issue;

  return $self if !$type;

  $self->type($type);

  return $self if $self->issue;

  return $self if !$code;

  my $value = $self->value;

  if ((!CORE::defined($value) || $value eq '') && $self->presence eq 'required') {
    $self->issue_info($name, @args);

    return $self;
  }

  local $_ = $value;

  $self->issue_info($name, @args) if !$self->$code($value, @args);

  return $self;
}

sub defined {
  my ($self) = @_;

  $self->type('defined');

  return $self;
}

sub each {
  my ($self, $method, $path) = @_;

  my $result = [];

  $method ||= 'optional';

  my $node = (
    (CORE::defined($path))
      && $method eq 'optional'
      || $method eq 'present'
      || $method eq 'required'
  ) ? $self->$method($path) : $self;

  my $value = $node->value;

  if (ref $value eq 'ARRAY') {
    push @{$result}, $node->$method($_) for 0..$#${value};
  }
  else {
    push @{$result}, $node;
  }

  return wantarray ? @{$result} : $result;
}

sub errors {
  my ($self, $data) = @_;

  my $errors = $self->encased('errors');

  $errors = $self->recase('errors', ref $data eq 'ARRAY' ? $data : []) if !$errors;

  return wantarray ? @{$errors} : $errors;
}

sub exists {
  my ($self) = @_;

  my @value = $self->value;

  return @value ? true : false;
}

sub float {
  my ($self) = @_;

  $self->type('float');

  return $self;
}

sub hashref {
  my ($self) = @_;

  $self->type('hashref');

  return $self;
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

sub issue_args {
  my ($self) = @_;

  my $issue = $self->issue;

  my $args = ref $issue eq 'ARRAY' ? $issue->[1] : [];

  return $args;
}

sub issue_info {
  my ($self, $type, @args) = @_;

  if ($type) {
    $self->issue([$type, [@args]]);

    push @{$self->errors}, [$self->path, $self->issue] if ref $self->errors eq 'ARRAY';
  }
  else {
    ($type, @args) = ($self->issue_type, @{$self->issue_args});
  }

  return wantarray ? ($type, @args) : $self->issue;
}

sub issue_type {
  my ($self) = @_;

  my $issue = $self->issue;

  my $type = ref $issue eq 'ARRAY' ? $issue->[0] : undef;

  return $type;
}

sub length {
  my ($self, $min_length, $max_length) = @_;

  $self->min_length($min_length);

  $self->max_length($max_length);

  return $self;
}

sub lowercase {
  my ($self) = @_;

  my $value = $self->value;

  if (CORE::defined($value) && !ref $value) {
    $self->value(lc $value);
  }

  return $self;
}

sub max_length {
  my ($self, $length) = @_;

  return $self if $self->issue;

  my $value = $self->value;

  if (ref $value) {
    $self->issue_info('max_length', $length);

    return $self;
  }

  if (!CORE::defined($value) && $self->presence eq 'optional') {
    return $self;
  }

  if ((!CORE::defined($value) || $value eq '') && $self->presence eq 'required') {
    $self->issue_info('max_length', $length);

    return $self;
  }

  if (CORE::length($value) > $length) {
    $self->issue_info('max_length', $length);
  }

  return $self;
}

sub max_number {
  my ($self, $maximum) = @_;

  return $self if $self->issue;

  my $value = $self->value;

  if (ref $value) {
    $self->issue_info('max_number', $maximum);

    return $self;
  }

  if (!CORE::defined($value) && $self->presence eq 'optional') {
    return $self;
  }

  if ((!CORE::defined($value) || $value eq '') && $self->presence eq 'required') {
    $self->issue_info('max_number', $maximum);

    return $self;
  }

  if ($value !~ /^-?\d+\.?\d*$/ || $value > $maximum) {
    $self->issue_info('max_number', $maximum);
  }

  return $self;
}

sub min_length {
  my ($self, $length) = @_;

  return $self if $self->issue;

  my $value = $self->value;

  if (ref $value) {
    $self->issue_info('min_length', $length);

    return $self;
  }

  if (!CORE::defined($value) && $self->presence eq 'optional') {
    return $self;
  }

  if ((!CORE::defined($value) || $value eq '') && $self->presence eq 'required') {
    $self->issue_info('min_length', $length);

    return $self;
  }

  if (CORE::length($value) < $length) {
    $self->issue_info('min_length', $length);
  }

  return $self;
}

sub min_number {
  my ($self, $minimum) = @_;

  return $self if $self->issue;

  my $value = $self->value;

  if (ref $value) {
    $self->issue_info('min_number', $minimum);

    return $self;
  }

  if (!CORE::defined($value) && $self->presence eq 'optional') {
    return $self;
  }

  if ((!CORE::defined($value) || $value eq '') && $self->presence eq 'required') {
    $self->issue_info('min_number', $minimum);

    return $self;
  }

  if ($value !~ /^-?\d+\.?\d*$/ || $value < $minimum) {
    $self->issue_info('min_number', $minimum);
  }

  return $self;
}

sub number {
  my ($self) = @_;

  $self->type('number');

  return $self;
}

sub on_invalid {
  my ($self, $code, @args) = @_;

  return $self if !$code || !$self->issue;

  local $_ = $self;

  return $self->$code(@args);
}

sub on_valid {
  my ($self, $code, @args) = @_;

  return $self if !$code || $self->issue;

  local $_ = $self;

  return $self->$code(@args);
}

sub optional {
  my ($self, $path) = @_;

  if (!CORE::defined($path)) {
    $self->recase('presence', 'optional');

    return $self;
  }

  my $node = $self->select($path);

  $node->recase('presence', 'optional');

  return $node;
}

sub pointer {
  my ($self, @path) = @_;

  my $pointer = join '.', grep defined, $self->path, @path;

  return $pointer;
}

sub presence {
  my ($self) = @_;

  my $presence = $self->encased('presence');

  return $presence || 'required';
}

sub present {
  my ($self, $path) = @_;

  my $node = CORE::defined($path) ? $self->select($path) : $self;

  $node->recase('presence', 'present');

  my @value = $node->value;

  $node->issue_info('present') if !@value;

  return $node;
}

sub required {
  my ($self, $path) = @_;

  my $node = CORE::defined($path) ? $self->select($path) : $self;

  $node->recase('presence', 'required');

  my @value = $node->value;

  return $node if @value && scalar grep defined, grep CORE::length, @value;

  $node->issue_info('required');

  return $node;
}

sub select {
  my ($self, $path) = @_;

  if (!CORE::defined($path)) {
    return $self;
  }

  my @value = $self->value;

  my $object;

  if (!$object && ref $value[0] eq 'ARRAY') {
    require Venus::Array;
    $object = Venus::Array->new(value => $value[0]);
  }

  if (!$object && ref $value[0] eq 'HASH') {
    require Venus::Hash;
    $object = Venus::Hash->new(value => $value[0]);
  }

  my ($data, $okay) =  ($object ? ($object->path($path)) : (undef, 0));

  my $node = $self->class->new(path => $self->pointer($path), input => [$okay ? $data : ()]);

  $node->errors(scalar $self->errors) if $self->errors;

  return $node;
}

sub string {
  my ($self) = @_;

  $self->type('string');

  return $self;
}

sub strip {
  my ($self) = @_;

  my $value = $self->value;

  if (CORE::defined($value) && !ref $value) {
    $value =~ s/\s{2,}/ /g;
    $self->value($value);
  }

  return $self;
}

sub sync {
  my ($self, $node) = @_;

  return $self if !$node;

  my @value = $node->value;

  return $self if !@value;

  @value = $self->value;

  my $object;

  if (!$object && ref $value[0] eq 'ARRAY') {
    require Venus::Array;
    $object = Venus::Array->new(value => $value[0]);
  }

  if (!$object && ref $value[0] eq 'HASH') {
    require Venus::Hash;
    $object = Venus::Hash->new(value => $value[0]);
  }

  if (!$object) {
    return $self;
  }

  $object->sets($node->path, $node->value);

  return $self;
}

sub titlecase {
  my ($self) = @_;

  my $value = $self->value;

  if (CORE::defined($value) && !ref $value) {
    $value =~ s/\b(\w)/\U$1/g;
    $self->value($value);
  }

  return $self;
}

sub trim {
  my ($self) = @_;

  my $value = $self->value;

  if (CORE::defined($value) && !ref $value) {
    $value =~ s/^\s+|\s+$//g;
    $self->value($value);
  }

  return $self;
}

sub type {
  my ($self, $expr) = @_;

  if ($self->issue) {
    return $self
  }

  my $value = $self->value;

  if (!CORE::defined($value) && $self->presence eq 'optional') {
    return $self;
  }

  $expr ||= 'any';

  require Venus::Type;

  my $type = Venus::Type->new;

  my $passed = $type->check($expr)->eval($value);

  $self->issue_info('type', $expr) if !$passed;

  return $self;
}

sub uppercase {
  my ($self) = @_;

  my $value = $self->value;

  if (CORE::defined($value) && !ref $value) {
    $self->value(uc $value);
  }

  return $self;
}

sub value {
  my ($self, @args) = @_;

  my $input = @args ? $self->input([@args]) : $self->input;

  return wantarray ? (@{$input}) : $input->[0];
}

sub yesno {
  my ($self) = @_;

  $self->type('yesno');

  return $self;
}

1;
