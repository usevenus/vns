package Venus::Set;

use 5.018;

use strict;
use warnings;

use Venus::Class 'attr', 'base', 'with';

base 'Venus::Kind::Utility';

with 'Venus::Role::Mappable';

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

  $data->{accept} ||= 'any';

  return $data;
}

sub build_self {
  my ($self, $data) = @_;

  my $value = delete $self->{value};

  $self->push(@$value) if ref $value eq 'ARRAY';

  return $self;
}

# METHODS

sub all {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $failed = 0;

  for (my $i = 0; $i < @$data; $i++) {
    my $index = $i;
    my $value = $data->[$i];

    local $_ = $value;
    $failed++ if !$code->($index, $value);

    CORE::last if $failed;
  }

  return $failed ? false : true;
}

sub any {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $found = 0;

  for (my $i = 0; $i < @$data; $i++) {
    my $index = $i;
    my $value = $data->[$i];

    local $_ = $value;
    $found++ if $code->($index, $value);

    CORE::last if $found;
  }

  return $found ? true : false;
}

sub assertion {
  my ($self) = @_;

  my $assert = $self->SUPER::assertion;

  $assert->match('arrayref')->format(sub{
    (ref $self || $self)->new($_)
  });


  return $assert;
}

sub attest {
  my ($self) = @_;

  require Venus::Assert;

  my $assert = Venus::Assert->new;

  my $accept = $self->accept;

  $assert->expression("within[arrayref, $accept]");

  return $assert->result($self->get);
}

sub call {
  my ($self, $mapper, $method, @args) = @_;

  require Venus::Type;

  return $self->$mapper(sub{
    my ($key, $val) = @_;

    my $type = Venus::Type->new($val)->deduce;

    local $_ = $type;

    $type->$method(@args)
  });
}

sub contains {
  my ($self, $value) = @_;

  my $value_to_object = $self->value_to_object($value);

  my $value_to_digest = $self->value_to_digest($value_to_object);
  my $index_by_digest = $self->index_by_digest;

  if (exists $index_by_digest->{$value_to_digest}) {
    return true;
  }

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

  return scalar(@$data);
}

sub default {
  return [];
}

sub delete {
  my ($self, $index) = @_;

  return undef if !$index;

  my $index_by_digest = $self->index_by_digest;
  my $index_by_order = $self->index_by_order;

  my $value = $index_by_digest->{$index_by_order->{$index}};

  return undef if !defined $value;

  return $self->remove($value);
}

