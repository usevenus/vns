package Venus::Error;

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
  'eq' => sub{$_[0]->render eq "$_[1]"},
  'ne' => sub{$_[0]->render ne "$_[1]"},
  'qr' => sub{qr/@{[quotemeta($_[0]->render)]}/},
  '~~' => 'explain',
  fallback => 1,
);

# ATTRIBUTES

attr 'name';
attr 'cause';
attr 'context';
attr 'message';
attr 'offset';
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

  if ($data->{name}) {
    $self->name($data->{name});
  }

  if (!$self->context) {
    $self->context('N/A');
  }

  if (!$self->message) {
    $self->message('Exception!');
  }

  if (!exists $data->{verbose}) {
    $self->verbose($ENV{VENUS_ERROR_VERBOSE} // 1);
  }

  if (!exists $data->{offset}) {
    $self->offset($ENV{VENUS_ERROR_TRACE_OFFSET} // 2);
  }

  if (!@{$self->frames}) {
    $self->trace($self->offset);
  }

  if (my $stash = delete $data->{stash}) {
    %{$self->stash} = %{$stash};
  }

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

  my $method = $self->method('as', $name);

  $self = ref $self ? $self : $self->new;

  return $self->do('name', $name) if !$self->can($method);

  return $self->$method;
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

sub capture {
  my ($self, @args) = @_;

  $self->stash(captured => {
    callframe => [caller($self->offset // 0)],
    arguments => [@args],
  });

  return $self;
}

sub captured {
  my ($self) = @_;

  my $captured = $self->stash->{captured};

  return $captured;
}

sub copy {
  my ($self, $data) = @_;

  if (!$data->isa('Venus::Error')) {
    return $self;
  }

  if ($data->name) {
    $self->name($data->name)
  }

  if ($data->context) {
    $self->context($data->context)
  }

  if ($data->message) {
    $self->message($data->message)
  }

  if (defined $data->verbose) {
    $self->verbose($data->verbose)
  }

  if (@{$data->frames}) {
    $self->recase('frames', $data->frames)
  }

  if (my $stash = $data->stash) {
    %{$self->stash} = (%{$self->stash}, %{$stash});
  }

  return $self;
}

sub explain {
  my ($self) = @_;

  $self->trace(1, 1) if !@{$self->frames};

  my $frames = $self->frames;
  my $message = $self->render;

  my @stacktrace = "$message" =~ s/^\s+|\s+$//gr;

  return join "\n", @stacktrace, "" if !$self->verbose;

  push @stacktrace, 'Name:', $self->name || 'N/A';
  push @stacktrace, 'Type:', ref($self);
  push @stacktrace, 'Context:', $self->context || 'N/A';

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

  my $cause = $self->cause;

  if ($cause) {
    $cause = join("\n", "", "Cause:\n", "$cause");
    chomp $cause;
    push @stacktrace, $cause;
  }

  return join "\n", @stacktrace, "";
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

sub frames {
  my ($self) = @_;

  return $self->encase('frames', []);
}

sub get {
  my ($self, @args) = @_;

  @args = map $self->$_, @args;

  return wantarray ? (@args) : $args[0];
}

sub id {
  my ($self, @args) = @_;

  my $name = join '.', grep defined, @args;

  $name = lc $name =~ s/\W+/./gr if $name;

  return $name;
}

sub input {
  my ($self, @args) = @_;

  $self->stash(input => {
    callframe => [caller($self->offset // 0)],
    arguments => [@args],
  });

  return $self;
}

sub is {
  my ($self, $name) = @_;

  $name = $self->id($name);

  my $method = $self->method('is', $name);

  return false if !$self->name && !$self->can($method);

  return $self->name eq $name ? true : false if $self->name && !$self->can($method);

  return (ref $self ? $self: $self->new)->$method ? true : false;
}

sub label {
  my ($self, $name) = @_;

  $name = lc $name =~ s/\W/_/gr if $name;

  return $name;
}

sub method {
  my ($self, @name) = @_;

  @name = map {lc s/\W/_/gr} @name;

  return join '_', @name;
}

sub name {
  my ($self, $name) = @_;

  return $self->ITEM('name', defined $name ? $self->id($name) || () : ());
}

sub of {
  my ($self, $name) = @_;

  $name = $self->id($name);

  my $method = $self->method('of', $name);

  return false if !$self->name && !$self->can($method);

  return $self->name =~ /$name/ ? true : false if $self->name && !$self->can($method);

  return (ref $self ? $self: $self->new)->$method ? true : false;
}

sub on {
  my ($self, $name) = @_;

  $self = ref $self ? $self : $self->new;

  $name ||= (split(/::/, (caller($self->offset // 0))[3]))[-1];

  $self->name($self->id('on', $name)) if $name && $name ne '__ANON__' && $name ne '(eval)';

  return $self;
}

sub output {
  my ($self, @args) = @_;

  $self->stash(output => {
    callframe => [caller($self->offset // 0)],
    arguments => [@args],
  });

  return $self;
}

sub render {
  my ($self) = @_;

  my $message = $self->message;
  my $stashed = $self->stash;

  while (my($key, $value) = each(%$stashed)) {
    next if !defined $value;
    my $token = quotemeta $key;
    $message =~ s/\{\{\s*$token\s*\}\}/$value/g;
  }

  return $message;
}

sub reset {
  my ($self) = @_;

  $self->verbose($ENV{VENUS_ERROR_VERBOSE} // 1) if !defined $self->verbose;

  $self->offset($ENV{VENUS_ERROR_TRACE_OFFSET} // 1) if !defined $self->offset;

  $self->context((caller(($self->offset // 0) + 1))[3]);

  $self->trace(($self->offset // 0) + 1);

  return $self;
}

sub set {
  my ($self, @args) = @_;

  if (@args > 2 && not @args % 2) {
    my %data = @args;

    $self->$_($data{$_}) for keys %data;

    return $self;
  }

  if (@args > 0 && ref $args[0] eq 'HASH') {
    my %data = %{$args[0]};

    $self->$_($data{$_}) for keys %data;

    return $self;
  }

  my ($key, @value) = @args;

  $self->$key(@value);

  return $self;
}

sub stash {
  my ($self, @args) = @_;

  if (@args > 2 && not @args % 2) {
    my %data = @args;

    $self->stash($_, $data{$_}) for keys %data;

    return $self->stash;
  }

  if (@args > 0 && ref $args[0] eq 'HASH') {
    my %data = %{$args[0]};

    if (!%data) {
      return $self->recase('stashed', {});
    }

    $self->stash($_, $data{$_}) for keys %data;

    return $self->stash;
  }

  my ($key, @value) = @args;

  my $stashed = $self->encase('stashed', {});

  return $stashed if !defined $key;

  return $stashed->{$key} if !@value;

  my $value = $stashed->{$key} = $value[0];

  return $value;
}

sub sysinfo {
  my ($self) = @_;

  $self->system_name;
  $self->system_path;
  $self->system_perl_path;
  $self->system_perl_version;
  $self->system_process_id;
  $self->system_script_args;
  $self->system_script_path;

  return $self;
}

sub system_name {
  my ($self, @args) = @_;

  $self->stash('system_name', @args ? $args[0] : $^O);

  return $self;
}

sub system_path {
  my ($self, @args) = @_;

  require Cwd;

  $self->stash('system_path', @args ? $args[0] : Cwd->getcwd);

  return $self;
}

sub system_perl_path {
  my ($self, @args) = @_;

  $self->stash('system_perl_path', @args ? $args[0] : $^X);

  return $self;
}

sub system_perl_version {
  my ($self, @args) = @_;

  $self->stash('system_perl_version', @args ? $args[0] : "$^V");

  return $self;
}

sub system_process_id {
  my ($self, @args) = @_;

  $self->stash('system_process_id', @args ? $args[0] : $$);

  return $self;
}

sub system_script_args {
  my ($self, @args) = @_;

  $self->stash('system_script_args', @args ? [@args] : [@ARGV]);

  return $self;
}

sub system_script_path {
  my ($self, @args) = @_;

  $self->stash('system_script_path', @args ? $args[0] : $0);

  return $self;
}

sub trace {
  my ($self, $offset, $limit) = @_;

  my $frames = $self->frames;

  @$frames = ();

  for (my $i = $offset // $self->offset; my @caller = caller($i); $i++) {
    push @$frames, [@caller];

    last if defined $limit && $i + 1 == $offset + $limit;
  }

  return $self;
}

sub throw {
  my ($self, @args) = @_;

  $self = $self->new(@args) if !ref $self;

  die $self;
}

1;
