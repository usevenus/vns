package Venus::Core::Role;

use 5.018;

use strict;
use warnings;

no warnings 'once';

use base 'Venus::Core';

# IMPORTS

use Venus::Hook;

# HOOKS

{
  no warnings 'once';

  *does = *Venus::Hook::DOES;

  *meta = *Venus::Hook::META;

  *BUILD = *Venus::Hook::BUILD_FOR_ROLE;

  *DESTROY = *Venus::Hook::DESTROY_FOR_ROLE;

  *EXPORT = *Venus::Hook::EXPORT_FOR_ROLE;

  *IMPORT = *Venus::Hook::IMPORT_FOR_ROLE;
}

# METHODS

sub import {
  my ($self) = @_;

  require Venus;

  @_ = ("${self} cannot be used via the \"use\" declaration");

  goto \&Venus::fault;
}

sub unimport {
  my ($self, @args) = @_;

  my $target = caller;

  return $self->UNIMPORT($target, @args);
}

1;
