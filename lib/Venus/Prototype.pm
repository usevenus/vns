package Venus::Prototype;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Valuable';
with 'Venus::Role::Buildable';
with 'Venus::Role::Proxyable';

use Scalar::Util ();

# BUILDERS

sub build_args {
  my ($self, $data) = @_;

  if (keys %$data == 1 && exists $data->{value}) {
    return _clone($data);
  }
  return {
    value => _clone($data)
  };
}

sub build_proxy {
  my ($self, $package, $method, @args) = @_;

  # as a method/routine
  return sub {
    $self->{value}{"\&$method"}->($self, @args)
  }
  if defined $self->{value}{"\&$method"};

  # as a property/attribute
  return sub {
    @args ? $self->{value}{"\$$method"} = $args[0] : $self->{value}{"\$$method"}
  }
  if exists $self->{value}{"\$$method"};

  return undef;
}

# HOOKS

sub _clone {
  my ($data) = @_;

  if (!defined($data)) {
    return $data;
  }
  elsif (!Scalar::Util::blessed($data) && ref($data) eq 'HASH') {
    my $copy = {};
    for my $key (keys %$data) {
      $copy->{$key} = _clone($data->{$key});
    }
    return $copy;
  }
  elsif (!Scalar::Util::blessed($data) && ref($data) eq 'ARRAY') {
    my $copy = [];
    for (my $i = 0; $i < @$data; $i++) {
      $copy->[$i] = _clone($data->[$i]);
    }
    return $copy;
  }
  else {
    return $data;
  }
}

sub _value {
  my ($data) = @_;

  if (keys %$data == 1 && exists $data->{value}) {
    return $data->{value};
  }
  else {
    return $data;
  }
}

# METHODS

sub apply {
  my ($self, $data) = @_;

  $data ||= {};

  return $self->do('value', _clone({%{_value($self)}, %{_value($data)}}));
}

sub call {
  my ($self, $method, @args) = @_;

  # as a method/routine
  return $self->{value}{"\&$method"}->($self, @args)
    if defined $self->{value}{"\&$method"};

  # as a property/attribute
  return @args ? $self->{value}{"\$$method"} = $args[0] : $self->{value}{"\$$method"}
    if exists $self->{value}{"\$$method"};
}

sub default {
  my ($self) = @_;

  return {};
}

sub extend {
  my ($self, $data) = @_;

  $data ||= {};

  return $self->class->new(_clone({%{_value($self)}, %{_value($data)}}));
}

sub get {
  my ($self, @args) = @_;

  return $self->value if !@args;

  my ($index) = @args;

  return $self->value->{$index};
}

sub set {
  my ($self, @args) = @_;

  return $self->value if !@args;

  return $self->value(@args) if @args == 1 && ref $args[0] eq 'HASH';

  my ($index, $value) = @args;

  return if not defined $index;

  return $self->value->{$index} = $value;
}

1;
