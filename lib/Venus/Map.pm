package Venus::Map;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Mappable';
with 'Venus::Role::Encaseable';

# ATTRIBUTES

attr 'accept';

# BUILDERS

sub build_arg {
  my ($self, $data) = @_;

  return {
    value => $data,
  };
}

sub build_args {
  my ($self, $data) = @_;

  if (keys %$data == 1 && exists $data->{value}) {
    return $data;
  }
  elsif (keys %$data == 1 && exists $data->{accept}) {
    return $data;
  }
  elsif (keys %$data == 2 && exists $data->{accept} && exists $data->{value}) {
    return $data;
  }
  else {
    return {
      value => $data,
    };
  }

  return $data;
}

sub build_self {
  my ($self, $data) = @_;

  $self->{accept} ||= 'any';

  my $value = delete $self->{value};

  $self->push(%$value) if ref $value eq 'HASH';

  return $self;
}

# METHODS

sub all {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $failed = 0;

  my $keys = $self->keys;

  for my $key (@$keys) {
    my $value = $data->{$key};

    local $_ = $value;
    $failed++ if !$code->($key, $value);

    CORE::last if $failed;
  }

  return $failed ? false : true;
}

sub any {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $keys = $self->keys;

  my $found = 0;

  for my $key (@$keys) {
    my $value = $data->{$key};

    local $_ = $value;
    $found++ if $code->($key, $value);

    CORE::last if $found;
  }

  return $found ? true : false;
}

sub attest {
  my ($self) = @_;

  require Venus::Assert;

  my $assert = Venus::Assert->new;

  my $accept = $self->accept;

  $assert->expression("within[hashref, $accept]");

  return $assert->result($self->get);
}

sub call {
  my ($self, $mapper, $method, @args) = @_;

  require Venus::What;

  return $self->$mapper(sub{
    my ($key, $val) = @_;

    my $what = Venus::What->new($val)->deduce;

    local $_ = $what;

    $what->$method(@args)
  });
}

sub contains {
  my ($self, $value) = @_;

  my $data = $self->get;

  if (CORE::grep({$value eq $_} CORE::values(%{$data}))) {
    return true;
  }

  my $value_to_object = $self->value_to_object($value);

  my $value_to_refaddr = $self->value_to_refaddr($value_to_object);
  my $index_by_refaddr = $self->index_by_refaddr;

  if (exists $index_by_refaddr->{$value_to_refaddr}) {
    return true;
  }

  return false;
}

sub count {
  my ($self) = @_;

  my $data = $self->get;

  return scalar(CORE::keys(%$data));
}

sub default {
  return {};
}

sub delete {
  my ($self, $index) = @_;

  return $self->remove($index);
}

sub difference {
  my ($self, $data) = @_;

  require Venus;
  require Scalar::Util;

  my $set = $self->class->new;

  if (Scalar::Util::blessed($data) && $data->isa('Venus::Map')) {
    $set->push(@$_) for grep !$self->contains($$_[1]), $data->pairs;
  }
  elsif (Scalar::Util::blessed($data) && $data->isa('Venus::Hash')) {
    $set->push(@$_) for grep !$self->contains($$_[1]), $data->pairs;
  }
  elsif (ref($data) eq 'HASH') {
    $set->push(@$_) for grep !$self->contains($$_[1]), Venus::pairs($data);
  }

  return $set;
}

sub different {
  my ($self, $data) = @_;

  my $set = $self->difference($data);

  return $set->count ? true : false;
}

sub each {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $keys = $self->keys;

  my $result = [];

  for my $key (@{$keys}) {
    my $value = $data->{$key};

    local $_ = $value;
    CORE::push(@$result, $code->($key, $value));
  }

  return wantarray ? (@$result) : $result;
}

sub empty {
  my ($self) = @_;

  $self->reset;

  return $self;
}

sub exists {
  my ($self, $index) = @_;

  my $index_by_index = $self->index_by_index;

  return exists $index_by_index->{$index} ? true : false;
}

sub first {
  my ($self) = @_;

  my $index = $self->keys->[0];

  return $self->get($index);
}

sub get {
  my ($self, @args) = @_;

  return $self->value if !@args;

  my ($index) = @args;

  return $self->value->{$index};
}

sub grep {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $keys = $self->keys;

  my $result = [];

  for my $key (@$keys) {
    my $value = $data->{$key};

    local $_ = $value;
    CORE::push(@$result, $value) if $code->($key, $value);
  }

  return wantarray ? (@$result) : $result;
}

sub head {
  my ($self, $size) = @_;

  my $pairs = $self->pairs;

  $size = !$size ? 1 : $size > @$pairs ? @$pairs : $size;

  my $index = $size - 1;

  return [CORE::map($$_[1], @{$pairs}[0..$index])];
}

