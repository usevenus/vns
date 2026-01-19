package Venus::Role::Fromable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'fault';

# METHODS

sub from {
  my ($self, @args) = @_;

  require Venus::What;

  my $type = lc scalar Venus::What->new(value => $args[0])->identify;

  (my $name, @args) = @args < 2 ? ($type, @args) : (@args);

  my $class = ref $self || $self;

  fault "No name provided to \"from\" via package \"$class\"" if !$name;

  my $method = "from_$name";

  return $class->new($class->$method(@args)) if $class->can($method);

  fault "Unable to locate class method \"$method\" via package \"$class\"";
}

# EXPORTS

sub EXPORT {
  ['from']
}

1;
