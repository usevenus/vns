package Venus::Role::Throwable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'with';

# METHODS

sub die {
  my ($self, $data) = @_;

  $data ||= {};

  if (!ref $data) {
    $data = $self->can($data) ? $self->$data : {package => $data};
  }

  $data = {} if ref $data ne 'HASH';

  my $args = $data->{throw} ? delete $data->{throw} : $data->{args} ? delete $data->{args} : undef;

  $data = $self->$args($data) if $args;

  require Venus::Throw;

  my ($throw) = @_ = (
    Venus::Throw->new(
      context => (caller(1))[3],
      package => join('::', map ucfirst, ref($self), 'error'),
    ),
    $data,
  );

  goto $throw->can('die');
}

sub error {
  my ($self, $data) = @_;

  $data ||= {};

  if (!ref $data) {
    $data = $self->can($data) ? $self->$data : {package => $data};
  }

  $data = {} if ref $data ne 'HASH';

  my $args = $data->{throw} ? delete $data->{throw} : $data->{args} ? delete $data->{args} : undef;

  $data = $self->$args($data) if $args;

  require Venus::Throw;

  my ($throw) = @_ = (
    Venus::Throw->new(
      context => (caller(1))[3],
      package => $data->{package} || join('::', map ucfirst, ref($self), 'error'),
    ),
    $data,
  );

  goto $throw->can('error');
}

sub throw {
  my ($self, $data) = @_;

  $data ||= {};

  if (!ref $data) {
    $data = $self->can($data) ? $self->$data : {package => $data};
  }

  $data = {} if ref $data ne 'HASH';

  my $args = $data->{throw} ? delete $data->{throw} : $data->{args} ? delete $data->{args} : undef;

  $data = $self->$args($data) if $args;

  require Venus::Throw;

  my $throw = Venus::Throw->new(
    context => (caller(1))[3],
    package => $data->{package} || join('::', map ucfirst, ref($self), 'error'),
  );

  for my $key (keys %{$data}) {
    $throw->$key($data->{$key}) if $throw->can($key);
  }

  return $throw;
}

# EXPORTS

sub EXPORT {
  ['die', 'error', 'throw']
}

1;
