package Venus::Hook;

use 5.018;

use strict;
use warnings;

use Hash::Util::FieldHash;

no warnings 'once';

# HOOKS

# ARGS hook
sub ARGS {
  my ($self, @args) = @_;

  return (!@args)
    ? ($self->DATA)
    : ((@args == 1 && ref($args[0]) eq 'HASH')
    ? (do{my %args = %{$args[0]}; !CORE::keys(%args) ? $self->DATA : {%args}})
    : (@args % 2 ? {@args, undef} : {@args}));
}

# ATTR hook
sub ATTR {
  my ($self, $attr, @args) = @_;

  no strict 'refs';

  no warnings 'redefine';

  *{"@{[$self->NAME]}::$attr"} = sub {$_[0]->ITEM($attr, @_[1..$#_])}
    if !$self->can($attr);

  my $index = int(keys(%{$${"@{[$self->NAME]}::META"}{ATTR}})) + 1;

  $${"@{[$self->NAME]}::META"}{ATTR}{$attr} = [$index, [$attr, @args]];

  my $metacache = join '::', $self->NAME, $self->METACACHE;

  ${$metacache} = undef;

  return $self;
}

# AUDIT hook
sub AUDIT {
  my ($self) = @_;

  return $self;
}

# BASE hook
sub BASE {
  my ($self, $base, @args) = @_;

  no strict 'refs';

  if (!grep !/\A[^:]+::\z/, keys(%{"${base}::"})) {
    local $@; eval "require $base"; do{require Venus; Venus::fault($@)} if $@;
  }

  @{"@{[$self->NAME]}::ISA"} = (
    $base, (grep +($_ ne $base), @{"@{[$self->NAME]}::ISA"})
  );

  my $index = int(keys(%{$${"@{[$self->NAME]}::META"}{BASE}})) + 1;

  $${"@{[$self->NAME]}::META"}{BASE}{$base} = [$index, [$base, @args]];

  my $metacache = join '::', $self->NAME, $self->METACACHE;

  ${$metacache} = undef;

  return $self;
}

# BLESS hook
sub BLESS {
  my ($self, @args) = @_;

  my $name = $self->NAME;
  my $data = $self->DATA($self->ARGS($self->BUILDARGS(@args)));
  my $anew = bless($data, $name);

  no strict 'refs';

  $anew->BUILD($data);

  $anew->CONSTRUCT;

  return $anew if $name eq 'Venus::Meta';

  require Venus::Meta;

  my $metacache = join '::', $self->NAME, $self->METACACHE;

  ${$metacache} ||= Venus::Meta->new(name => $name);

  return $anew;
}

# BUILD hook
sub BUILD {
  my ($self) = @_;

  return $self;
}

# BUILD hook handler for class
sub BUILD_FOR_CLASS {
  my ($self, @data) = @_;

  no strict 'refs';

  my @roles = @{$self->META->roles};

  for my $action (grep defined, map *{"${_}::BUILD"}{"CODE"}, @roles) {
    $self->$action(@data);
  }

  return $self;
}

# BUILD hook handler for role
sub BUILD_FOR_ROLE {
  my ($self, @data) = @_;

  no strict 'refs';

  my @roles = @{$self->META->roles};

  for my $action (grep defined, map *{"${_}::BUILD"}{"CODE"}, @roles) {
    $self->$action(@data);
  }

  return $self;
}

# BUILD hook handler for mixin
sub BUILD_FOR_MIXIN {
  my ($self) = @_;

  return $self;
}

# BUILDARGS hook
sub BUILDARGS {
  my ($self, @args) = @_;

  return (@args);
}

# CONSTRUCT hook
sub CONSTRUCT {
  my ($self) = @_;

  return $self;
}

# CONSTRUCT hook handler for class
sub CONSTRUCT_FOR_CLASS {
  my ($self, @data) = @_;

  no strict 'refs';

  my @mixins = @{$self->META->mixins};

  for my $action (grep defined, map *{"${_}::CONSTRUCT"}{"CODE"}, @mixins) {
    $self->$action(@data);
  }

  my @roles = @{$self->META->roles};

  for my $action (grep defined, map *{"${_}::CONSTRUCT"}{"CODE"}, @roles) {
    $self->$action(@data);
  }

  return $self;
}

# CONSTRUCT hook handler for role
sub CONSTRUCT_FOR_ROLE {
}

# CONSTRUCT hook handler for mixin
sub CONSTRUCT_FOR_MIXIN {
}

# CLONE hook
sub CLONE {
  my ($self) = @_;

  require Scalar::Util;

  if (!Scalar::Util::blessed($self)) {
    require Venus;

    Venus::fault("Can't clone without an instance of \"${self}\"");
  }

  require Storable;

  no warnings 'once';

  local $Storable::Deparse = 1;

  local $Storable::Eval = 1;

  my $clone = Storable::dclone($self);

  my $store = $self->STORE;

  my $instance = $store->{$clone} = Storable::dclone($store->{$self} ||= {});

  return $clone;
}

# DATA hook
sub DATA {
  my ($self, $data) = @_;

  return $data || {};
}

# DECONSTRUCT hook
sub DECONSTRUCT {
  my ($self) = @_;

  return $self;
}

# DECONSTRUCT hook handler for class
sub DECONSTRUCT_FOR_CLASS {
  my ($self, @data) = @_;

  no strict 'refs';

  my @mixins = @{$self->META->mixins};

  for my $action (grep defined, map *{"${_}::DECONSTRUCT"}{"CODE"}, @mixins) {
    $self->$action(@data);
  }

  my @roles = @{$self->META->roles};

  for my $action (grep defined, map *{"${_}::DECONSTRUCT"}{"CODE"}, @roles) {
    $self->$action(@data);
  }

  return $self;
}

# DECONSTRUCT hook handler for role
sub DECONSTRUCT_FOR_ROLE {
}

# DECONSTRUCT hook handler for mixin
sub DECONSTRUCT_FOR_MIXIN {
}

# DESTROY hook
sub DESTROY {
  my ($self) = @_;

  $self->DECONSTRUCT;

  return $self;
}

# DESTROY hook handler for class
sub DESTROY_FOR_CLASS {
  my ($self, @data) = @_;

  no strict 'refs';

  my @mixins = @{$self->META->mixins};

  for my $action (grep defined, map *{"${_}::DESTROY"}{"CODE"}, @mixins) {
    $self->$action(@data);
  }

  my @roles = @{$self->META->roles};

  for my $action (grep defined, map *{"${_}::DESTROY"}{"CODE"}, @roles) {
    $self->$action(@data);
  }

  return $self;
}

# DESTROY hook handler for role
sub DESTROY_FOR_ROLE {
  my ($self, @data) = @_;

  no strict 'refs';

  my @mixins = @{$self->META->mixins};

  for my $action (grep defined, map *{"${_}::DESTROY"}{"CODE"}, @mixins) {
    $self->$action(@data);
  }

  my @roles = @{$self->META->roles};

  for my $action (grep defined, map *{"${_}::DESTROY"}{"CODE"}, @roles) {
    $self->$action(@data);
  }

  return $self;
}

# DESTROY hook handler for mixin
sub DESTROY_FOR_MIXIN {
  my ($self) = @_;

  return;
}

# DOES hook
sub DOES {
  my ($self, $role) = @_;

  return if !$role;

  return $self->META->role($role);
}

# EXPORT hook
sub EXPORT {
  my ($self, $into) = @_;

  no strict;
  no warnings 'once';

  return [@{"${self}::EXPORT"}];
}

# EXPORT hook handler for class
sub EXPORT_FOR_CLASS {
  my ($self, $into) = @_;

  no strict;
  no warnings 'once';

  return [@{"${self}::EXPORT"}];
}

# EXPORT hook handler for role
sub EXPORT_FOR_ROLE {
  my ($self, $into) = @_;

  no strict;
  no warnings 'once';

  return [@{"${self}::EXPORT"}];
}

# EXPORT hook handler for mixin
sub EXPORT_FOR_MIXIN {
  my ($self, $into) = @_;

  no strict;
  no warnings 'once';

  return [@{"${self}::EXPORT"}];
}

# FROM hook
sub FROM {
  my ($self, $base) = @_;

  $self->BASE($base);

  $base->AUDIT($self->NAME) if $base->can('AUDIT');

  no warnings 'redefine';

  $base->IMPORT($self->NAME);

  return $self;
}

# GET hook
sub GET {
  my ($self, $name) = @_;

  return $self->{$name};
}

# IMPORT hook
sub IMPORT {
  my ($self, $into) = @_;

  no strict 'refs';
  no warnings 'redefine';

  for my $name (@{$self->EXPORT($into)}) {
    *{"${into}::${name}"} = \&{"@{[$self->NAME]}::${name}"};
  }

  return $self;
}

# IMPORT hook handler for class
sub IMPORT_FOR_CLASS {
  my ($self, $into) = @_;

  no strict 'refs';
  no warnings 'redefine';

  for my $name (@{$self->EXPORT($into)}) {
    *{"${into}::${name}"} = \&{"@{[$self->NAME]}::${name}"};
  }

  return $self;
}

# IMPORT hook handler for role
sub IMPORT_FOR_ROLE {
  my ($self, $into) = @_;

  no strict 'refs';
  no warnings 'redefine';

  for my $name (grep !*{"${into}::${_}"}{"CODE"}, @{$self->EXPORT($into)}) {
    *{"${into}::${name}"} = \&{"@{[$self->NAME]}::${name}"};
  }

  return $self;
}

# IMPORT hook handler for mixin
sub IMPORT_FOR_MIXIN {
  my ($self, $into) = @_;

  no strict 'refs';
  no warnings 'redefine';

  for my $name (@{$self->EXPORT($into)}) {
    *{"${into}::${name}"} = \&{"@{[$self->NAME]}::${name}"};
  }

  return $self;
}

# ITEM hook
sub ITEM {
  my ($self, $name, @args) = @_;

  return $name ? (@args ? $self->SET($name, $args[0]) : $self->GET($name)) : undef;
}

# META hook
sub META {
  my ($self) = @_;

  no strict 'refs';

  require Venus::Meta;

  my $metacache = join '::', my $name = $self->NAME, $self->METACACHE;

  return ${$metacache} ||= Venus::Meta->new(name => $name);
}

# METACACHE cache name (for META hook)
sub METACACHE {
  my ($self) = @_;

  return 'METACACHE';
}

# MIXIN hook
sub MIXIN {
  my ($self, $mixin, @args) = @_;

  no strict 'refs';

  if (!grep !/\A[^:]+::\z/, keys(%{"${mixin}::"})) {
    local $@; eval "require $mixin"; do{require Venus; Venus::fault($@)} if $@;
  }

  no warnings 'redefine';

  $mixin->IMPORT($self->NAME);

  no strict 'refs';

  my $index = int(keys(%{$${"@{[$self->NAME]}::META"}{MIXIN}})) + 1;

  $${"@{[$self->NAME]}::META"}{MIXIN}{$mixin} = [$index, [$mixin, @args]];

  my $metacache = join '::', $self->NAME, $self->METACACHE;

  ${$metacache} = undef;

  return $self;
}

# MASK hook
sub MASK {
  my ($self, $mask, @args) = @_;

  no strict 'refs';

  no warnings 'redefine';

  my $store = $self->STORE;

  *{"@{[$self->NAME]}::$mask"} = sub {
    my ($self, @args) = @_;

    my $caller = caller;

    require Scalar::Util;

    if (!Scalar::Util::blessed($self)) {
      require Venus;

      Venus::fault(
        "Can't get/set private variable \"${mask}\" without an instance of \"${self}\""
      );
    }

    my $class = ref $self;

    if ($caller ne $class && !$class->isa($caller)) {
      my $authorized = 0;

      no strict 'refs';
      no warnings 'once';

      if (${"${caller}::META"} && $${"${caller}::META"}{MASK}{$mask}) {
        require Venus::Meta;

        my $meta = Venus::Meta->new(name => $class);

        if ($meta->role($caller) || $meta->mixin($caller)) {
          $authorized = 1;
        }
      }

      if (!$authorized) {
        require Venus;

        Venus::fault(
          "Can't get/set private variable \"${mask}\" outside the class or subclass of \"${class}\""
        );
      }
    }

    no warnings 'once';

    my $variable = $store->{$self} ||= {};

    return @args ? ($variable->{$mask} = $args[0]) : $variable->{$mask};
  }
  if !$self->can($mask);

  my $index = int(keys(%{$${"@{[$self->NAME]}::META"}{MASK}})) + 1;

  $${"@{[$self->NAME]}::META"}{MASK}{$mask} = [$index, [$mask, @args]];

  my $metacache = join '::', $self->NAME, $self->METACACHE;

  ${$metacache} = undef;

  return $self;
}

# NAME hook
sub NAME {
  my ($self) = @_;

  return ref $self || $self;
}

# ROLE hook
sub ROLE {
  my ($self, $role, @args) = @_;

  no strict 'refs';

  if (!grep !/\A[^:]+::\z/, keys(%{"${role}::"})) {
    local $@; eval "require $role"; do{require Venus; Venus::fault($@)} if $@;
  }

  no warnings 'redefine';

  $role->IMPORT($self->NAME);

  no strict 'refs';

  my $index = int(keys(%{$${"@{[$self->NAME]}::META"}{ROLE}})) + 1;

  $${"@{[$self->NAME]}::META"}{ROLE}{$role} = [$index, [$role, @args]];

  my $metacache = join '::', $self->NAME, $self->METACACHE;

  ${$metacache} = undef;

  return $self;
}

# SET hook
sub SET {
  my ($self, $name, $data) = @_;

  return $self->{$name} = $data;
}

# STORE for private data (for MASK hook)
sub STORE {
  my ($self) = @_;

  no strict 'refs';

  no warnings 'once';

  state $cache = {};

  my $caller = caller;

  if (!$cache->{$self->NAME}) {
    my $name = 'STORE';

    for my $class ($self->NAME, $self->META->bases) {
      if (ref ${"${class}::${name}"}) {
        $cache->{$self->NAME} = ${"${class}::${name}"};
        last;
      }
    }

    if (!$cache->{$self->NAME}) {
      Hash::Util::FieldHash::fieldhash(my %data);

      $cache->{$self->NAME} = ${"@{[$self->NAME]}::${name}"} = \%data;
    }
  }

  return $cache->{$self->NAME} if $caller eq __PACKAGE__;

  require Scalar::Util;

  if (!Scalar::Util::blessed($self)) {
    require Venus;
    Venus::fault(
      "Can't access STORE from \"${caller}\""
    );
  }

  my $class = ref $self;

  return $cache->{$self->NAME} if $caller eq $class || $class->isa($caller);

  require Venus::Meta;

  my $meta = Venus::Meta->new(name => $class);

  if ($meta->role($caller) || $meta->mixin($caller)) {
    return $cache->{$self->NAME};
  }

  require Venus;

  Venus::fault(
    "Can't access STORE outside the class or subclass of \"${class}\""
  );
}

# SUBS hook
sub SUBS {
  my ($self) = @_;

  no strict 'refs';

  return [
    sort grep *{"@{[$self->NAME]}::$_"}{"CODE"},
    grep /^[_a-zA-Z]\w*$/, keys %{"@{[$self->NAME]}::"}
  ];
}

# TEST hook
sub TEST {
  my ($self, $role) = @_;

  $self->ROLE($role);

  $role->AUDIT($self->NAME) if $role->can('AUDIT');

  return $self;
}

# UNIMPORT hook
sub UNIMPORT {
  my ($self, $into, @args) = @_;

  return $self;
}

# USE hook
sub USE {
  my ($self, $into, @args) = @_;

  return $self;
}

1;