package Venus::Random;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Valuable';
with 'Venus::Role::Buildable';
with 'Venus::Role::Accessible';

# STATE

state $ORIG_SEED = srand;
state $SELF_SEED = substr(((time ^ $$) ** 2), 0, length($ORIG_SEED));
srand $ORIG_SEED;

# BUILDERS

sub build_self {
  my ($self, $data) = @_;

  $self->reseed($self->value);

  return $self;
}

# METHODS

sub alphanumeric {
  my ($self) = @_;

  my $code = $self->select(['digit', 'letter']);

  return $self->$code;
}

sub alphanumerics {
  my ($self, $times) = @_;

  my $result = $self->collect($times || 1, 'alphanumeric');

  return $result;
}

sub base64 {
  my ($self) = @_;

  require Digest::SHA;
  require MIME::Base64;

  my $result = $self->token;

  $result = MIME::Base64::encode_base64(Digest::SHA::sha256($result));

  chomp $result;

  return $result;
}

sub bit {
  my ($self) = @_;

  return $self->select([1, 0]);
}

sub bits {
  my ($self, $times) = @_;

  my $result = $self->collect($times || 1, 'bit');

  return $result;
}

sub boolean {
  my ($self) = @_;

  return $self->select([true, false]);
}

sub byte {
  my ($self) = @_;

  return chr(int($self->pick * 256));
}

sub bytes {
  my ($self, $times) = @_;

  my $result = $self->collect($times || 1, 'byte');

  return $result;
}

sub character {
  my ($self) = @_;

  my $code = $self->select(['digit', 'letter', 'symbol']);

  return $self->$code;
}

sub characters {
  my ($self, $times) = @_;

  my $result = $self->collect($times || 1, 'character');

  return $result;
}

sub collect {
  my ($self, $times, $code, @args) = @_;

  return scalar($self->repeat($times, $code, @args));
}

sub default {
  state $default = $SELF_SEED;

  return $default++;
}

sub digest {
  my ($self) = @_;

  my $result = $self->token;

  return $result;
}

sub digit {
  my ($self) = @_;

  return int($self->pick(10));
}

sub digits {
  my ($self, $times) = @_;

  my $result = $self->collect($times || 1, 'digit');

  return $result;
}

sub float {
  my ($self, $place, $from, $upto) = @_;

  $from //= 0;
  $upto //= $self->number;

  my $tmp; $tmp = $from and $from = $upto and $upto = $tmp if $from > $upto;

  $place //= $self->nonzero;

  return sprintf("%.${place}f", $from + rand() * ($upto - $from));
}

sub hexdecimal {
  my ($self) = @_;

  state $hexdecimal = [0..9, 'a'..'f'];

  return $self->select($hexdecimal);
}

sub hexdecimals {
  my ($self, $times) = @_;

  my $result = $self->collect($times || 1, 'hexdecimal');

  return $result;
}

sub id {
  my ($self) = @_;

  state $instance = 0;

  state $previous = '';

  my $current = time;

  if ($current eq $previous) {
    $instance++;
  }
  else {
    $instance = 0;
    $previous = $current;
  }

  my $result = $current . $instance . $$;

  return $result;
}

sub letter {
  my ($self) = @_;

  my $code = $self->select(['uppercased', 'lowercased']);

  return $self->$code;
}

sub letters {
  my ($self, $times) = @_;

  my $result = $self->collect($times || 1, 'letter');

  return $result;
}

sub lowercased {
  my ($self) = @_;

  return lc(chr($self->range(97, 122)));
}

sub pick {
  my ($self, $data) = @_;

  return $data ? rand($data) : rand;
}

sub nonce {
  my ($self) = @_;

  my $result = $self->collect(10, 'alphanumeric');

  return $result;
}

sub nonzero {
  my ($self, $code, @args) = @_;

  $code ||= 'digit';

  my $value = $self->$code(@args);

  return
    ($value < 0 && $value > -1) ? ($value + -1)
    : (($value < 1 && $value > 0) ? ($value + 1)
    : ($value == 0 ? $self->nonzero : $value));
}