sub index {
  my ($self) = @_;

  my $index = $self->encase('index', {});

  return $index;
}

sub index_by_deduced {
  my ($self) = @_;

  my $deduced = $self->index->{deduced} ||= {};

  return $deduced;
}

sub index_by_index {
  my ($self) = @_;

  my $index = $self->index->{index} ||= {};

  return $index;
}

sub index_by_names {
  my ($self) = @_;

  my $names = $self->index->{names} ||= {};

  return $names;
}

sub index_by_order {
  my ($self) = @_;

  my $order = $self->index->{order} ||= {};

  return $order;
}

sub index_by_refaddr {
  my ($self) = @_;

  my $refaddr = $self->index->{refaddr} ||= {};

  return $refaddr;
}

sub insert {
  my ($self, $name, $value) = @_;

  my $value_to_deduced = $self->value_to_deduced($value);
  my $value_to_object = $self->value_to_object($value);

  my $index_by_deduced = $self->index_by_deduced;
  my $index_by_index = $self->index_by_index;
  my $index_by_names = $self->index_by_names;
  my $index_by_refaddr = $self->index_by_refaddr;
  my $index_by_order = $self->index_by_order;

  my $value_to_refaddr = $self->value_to_refaddr($value_to_object);

  if (!exists $index_by_index->{$name}) {
    my $index = int keys %{$index_by_order};
    $index_by_index->{$name} = $index;
    $index_by_order->{$index} = $name;
  }
  else {
    my $old_value_to_refaddr
      = $self->value_to_refaddr($index_by_names->{$name});
    delete $index_by_refaddr->{$old_value_to_refaddr}
      if $old_value_to_refaddr && $old_value_to_refaddr ne $value_to_refaddr;
  }

  $index_by_refaddr->{$value_to_refaddr} = $name;
  $index_by_deduced->{$name} = $value_to_deduced;
  $index_by_names->{$name} = $value_to_object;

  return $value_to_object;
}

sub iterator {
  my ($self) = @_;

  my $pairs = $self->pairs;

  my $i = 0;

  return sub {
    return undef if $i > $#{$pairs};
    return wantarray ? (@{$pairs->[$i++]}) : $pairs->[$i++][1];
  }
}

sub intersection {
  my ($self, $data) = @_;

  require Scalar::Util;

  my $set = $self->class->new;

  if (Scalar::Util::blessed($data) && $data->isa('Venus::Map')) {
    $set->push(@$_) for grep $self->contains($$_[1]), $data->pairs;
  }
  elsif (Scalar::Util::blessed($data) && $data->isa('Venus::Hash')) {
    $set->push(@$_) for grep $self->contains($$_[1]), $data->pairs;
  }
  elsif (ref($data) eq 'HASH') {
    $set->push(@$_) for grep $self->contains($$_[1]), Venus::pairs($data);
  }

  return $set;
}

sub intersect {
  my ($self, $data) = @_;

  my $set = $self->intersection($data);

  return $set->count ? true : false;
}

