package Venus::Replace;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Encaseable';
with 'Venus::Role::Explainable';

# OVERLOADS

use overload (
  '""' => 'explain',
  'eq' => sub{"$_[0]" eq "$_[1]"},
  'ne' => sub{"$_[0]" ne "$_[1]"},
  'qr' => sub{qr{@{[quotemeta("$_[0]")]}}},
  '~~' => 'explain',
  fallback => 1,
);

# ATTRIBUTES

attr 'flags';
attr 'regexp';
attr 'string';
attr 'substr';

# BUILDERS

sub build_self {
  my ($self, $data) = @_;

  $self->flags('') if !$self->flags;
  $self->regexp(qr//) if !defined $self->regexp;
  $self->string('') if !defined $self->string;
  $self->substr('') if !defined $self->substr;

  return $self;
}

# METHODS

sub captures {
  my ($self) = @_;

  my $evaluation = $self->encased('evaluation') || $self->evaluate;

  my $string = $self->initial;
  my $last_match_start = $self->last_match_start;
  my $last_match_end = $self->last_match_end;

  my $captures = [];

  for (my $i = 1; $i < @$last_match_end; $i++) {
    my $start = $last_match_start->[$i] || 0;
    my $end = $last_match_end->[$i] || 0;

    push @$captures, substr $string, $start, $end - $start;
  }

  return wantarray ? (@$captures) : $captures;
}

sub count {
  my ($self) = @_;

  my $evaluation = $self->encased('evaluation') || $self->evaluate;

  return $evaluation->[2];
}

sub evaluate {
  my ($self) = @_;

  my $captures = 0;
  my $flags = $self->flags;
  my @matches = ();
  my $regexp = $self->regexp;
  my $string = $self->string;
  my $substr = $self->substr;
  my $initial = "$string";

  local $@;
  eval join ';', (
    '$captures = (' . '$string =~ s/$regexp/$substr/' . ($flags // '') . ')',
    '@matches = ([@-], [@+], {%-})',
  );

  my $error = $@;

  if ($error) {
    $self->error_on_evaluate({error => $error})->throw;
  }

  return $self->recase(evaluation => [
    $regexp,
    $string,
    $captures,
    @matches,
    $initial,
  ]);
}

sub explain {
  my ($self) = @_;

  return $self->get;
}

sub get {
  my ($self) = @_;

  my $evaluation = $self->encased('evaluation') || $self->evaluate;

  return $evaluation->[1];
}

sub initial {
  my ($self) = @_;

  my $evaluation = $self->encased('evaluation') || $self->evaluate;

  return $evaluation->[6];
}

sub last_match_end {
  my ($self) = @_;

  my $evaluation = $self->encased('evaluation') || $self->evaluate;

  return $evaluation->[4];
}

sub last_match_start {
  my ($self) = @_;

  my $evaluation = $self->encased('evaluation') || $self->evaluate;

  return $evaluation->[3];
}

sub matched {
  my ($self) = @_;

  my $evaluation = $self->encased('evaluation') || $self->evaluate;

  my $string = $self->initial;
  my $last_match_start = $self->last_match_start;
  my $last_match_end = $self->last_match_end;

  my $start = $last_match_start->[0] || 0;
  my $end = $last_match_end->[0] || 0;

  return substr $string, $start, $end - $start;
}

sub named_captures {
  my ($self) = @_;

  my $evaluation = $self->encased('evaluation') || $self->evaluate;

  return $evaluation->[5];
}

sub prematched {
  my ($self) = @_;

  my $evaluation = $self->encased('evaluation') || $self->evaluate;

  my $string = $self->initial;
  my $last_match_start = $self->last_match_start;
  my $last_match_end = $self->last_match_end;

  my $start = $last_match_start->[0] || 0;
  my $end = $last_match_end->[0] || 0;

  return substr $string, 0, $start;
}

sub postmatched {
  my ($self) = @_;

  my $evaluation = $self->encased('evaluation') || $self->evaluate;

  my $string = $self->initial;
  my $last_match_start = $self->last_match_start;
  my $last_match_end = $self->last_match_end;

  my $start = $last_match_start->[0] || 0;
  my $end = $last_match_end->[0] || 0;

  return substr $string, $end;
}

sub set {
  my ($self, $string) = @_;

  $self->string($string);

  my $evaluation = $self->evaluate;

  return $evaluation->[1];
}

# ERRORS

sub error_on_evaluate {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  $error->name('on.evaluate');
  $error->message($data->{error});
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

1;
