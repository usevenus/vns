package Venus::Task::Venus::New;

use 5.018;

use strict;
use warnings;

use Venus::Class 'base';

# IMPORTS

use Venus::Path;

# INHERITS

base 'Venus::Task::Venus';

# REQUIRES

require Venus;

# METHODS

sub name {
  'vns new'
}

sub execute {
  my ($self) = @_;

  return $self->Venus::Task::execute;
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

  my $type = $self->argument_value('type');

  my $file = $type ? ".vns.$type" : $self->file;

  my $path = Venus::Path->new($file)->absolute;

  $type = $path->extension;

  my $supported = grep {$type eq $_} qw(yaml yml json js perl pl);

  if (!$supported) {
    $self->log_error("$path invalid");

    return $self;
  }

  if ($path->exists) {
    $self->log_error("$path exists");

    return $self;
  }

  require Venus::Config;

  Venus::Config->new($self->init)->write_file($path);

  $self->log_info("$path created");

  return $self;
}

sub prepare {
  my ($self) = @_;

  $self->summary('initialize a new Venus configuration file');

  # type
  $self->argument('type', {
    name => 'type',
    help => 'Configuration file type. See "types" below.',
    multiples => 0,
    required => 0,
    type => 'string',
    wants => 'string',
  });

  # json
  $self->choice('json', {
    name => 'json',
    help => 'A JSON configuration file. E.g. .vns.json.',
    argument => 'type',
  });

  # js
  $self->choice('js', {
    name => 'js',
    help => 'A JSON configuration file. E.g. .vns.js.',
    argument => 'type',
  });

  # perl
  $self->choice('perl', {
    name => 'perl',
    help => 'A Perl configuration file. E.g. .vns.perl.',
    argument => 'type',
  });

  # pl
  $self->choice('pl', {
    name => 'pl',
    help => 'A Perl configuration file. E.g. .vns.pl.',
    argument => 'type',
  });

  # yaml
  $self->choice('yaml', {
    name => 'yaml',
    help => 'A YAML configuration file. E.g. .vns.yaml.',
    argument => 'type',
  });

  # yml
  $self->choice('yml', {
    name => 'yml',
    help => 'A YAML configuration file. E.g. .vns.yml.',
    argument => 'type',
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