package Venus::Run;

use 5.018;

use strict;
use warnings;

use Venus::Class 'attr', 'base', 'with';

# IMPORTS

use Venus;
use Venus::Config;
use Venus::Os;
use Venus::Path;

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Optional';

# STATE

state $init_config = {
  data => {
    VENUS_RUN_DEBUG => 1,
  },
  exec => {
    brew => 'perlbrew',
    cpan => 'cpanm -llocal -qn',
    docs => 'perldoc',
    each => 'shim -nE',
    edit => '$EDITOR $VENUS_FILE',
    eval => 'shim -E',
    exec => '$PERL',
    info => '$PERL -V',
    lint => 'perlcritic',
    okay => '$PERL -c',
    repl => '$REPL',
    reup => 'cpanm -qn Venus',
    says => 'eval "map log(eval), @ARGV"',
    shim => '$PERL -MVenus=true,false,log',
    test => '$PROVE',
    tidy => 'perltidy',
  },
  libs => [
    '-Ilib',
    '-Ilocal/lib/perl5',
  ],
  path => [
    'bin',
    'dev',
    'local/bin',
  ],
  perl => {
    perl => 'perl',
    prove => 'prove',
  },
  vars => {
    PERL => 'perl',
    PROVE => 'prove',
    REPL => '$PERL -dE0',
  },
};

# ATTRIBUTES

attr 'cache';
attr 'config';
attr 'debug';
attr 'handler';

# BUILDERS

sub build_arg {
  my ($self, $file) = @_;

  return {
    config => $self->load_config($file),
  };
}

sub build_self {
  my ($self, $data) = @_;

  $self->debug($ENV{VENUS_DEBUG}) if defined $ENV{VENUS_DEBUG};

  $self->debug($ENV{VENUS_RUN_DEBUG}) if defined $ENV{VENUS_RUN_DEBUG};

  return $self;
}

sub default_cache {
  my ($self, $data) = @_;

  return $self->new_cache;
}

sub default_config {
  my ($self, $data) = @_;

  return $self->new_config;
}

sub default_debug {
  my ($self, $data) = @_;

  return false;
}

sub default_handler {
  my ($self, $data) = @_;

  return $self->new_handler;
}

# HOOKS

sub _error {
  do {local $| = 1; CORE::print(STDERR @_, "\n")}
}

sub _print {
  do {local $| = 1; CORE::print(@_, "\n")}
}

sub _prompt {
  do {local $\ = ''; local $_ = <STDIN>; chomp; $_}
}

sub _system {
  local $SIG{__WARN__} = sub {}; CORE::system(@_) == 0 ? true : false;
}

# METHODS

sub callback {
  my ($self, $code, @args) = @_;

  if (!@args) {
    return;
  }

  my $config = $self->prepare_conf($self->config);

  my %ORIG_ENV = %ENV;

  $self->prepare_vars($config);
  $self->prepare_path($config);
  $self->prepare_libs($config);

  my $result;

  for my $step ($self->resolve($config, @args)) {
    my ($prog, @step_args) = ref $step eq 'ARRAY' ? (@{$step}) : ($step);

    if (!$prog) {
      next;
    }

    $result = $code->($prog, @step_args);

    if (!$result) {
      last;
    }
  }

  %ENV = %ORIG_ENV;

  return $result;
}

sub execute {
  my ($self, @args) = @_;

  return $self->callback($self->handler, @args);
}

sub expand_prog {
  my ($self, $prog) = @_;

  return Venus::Os->which($prog);
}

