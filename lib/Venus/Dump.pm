package Venus::Dump;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Valuable';
with 'Venus::Role::Buildable';
with 'Venus::Role::Accessible';
with 'Venus::Role::Explainable';

# OVERLOADS

use overload (
  '""' => 'explain',
  '~~' => 'explain',
  fallback => 1,
);

# ATTRIBUTES

attr 'decoder';
attr 'encoder';

# BUILDERS

sub build_arg {
  my ($self, $data) = @_;

  return {
    value => $data
  };
}

sub build_args {
  my ($self, $data) = @_;

  if (keys %$data == 1 && exists $data->{value}) {
    return $data;
  }
  return {
    value => $data
  };
}

sub build_nil {
  my ($self, $data) = @_;

  return {
    value => $data
  };
}

sub build_self {
  my ($self, $data) = @_;

  $self->encoder(sub {
    my ($data) = @_;
    require Data::Dumper;
    no warnings 'once';
    local $Data::Dumper::Indent = 1;
    local $Data::Dumper::Purity = 1;
    local $Data::Dumper::Quotekeys = 0;
    local $Data::Dumper::Deepcopy = 1;
    local $Data::Dumper::Deparse = 1;
    local $Data::Dumper::Sortkeys = 1;
    local $Data::Dumper::Terse = 1;
    local $Data::Dumper::Useqq = 1;
    Data::Dumper->Dump([$data])
  });

  $self->decoder(sub {
    my ($text) = @_;
    require Symbol;
    my $name = join '::', __PACKAGE__, join '_', 'Eval', rand =~ s/\D//gr;
    my $data = eval "package $name; no warnings; return $text";
    Symbol::delete_package($name);
    return $data;
  });

  return $self;
}

# METHODS

sub decode {
  my ($self, $data) = @_;

  # double-traversing the data structure due to lack of boolean support
  return $self->set(FROM_BOOL($self->decoder->($data)));
}

sub encode {
  my ($self) = @_;

  # double-traversing the data structure due to lack of boolean support
  return $self->encoder->(TO_BOOL($self->get));
}

sub explain {
  my ($self) = @_;

  return $self->encode;
}

sub FROM_BOOL {
  my ($value) = @_;

  require Venus::Boolean;

  if (ref($value) eq 'HASH') {
    for my $key (keys %$value) {
      $value->{$key} = FROM_BOOL($value->{$key});
    }
    return $value;
  }

  if (ref($value) eq 'ARRAY') {
    for my $key (keys @$value) {
      $value->[$key] = FROM_BOOL($value->[$key]);
    }
    return $value;
  }

  return Venus::Boolean::TO_BOOL(Venus::Boolean::FROM_BOOL($value));
}

sub TO_BOOL {
  my ($value) = @_;

  require Venus::Boolean;

  if (ref($value) eq 'HASH') {
    $value = {
      %$value
    };
    for my $key (keys %$value) {
      $value->{$key} = TO_BOOL($value->{$key});
    }
    return $value;
  }

  if (ref($value) eq 'ARRAY') {
    $value = [
      @$value
    ];
    for my $key (keys @$value) {
      $value->[$key] = TO_BOOL($value->[$key]);
    }
    return $value;
  }

  return Venus::Boolean::TO_BOOL_TFO($value);
}

1;
