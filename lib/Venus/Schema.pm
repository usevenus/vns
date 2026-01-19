package Venus::Schema;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Encaseable';

# METHODS

sub rule {
  my ($self, $data) = @_;

  my $ruleset = $self->ruleset;

  push @{$ruleset}, $data if ref $data eq 'HASH';

  return $self;
}

sub rules {
  my ($self, @data) = @_;

  $self->rule($_) for @data;

  return $self;
}

sub ruleset {
  my ($self, $data) = @_;

  my $ruleset = $self->encased('ruleset');

  $ruleset = $self->recase('ruleset', ref $data eq 'ARRAY' ? $data : []) if !$ruleset;

  return $ruleset;
}

sub shorthand {
  my ($self, $data) = @_;

  my @pairs;

  if (ref $data eq 'ARRAY') {
    for (my $i = 0; $i < @{$data}; $i += 2) {
      push @pairs, [$data->[$i], $data->[$i + 1]];
    }
  }
  elsif (ref $data eq 'HASH') {
    while (my ($key, $value) = each %{$data}) {
      push @pairs, [$key, $value];
    }
  }
  else {
    return [];
  }

  my @ruleset;

  for my $pair (@pairs) {
    my ($key, $type) = @{$pair};

    my $presence = 'required';

    if ($key =~ s/!$//) {
      $presence = 'required';
    }
    elsif ($key =~ s/\?$//) {
      $presence = 'optional';
    }
    elsif ($key =~ s/\*$//) {
      $presence = 'present';
    }

    my $selector;

    if ($key =~ /\./) {
      $selector = [split /\./, $key];
    }
    else {
      $selector = $key;
    }

    push @ruleset, {
      selector => $selector,
      presence => $presence,
      execute => $type,
    };
  }

  return \@ruleset;
}

sub validate {
  my ($self, $data) = @_;

  require Venus::Validate;

  my $validate = Venus::Validate->new(input => $data);

  my $errors = $validate->errors([]);

  my $ruleset = $self->ruleset;

  for my $rule (@{$ruleset}) {
    my $selector = $rule->{selector};
    my $presence = $rule->{presence} || 'optional';
    my $executes = $rule->{executes} || (
      $rule->{execute} ? [$rule->{execute}] : undef
    );

    next if $presence ne 'optional' && $presence ne 'present' && $presence ne 'required';

    my @nodes;

    if (defined $selector) {
      if (ref $selector eq 'ARRAY') {
        @nodes = ($validate);
        for my $i (0..$#{$selector}) {
          my $path = $selector->[$i];
          my $method = ($i == $#{$selector}) ? $presence : 'optional';
          @nodes = map +($_->each($method, $path)), @nodes;
        }
      }
      else {
        @nodes = ($validate->$presence($selector));
      }
    }
    else {
      @nodes = ($validate->$presence);
    }

    for my $node (@nodes) {
      for my $execute (@{$executes || []}) {
        my ($method, @args) = ref $execute eq 'ARRAY' ? @{$execute} : ($execute);

        $node->$method(@args);
      }
      $validate->sync($node);
    }
  }

  my $value = $validate->value;

  return wantarray ? ($errors, $value) : $errors;
}

1;
