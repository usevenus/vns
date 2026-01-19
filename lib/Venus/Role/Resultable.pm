package Venus::Role::Resultable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role;

# METHODS

sub result {
  my ($self, $code, @args) = @_;

  require Venus::Result;

  my $result = Venus::Result->new;

  $result = $result->then(sub{$self->$code(@args)}) if $code;

  return $result;
}

# EXPORTS

sub EXPORT {
  ['result']
}

1;
