package Venus::Role::Catchable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'fault';

# AUDITS

sub AUDIT {
  my ($self, $from) = @_;

  if (!$from->does('Venus::Role::Tryable')) {
    fault "${self} requires ${from} to consume Venus::Role::Tryable";
  }

  return $self;
}

# METHODS

sub catch {
  my ($self, $method, @args) = @_;

  my @result = $self->try($method, @args)->error(\my $error)->result;

  return wantarray ? ($error ? ($error, undef) : ($error, @result)) : $error;
}

sub caught {
  my ($self, $data, $type, $code) = @_;

  require Scalar::Util;

  ($type, my($name)) = @$type if ref $type eq 'ARRAY';

  my $is_true = $data
    && Scalar::Util::blessed($data)
    && $data->isa('Venus::Error')
    && $data->isa($type || 'Venus::Error')
    && ($data->name ? $data->of($name || '') : !$name);

  return undef unless $is_true;

  local $_ = $data;
  return $code ? $code->($data) : $data;
}

sub maybe {
  my ($self, $method, @args) = @_;

  my @result = $self->try($method, @args)->error(\my $error)->result;

  return wantarray ? ($error ? (undef) : (@result)) : ($error ? undef : $result[0]);
}

# EXPORTS

sub EXPORT {
  ['catch', 'caught', 'maybe']
}

1;