sub number {
  my ($self, $from, $upto) = @_;

  $upto //= 0;
  $from //= $self->digit;

  return $self->range($from, $upto) if $upto;

  return int($self->pick(10 ** ($from > 9 ? 9 : $from) -1));
}

sub numbers {
  my ($self, $times) = @_;

  my $result = $self->collect($times || 1, 'number', 1, 9);

  return $result;
}

sub password {
  my ($self, $ccount) = @_;

  $ccount ||= 16;

  my $scount = $ccount > 8 ? $ccount / 8 : 1;

  my $result = $self->shuffle(join '', $self->alphanumerics($ccount - $scount), $self->symbols($scount));

  return $result;
}

sub range {
  my ($self, $from, $upto) = @_;

  return 0 if !defined $from;
  return 0 if !defined $upto && $from == 0;

  return $from if $from == $upto;

  my $ceil = 2147483647;

  $from = 0 if !$from || $from > $ceil;
  $upto = $ceil if !$upto || $upto > $ceil;

  return $from + int($self->pick(($upto-$from) + 1));
}

sub repeat {
  my ($self, $times, $code, @args) = @_;

  my @values;

  $code ||= 'digit';
  $times ||= 1;

  push @values, $self->$code(@args) for 1..$times;

  return wantarray ? (@values) : join('', @values);
}

sub reseed {
  my ($self, $seed) = @_;

  my $THIS_SEED = !$seed || $seed =~ /\D/ ? $SELF_SEED : $seed;

  $self->value($THIS_SEED);

  srand $THIS_SEED;

  return $self;
}

sub reset {
  my ($self) = @_;

  $self->reseed($SELF_SEED);

  srand $SELF_SEED;

  return $self;
}

sub restore {
  my ($self) = @_;

  $self->reseed($ORIG_SEED);

  srand $ORIG_SEED;

  return $self;
}

sub select {
  my ($self, $data) = @_;

  if (UNIVERSAL::isa($data, 'ARRAY')) {
    my $keys = @$data;
    my $rand = $self->range(0, $keys <= 0 ? 0 : $keys - 1);
    return (@$data)[$rand];
  }

  if (UNIVERSAL::isa($data, 'HASH')) {
    my $keys = keys(%$data);
    my $rand = $self->range(0, $keys <= 0 ? 0 : $keys - 1);
    return $$data{(sort keys %$data)[$rand]};
  }

  return undef;
}

sub shuffle {
  my ($self, $data) = @_;

  my @characters = split '', $data || '';

  for (my $i = @characters - 1; $i > 0; $i--) {
    my $j = $self->pick($i + 1); @characters[$i, $j] = @characters[$j, $i];
  }

  return join '', @characters;
}

sub symbol {
  my ($self) = @_;

  state $symbols = [split '', q(~!@#$%^&*\(\)-_=+[]{}\|;:'",./<>?)];

  return $self->select($symbols);
}

sub symbols {
  my ($self, $times) = @_;

  my $result = $self->collect($times || 1, 'symbol');

  return $result;
}

sub token {
  my ($self) = @_;

  require Sys::Hostname;

  state $hostname = Sys::Hostname::hostname();

  state $instance = 1;

  require Time::HiRes;

  my ($seconds, $microseconds) = Time::HiRes::gettimeofday();

  require Digest::MD5;

  my $result = Digest::MD5::md5_hex(join ':', $hostname, $^T, $^O, $^X, $0, $$, $seconds, $microseconds, $instance++);

  return $result;
}

sub uppercased {
  my ($self) = @_;

  return uc(chr($self->range(97, 122)));
}

sub urlsafe {
  my ($self) = @_;

  my $result = $self->base64;

  $result =~ tr{+/}{-_}; $result =~ s/=+$//;

  return $result;
}

sub uuid {
  my ($self) = @_;

  my $result = $self->token;

  $result =~ s/^(.{8})(.{4})(.{4})(.{4})(.{12})$/$1-$2-$3-$4-$5/;

  return $result;
}

1;
