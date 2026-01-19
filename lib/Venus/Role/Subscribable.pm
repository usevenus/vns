package Venus::Role::Subscribable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'with';

# METHODS

sub name {
  my ($name) = @_;

  $name = lc $name =~ s/\W+/_/gr if $name;

  return $name;
}

sub publish {
  my ($self, $name, @args) = @_;

  $name = name($name) or return $self;

  &$_(@args) for @{$self->{subscriptions}->{$name}};

  return $self;
}

sub subscribe {
  my ($self, $name, $code) = @_;

  $name = name($name) or return $self;

  push @{$self->{subscriptions}->{$name}}, $code;

  return $self;
}

sub subscribers {
  my ($self, $name) = @_;

  $name = name($name) or return 0;

  if (exists $self->{subscriptions}->{$name}) {
    return 0+@{$self->{subscriptions}->{$name}};
  }
  else {
    return 0;
  }
}

sub unsubscribe {
  my ($self, $name, $code) = @_;

  $name = name($name) or return $self;

  if ($code) {
    $self->{subscriptions}->{$name} = [
      grep { $code ne $_ } @{$self->{subscriptions}->{$name}}
    ];
  }
  else {
    delete $self->{subscriptions}->{$name};
  }

  delete $self->{subscriptions}->{$name} if !$self->subscribers($name);

  return $self;
}

# EXPORTS

sub EXPORT {
  ['publish', 'subscribe', 'subscribers', 'unsubscribe']
}

1;
