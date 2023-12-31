package Venus::Container;

use 5.018;

use strict;
use warnings;

use Venus::Class 'base', 'with';

base 'Venus::Kind::Utility';

with 'Venus::Role::Buildable';
with 'Venus::Role::Valuable';

# BUILDERS

sub build_args {
  my ($self, $data) = @_;

  if (keys %$data == 1 && exists $data->{value}) {
    return $data;
  }
  return {
    value => $data
  };
}

# METHODS

sub metadata {
  my ($self, $name) = @_;

  return $name ? $self->tokens->{metadata}->{$name} : $self->tokens->{metadata};
}

sub reify {
  my ($self, $name, $data) = @_;

  return if !$name;

  my $cache = $self->{'$cache'} ||= $self->service_cache;

  return $cache->{$name} if $cache->{$name};

  my $services = $self->services;
  my $service = $services->{$name} or return;

  if (my $extends = $service->{extends}) {
    $service = $self->service_merge($service, $services->{$extends});
  }

  my $value = $self->service_build($service,
      $data
    ? $self->service_reify($data)
    : $self->service_reify($service->{argument}));

  my $lifecycle = $service->{lifecycle};
  $self->{'$cache'}->{$name} = $value if $lifecycle && $lifecycle eq 'singleton';

  return $value;
}

sub resolve {
  my ($self, $name, $data) = @_;

  return if !$name;

  my $value = $self->get;

  return exists $value->{$name} ? $value->{$name} : $self->reify($name, $data);
}

sub service_build {
  my ($self, $service, $argument) = @_;

  my $space = $self->service_space($service->{package});

  $space->load;

  my $construct;

  if (my $builder = $service->{builder}) {
    my $original;

    my $injectables = $argument;

    for (my $i=0; $i < @$builder; $i++) {
      my $buildspec = $builder->[$i];
      my $argument = $buildspec->{argument};
      my $argument_as = $buildspec->{argument_as};
      my $inject = $buildspec->{inject};
      my $return = $buildspec->{return};
      my $result = $construct || $space->package;

      my @arguments;

      if ($inject) {
        @arguments = $self->service_props(
          $self->service_reify($injectables), $inject
        );
      }
      else {
        @arguments = $self->service_props(
          $self->service_reify($argument), $argument_as
        );
      }

      if (my $function = $buildspec->{function}) {
        $result = $space->call($function, @arguments);
      }
      elsif (my $method = $buildspec->{method}) {
        $result = $space->call($method, $result, @arguments);
      }
      elsif (my $routine = $buildspec->{routine}) {
        $result = $space->call($routine, $space->package, @arguments);
      }
      else {
        next;
      }

      if ($return eq 'class') {
        $construct = $space->package;
      }
      if ($return eq 'result') {
        $construct = $result;
      }
      if ($return eq 'self') {
        $construct = $original //= $result;
      }
    }
  }
  elsif (my $method = $service->{method}) {
    $construct = $space->package->$method(
      $self->service_props($argument, $service->{argument_as}));
  }
  elsif (my $function = $service->{function}) {
    $construct = $space->call($function,
      $self->service_props($argument, $service->{argument_as}));
  }
  elsif (my $routine = $service->{routine}) {
    $construct = $space->call($routine, $space->package,
      $self->service_props($argument, $service->{argument_as}));
  }
  elsif (my $constructor = $service->{constructor}) {
    $construct = $space->package->$constructor(
      $self->service_props($argument, $service->{argument_as}));
  }
  else {
    $construct = $space->package->can('new')
      ? $space->call('new', $space->package,
        $self->service_props($argument, $service->{argument_as}))
      : $space->package;
  }

  return $construct;
}

sub service_cache {
  my ($self) = @_;

  $self->{'$cache'} = {};

  my $cache = {};
  my $services = $self->services;

  for my $name (keys %$services) {
    next if $cache->{$name};

    my $service = $services->{$name};
    my $lifecycle = $service->{lifecycle};

    next if !$lifecycle;

    if ($lifecycle eq 'eager') {
      $cache->{$name} = $self->reify($name);
    }
  }

  return $cache;
}

sub service_merge {
  my ($self, $left, $right) = @_;

  my $new_service = {};

  if (my $extends = $right->{extends}) {
    $right = $self->service_merge($right, $self->services->{$extends});
  }

  $new_service = {%$right, %$left};

  delete $new_service->{extends};

  if ((my $arg1 = $left->{argument}) || (my $arg2 = $right->{argument})) {
    if ((defined $left->{argument} && !ref($arg1))
      || (defined $right->{argument} && !ref($arg2))) {
      $new_service->{argument} ||= $arg1 if $arg1;
    }
    elsif ((defined $left->{argument} && (ref($arg1) eq 'ARRAY'))
      && (defined $right->{argument} && (ref($arg2) eq 'ARRAY'))) {
      $new_service->{argument} = [@$arg2, @$arg1];
    }
    elsif ((defined $left->{argument} && (ref($arg1) eq 'HASH'))
      && (defined $right->{argument} && (ref($arg2) eq 'HASH'))) {
      $new_service->{argument} = {%$arg2, %$arg1};
    }
    else {
      $new_service->{argument} ||= $arg1 if $arg1;
    }
  }

  return $new_service;
}

