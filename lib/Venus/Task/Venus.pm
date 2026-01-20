package Venus::Task::Venus;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base';

# INHERITS

base 'Venus::Task';

# REQUIRES

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

sub init {

  return {
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
}

sub perform {
  my ($self) = @_;

  my $result = $self->dispatch;

  # Fallback: treat unknown commands as 'run' subcommand
  if (!$result) {
    my @data = @{$self->data};
    if (@data && length($data[0]) && $data[0] !~ /^-/) {
      require Venus::Task::Venus::Run;
      Venus::Task::Venus::Run->new->handle(@data);
      return $self;
    }
    $self->help;
  }

  return $self;
}

sub spec_data {
  my ($self) = @_;

  return {
    footer => $self->footer,
    arguments => [
      {
        name => 'task',
        help => 'Task sub-command.',
        range => '0',
        type => 'string',
      },
      {
        name => 'args',
        help => 'Task arguments.',
        range => '1:',
        multiples => 1,
        type => 'string',
      },
    ],
    choices => [
      {
        name => 'gen',
        help => 'Generate Venus source code.',
        argument => 'task'
      },
      {
        name => 'get',
        help => 'Get values in the Venus configuration file.',
        argument => 'task'
      },
      {
        name => 'new',
        help => 'Initialize a new Venus configuration file.',
        argument => 'task'
      },
      {
        name => 'run',
        help => 'Execute Venus configuration commands.',
        argument => 'task'
      },
      {
        name => 'set',
        help => 'Set values in the Venus configuration file.',
        argument => 'task'
      },
      ],
    commands => [
      ['task', 'gen', 'Venus::Task::Venus::Gen'],
      ['task', 'get', 'Venus::Task::Venus::Get'],
      ['task', 'new', 'Venus::Task::Venus::New'],
      ['task', 'run', 'Venus::Task::Venus::Run'],
      ['task', 'set', 'Venus::Task::Venus::Set'],
    ],
  };
}

1;
