package Venus::Role::Encaseable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'fault', 'mask';

# ATTRIBUTES

mask 'private';

# AUDITS

sub AUDIT {
  my ($self, $from) = @_;

  if (!$from->isa('Venus::Core')) {
    fault "${self} requires ${from} to derive from Venus::Core";
  }

  return $self;
}

# METHODS

sub clone {
  my ($self) = @_;

  return $self->CLONE;
}

sub encase {
  my ($self, $key, $value) = @_;

  return if !$key;

  my $caller = caller;

  require Scalar::Util;

  if (!Scalar::Util::blessed($self)) {
    fault "Can't encase variable \"${key}\" without an instance of \"${self}\"";
  }

  my $class = ref $self;

  if ($caller ne $class && !$class->isa($caller)) {
    fault "Can't encase variable \"${key}\" outside the class or subclass of \"${class}\"";
  }

  my $data = $self->private || $self->private({});

  return $data->{$key} if exists $data->{$key};

  return $data->{$key} = $value;
}

sub encased {
  my ($self, $key) = @_;

  return if !$key;

  my $caller = caller;

  require Scalar::Util;

  if (!Scalar::Util::blessed($self)) {
    fault "Can't retrieve encased variable \"${key}\" without an instance of \"${self}\"";
  }

  my $class = ref $self;

  if ($caller ne $class && !$class->isa($caller)) {
    fault "Can't retrieve encased variable \"${key}\" outside the class or subclass of \"${class}\"";
  }

  my $data = $self->private || $self->private({});

  return $data->{$key};
}

sub recase {
  my ($self, $key, $value) = @_;

  return if !$key;

  my $caller = caller;

  require Scalar::Util;

  if (!Scalar::Util::blessed($self)) {
    fault "Can't recase variable \"${key}\" without an instance of \"${self}\"";
  }

  my $class = ref $self;

  if ($caller ne $class && !$class->isa($caller)) {
    fault "Can't recase variable \"${key}\" outside the class or subclass of \"${class}\"";
  }

  my $data = $self->private || $self->private({});

  return $data->{$key} = $value;
}

sub uncase {
  my ($self, $key) = @_;

  return if !$key;

  my $caller = caller;

  require Scalar::Util;

  if (!Scalar::Util::blessed($self)) {
    fault "Can't uncase variable \"${key}\" without an instance of \"${self}\"";
  }

  my $class = ref $self;

  if ($caller ne $class && !$class->isa($caller)) {
    fault "Can't uncase variable \"${key}\" outside the class or subclass of \"${class}\"";
  }

  my $data = $self->private || $self->private({});

  return delete $data->{$key};
}

# EXPORTS

sub EXPORT {
  ['clone', 'encase', 'encased', 'private', 'recase', 'uncase']
}

1;