sub expand_vars {
  my ($self, $text) = @_;

  return ($text // '') =~ s{\$([A-Z_]+)}{$ENV{$1} // "\$" . $1}egr;
}

sub prepare_conf {
  my ($self, $config) = @_;

  if (my $from = $config->{from}) {
    my @files = ref($from) eq 'ARRAY' ? @{$from} : ($from);

    for my $file (@files) {
      $config = Venus::merge(
        $self->load_config($self->expand_vars($file)), $config,
      );
    }
  }

  if (my $when = $config->{when}) {
    my $os_type = Venus::Os->type;

    if ($when->{$os_type}) {
      $config = Venus::merge($config, $when->{$os_type});
    }
  }

  return $config;
}

sub prepare_libs {
  my ($self, $config) = @_;

  my $lib_paths = $config->{libs} // [];

  my %seen_paths;

  my @absolute_paths = map {Venus::Path->new($self->expand_vars($_))->absolute}
    map /^-I\w*?(.*)$/, @{$lib_paths};

  my $separator = Venus::Os->is_win ? ';' : ':';

  $ENV{PERL5LIB} = join $separator, grep {!$seen_paths{$_}++} @absolute_paths;

  return $config;
}

sub prepare_path {
  my ($self, $config) = @_;

  if (!$config->{path}) {
    return $config;
  }

  my $separator = Venus::Os->is_win ? ';' : ':';

  my @absolute_paths = map {Venus::Path->new($self->expand_vars($_))->absolute}
    @{$config->{path}};

  $ENV{PATH} = join $separator, @absolute_paths, $ENV{PATH};

  return $config;
}

sub prepare_vars {
  my ($self, $config) = @_;

  if (my $data = $config->{data}) {
    for my $key (sort keys %$data) {
      $ENV{$key} = join ' ', grep defined, $data->{$key};
    }
  }

  if (my $vars = $config->{vars}) {
    for my $key (sort keys %$vars) {
      $ENV{$key} = join ' ', grep defined,
        @{$self->resolve_command($config, $vars->{$key})};
    }
  }

  if (my $asks = $config->{asks}) {
    for my $key (sort keys %$asks) {
      if (!defined $ENV{$key}) {
        _print $asks->{$key}; my $input = _prompt;
        $ENV{$key} = $input;
      }
    }
  }

  return $config;
}

sub resolve {
  my ($self, $config, @args) = @_;

  if (!@args) {
    return [];
  }

  my $item = shift @args;

  my @resolved_with;

  if (@args) {
    @resolved_with = $self->resolve_with($config, $item, @args);
  }

  my @resolved;

  if (!@resolved_with) {
    @resolved = $self->resolve_recursive($config, $item);
  }

  my @resolved_flow;

  if (@resolved) {
    @resolved_flow = $self->resolve_flow($config, @resolved, @args);
  }

  my $results;

  if (@resolved_with) {
    $results = [@resolved_with];
  }
  elsif (@resolved_flow) {
    $results = [@resolved_flow];
  }
  else {
    $results = [scalar $self->resolve_command($config, @resolved, @args)];
  }

  return wantarray ? (@{$results}) : $results;
}

sub resolve_cache {
  my ($self, $config, $item) = @_;

  if (exists $self->cache->{$item}) {
    return ref $self->cache->{$item}
      ? $self->cache->{$item}
      : $self->resolve_cache($config, $self->cache->{$item});
  }
  else {
    return;
  }
}

sub resolve_command {
  my ($self, $config, @args) = @_;

  my ($prog, @rest) = (@args);

  my $path = $self->expand_prog($prog);

  my @parts = grep defined, ($path || $prog), @rest;

  $prog = $self->expand_vars(shift @parts);

  for my $arg (@parts) {
    if ($arg =~ /^(?:\|+|\&+|[<>]+|\d[<>&]+\d?)$/) {
      next;
    }

    if ($arg =~ /^\$[A-Z]\w+$/) {
      $arg = $self->expand_vars($arg);
    }

    if ($arg =~ /^\$\((.*)\)$/) {
      $arg = "\$(@{[@{$self->prep($config, $1)}]})";
    }

    $arg = Venus::Os->quote($arg);
  }

  my $results = [$prog ? ($prog, @parts) : ()];

  return wantarray ? (@{$results}) : $results;
}

sub resolve_exec {
  my ($self, $config, $item) = @_;

  if (exists $self->cache->{$item}) {
    return $self->cache->{$item};
  }

  if (!($config->{exec} && exists $config->{exec}->{$item})) {
    return;
  }

  return $self->cache->{$item} = $config->{exec}->{$item};
}

sub resolve_find {
  my ($self, $config, $item) = @_;

  if (exists $self->cache->{$item}) {
    return $self->cache->{$item};
  }

  if (!($config->{find} && exists $config->{find}->{$item})) {
    return;
  }

  return $self->cache->{$item} = $config->{find}->{$item};
}

sub resolve_flow {
  my ($self, $config, $item, @args) = @_;

  if (!($config->{flow} && $config->{flow}{$item})) {
    return;
  }

  my @results = map {$self->resolve($config, $_, @args)} @{$config->{flow}{$item}};

  return wantarray ? (@results) : [@results];
}

sub resolve_func {
  my ($self, $config, $item, @args) = @_;

  if (exists $self->cache->{$item}) {
    return $self->cache->{$item};
  }

  if (!($config->{func} && exists $config->{func}{$item})) {
    return;
  }

  my $from = Venus::Path->new($self->file);

  $ENV{VENUS_RUN_FROM_ROOT} = $from->parent->absolute->get;
  $ENV{VENUS_RUN_FROM_FILE} = $from->absolute->get;

  my $func = Venus::Path->new($config->{func}->{$item});

  $ENV{VENUS_RUN_FUNC_ROOT} = $func->parent->absolute->get;
  $ENV{VENUS_RUN_FUNC_FILE} = $func->absolute->get;

  my $run = $self->from_file("$func");

  my $results = $run->resolve($run->config, @args);

  return wantarray ? (@{$results}) : $results;
}

sub resolve_perl {
  my ($self, $config, $item) = @_;

  if (exists $self->cache->{$item}) {
    return $self->cache->{$item};
  }

  if (!($config->{perl} && exists $config->{perl}{$item})) {
    return;
  }

  my $perl = $config->{perl}{$item};
  my @libs = map {$self->cache->{$_} = $_} @{$config->{libs} // []};
  my @load = map {$self->cache->{$_} = $_} @{$config->{load} // []};

  my $result = join ' ', $perl, @libs, @load;

  $self->cache->{$item} = $self->cache->{$result} = [$perl, @libs, @load];

  return $result;
}

sub resolve_recursive {
  my ($self, $config, $item) = @_;

  if (exists $self->cache->{$item}) {
    return ref $self->cache->{$item} eq 'ARRAY'
      ? (wantarray ? (@{$self->cache->{$item}}) : $self->cache->{$item})
      : $self->cache->{$item};
  }

  my @parts = grep length, ($item // '') =~ /(?x)(?:"([^"]*)"|([^\s]*))\s?/g;

  my @results;

  for my $part (@parts) {
    my $cached = exists $self->cache->{$part} ? 1 : 0;
    my $recurse = $cached
      ? (ref $self->cache->{$part} ? 0 : $self->cache->{$self->cache->{$part}})
      : 0;
    my $resolved
      = $cached ? $self->cache->{$part} : $self->resolve_exec($config, $part)
      // $self->resolve_func($config, $part)
      // $self->resolve_task($config, $part)
      // $self->resolve_vars($config, $part)
      // $self->resolve_find($config, $part)
      // $self->resolve_perl($config, $part);

    push @results, Venus::list(
      $resolved && ((!$cached && $resolved ne $part) || $recurse)
        ? $self->resolve_recursive($config, $resolved)
        : ($resolved // $part)
      );
  }

  $self->cache->{$item} = [@results];

  return wantarray ? (@results) : $self->cache->{$item};
}

sub resolve_task {
  my ($self, $config, $item) = @_;

  if (exists $self->cache->{$item}) {
    return $self->cache->{$item};
  }

  if (!($config->{task} && exists $config->{task}{$item})) {
    return;
  }

  return $self->cache->{$item} = $config->{task}{$item};
}

sub resolve_vars {
  my ($self, $config, $item) = @_;

  if (exists $self->cache->{$item}) {
    return $self->cache->{$item};
  }

  my ($var) = $item =~ /^\$(\w+)$/;

  if (!(defined $var && $config->{vars} && exists $config->{vars}{$var})) {
    return;
  }

  return $self->cache->{$item} = $config->{vars}{$var};
}

sub resolve_with {
  my ($self, $config, $item, @args) = @_;

  if (!($config->{with} && exists $config->{with}->{$item})) {
    return;
  }

  my $here = Venus::Path->new;

  my $from = Venus::Path->new($self->file);

  $ENV{VENUS_RUN_FROM_ROOT} = $from->parent->absolute->get;
  $ENV{VENUS_RUN_FROM_FILE} = $from->absolute->get;

  my $with = Venus::Path->new($config->{with}->{$item});

  $ENV{VENUS_RUN_WITH_ROOT} = $with->parent->absolute->get;
  $ENV{VENUS_RUN_WITH_FILE} = $with->absolute->get;

  my $run = $self->from_file("$with");

  chdir $ENV{VENUS_RUN_WITH_ROOT};

  my $results = $run->resolve($run->config, @args);

  chdir $here->get;

  return wantarray ? (@{$results}) : $results;
}

sub result {
  my ($self, @args) = @_;

  return $self->execute(@args);
}

# ROUTINES

sub file {
  my ($self) = @_;

  return $ENV{VENUS_FILE}
      || $ENV{VENUS_RUN_FILE}
      || $ENV{VENUS_RUN_CONFIG}
      || (grep -f, map ".vns.$_", qw(yaml yml json js perl pl))[0]
      || '.vns.pl';
}

sub find_config {
  my ($self) = @_;

  my $file = $self->file;

  return -f $file ? $self->load_config($file) : $self->init_config;
}

sub from_file {
  my ($self, $file) = @_;

  $file ||= $self->file;

  return $self->new(config => $self->load_config($file));
}

sub from_find {
  my ($self) = @_;

  return $self->new(config => $self->find_config);
}

sub from_hash {
  my ($self, $data) = @_;

  return $self->new(config => $data);
}

sub from_init {
  my ($self) = @_;

  return $self->new(config => $self->init_config);
}

sub init_config {
  my ($self, @args) = @_;

  return $init_config;
}

sub load_config {
  my ($self, $file) = @_;

  return Venus::Config->read_file($file)->value
}

sub new_cache {
  my ($self) = @_;

  return {};
}

sub new_config {
  my ($self) = @_;

  return $self->find_config;
}

sub new_handler {
  my ($self) = @_;

  return sub {
    my $command = join ' ', @_;

    if ($self->debug) {
      _print("Using: $command");
    }

    my $result = _system($command);

    if (!$result) {
      _error("Error running command! $command");
    }

    return $result;
  };
}

1;