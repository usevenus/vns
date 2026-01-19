package Venus::Task;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base';

# INHERITS

base 'Venus::Cli';

# HOOKS

sub _stderr {
  require Venus::Os;

  return Venus::Os->new->write('STDERR', join "\n", @_, "");
}

sub _stdout {
  require Venus::Os;

  return Venus::Os->new->write('STDOUT', join "\n", @_, "");
}

# METHODS

sub execute {
  my ($self) = @_;

  my $errors = 0;

  $errors += $self->handle_help;

  $errors += $self->handle_errors_in_arguments if !$errors;

  $errors += $self->handle_errors_in_options if !$errors;

  $self->perform($self->assigned_options, $self->assigned_arguments) if !$errors;

  $errors += $self->handle_errors_in_log_events;

  return $errors ? $self->fail : $self->pass;
}

sub handle {
  my ($self, @args) = @_;

  $self->prepare->reorder->parse(@args ? @args : @{$self->data})->execute;

  return $self;
}

sub handle_errors_in_argument {
  my ($self, $name) = @_;

  my $errors = 0;

  for my $error ($self->argument_errors($name)) {
    if ($error->[0] eq 'required') {
      $self->log_error(qq(The argument "$name" is required));
    }
    elsif ($error->[0] eq 'type') {
      my $type = $error->[1][0];
      $self->log_error(qq(The argument "$name" expects a "$type"));
    }
    else {
      $self->log_error(qq(The argument "$name" is incorrect));
    }
    $errors++;
    last;
  }

  return $errors;
}

sub handle_errors_in_arguments {
  my ($self) = @_;

  my $errors = 0;

  for my $name ($self->argument_names) {
    $errors += $self->handle_errors_in_argument($name);
    last if $errors;
  }

  return $errors;
}

sub handle_errors_in_log_events {
  my ($self) = @_;

  my $errors = 0;

  my $events = $self->log_events;

  for my $event (@{$events}) {
    my ($level, $message) = @{$event};

    if ($level eq 'debug') {
      _stdout($message);
    }

    if ($level eq 'error') {
      _stderr($message); $errors++;
    }

    if ($level eq 'fatal') {
      _stderr($message); $errors++;
    }

    if ($level eq 'info') {
      _stdout($message);
    }

    if ($level eq 'trace') {
      _stdout($message);
    }

    if ($level eq 'warn') {
      _stderr($message); $errors++;
    }
  }

  return $errors;
}

sub handle_errors_in_option {
  my ($self, $name) = @_;

  my $errors = 0;

  for my $error ($self->option_errors($name)) {
    if ($error->[0] eq 'required') {
      $self->log_error(qq(The option "$name" is required));
    }
    elsif ($error->[0] eq 'type') {
      my $type = $error->[1][0];
      $self->log_error(qq(The option "$name" expects a "$type"));
    }
    else {
      $self->log_error(qq(The option "$name" is incorrect));
    }
    $errors++;
    last;
  }

  return $errors;
}

sub handle_errors_in_options {
  my ($self) = @_;

  my $errors = 0;

  for my $name ($self->option_names) {
    $errors += $self->handle_errors_in_option($name);
    last if $errors;
  }

  return $errors;
}

sub handle_help {
  my ($self) = @_;

  my $errors = 0;

  $self->help if $errors += $self->parsed->{help} ? 1 : 0;

  return $errors;
}

sub perform {
  my ($self) = @_;

  my $result = $self->dispatch;

  $self->help if !$result;

  return $self;
}

sub prepare {
  my ($self) = @_;

  my $spec_data = $self->spec_data;

  $self->option('help', {
    name => 'help',
    multiples => 0,
    required => 0,
    type => 'boolean',
    wants => 'boolean',
  });

  if ($spec_data && ref $spec_data eq 'HASH') {
    $self->spec($spec_data);
  }

  return $self;
}

sub spec_data {
  my ($self) = @_;

  return undef;
}

sub reorder {
  my ($self) = @_;

  my $option = $self->option('help');

  $option->{index} = $self->option_count + 1 if $option;

  $self->SUPER::reorder;

  return $self;
}

sub run {
  my ($self, $name) = @_;

  $name ||= $0;

  $self = $self->new(name => $name);

  $self->handle if !caller(1);

  return $self;
}

1;
