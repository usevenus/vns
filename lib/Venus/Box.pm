package Venus::Box;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'with';

# INTEGRATES

with 'Venus::Role::Buildable';
with 'Venus::Role::Proxyable';

# BUILDERS

sub build_arg {
  my ($self, $data) = @_;

  return {
    value => $data,
  };
}

sub build_args {
  my ($self, $data) = @_;

  if (keys %$data == 1 && exists $data->{value}) {
    return $data;
  }
  return {
    value => $data,
  };
}

sub build_self {
  my ($self, $data) = @_;

  require Venus::What;

  $data //= {};

  $self->{value} = Venus::What->new(value => $data->{value})->deduce;

  return $self;
}

sub build_proxy {
  my ($self, $package, $method, @args) = @_;

  require Scalar::Util;

  my $value = $self->{value};

  if (not(Scalar::Util::blessed($value))) {
    require Venus::Error;
    return Venus::Error->throw(
      "$package can only operate on objects, not $value"
    );
  }
  if (!$value->can($method)) {
    if (my $handler = $self->can("__handle__${method}")) {
      return sub {$self->$handler(@args)};
    }
    elsif (!$value->can('AUTOLOAD')) {
      return undef;
    }
  }
  return sub {
    local $_ = $value;
    my $result = [
      $value->$method(@args)
    ];
    $result = $result->[0] if @$result == 1;
    if (Scalar::Util::blessed($result)) {
      return not(UNIVERSAL::isa($result, 'Venus::Box'))
        ? ref($self)->new(value => $result)
        : $result;
    }
    else {
      require Venus::What;
      return ref($self)->new(
        value => Venus::What->new(value => $result)->deduce
      );
    }
  };
}

# METHODS

sub __handle__unbox {
  my ($self, $code, @args) = @_;
  return $code ? $self->$code(@args)->{value} : $self->{value};
}

1;
