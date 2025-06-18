package Venus::Assert;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Buildable';

# OVERLOADS

use overload (
  '&{}' => sub{$_[0]->validator},
  fallback => 1,
);

# ATTRIBUTES

attr 'name';

# BUILDERS

sub build_arg {
  my ($self, $name) = @_;

  return {
    name => $name,
  };
}

sub build_self {
  my ($self, $data) = @_;

  $self->conditions;

  return $self;
}

# METHODS

sub accept {
  my ($self, $name, @args) = @_;

  return $self if !$name;

  $self->check->accept($name, @args);

  return $self;
}

sub check {
  my ($self, @args) = @_;

  require Venus::Check;

  $self->{check} = $args[0] if @args;

  $self->{check} ||= Venus::Check->new;

  return $self->{check};
}

sub clear {
  my ($self) = @_;

  $self->check->clear;
  $self->constraint->clear;
  $self->coercion->clear;

  return $self;
}

sub coerce {
  my ($self, $data) = @_;

  return $self->coercion->result($self->value($data));
}

sub coercion {
  my ($self, @args) = @_;

  require Venus::Coercion;

  $self->{coercion} = $args[0] if @args;

  $self->{coercion} ||= Venus::Coercion->new->do('check', $self->check);

  return $self->{coercion};
}

sub conditions {
  my ($self) = @_;

  return $self;
}

sub constraint {
  my ($self, @args) = @_;

  require Venus::Constraint;

  $self->{constraint} = $args[0] if @args;

  $self->{constraint} ||= Venus::Constraint->new->do('check', $self->check);

  return $self->{constraint};
}

sub ensure {
  my ($self, @code) = @_;

  $self->constraint->ensure(@code);

  return $self;
}

sub expression {
  my ($self, $data) = @_;

  return $self if !$data;

  $data =
  $data =~ s/\s*\n+\s*/ /gr =~ s/^\s+|\s+$//gr =~ s/\[\s+/[/gr =~ s/\s+\]/]/gr;

  require Venus::Type;

  $self->name($data) if !$self->name;

  my $parsed = Venus::Type->new->expression($data);

  $parsed = [$parsed] if !ref $parsed;

  $self->accept(
    @{$parsed} > 0
    ? ((ref $parsed->[0] eq 'ARRAY') ? @{$parsed->[0]} : @{$parsed})
    : @{$parsed}
  );

  return $self;
}

sub format {
  my ($self, @code) = @_;

  $self->coercion->format(@code);

  return $self;
}

sub match {
  my ($self, @args) = @_;

  require Venus::Coercion;
  my $match = Venus::Coercion->new->accept(@args);

  push @{$self->matches}, sub {
    my ($source, $value) = @_;
    local $_ = $value;
    return $match->result($value);
  };

  return $match;
}

sub matches {
  my ($self) = @_;

  my $matches = $self->{'matches'} ||= [];

  return wantarray ? (@{$matches}) : $matches;
}

sub parse {
  my ($self, $expr) = @_;

  $expr ||= '';

  $expr =
  $expr =~ s/\s*\n+\s*/ /gr =~ s/^\s+|\s+$//gr =~ s/\[\s+/[/gr =~ s/\s+\]/]/gr;

  require Venus::Type;

  my $parsed = Venus::Type->new->expression($expr);

  $parsed = [$parsed] if !ref $parsed;

  return $parsed;
}

sub received {
  my ($self, $data) = @_;

  require Scalar::Util;

  if (!defined $data) {
    return '';
  }

  my $blessed = Scalar::Util::blessed($data);
  my $isvenus = $blessed && $data->isa('Venus::Core') && $data->can('does');

  if (!$blessed && !ref $data) {
    return $data;
  }
  if ($blessed && ref($data) eq 'Regexp') {
    return "$data";
  }
  if ($isvenus && $data->does('Venus::Role::Explainable')) {
    return $self->dump(sub{$data->explain});
  }
  if ($isvenus && $data->does('Venus::Role::Valuable')) {
    return $self->dump(sub{$data->value});
  }
  if ($isvenus && $data->does('Venus::Role::Dumpable')) {
    return $data->dump;
  }
  if ($blessed && overload::Method($data, '""')) {
    return "$data";
  }
  if ($blessed && $data->can('as_string')) {
    return $data->as_string;
  }
  if ($blessed && $data->can('to_string')) {
    return $data->to_string;
  }
  if ($blessed && $data->isa('Venus::Kind')) {
    return $data->stringified;
  }
  else {
    return $self->dump(sub{$data});
  }
}

sub render {
  my ($self, $into, $data) = @_;

  require Venus::Type;

  return Venus::Type->new->expression([!$into ? $data : ($into, ref $data eq 'ARRAY' ? @{$data} : $data)]);
}

sub result {
  my ($self, $data) = @_;

  return $self->coerce($self->validate($self->value($data)));
}

sub valid {
  my ($self, $data) = @_;

  return $self->constraint->result($self->value($data));
}

sub validate {
  my ($self, $data) = @_;

  my $valid = $self->valid($data);

  return $data if $valid;

  my $error = $self->check->catch('result');

  my $received = $self->received($data);

  my $message = join("\n\n",
    'Type:',
    ($self->name || 'Unknown'),
    'Failure:',
    $error->message,
    'Received:',
    (defined $data ? ($received eq '' ? '""' : $received) : ('(undefined)')),
  );

  $error->message($message);

  return $error->throw;
}

sub validator {
  my ($self) = @_;

  return $self->defer('validate');
}

sub value {
  my ($self, $data) = @_;

  my $result = $data;

  for my $match ($self->matches) {
    $result = $match->($self, $result);
  }

  return $result;
}

1;
