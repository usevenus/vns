package Venus::Error;

use 5.018;

use strict;
use warnings;

use Venus::Class 'attr', 'base', 'with';

base 'Venus::Kind::Utility';

with 'Venus::Role::Explainable';
with 'Venus::Role::Stashable';

use overload (
  '""' => 'explain',
  'eq' => sub{$_[0]->render eq "$_[1]"},
  'ne' => sub{$_[0]->render ne "$_[1]"},
  'qr' => sub{qr/@{[quotemeta($_[0]->render)]}/},
  '~~' => 'explain',
  fallback => 1,
);

# ATTRIBUTES

attr 'name';
attr 'context';
attr 'message';
attr 'verbose';

# BUILDERS

sub build_arg {
  my ($self, $data) = @_;

  return {
    message => $data,
  };
}

sub build_self {
  my ($self, $data) = @_;

  $self->name($data->{name}) if $self->name;
  $self->context('(None)') if !$self->context;
  $self->message('Exception!') if !$self->message;
  $self->verbose($ENV{VENUS_ERROR_VERBOSE} // 1) if !exists $data->{verbose};
  $self->trace($ENV{VENUS_ERROR_TRACE_OFFSET} // 2) if !@{$self->frames};

  return $self;
}

# METHODS

sub arguments {
  my ($self, $index) = @_;

  my $captured = $self->captured;

  return undef if !$captured;

  my $arguments = $captured->{arguments};

  return $arguments if !defined $index;

  return undef if !$arguments;

  return $arguments->[$index];
}


sub as {
  my ($self, $name) = @_;

  $name = $self->id($name);

  my $method = "as_${name}";

  $self = ref $self ? $self : $self->new;

  if (!$self->can($method)) {
    return $self->do('name', $name);
  }

  return $self->$method;
}

sub assertion {
  my ($self) = @_;

  my $assertion = $self->SUPER::assertion;

  $assertion->match('string')->format(sub{
    (ref $self || $self)->new($_)
  });

  return $assertion;
}

sub callframe {
  my ($self, $index) = @_;

  my $captured = $self->captured;

  return undef if !$captured;

  my $callframe = $captured->{callframe};

  return $callframe if !defined $index;

  return undef if !$callframe;

  return $callframe->[$index];
}

sub captured {
  my ($self) = @_;

  return $self->stash('captured');
}

sub id {
  my ($self, $name) = @_;

  $name = lc $name =~ s/\W+/_/gr if $name;

  return $name;
}

sub explain {
  my ($self) = @_;

  $self->trace(1, 1) if !@{$self->frames};

  my $frames = $self->{'$frames'};
  my $message = $self->render;

  my @stacktrace = "$message" =~ s/^\s+|\s+$//gr;

  return join "\n", @stacktrace, "" if !$self->verbose;

  push @stacktrace, 'Name:', $self->name || '(None)';
  push @stacktrace, 'Type:', ref($self);
  push @stacktrace, 'Context:', $self->context || '(None)';

  no warnings 'once';

  require Data::Dumper;

  local $Data::Dumper::Indent = 1;
  local $Data::Dumper::Trailingcomma = 0;
  local $Data::Dumper::Purity = 0;
  local $Data::Dumper::Pad = '';
  local $Data::Dumper::Varname = 'VAR';
  local $Data::Dumper::Useqq = 0;
  local $Data::Dumper::Terse = 1;
  local $Data::Dumper::Freezer = '';
  local $Data::Dumper::Toaster = '';
  local $Data::Dumper::Deepcopy = 1;
  local $Data::Dumper::Quotekeys = 0;
  local $Data::Dumper::Bless = 'bless';
  local $Data::Dumper::Pair = ' => ';
  local $Data::Dumper::Maxdepth = 0;
  local $Data::Dumper::Maxrecurse = 1000;
  local $Data::Dumper::Useperl = 0;
  local $Data::Dumper::Sortkeys = 1;
  local $Data::Dumper::Deparse = 1;
  local $Data::Dumper::Sparseseen = 0;

  my $stashed = Data::Dumper->Dump([$self->stash]);

  $stashed =~ s/^'|'$//g;

  chomp $stashed;

  push @stacktrace, 'Stashed:', $stashed;
  push @stacktrace, 'Traceback (reverse chronological order):' if @$frames > 1;

  use warnings 'once';

  @stacktrace = (join("\n\n", grep defined, @stacktrace), '');

  for (my $i = 1; $i < @$frames; $i++) {
    my $pack = $frames->[$i][0];
    my $file = $frames->[$i][1];
    my $line = $frames->[$i][2];
    my $subr = $frames->[$i][3];

    push @stacktrace, "$subr\n  in $file at line $line";
  }

  return join "\n", @stacktrace, "";
}

sub frames {
  my ($self) = @_;

  return $self->{'$frames'} //= [];
}

sub is {
  my ($self, $name) = @_;

  $name = $self->id($name);

  my $method = "is_${name}";

  if ($self->name && !$self->can($method)) {
    return $self->name eq $name ? true : false;
  }

  return (ref $self ? $self: $self->new)->$method ? true : false;
}

sub name {
  my ($self, $name) = @_;

  return $self->ITEM('name', $self->id($name) // ());
}

sub of {
  my ($self, $name) = @_;

  $name = $self->id($name);

  my $method = "of_${name}";

  if ($self->name && !$self->can($method)) {
    return $self->name =~ /$name/ ? true : false;
  }

  return (ref $self ? $self: $self->new)->$method ? true : false;
}

sub frame {
  my ($self, $index) = @_;

  my $frames = $self->frames;

  $index //= 0;

  return {
    package => $frames->[$index][0],
    filename => $frames->[$index][1],
    line => $frames->[$index][2],
    subroutine => $frames->[$index][3],
    hasargs => $frames->[$index][4],
    wantarray => $frames->[$index][5],
    evaltext => $frames->[$index][6],
    is_require => $frames->[$index][7],
    hints => $frames->[$index][8],
    bitmask => $frames->[$index][9],
    hinthash => $frames->[$index][10],
  };
}

sub render {
  my ($self) = @_;

  my $message = $self->message;
  my $stashed = $self->stash;

  while (my($key, $value) = each(%$stashed)) {
    my $token = quotemeta $key;
    $message =~ s/\{\{\s*$token\s*\}\}/$value/g;
  }

  return $message;
}

sub throw {
  my ($self, @args) = @_;

  $self = $self->new(@args) if !ref $self;

  die $self;
}

sub trace {
  my ($self, $offset, $limit) = @_;

  my $frames = $self->frames;

  @$frames = ();

  for (my $i = $offset // 1; my @caller = caller($i); $i++) {
    push @$frames, [@caller];

    last if defined $limit && $i + 1 == $offset + $limit;
  }

  return $self;
}

1;
