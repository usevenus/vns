package Venus::Match;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

use Scalar::Util ();

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Valuable';
with 'Venus::Role::Buildable';
with 'Venus::Role::Accessible';

# ATTRIBUTES

attr 'on_none';
attr 'on_only';
attr 'on_then';
attr 'on_when';

# BUILDERS

sub build_self {
  my ($self, $data) = @_;

  $self->on_none(sub{}) if !$self->on_none;
  $self->on_only(sub{1}) if !$self->on_only;
  $self->on_then([]) if !$self->on_then;
  $self->on_when([]) if !$self->on_when;

  return $self;
}

# METHODS

sub boolean {
  my ($self) = @_;

  $self->then(sub{return true})->none(sub{return false});

  return $self;
}

sub clear {
  my ($self) = @_;

  $self->on_none(sub{});
  $self->on_only(sub{1});
  $self->on_then([]);
  $self->on_when([]);

  return $self;
}

sub data {
  my ($self, $data) = @_;

  while(my($key, $value) = each(%$data)) {
    $self->just($key)->then($value);
  }

  return $self;
}

sub defined {
  my ($self) = @_;

  $self->only(sub{CORE::defined($_[0])});

  return $self;
}

sub expr {
  my ($self, $topic) = @_;

  $self->when(sub{
    my $value = $self->value;

    if (!CORE::defined($value)) {
      return false;
    }
    if (Scalar::Util::blessed($value) && !overload::Overloaded($value)) {
      return false;
    }
    if (!Scalar::Util::blessed($value) && ref($value)) {
      return false;
    }
    if (ref($topic) eq 'Regexp' && "$value" =~ qr/$topic/) {
      return true;
    }
    elsif ("$value" eq "$topic") {
      return true;
    }
    else {
      return false;
    }
  });

  return $self;
}

sub just {
  my ($self, $topic) = @_;

  $self->when(sub{
    my $value = $self->value;

    if (!CORE::defined($value)) {
      return false;
    }
    if (Scalar::Util::blessed($value) && !overload::Overloaded($value)) {
      return false;
    }
    if (!Scalar::Util::blessed($value) && ref($value)) {
      return false;
    }
    if ("$value" eq "$topic") {
      return true;
    }
    else {
      return false;
    }
  });

  return $self;
}

sub none {
  my ($self, $code) = @_;

  $self->on_none(UNIVERSAL::isa($code, 'CODE') ? $code : sub{$code});

  return $self;
}

sub object {
  my ($self) = @_;

  require Scalar::Util;

  $self->only(sub{Scalar::Util::blessed($_[0])});

  return $self;
}

sub only {
  my ($self, $code) = @_;

  $self->on_only($code);

  return $self;
}

sub result {
  my ($self, @args) = @_;

  $self->value($args[0]) if @args;

  my $result;
  my $matched = 0;
  my $value = $self->value;

  local $_ = $value;
  if (!$self->on_only->($value)) {
    local $_ = $value;
    $result = $self->on_none->($value);
    return wantarray ? ($result, $matched) : $result;
  }

  for (my $i = 0; $i < @{$self->on_when}; $i++) {
    if ($self->on_when->[$i]->($value)) {
      $result = $self->on_then->[$i]->($value);
      $matched++;
      last;
    }
  }

  if (!$matched) {
    local $_ = $value;
    $result = $self->on_none->($value);
  }

  return wantarray ? ($result, $matched) : $result;
}

sub take {
  my ($self) = @_;

  $self->then(sub{return $_[0]})->none(sub{return undef});

  return $self;
}

sub test {
  my ($self) = @_;

  my $matched = 0;

  my $value = $self->value;

  local $_ = $value;

  return $matched if !$self->on_only->($value);

  for (my $i = 0; $i < @{$self->on_when}; $i++) {
    if ($self->on_when->[$i]->($value)) {
      $matched++;
      last;
    }
  }

  return $matched;
}

sub then {
  my ($self, $code) = @_;

  my $next = $#{$self->on_when};

  $self->on_then->[$next] = UNIVERSAL::isa($code, 'CODE') ? $code : sub{$code};

  return $self;
}

sub type {
  my ($self, $expr) = @_;

  require Venus::Type;

  $self->when(sub{Venus::Type->new->check($expr)->eval($_[0])});

  return $self;
}

sub when {
  my ($self, $code, @args) = @_;

  my $next = (@{$self->on_when}-$#{$self->on_then}) > 1 ? -1 : @{$self->on_when};

  $self->on_when->[$next] = sub {
    (local $_ = $_[0])->$code(@args);
  };

  return $self;
}

sub where {
  my ($self) = @_;

  my $where = $self->new;

  $self->then(sub{$where->result(@_)});

  return $where;
}

sub yesno {
  my ($self) = @_;

  $self->then(sub{return "yes"})->none(sub{return "no"});

  return $self;
}

1;
