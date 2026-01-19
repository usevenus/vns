package Venus::Task::Venus::Run;

use 5.018;

use strict;
use warnings;

use Venus::Class 'attr', 'base';

# IMPORTS

use Venus::Run;

# INHERITS

base 'Venus::Task::Venus';

# REQUIRES

require Venus;

# METHODS

sub name {
  'vns run'
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

  my $run = Venus::Run->new;

  $run->result(@{$self->data});

  return $self;
}

sub prepare {
  my ($self) = @_;

  $self->summary('execute commands in the Venus configuration file');

  # name
  $self->argument('name', {
    name => 'name',
    help => 'The command to execute.',
    range => '0',
    required => 1,
    type => 'string',
    wants => 'string',
  });

  # args
  $self->argument('args', {
    name => 'args',
    help => 'The arguments provide to the command.',
    range => '1:',
    multiples => true,
    type => 'string',
    wants => 'string',
  });

  my $config = Venus::Config->read_file($self->file)->value;

  if ($config->{exec}) {
    for my $name (sort keys %{$config->{exec}}) {
      $self->choice($name, {
        name => $name,
        help => $config->{exec}->{$name},
        argument => 'name'
      });
    }
  }

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