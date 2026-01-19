package Venus::Module;

use 5.018;

use strict;
use warnings;

# IMPORTS

sub import {
  my ($self, @args) = @_;

  my $from = caller;

  require Venus::Core;

  no strict 'refs';
  no warnings 'redefine';
  no warnings 'once';

  @args = grep defined && !ref && /^[A-Za-z]/, @args;

  my %exports = map +($_,$_), @args ? @args : qw(
    false
    mixin
    role
    test
    true
    with
  );

  @{"${from}::ISA"} = 'Venus::Core';

  if ($exports{"after"} && !*{"${from}::after"}{"CODE"}) {
    *{"${from}::after"} = sub ($$) {require Venus; goto \&Venus::after};
  }
  if ($exports{"around"} && !*{"${from}::around"}{"CODE"}) {
    *{"${from}::around"} = sub ($$) {require Venus; goto \&Venus::around};
  }
  if ($exports{"before"} && !*{"${from}::before"}{"CODE"}) {
    *{"${from}::before"} = sub ($$) {require Venus; goto \&Venus::before};
  }
  if ($exports{"catch"} && !*{"${from}::catch"}{"CODE"}) {
    *{"${from}::catch"} = sub (&) {require Venus; goto \&Venus::catch};
  }
  if ($exports{"error"} && !*{"${from}::error"}{"CODE"}) {
    *{"${from}::error"} = sub (;$) {require Venus; goto \&Venus::error};
  }
  if (!*{"${from}::false"}{"CODE"}) {
    *{"${from}::false"} = sub {require Venus; Venus::false()};
  }
  if ($exports{"fault"} && !*{"${from}::fault"}{"CODE"}) {
    *{"${from}::fault"} = sub (;$) {require Venus; goto \&Venus::fault};
  }
  if ($exports{"handle"} && !*{"${from}::handle"}{"CODE"}) {
    *{"${from}::handle"} = sub ($$) {require Venus; goto \&Venus::handle};
  }
  if ($exports{"hook"} && !*{"${from}::hook"}{"CODE"}) {
    *{"${from}::hook"} = sub ($$$) {require Venus; goto \&Venus::hook};
  }
  if (!*{"${from}::import"}{"CODE"}) {
    *{"${from}::import"} = sub {my $target = caller; $_[0]->USE($target); $_[0]->IMPORT($target, @_)};
  }
  if ($exports{"raise"} && !*{"${from}::raise"}{"CODE"}) {
    *{"${from}::raise"} = sub ($;$) {require Venus; goto \&Venus::raise};
  }
  if ($exports{"mixin"} && !*{"${from}::mixin"}{"CODE"}) {
    *{"${from}::mixin"} = sub {@_ = ($from, @_); goto \&mixin};
  }
  if ($exports{"role"} && !*{"${from}::role"}{"CODE"}) {
    *{"${from}::role"} = sub {@_ = ($from, @_); goto \&role};
  }
  if ($exports{"test"} && !*{"${from}::test"}{"CODE"}) {
    *{"${from}::test"} = sub {@_ = ($from, @_); goto \&test};
  }
  if (!*{"${from}::true"}{"CODE"}) {
    *{"${from}::true"} = sub {require Venus; Venus::true()};
  }
  if (!*{"${from}::unimport"}{"CODE"}) {
    *{"${from}::unimport"} = sub {my $target = caller; $_[0]->UNIMPORT($target, @_)};
  }
  if ($exports{"with"} && !*{"${from}::with"}{"CODE"}) {
    *{"${from}::with"} = sub {@_ = ($from, @_); goto \&test};
  }

  ${"${from}::META"} = {};

  ${"${from}::@{[$from->METACACHE]}"} = undef;

  return $self;
}

# ROUTINES

sub mixin {
  my ($from, @args) = @_;

  $from->MIXIN(@args);

  return $from;
}

sub role {
  my ($from, @args) = @_;

  $from->ROLE(@args);

  return $from;
}

sub test {
  my ($from, @args) = @_;

  $from->TEST(@args);

  return $from;
}

1;
