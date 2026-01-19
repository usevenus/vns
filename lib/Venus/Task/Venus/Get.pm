package Venus::Task::Venus::Get;

use 5.018;

use strict;
use warnings;

use Venus::Class 'base';

# IMPORTS

use Venus::Config;
use Venus::Hash;

# INHERITS

base 'Venus::Task::Venus';

# REQUIRES

require Venus;

# METHODS

sub name {
  'vns get'
}

sub footer {

  return <<"EOF";
Copyright 2022-2023, Vesion $Venus::VERSION, The Venus "AUTHOR" and "CONTRIBUTORS"

More information on "vns" and/or the "Venus" standard library, visit
https://p3rl.org/vns.
EOF
}

sub perform {
  my ($self) = @_;

  my $file = $self->file;
  my $path = $self->argument_value('path');

  my $config = Venus::Hash->new(Venus::Config->read_file($file)->value);

  my ($value) = $config->gets($path);

  $self->log_info($value) if defined $value;

  return $self;
}

sub prepare {
  my ($self) = @_;

  $self->summary('get values in the Venus configuration file');

  # path
  $self->argument('path', {
    name => 'path',
    help => 'Value path. Use dot-natotion. E.g. "perl.repl".',
    range => '0',
    multiples => 0,
    required => 1,
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