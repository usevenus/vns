package Venus::Role::Encaseable;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Role 'fault';

# STATE

state $NAME = 'DATA';

# IMPORTS

sub IMPORT {
  my ($self, $from) = @_;

  my $class = ref $from || $from;

  no strict 'refs';

  my $name = $NAME;

  no warnings 'once';

  my $data = {};

  ${"${class}::${name}"} ||= sub {
    my $caller = caller;
    return $caller eq __PACKAGE__ ? $data : {}
  };

  $self->SUPER::IMPORT($from);

  return $self;
}

# AUDITS

sub AUDIT {
  my ($self, $from) = @_;

  if (!$from->isa('Venus::Core')) {
    fault "${self} requires ${from} to derive from Venus::Core";
  }

  return $self;
}

# STORE

sub STORE {
  my ($self) = @_;

  my $class = ref $self || $self;

  no strict 'refs';

  my $name = $NAME;

  no warnings 'once';

  state $cache = {};

  return $cache->{$class} if $cache->{$class};

  require Venus::Meta;

  for my $from ($class, Venus::Meta->new(name => $class)->bases) {
    if (ref ${"${from}::${name}"} eq 'CODE') {
      $cache->{$class} = ${"${from}::${name}"};
      last;
    }
  }

  return $cache->{$class};
}

# METHODS

sub clone {
  my ($self) = @_;

  my $class = ref $self || $self;

  require Storable;

  local $Storable::Deparse = 1;

  local $Storable::Eval = 1;

  my $clone = Storable::dclone($self);

  my $data = STORE($class);

  my $from_refaddr = Scalar::Util::refaddr($self);

  my $into_refaddr = Scalar::Util::refaddr($clone);

  my $instance = $data->()->{$into_refaddr} = Storable::dclone($data->()->{$from_refaddr} ||= {});

  return $clone;
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

  no strict 'refs';

  my $refaddr = Scalar::Util::refaddr($self);

  no warnings 'once';

  my $data = STORE($class);

  my $instance = $data->()->{$refaddr} ||= {};

  return $instance->{$key} if exists $instance->{$key};

  return $instance->{$key} = $value;
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

  no strict 'refs';

  my $refaddr = Scalar::Util::refaddr($self);

  no warnings 'once';

  my $data = STORE($class);

  my $instance = $data->()->{$refaddr} ||= {};

  return $instance->{$key};
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

  no strict 'refs';

  my $refaddr = Scalar::Util::refaddr($self);

  no warnings 'once';

  my $data = STORE($class);

  my $instance = $data->()->{$refaddr} ||= {};

  return $instance->{$key} = $value;
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

  no strict 'refs';

  my $refaddr = Scalar::Util::refaddr($self);

  no warnings 'once';

  my $data = STORE($class);

  my $instance = $data->()->{$refaddr} ||= {};

  return delete $instance->{$key};
}

# DESTROY

sub DESTROY {
  my ($self) = @_;

  DESTROY_DATA($self);

  return $self;
}

sub DESTROY_DATA {
  my ($self) = @_;

  require Scalar::Util;

  if (!Scalar::Util::blessed($self)) {
    return $self;
  }

  my $class = ref $self;

  no strict 'refs';

  my $refaddr = Scalar::Util::refaddr($self);

  no warnings 'once';

  my $data = STORE($class);

  return $self if !$data;

  my $encased = $data->();

  return $self if !$encased;

  delete $encased->{$refaddr};

  return $self;
}

# EXPORTS

sub EXPORT {
  ['clone', 'encase', 'encased', 'recase', 'uncase']
}

1;