sub service_props {
  my ($self, $prop, $prop_as) = @_;

  my @props;

  if ($prop && $prop_as) {
    if (lc($prop_as) eq 'array' || lc($prop_as) eq 'arrayref') {
      if (ref $prop eq 'HASH') {
        @props = ([$prop]);
      }
      else {
        @props = ($prop);
      }
    }
    if (lc($prop_as) eq 'hash' || lc($prop_as) eq 'hashref') {
      if (ref $prop eq 'ARRAY') {
        @props = ({@$prop});
      }
      else {
        @props = ($prop);
      }
    }
    if (lc($prop_as) eq 'list') {
      if (ref $prop eq 'ARRAY') {
        @props = (@$prop);
      }
      elsif (ref $prop eq 'HASH') {
        @props = (%$prop);
      }
      else {
        @props = ($prop);
      }
    }
  }
  else {
    @props = ($prop) if defined $prop;
  }

  return (@props);
}

sub service_reify {
  my ($self, $props) = @_;

  my $metadata = $self->metadata;
  my $services = $self->services;

  if (ref $props eq 'ARRAY') {
    $props = [map $self->service_reify($_), @$props];
  }

  # $metadata
  if (ref $props eq 'HASH' && (keys %$props) == 1) {
    if ($props && $props->{'$metadata'}) {
      $props = $metadata->{$props->{'$metadata'}};
    }
  }

  # $envvar
  if (ref $props eq 'HASH' && (keys %$props) == 1) {
    if (my $envvar = $props->{'$envvar'}) {
      if (exists $ENV{$envvar}) {
        $props = $ENV{$envvar};
      }
      elsif (exists $ENV{uc($envvar)}) {
        $props = $ENV{uc($envvar)};
      }
      else {
        $props = undef;
      }
    }
  }

  # $function
  if (ref $props eq 'HASH' && (keys %$props) == 1) {
    if ($props->{'$function'}) {
      my ($name, $next) = split /#/, $props->{'$function'};
      if ($name && $next) {
        if (my $resolved = $self->reify($name)) {
          if (Scalar::Util::blessed($resolved)
            || (!ref($resolved) && ($resolved =~ /^[a-z-A-Z]/))) {
            my $space = $self->service_space(ref $resolved || $resolved);
            $props = $space->call($next) if $next && $next =~ /^[a-zA-Z]/;
          }
        }
      }
    }
  }

  # $method
  if (ref $props eq 'HASH' && (keys %$props) == 1) {
    if ($props->{'$method'}) {
      my ($name, $next) = split /#/, $props->{'$method'};
      if ($name && $next) {
        if (my $resolved = $self->reify($name)) {
          if (Scalar::Util::blessed($resolved)
            || (!ref($resolved) && ($resolved =~ /^[a-z-A-Z]/))) {
            $props = $resolved->$next if $next && $next =~ /^[a-zA-Z]/;
          }
        }
      }
    }
  }

  # $routine
  if (ref $props eq 'HASH' && (keys %$props) == 1) {
    if ($props->{'$routine'}) {
      my ($name, $next) = split /#/, $props->{'$routine'};
      if ($name && $next) {
        if (my $resolved = $self->reify($name)) {
          if (Scalar::Util::blessed($resolved)
            || (!ref($resolved) && ($resolved =~ /^[a-z-A-Z]/)))
          {
            my $space = $self->service_space(ref $resolved || $resolved);
            $props = $space->call($next, $space->package)
              if $next && $next =~ /^[a-zA-Z]/;
          }
        }
      }
    }
  }

  # $callback
  if (ref $props eq 'HASH' && (keys %$props) == 1) {
    if (my $callback = $props->{'$callback'}) {
      $props = sub { $self->reify($callback) };
    }
  }

  # $service
  if (ref $props eq 'HASH' && (keys %$props) == 1) {
    if ($props->{'$service'}) {
      $props = $self->reify($props->{'$service'});
    }
  }

  if (ref $props eq 'HASH' && grep ref, values %$props) {
    @$props{keys %$props} = map $self->service_reify($_), values %$props;
  }

  return $props;
}

sub service_space {
  my ($self, $name) = @_;

  require Venus::Space;

  return Venus::Space->new($name);
}

sub services {
  my ($self, $name) = @_;

  return $name ? $self->tokens->{services}->{$name} : $self->tokens->{services};
}

sub tokens {
  my ($self) = @_;

  return $self->{'$tokens'} ||= {
    services => $self->get->{'$services'} || {},
    metadata => $self->get->{'$metadata'} || {},
  };
}

1;
