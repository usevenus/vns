package Venus::Task::Venus;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base';

# INHERITS

base 'Venus::Task';

# REQUIRES

require Venus::Os;
require Venus::Path;
require Venus;

# METHODS

sub execute {
  my ($self) = @_;

  $self->fail if $self->no_input;

  return $self->SUPER::execute;
}

sub file {

  return ($ENV{VENUS_FILE}
      || (grep -f, map ".vns.$_", qw(yaml yml json js perl pl))[0]
      || '.vns.pl');
}

sub footer {

  return <<"EOF";
Config:

Here is an example configuration in YAML (e.g. in .vns.yaml).

  ---
  data:
    ECHO: true
  exec:
    cpan: cpanm -llocal -qn
    deps: cpan --installdeps .
    each: \$PERL -MVenus=log -nE
    exec: \$PERL -MVenus=log -E
    okay: \$PERL -c
    repl: \$PERL -dE0
    says: exec "map log(eval), \@ARGV"
    test: \$PROVE
  libs:
  - -Ilib
  - -Ilocal/lib/perl5
  path:
  - bin
  - dev
  - local/bin
  perl:
    perl: perl
    prove: prove
  vars:
    PERL: perl
    PROVE: prove

Examples:

Here are examples usages using the example YAML configuration.

  # Mint a new configuration file
  vns new yaml

  # Install a distribution
  vns run cpan \$DIST

  # Install dependencies in the CWD
  vns run deps

  # Check that a package can be compiled
  vns run okay \$FILE

  # Use the Perl debugger as a REPL
  vns run repl

  # Evaluate arbitrary Perl expressions
  vns run exec ...

  # Test the Perl project in the CWD
  vns run test t

Copyright 2022-2023, Vesion $Venus::VERSION, The Venus "AUTHOR" and "CONTRIBUTORS"

More information on "vns" and/or the "Venus" standard library, visit
https://p3rl.org/vns.
EOF
}

sub handle_command {
  my ($self, $name, @args) = @_;

  my $prog;
  my $root;

  my $os = Venus::Os->new;

  $prog = $os->which($name);

  my $path = Venus::Path->new;

  $root = $path->root('d', 'shim') if !$prog;

  $prog = $root->child('shim')->child($name)->value if !$prog && $root;

  $root = $path->root('d', 'bin') if !$prog;;

  $prog = $root->child('bin')->child($name)->value if !$prog && $root;

  $os->maybe('syscall', $prog, @args);

  return $self;
}

sub handle_gen_command {
  my ($self, @args) = @_;

  return $self->handle_command('vns-gen', @args);
}

sub handle_get_command {
  my ($self, @args) = @_;

  return $self->handle_command('vns-get', @args);
}

sub handle_help {
  my ($self) = @_;

  my $errors = (
    $self->input_arguments_defined_count == 0
    && $self->input_options_defined_count == 1
    && $self->input_options_defined->{help}
  ) ? 1 : 0;

  $self->help if $errors;

  return $errors;
}

sub handle_new_command {
  my ($self, @args) = @_;

  return $self->handle_command('vns-new', @args);
}

sub handle_run_command {
  my ($self, @args) = @_;

  return $self->handle_command('vns-run', @args);
}

sub handle_set_command {
  my ($self, @args) = @_;

  return $self->handle_command('vns-set', @args);
}

sub init {

  return {
    data => {
      ECHO => 1,
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
    libs => ['-Ilib', '-Ilocal/lib/perl5',],
    path => ['bin', 'dev', 'local/bin',],
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
}

sub perform {
  my ($self) = @_;

  my $task = $self->input->{task} || "";

  my @data = @{$self->data};

  shift @data;

  if ($task eq 'gen') {
    $self->handle_gen_command(@data);
  }
  elsif ($task eq 'get') {
    $self->handle_get_command(@data);
  }
  elsif ($task eq 'new') {
    $self->handle_new_command(@data);
  }
  elsif ($task eq 'run') {
    $self->handle_run_command(@data);
  }
  elsif ($task eq 'set') {
    $self->handle_set_command(@data);
  }
  else {
    $self->handle_run_command($task, @data);
  }

  return $self;
}

sub prepare {
  my ($self) = @_;

  $self->summary('Execute Venus tasks.');

  # task
  $self->argument('task', {
    name => 'task',
    help => 'Task sub-command.',
    range => '0',
    multiples => 0,
    required => 1,
    type => 'string',
    wants => 'string',
  });

  # gen
  $self->choice('gen', {
    name => 'gen',
    help => 'Generate Venus source code.',
    argument => 'task',
  });

  # get
  $self->choice('get', {
    name => 'get',
    help => 'Get values in the Venus configuration file.',
    argument => 'task',
  });

  # new
  $self->choice('new', {
    name => 'new',
    help => 'Initialize a new Venus configuration file.',
    argument => 'task',
  });

  # run
  $self->choice('run', {
    name => 'run',
    help => 'Execute Venus configuration commands.',
    argument => 'task',
  });

  # set
  $self->choice('set', {
    name => 'set',
    help => 'Set values in the Venus configuration file.',
    argument => 'task',
  });

  # args
  $self->argument('args', {
    name => 'args',
    help => 'Task arguments.',
    range => '1:',
    multiples => 1,
    required => 0,
    type => 'string',
    wants => 'string',
  });

  # help
  $self->option('help', {
    name => 'help',
    help => 'Display the help text.',
    multiples => 0,
    required => 0,
    type => 'boolean',
    wants => 'boolean',
  });

  return $self;
}

1;