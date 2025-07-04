package Venus::Role::Deferrable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'fault';

# METHODS

sub defer {
  my ($self, $name, @args) = @_;

  return sub {$self} if !$name;

  my $code = $self->can($name)
    or fault "Unable to defer $name: can't find $name in @{[ref $self]}";

  return sub {@_ = ($self, @args, @_); goto $code};
}

# EXPORTS

sub EXPORT {
  ['defer']
}

1;
