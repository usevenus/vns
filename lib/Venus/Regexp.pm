package Venus::Regexp;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base';

# INHERITS

base 'Venus::Kind::Value';

# OVERLOADS

use overload (
  'eq' => sub{"$_[0]" eq "$_[1]"},
  'ne' => sub{"$_[0]" ne "$_[1]"},
  'qr' => sub{$_[0]->value},
  fallback => 1,
);

# METHODS

sub comparer {
  my ($self) = @_;

  return 'stringified';
}

sub default {
  return qr//;
}

sub replace {
  my ($self, $string, $substr, $flags) = @_;

  require Venus::Replace;

  my $replace = Venus::Replace->new(
    regexp => $self->get,
    string => $string // '',
    substr => $substr // '',
    flags => $flags // '',
  );

  return $replace->do('evaluate');
}

sub search {
  my ($self, $string) = @_;

  require Venus::Search;

  my $search = Venus::Search->new(
    regexp => $self->get,
    string => $string // '',
  );

  return $search->do('evaluate');
}

1;
