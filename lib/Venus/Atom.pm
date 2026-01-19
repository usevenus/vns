package Venus::Atom;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base';

# INHERITS

base 'Venus::Sealed';

# OVERLOADS

use overload (
  '""' => sub{$_[0]->get // ''},
  '~~' => sub{$_[0]->get // ''},
  'eq' => sub{($_[0]->get // '') eq "$_[1]"},
  'ne' => sub{($_[0]->get // '') ne "$_[1]"},
  'qr' => sub{qr/@{[quotemeta($_[0])]}/},
  fallback => 1,
);

# METHODS

sub __get {
  my ($self, $init, $data) = @_;

  return $init->{value};
}

sub __set {
  my ($self, $init, $data, $value) = @_;

  if (ref $value || !defined $value || $value eq '') {
    return undef;
  }

  return $init->{value} = $value if !exists $init->{value};

  return $self->error_on_set->throw;
}

# ERRORS

sub error_on_set {
  my ($self) = @_;

  my $error = $self->error->sysinfo;

  $error->name('on.set');
  $error->message('Can\'t re-set atom value');
  $error->offset(1);
  $error->reset;

  return $error;
}

1;
