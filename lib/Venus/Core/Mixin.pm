package Venus::Core::Mixin;

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

  *BUILD = *Venus::Hook::BUILD_FOR_MIXIN;

  *DESTROY = *Venus::Hook::DESTROY_FOR_MIXIN;

  *EXPORT = *Venus::Hook::EXPORT_FOR_MIXIN;

  *IMPORT = *Venus::Hook::IMPORT_FOR_MIXIN;
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
