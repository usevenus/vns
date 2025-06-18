package Venus::Throw;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base';

# INHERITS

base 'Venus::Error';

# OVERLOADS

use overload (
  '""' => sub{$_[0]->error->explain},
  '~~' => sub{$_[0]->error->explain},
  fallback => 1,
);

# ATTRIBUTES

attr 'package';
attr 'parent';

# BUILDERS

sub build_arg {
  my ($self, $data) = @_;

  return {
    package => $data,
  };
}

sub build_self {
  my ($self, $data) = @_;

  if (!$self->parent) {
    $self->parent('Venus::Error');
  }

  if (my $stash = delete $data->{stash}) {
    %{$self->stash} = %{$stash};
  }

  return $self;
}

# METHODS

sub die {
  my ($self, $data) = @_;

  $data ||= {};

  $data->{raise} = true;

  @_ = ($self, $data);

  goto $self->can('error');
}

sub error {
  my ($self, $data) = @_;

  $data ||= {};

  for my $key (keys %{$data}) {
    next if $key eq 'die';
    next if $key eq 'error';

    $self->$key($data->{$key}) if $self->can($key);
  }

  my $context = $self->context;

  if (!$context) {
    $context = $self->context((caller(($self->offset // 0) + 1))[3]);
  }

  my $package = $self->package;

  if (!$package) {
    $package = $self->package(join('::', map ucfirst, (caller($self->offset // 0))[0], 'error'));
  }

  my $parent = $self->parent;

  if (!$parent) {
    $parent = $self->parent('Venus::Error');
  }

  local $@;

  if (!$package->can('new') and !eval "package $package; use base '$parent'; 1") {
    my $throw = $self->class->new;
    $throw->message($@);
    $throw->package('Venus::Throw::Error');
    $throw->parent('Venus::Error');
    $throw->stash(package => $package);
    $throw->stash(parent => $parent);
    $throw->die;
  }

  if (!$parent->isa('Venus::Error')) {
    my $throw = $self->class->new;
    $throw->message(qq(Parent '$parent' doesn't derive from 'Venus::Error'));
    $throw->package('Venus::Throw::Error');
    $throw->parent('Venus::Error');
    $throw->stash(package => $package);
    $throw->stash(parent => $parent);
    $throw->die;
  }

  if (!$package->isa('Venus::Error')) {
    my $throw = $self->class->new;
    $throw->message(qq(Package '$package' doesn't derive from 'Venus::Error'));
    $throw->package('Venus::Throw::Error');
    $throw->parent('Venus::Error');
    $throw->stash(package => $package);
    $throw->stash(parent => $parent);
    $throw->die;
  }

  my $error = $package->new->copy($self);

  (@_ = ($error)) && goto $error->can('throw') if $data && $data->{raise};

  return $error;
}

1;
