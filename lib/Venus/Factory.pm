package Venus::Factory;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Buildable';
with 'Venus::Role::Encaseable';
with 'Venus::Role::Tryable';
with 'Venus::Role::Catchable';
with 'Venus::Role::Throwable';

# ATTRIBUTES

attr 'name';

# METHODS

sub args {
  my ($self, @args) = @_;

  my @value = $self->value;

  @value = @args if @args;

  my @list = $self->list;

  for my $item (reverse @list) {
    my ($name, @args) = ref $item ? @{$item} : $item;
    my $container = $self->retrieve($name);
    unshift @value, $container->resolve(@args) if $container;
  }

  return @value if @value > 1;

  my $arrayref = $self->arrayref;

  if ($arrayref && (!@value || (@value == 1 && ref $value[0] eq 'ARRAY'))) {
    for my $item (reverse @{$arrayref}) {
      my ($name, @args) = ref $item ? @{$item} : $item;
      my $container = $self->retrieve($name);
      unshift @{$value[0]}, $container->resolve(@args) if $container;
    }
  }

  my $hashref = $self->hashref;

  if ($hashref && (!@value || (@value == 1 && ref $value[0] eq 'HASH'))) {
    for my $pair (map +([$_, $$hashref{$_}]), keys %{$hashref}) {
      my ($name, @args) = ref $$pair[1] ? @{$$pair[1]} : $$pair[1];
      my $container = $self->retrieve($name);
      ${$value[0]}{$$pair[0]} = $container->resolve(@args) if $container && !exists ${$value[0]}{$$pair[0]};
    }
  }

  return wantarray ? (@value) : $value[0];
}

sub arrayref {
  my ($self, @data) = @_;

  if (@data) {
    $self->{arrayref} = [@data];

    return $self;
  }
  else {

    return $self->{arrayref};
  }
}

sub assert {
  my ($self, @data) = @_;

  if (@data) {
    $self->{assert} = $data[0];

    return $self;
  }
  else {

    return $self->{assert};
  }
}

sub attach {
  my ($self, $name, $data) = @_;

  my $class = ref $self;

  return $self if !$data || !UNIVERSAL::isa($data, $class);

  my $registry = $self->registry || $self->registry({})->registry;

  my $container = $registry->{$name} = $data;

  $container->registry($registry);

  $container->name($name) if !$container->name;

  $container->cache($self->cache) if $self->cache;

  return $container;
}

sub build {
  my ($self, $name, @args) = @_;

  my $container = $self->retrieve($name);

  return $container->resolve(@args);
}

sub builder {
  my ($self, @data) = @_;

  if (@data) {
    $self->{builder} = $data[0];

    return $self;
  }
  else {

    return $self->{builder};
  }
}

sub cache {
  my ($self, @data) = @_;

  if (@data) {
    $self->recase('cache', $data[0]);

    return $self;
  }
  else {

    return $self->encased('cache');
  }
}

sub cached {
  my ($self, @data) = @_;

  if (@data) {
    $self->{cached} = $data[0] ? true : false;

    return $self;
  }
  else {

    return $self->{cached};
  }
}

sub callback {
  my ($self, @args) = @_;

  return $self->defer('resolve', @args);
}

sub chain {
  my ($self, @data) = @_;

  if (@data) {
    $self->{chain} = [@data];

    return $self;
  }
  else {

    return $self->{chain};
  }
}

sub class {
  my ($self, @data) = @_;

  if (@data) {
    $self->assert($data[0])->package($data[0])->method('new');

    return $self;
  }
  else {

    return ($self->protocol
        && $self->protocol eq 'method'
        && $self->dispatch
        && $self->dispatch eq 'new') ? $self->package : undef;
  }
}

