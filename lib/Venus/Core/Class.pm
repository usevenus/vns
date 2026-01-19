package Venus::Core::Class;

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

  *clone = *Venus::Hook::CLONE;

  *does = *Venus::Hook::DOES;

  *meta = *Venus::Hook::META;

  *new = *Venus::Hook::BLESS;

  *BUILD = *Venus::Hook::BUILD_FOR_CLASS;

  *CONSTRUCT = *Venus::Hook::CONSTRUCT_FOR_CLASS;

  *DECONSTRUCT = *Venus::Hook::DECONSTRUCT_FOR_CLASS;

  *DESTROY = *Venus::Hook::DESTROY_FOR_CLASS;

  *EXPORT = *Venus::Hook::EXPORT_FOR_CLASS;

  *IMPORT = *Venus::Hook::IMPORT_FOR_CLASS;
}

# METHODS

sub import {
  my ($self, @args) = @_;

  my $target = caller;

  $self->USE($target);

  return $self->IMPORT($target, @args);
}

sub unimport {
  my ($self, @args) = @_;

  my $target = caller;

  return $self->UNIMPORT($target, @args);
}

1;