sub join {
  my ($self, $delimiter) = @_;

  my $pairs = $self->pairs;

  return CORE::join($delimiter // '', map $$_[1], @{$pairs});
}

sub keys {
  my ($self) = @_;

  my $index_by_order = $self->index_by_order;

  return [CORE::map($index_by_order->{$_},
    CORE::sort(CORE::keys(%{$index_by_order})))];
}

sub last {
  my ($self) = @_;

  my $index = $self->keys->[-1];

  return $self->get($index);
}

sub length {
  my ($self) = @_;

  return $self->count;
}

sub list {
  my ($self) = @_;

  return wantarray ? (map $$_[1], @{$self->pairs}) : $self->count;
}

sub map {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $keys = $self->keys;

  my $result = [];

  for my $key (@$keys) {
    my $value = $data->{$key};

    local $_ = $value;
    CORE::push(@$result, $code->($key, $value));
  }

  return wantarray ? (@$result) : $result;
}

sub merge {
  my ($self, @data) = @_;

  require Scalar::Util;

  if (@data == 1
    && Scalar::Util::blessed($data[0])
    && ($data[0]->isa('Venus::Map') || $data[0]->isa('Venus::Hash')))
  {
    @data = map +(@$_), $data[0]->pairs;
  }

  $self->push(@data);

  return $self;
}

sub none {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $keys = $self->keys;

  my $found = 0;

  for my $key (@{$keys}) {
    my $value = $data->{$key};

    local $_ = $value;
    $found++ if $code->($key, $value);

    CORE::last if $found;
  }

  return $found ? false : true;
}

sub object_to_value {
  my ($self, $value) = @_;

  require Venus::What;

  return Venus::What->new($value)->detract;
}

sub one {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $keys = $self->keys;

  my $found = 0;

  for my $key (@{$keys}) {
    my $value = $data->{$key};

    local $_ = $value;
    $found++ if $code->($key, $value);

    CORE::last if $found > 1;
  }

  return $found == 1 ? true : false;
}

sub order {
  my ($self, @args) = @_;

  return $self if !@args;

  my $pairs = $self->pairs;

  my $index_by_index = $self->index_by_index;

  @args = map $index_by_index->{$_}, @args;

  $self->reset;

  my %seen = ();

  @$pairs = (map $pairs->[$_], grep !$seen{$_}++, (@args), 0..$#{$pairs});

  $self->insert(@$_) for @$pairs;

  return $self;
}

sub pairs {
  my ($self) = @_;

  my $index_by_deduced = $self->index_by_deduced;
  my $index_by_names = $self->index_by_names;
  my $index_by_order = $self->index_by_order;

  my $result = [
    CORE::map([
        $index_by_order->{$_},
        $index_by_deduced->{$index_by_order->{$_}}
        ? $self->object_to_value($index_by_names->{$index_by_order->{$_}})
        : $index_by_names->{$index_by_order->{$_}}
      ],
      CORE::sort(CORE::keys(%{$index_by_order})))
  ];

  return wantarray ? (@$result) : $result;
}

sub part {
  my ($self, $code) = @_;

  my $data = $self->get;

  my $results = [{}, {}];

  my $keys = $self->keys;

  for my $key (@{$keys}) {
    my $value = $data->{$key};
    local $_ = $value;
    my $result = $code->($key, $value);
    my $slot = $result ? $$results[0] : $$results[1];

    $slot->{$key} = $value;
  }

  return wantarray ? (@$results) : $results;
}

sub pop {
  my ($self) = @_;

  my $index = $self->keys->[-1];

  return $self->remove($index);
}

sub push {
  my ($self, @args) = @_;

  require Venus;

  @args = Venus::flat(@args);

  for (my $i = 0; $i < @args; $i += 2) {
    $self->insert($args[$i], $args[$i+1] // undef);
  }

  return $self->get;
}

sub random {
  my ($self) = @_;

  my $pairs = $self->pairs;

  return (@$pairs[rand($#{$pairs}+1)])->[1];
}

sub range {
  my ($self, @args) = @_;

  return $self->slice(@args) if @args > 1;

  my ($note) = @args;

  return $self->slice if !defined $note;

  require Venus::Range;

  return scalar Venus::Range->parse($note, [map $$_[1], @{$self->pairs}])->select;
}

sub remove {
  my ($self, $name) = @_;

  my $index_by_deduced = $self->index_by_deduced;
  my $index_by_index = $self->index_by_index;
  my $index_by_names = $self->index_by_names;
  my $index_by_refaddr = $self->index_by_refaddr;
  my $index_by_order = $self->index_by_order;

  return undef if !exists $index_by_names->{$name};

  my $value_to_object = delete $index_by_names->{$name};
  my $value_to_deduced = delete $index_by_deduced->{$name};

  my $value_to_refaddr = $self->value_to_refaddr($value_to_object);

  delete $index_by_order->{delete $index_by_index->{$name}};
  delete $index_by_refaddr->{$value_to_refaddr};

  my $point = 0;

  for my $index (CORE::sort(CORE::keys(%{$index_by_order}))) {
    if ($index != $point) {
      $index_by_order->{$point} = delete $index_by_order->{$index};
      $index_by_index->{$index_by_order->{$point}} = $point;
    }
    $point++;
  }

  return $value_to_deduced
    ? $self->object_to_value($value_to_object)
    : $value_to_object;
}

sub reset {
  my ($self, @data) = @_;

  $self->uncase('index');

  $self->insert($_) for @data;

  return $self;
}

sub reverse {
  my ($self) = @_;

  my $keys = $self->keys;

  $self->order(CORE::reverse(@{$keys}));

  my $pairs = $self->pairs;

  return [CORE::map($$_[1], @{$pairs})];
}

sub rotate {
  my ($self) = @_;

  my $pairs = $self->pairs;

  $self->reset;

  CORE::push(@$pairs, CORE::shift(@$pairs));

  $self->insert(@$_) for @$pairs;

  return [CORE::map($$_[1], @{$pairs})];
}

sub rsort {
  my ($self) = @_;

  my $pairs = $self->pairs;

  return [CORE::sort { $b cmp $a } CORE::map $$_[1], @{$pairs}];
}

sub set {
  my ($self, @args) = @_;

  return $self->value if !@args;

  return $self->push(@args);
}

sub shift {
  my ($self) = @_;

  my $index = $self->keys->[0];

  my $result = $self->remove($index);

  return $result;
}

sub shuffle {
  my ($self) = @_;

  my $pairs = $self->pairs;

  my $result = [CORE::map $$_[1], @{$pairs}];

  for my $index (0..$#$result) {
    my $other = int(rand(@$result));
    my $stash = $result->[$index];
    $result->[$index] = $result->[$other];
    $result->[$other] = $stash;
  }

  return $result;
}

sub slice {
  my ($self, @args) = @_;

  my $pairs = $self->pairs;

  return [map $$_[1], @$pairs[@args]];
}

sub sort {
  my ($self) = @_;

  my $pairs = $self->pairs;

  return [CORE::sort { $a cmp $b } CORE::map $$_[1], @{$pairs}];
}

sub subset {
  my ($self, $data) = @_;

  require Scalar::Util;

  my $set = $self->class->new;

  if (Scalar::Util::blessed($data) && $data->isa('Venus::Map')) {
    $set->push(@$_) for grep $self->contains($$_[1]), $data->pairs;
    return true if $data->count == $set->count;
  }
  elsif (Scalar::Util::blessed($data) && $data->isa('Venus::Hash')) {
    $set->push(@$_) for grep $self->contains($$_[1]), $data->pairs;
    return true if $data->count == $set->count;
  }
  elsif (ref($data) eq 'HASH') {
    $set->push(@$_) for grep $self->contains($$_[1]), Venus::pairs($data);
    return true if CORE::keys(%$data) == $set->count;
  }

  return false;
}

sub superset {
  my ($self, $data) = @_;

  require Scalar::Util;

  my $set = $self->class->new;

  if (Scalar::Util::blessed($data) && $data->isa('Venus::Map')) {
    $set->push(@$_) for grep !$data->contains($$_[1]), $self->pairs;
    return false if $set->count || $data->count <= $self->count;;
  }
  elsif (Scalar::Util::blessed($data) && $data->isa('Venus::Hash')) {
    my $temp = $self->class->new($data->get);
    $set->push(@$_) for grep !$temp->contains($$_[1]), $self->pairs;
    return false if $set->count || $temp->count <= $self->count;
  }
  elsif (ref($data) eq 'HASH') {
    my $temp = $self->class->new($data);
    $set->push(@$_) for grep !$temp->contains($$_[1]), $self->pairs;
    return false if $set->count || $temp->count <= $self->count;
  }

  return true;
}

sub tail {
  my ($self, $size) = @_;

  my $pairs = $self->pairs;

  $size = !$size ? 1 : $size > @$pairs ? @$pairs : $size;

  my $index = $#$pairs - ($size - 1);

  return [CORE::map($$_[1], @{$pairs}[$index..$#$pairs])];
}

sub unshift {
  my ($self, @args) = @_;

  my @keys;

  require Venus;

  @args = Venus::flat(@args);

  for (my $i = 0; $i < @args; $i += 2) {
    CORE::push(@keys, $args[$i]);
    $self->insert($args[$i], $args[$i+1] // undef);
  }

  $self->order(@keys);

  return $self->get;
}

sub value {
  my ($self) = @_;

  my $results = {};

  my $index_by_deduced = $self->index_by_deduced;
  my $index_by_order = $self->index_by_order;
  my $index_by_names = $self->index_by_names;

  for my $index (CORE::sort(CORE::keys(%{$index_by_order}))) {
    my $name = $index_by_order->{$index};
    my $deduced = $index_by_deduced->{$name};
    my $value = $index_by_names->{$name};
    $results->{$name} = $deduced ? $self->object_to_value($value) : $value;
  }

  return $results;
}

sub value_to_deduced {
  my ($self, $value) = @_;

  require Scalar::Util;

  return Scalar::Util::blessed($value) ? false : true;
}

sub value_to_object {
  my ($self, $value) = @_;

  require Venus::What;

  return Venus::What->new($value)->deduce;
}

sub value_to_refaddr {
  my ($self, $value) = @_;

  require Scalar::Util;

  return Scalar::Util::refaddr($value);
}

sub values {
  my ($self) = @_;

  my $results = [];

  my $index_by_deduced = $self->index_by_deduced;
  my $index_by_order = $self->index_by_order;
  my $index_by_names = $self->index_by_names;

  for my $index (CORE::sort(CORE::keys(%{$index_by_order}))) {
    my $name = $index_by_order->{$index};
    my $deduced = $index_by_deduced->{$name};
    my $value = $index_by_names->{$name};
    CORE::push(@{$results}, $deduced ? $self->object_to_value($value) : $value);
  }

  return $results;
}

1;