sub clone {
  my ($self) = @_;

  require Venus;

  my $class = ref $self;

  my $container = $class->new;

  my $arrayref = $self->arrayref;

  $container->arrayref(Venus::clone($arrayref)) if defined $arrayref;

  my $assert = $self->assert;

  $container->assert($assert) if defined $assert;

  my $builder = $self->builder;

  $container->builder($builder) if defined $builder;

  my $cached = $self->cached;

  $container->cached($cached) if defined $cached;

  my $chain = $self->chain;

  $container->chain(Venus::clone($chain)) if defined $chain;

  my $constructor = $self->constructor;

  $container->constructor($constructor) if defined $constructor;

  my $dispatch = $self->dispatch;

  $container->dispatch($dispatch) if defined $dispatch;

  my $hashref = $self->hashref;

  $container->hashref(Venus::clone($hashref)) if defined $hashref;

  my @list = $self->list;

  $container->list(map ref $_ ? Venus::clone($_) : $_, @list) if @list;

  my $name = $self->name;

  $container->name($name) if defined $name;

  my $package = $self->package;

  $container->package($package) if defined $package;

  my $protocol = $self->protocol;

  $container->protocol($protocol) if defined $protocol;

  my @value = $self->value;

  $container->value(map ref $_ ? Venus::clone($_) : $_, @value) if @value;

  return $container;
}

sub constructor {
  my ($self, @data) = @_;

  if (@data) {
    $self->{constructor} = $data[0];

    return $self;
  }
  else {

    return $self->{constructor};
  }
}

sub detach {
  my ($self, $name) = @_;

  my $registry = $self->registry || $self->registry({})->registry;

  my $container = delete $registry->{$name};

  return undef if !$container;

  return $container;
}

sub dispatch {
  my ($self, @data) = @_;

  if (@data) {
    $self->{dispatch} = $data[0];

    return $self;
  }
  else {

    return $self->{dispatch};
  }
}

sub dispatch_to_function {
  my ($self, $invocant, $function, @args) = @_;

  no strict 'refs';

  return &{"${invocant}::${function}"}(@args);
}

sub dispatch_to_method {
  my ($self, $invocant, $method, @args) = @_;

  return $invocant->$method(@args);
}

sub dispatch_to_routine {
  my ($self, $invocant, $routine, @args) = @_;

  return (ref $invocant || $invocant)->$routine(@args);
}

sub extend {
  my ($self, $name) = @_;

  require Venus;

  my $container = $self->retrieve($name);

  return $self if !$container;

  my $arrayref = $container->arrayref;

  $self->arrayref(Venus::clone($arrayref)) if defined $arrayref;

  my $assert = $container->assert;

  $self->assert($assert) if defined $assert;

  my $builder = $container->builder;

  $self->builder($builder) if defined $builder;

  my $cached = $container->cached;

  $self->cached($cached) if defined $cached;

  my $chain = $container->chain;

  $self->chain(Venus::clone($chain)) if defined $chain;

  my $constructor = $container->constructor;

  $self->constructor($constructor) if defined $constructor;

  my $dispatch = $container->dispatch;

  $self->dispatch($dispatch) if defined $dispatch;

  my $hashref = $container->hashref;

  $self->hashref(Venus::clone($hashref)) if defined $hashref;

  my @list = $container->list;

  $self->list(map ref $_ ? Venus::clone($_) : $_, @list) if @list;

  my $package = $container->package;

  $self->package($package) if defined $package;

  my $protocol = $container->protocol;

  $self->protocol($protocol) if defined $protocol;

  my @value = $container->value;

  $self->value(map ref $_ ? Venus::clone($_) : $_, @value) if @value;

  return $self;
}

sub function {
  my ($self, @data) = @_;

  if (@data) {
    $self->protocol('function')->dispatch($data[0]);

    return $self;
  }
  else {

    return ($self->protocol && $self->protocol eq 'function') ? $self->dispatch : undef;
  }
}

sub hashref {
  my ($self, @data) = @_;

  if (@data) {
    $self->{hashref} = $data[0];

    return $self;
  }
  else {

    return $self->{hashref};
  }
}

sub list {
  my ($self, @data) = @_;

  if (@data) {
    $self->{list} = [@data];

    return $self;
  }
  else {

    return $self->{list} ? @{$self->{list}} : ();
  }
}

sub method {
  my ($self, @data) = @_;

  if (@data) {
    $self->protocol('method')->dispatch($data[0]);

    return $self;
  }
  else {

    return ($self->protocol && $self->protocol eq 'method') ? $self->dispatch : undef;
  }
}

sub package {
  my ($self, @data) = @_;

  if (@data) {
    $self->{package} = $data[0];

    return $self;
  }
  else {

    return $self->{package};
  }
}

sub protocol {
  my ($self, @data) = @_;

  if (@data) {
    $self->{protocol} = $data[0];

    return $self;
  }
  else {

    return $self->{protocol};
  }
}