sub difference {
  my ($self, $data) = @_;

  require Scalar::Util;

  my $set = $self->class->new;

  if (Scalar::Util::blessed($data) && $data->isa('Venus::Set')) {
    $set->push($_) for grep !$self->contains($_), $data->list;
  }
  elsif (Scalar::Util::blessed($data) && $data->isa('Venus::Array')) {
    $set->push($_) for grep !$self->contains($_), $data->list;
  }
  elsif (ref($data) eq 'ARRAY') {
    $set->push($_) for grep !$self->contains($_), @$data;
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

  my $result = [];

  for (my $i = 0; $i < @$data; $i++) {
    my $index = $i;
    my $value = $data->[$i];

    local $_ = $value;
    CORE::push(@$result, $code->($index, $value));
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

  my $data = $self->get;

  return $index <= $#{$data} ? true : false;
}

sub first {
  my ($self) = @_;

  return $self->get->[0];
}

sub get {
  my ($self, @args) = @_;

  return $self->value if !@args;

  my ($index) = @args;

  return $self->value->[$index];
}

sub grep {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $result = [];

  for (my $i = 0; $i < @$data; $i++) {
    my $index = $i;
    my $value = $data->[$i];

    local $_ = $value;
    CORE::push(@$result, $value) if $code->($index, $value);
  }

  return wantarray ? (@$result) : $result;
}

sub head {
  my ($self, $size) = @_;

  my $data = $self->get;

  $size = !$size ? 1 : $size > @$data ? @$data : $size;

  my $index = $size - 1;

  return [@{$data}[0..$index]];
}

sub index {
  my ($self) = @_;

  return $self->{index} ||= {};
}

sub index_by_digest {
  my ($self) = @_;

  my $digest = $self->index->{digest} ||= {};

  return $digest;
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
  my ($self, $value) = @_;

  my $value_to_object = $self->value_to_object($value);

  my $value_to_digest = $self->value_to_digest($value_to_object);
  my $index_by_digest = $self->index_by_digest;

  if (exists $index_by_digest->{$value_to_digest}) {
    return $index_by_digest->{$value_to_digest};
  }

  my $value_to_refaddr = $self->value_to_refaddr($value_to_object);
  my $index_by_refaddr = $self->index_by_refaddr;

  if (exists $index_by_refaddr->{$value_to_refaddr}) {
    return $value_to_object;
  }

  my $index_by_order = $self->index_by_order;
  $index_by_order->{int keys %{$index_by_order}} = $value_to_digest;

  $index_by_digest->{$value_to_digest} = $value_to_object;
  $index_by_refaddr->{$value_to_refaddr} = $value_to_digest;

  return $value_to_object;
}

sub iterator {
  my ($self) = @_;

  my $data = $self->get;

  my $i = 0;
  my $j = 0;

  return sub {
    return undef if $i > $#{$data};
    return wantarray ? ($j++, $data->[$i++]) : $data->[$i++];
  }
}

sub intersection {
  my ($self, $data) = @_;

  require Scalar::Util;

  my $set = $self->class->new;

  if (Scalar::Util::blessed($data) && $data->isa('Venus::Set')) {
    $set->push($_) for grep $self->contains($_), $data->list;
  }
  elsif (Scalar::Util::blessed($data) && $data->isa('Venus::Array')) {
    $set->push($_) for grep $self->contains($_), $data->list;
  }
  elsif (ref($data) eq 'ARRAY') {
    $set->push($_) for grep $self->contains($_), @$data;
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

  my $data = $self->get;

  return CORE::join($delimiter // '', @$data);
}

sub keyed {
  my ($self, @keys) = @_;

  my $data = $self->get;

  my $i = 0;
  return {map { $_ => $data->[$i++] } @keys};
}

sub keys {
  my ($self) = @_;

  my $data = $self->get;

  return [0..$#{$data}];
}

sub last {
  my ($self) = @_;

  return $self->value->[-1];
}

sub length {
  my ($self) = @_;

  return $self->count;
}

sub list {
  my ($self) = @_;

  return wantarray ? (@{$self->value}) : scalar(@{$self->value});
}

sub map {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $result = [];

  for (my $i = 0; $i < @$data; $i++) {
    my $index = $i;
    my $value = $data->[$i];

    local $_ = $value;
    CORE::push(@$result, $code->($index, $value));
  }

  return wantarray ? (@$result) : $result;
}

sub merge {
  my ($self, @data) = @_;

  require Scalar::Util;

  for my $data (@data) {
    if (Scalar::Util::blessed($data)) {
      $self->push($data->isa('Venus::Set') ? $data->list : $data);
    }
    else {
      $self->push($data);
    }
  }

  return $self;
}

sub none {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $found = 0;

  for (my $i = 0; $i < @$data; $i++) {
    my $index = $i;
    my $value = $data->[$i];

    local $_ = $value;
    $found++ if $code->($index, $value);

    CORE::last if $found;
  }

  return $found ? false : true;
}

sub one {
  my ($self, $code) = @_;

  my $data = $self->get;

  $code = sub{} if !$code;

  my $found = 0;

  for (my $i = 0; $i < @$data; $i++) {
    my $index = $i;
    my $value = $data->[$i];

    local $_ = $value;
    $found++ if $code->($index, $value);

    CORE::last if $found > 1;
  }

  return $found == 1 ? true : false;
}

sub order {
  my ($self, @args) = @_;

  return $self if !@args;

  my $data = $self->get;

  $self->reset;

  my %seen = ();

  @$data = (map $data->[$_], grep !$seen{$_}++, (@args), 0..$#{$data});

  $self->insert($_) for @$data;

  return $self;
}

sub pairs {
  my ($self) = @_;

  my $data = $self->get;

  my $i = 0;
  my $result = [map +[$i++, $_], @$data];

  return wantarray ? (@$result) : $result;
}

sub part {
  my ($self, $code) = @_;

  my $data = $self->get;

  my $results = [[], []];

  for (my $i = 0; $i < @$data; $i++) {
    my $index = $i;
    my $value = $data->[$i];
    local $_ = $value;
    my $result = $code->($index, $value);
    my $slot = $result ? $$results[0] : $$results[1];

    CORE::push(@$slot, $value);
  }

  return wantarray ? (@$results) : $results;
}

sub pop {
  my ($self) = @_;

  return $self->remove($self->last);
}

sub push {
  my ($self, @args) = @_;

  $self->insert($_) for @args;

  return $self->get;
}

sub random {
  my ($self) = @_;

  my $data = $self->get;

  return @$data[rand($#{$data}+1)];
}

sub range {
  my ($self, @args) = @_;

  return $self->slice(@args) if @args > 1;

  my ($note) = @args;

  return $self->slice if !defined $note;

  my ($f, $l) = split /:/, $note, 2;

  my $data = $self->get;

  $f = 0 if !defined $f || $f eq '';
  $l = $f if !defined $l;
  $l = $#$data if !defined $l || $l eq '';

  $f = 0+$f;
  $l = 0+$l;

  $l = $#$data + $l if $f > -1 && $l < 0;

  return $self->slice($f..$l);
}

sub remove {
  my ($self, $value) = @_;

  my $value_to_object = $self->value_to_object($value);

  my $value_to_digest = $self->value_to_digest($value_to_object);
  my $index_by_digest = $self->index_by_digest;

  if (exists $index_by_digest->{$value_to_digest}) {
    $value_to_object = delete $index_by_digest->{$value_to_digest};
    $value_to_digest = $self->value_to_digest($value_to_object);
  }

  my $value_to_refaddr = $self->value_to_refaddr($value_to_object);
  my $index_by_refaddr = $self->index_by_refaddr;

  if (exists $index_by_refaddr->{$value_to_refaddr}) {
    delete $index_by_refaddr->{$value_to_refaddr};
  }

  my $count = 0;
  my $index_by_order = $self->index_by_order;

  %{$index_by_order} = map {$count++, $index_by_order->{$_}}
    CORE::grep {$index_by_order->{$_} ne $value_to_digest}
      CORE::sort(CORE::keys(%{$index_by_order}));

  return $value_to_object;
}

sub reset {
  my ($self, @data) = @_;

  delete $self->{index};

  $self->insert($_) for @data;

  return $self;
}

sub reverse {
  my ($self) = @_;

  my $data = $self->get;

  $self->reset;

  $self->insert($_) for CORE::reverse(@$data);

  return $self->get;
}

sub rotate {
  my ($self) = @_;

  my $data = $self->get;

  $self->reset;

  CORE::push(@$data, CORE::shift(@$data));

  $self->insert($_) for @$data;

  return $self->get;
}

sub rsort {
  my ($self) = @_;

  my $data = $self->get;

  return [CORE::sort { $b cmp $a } @$data];
}

sub set {
  my ($self, @args) = @_;

  return $self->value if !@args;

  return $self->insert(@args);
}

sub shift {
  my ($self) = @_;

  my $data = $self->get;

  $self->reset;

  my $result = CORE::shift(@$data);

  $self->insert($_) for @$data;

  return $result;
}

sub shuffle {
  my ($self) = @_;

  my $data = $self->get;
  my $result = [@$data];

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

  my $data = $self->get;

  return [@$data[@args]];
}

sub sort {
  my ($self) = @_;

  my $data = $self->get;

  return [CORE::sort { $a cmp $b } @$data];
}

sub subset {
  my ($self, $data) = @_;

  require Scalar::Util;

  my $set = $self->class->new;

  if (Scalar::Util::blessed($data) && $data->isa('Venus::Set')) {
    $set->push($_) for grep $self->contains($_), $data->list;
    return true if $data->count == $set->count;
  }
  elsif (Scalar::Util::blessed($data) && $data->isa('Venus::Array')) {
    $set->push($_) for grep $self->contains($_), $data->list;
    return true if $data->count == $set->count;
  }
  elsif (ref($data) eq 'ARRAY') {
    $set->push($_) for grep $self->contains($_), @$data;
    return true if @$data == $set->count;
  }

  return false;
}

sub superset {
  my ($self, $data) = @_;

  require Scalar::Util;

  my $set = $self->class->new;

  if (Scalar::Util::blessed($data) && $data->isa('Venus::Set')) {
    $set->push($_) for grep !$data->contains($_), $self->list;
    return false if $set->count || $data->count <= $self->count;;
  }
  elsif (Scalar::Util::blessed($data) && $data->isa('Venus::Array')) {
    my $temp = $self->class->new($data->get);
    $set->push($_) for grep !$temp->contains($_), $self->list;
    return false if $set->count || $temp->count <= $self->count;
  }
  elsif (ref($data) eq 'ARRAY') {
    my $temp = $self->class->new($data);
    $set->push($_) for grep !$temp->contains($_), $self->list;
    return false if $set->count || $temp->count <= $self->count;
  }

  return true;
}

sub tail {
  my ($self, $size) = @_;

  my $data = $self->get;

  $size = !$size ? 1 : $size > @$data ? @$data : $size;

  my $index = $#$data - ($size - 1);

  return [@{$data}[$index..$#$data]];
}

sub unique {
  my ($self) = @_;

  my $data = $self->get;

  return $data;
}

sub unshift {
  my ($self, @args) = @_;

  my $data = $self->get;

  $self->reset;

  CORE::unshift(@$data, @args);

  $self->insert($_) for @$data;

  return $data;
}

sub value {
  my ($self) = @_;

  my $index_by_digest = $self->index_by_digest;
  my $index_by_order = $self->index_by_order;

  return [
    CORE::map {$index_by_digest->{$index_by_order->{$_}}}
      CORE::sort(CORE::keys(%{$index_by_order}))
  ];
}

sub value_to_digest {
  my ($self, $value) = @_;

  require Digest;

  my $digest = Digest->new('SHA-1');
  my $method = "Venus::Role::Dumpable::dump";

  return $digest->add($value->$method)->hexdigest;
}

sub value_to_object {
  my ($self, $value) = @_;

  require Venus::Type;

  return Venus::Type->new($value)->deduce;
}

sub value_to_refaddr {
  my ($self, $value) = @_;

  require Scalar::Util;

  return Scalar::Util::refaddr($value);
}

1;
