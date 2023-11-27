package Venus::Core;

use 5.018;

use strict;
use warnings;

# METHODS

sub ARGS {
  my ($self, @args) = @_;

  return (!@args)
    ? ($self->DATA)
    : ((@args == 1 && ref($args[0]) eq 'HASH')
    ? (do{my %args = %{$args[0]}; !CORE::keys(%args) ? $self->DATA : {%args}})
    : (@args % 2 ? {@args, undef} : {@args}));
}

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

sub AUDIT {
  my ($self) = @_;

  return $self;
}

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

sub BLESS {
  my ($self, @args) = @_;

  my $name = $self->NAME;
  my $data = $self->DATA($self->ARGS($self->BUILDARGS(@args)));
  my $anew = bless($data, $name);

  no strict 'refs';

  $anew->BUILD($data);

  return $anew if $name eq 'Venus::Meta';

  require Venus::Meta;

  my $metacache = join '::', $self->NAME, $self->METACACHE;

  ${$metacache} ||= Venus::Meta->new(name => $name);

  return $anew;
}

sub BUILD {
  my ($self) = @_;

  return $self;
}

sub BUILDARGS {
  my ($self, @args) = @_;

  return (@args);
}

sub DATA {
  my ($self, $data) = @_;

  return $data || {};
}

sub DESTROY {
  my ($self) = @_;

  return;
}

sub DOES {
  my ($self, $role) = @_;

  return if !$role;

  return $self->META->role($role);
}

sub EXPORT {
  my ($self, $into) = @_;

  return [];
}

sub FROM {
  my ($self, $base) = @_;

  $self->BASE($base);

  $base->AUDIT($self->NAME) if $base->can('AUDIT');

  no warnings 'redefine';

  $base->IMPORT($self->NAME);

  return $self;
}

sub GET {
  my ($self, $name) = @_;

  return $self->{$name};
}

sub IMPORT {
  my ($self, $into) = @_;

  return $self;
}

sub ITEM {
  my ($self, $name, @args) = @_;

  return undef if !$name;
  return $self->GET($name) if !@args;
  return $self->SET($name, $args[0]);
}

sub META {
  my ($self) = @_;

  no strict 'refs';

  require Venus::Meta;

  my $metacache = join '::', my $name = $self->NAME, $self->METACACHE;

  return ${$metacache} ||= Venus::Meta->new(name => $name);
}

sub METACACHE {
  my ($self) = @_;

  return 'METACACHE';
}

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

sub NAME {
  my ($self) = @_;

  return ref $self || $self;
}

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

sub SET {
  my ($self, $name, $data) = @_;

  return $self->{$name} = $data;
}

sub SUBS {
  my ($self) = @_;

  no strict 'refs';

  return [
    sort grep *{"@{[$self->NAME]}::$_"}{"CODE"},
    grep /^[_a-zA-Z]\w*$/, keys %{"@{[$self->NAME]}::"}
  ];
}

sub TEST {
  my ($self, $role) = @_;

  $self->ROLE($role);

  $role->AUDIT($self->NAME) if $role->can('AUDIT');

  return $self;
}

sub UNIMPORT {
  my ($self, $into, @args) = @_;

  return $self;
}

sub USE {
  my ($self, $into, @args) = @_;

  return $self;
}

1;