sub register {
  my ($self, $name) = @_;

  my $class = ref $self;

  my $registry = $self->registry || $self->registry({})->registry;

  my $container = $registry->{$name} = $class->new(name => $name);

  $container->registry($registry);

  $container->cache($self->cache) if $self->cache;

  return $container;
}

sub registry {
  my ($self, @data) = @_;

  if (@data) {
    $self->recase('registry', $data[0]);

    return $self;
  }
  else {

    return $self->encased('registry');
  }
}

sub reset {
  my ($self, @data) = @_;

  if (@data) {
    my $value = delete $self->{$data[0]};

    return $value;
  }
  else {

    delete $self->{arrayref};
    delete $self->{assert};
    delete $self->{builder};
    delete $self->{cached};
    delete $self->{callback};
    delete $self->{chain};
    delete $self->{constructor};
    delete $self->{dispatch};
    delete $self->{hashref};
    delete $self->{list};
    delete $self->{name};
    delete $self->{package};
    delete $self->{protocol};
    delete $self->{value};

    return $self;
  }
}

sub resolve {
  my ($self, @args) = @_;

  my ($cache, $cached) = ($self->cache, $self->cached);

  return $cache->{$self->name} if $cache && $cached && $self->name;

  require Venus::Space;

  my $package = $self->package;

  return (scalar $self->value) ? (wantarray ? ($self->value) : ($self->value)[0]) : () if !$package;

  Venus::Space->new($package)->tryload;

  my $protocol = $self->protocol;

  my $dispatch = $self->dispatch;

  my @result;

  if ($protocol eq 'function') {
    my $constructor = $self->constructor;

    if ($constructor) {
      @result = $self->$constructor($package, $dispatch, $self->args(@args));
    }
    else {
      @result = $self->dispatch_to_function($package, $dispatch, $self->args(@args));
    }

    my $chain = $self->chain;

    if ($chain) {
      for my $item (@{$chain}) {
        my ($name, @args) = ref $item ? @{$item} : $item;
        @result = $self->dispatch_to_function($package, $name, @result ? @result : @args);
      }
    }
  }

  if ($protocol eq 'method') {
    my $constructor = $self->constructor;

    if ($constructor) {
      @result = (scalar $self->$constructor($package, $dispatch, $self->args(@args)));
    }
    else {
      @result = (scalar $self->dispatch_to_method($package, $dispatch, $self->args(@args)));
    }

    my $chain = $self->chain;

    if ($chain) {
      for my $item (@{$chain}) {
        my ($name, @args) = ref $item ? @{$item} : $item;
        @result = (scalar $result[0]->$name(@args));
      }
    }
  }

  if ($protocol eq 'routine') {
    my $constructor = $self->constructor;

    if ($constructor) {
      @result = (scalar $self->$constructor($package, $dispatch, $self->args(@args)));
    }
    else {
      @result = (scalar $self->dispatch_to_method($package, $dispatch, $self->args(@args)));
    }

    my $chain = $self->chain;

    if ($chain) {
      for my $item (@{$chain}) {
        my ($name, @args) = ref $item ? @{$item} : $item;
        @result = (scalar $result[0]->$name(@args));
      }
    }
  }

  my $builder = $self->builder;

  local $_ = $result[0];

  @result = ($self->$builder(@result)) if $builder;

  if (@result == 1) {
    my $assert = $self->assert;

    if ($assert) {
      require Venus::Assert;

      Venus::Assert->new($assert)->accept($assert)->result($result[0]);
    }

    $cache->{$self->name} = $result[0] if $cache && $cached && $self->name
  }

  return wantarray ? (@result) : $result[0];
}

sub retrieve {
  my ($self, $name) = @_;

  return $self if !$name;

  my $class = ref $self;

  my $registry = $self->registry || $self->registry({})->registry;

  my $container = $registry->{$name};

  return $container;
}

sub routine {
  my ($self, @data) = @_;

  if (@data) {
    $self->protocol('routine')->dispatch($data[0]);

    return $self;
  }
  else {

    return ($self->protocol && $self->protocol eq 'routine') ? $self->dispatch : undef;
  }
}

sub value {
  my ($self, @data) = @_;

  if (@data) {
    $self->{value} = [@data];

    return $self;
  }
  else {

    return $self->{value} ? @{$self->{value}} : ();
  }
}

1;
