package Venus::Cli;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

use POSIX ();

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Printable';

# ATTRIBUTES

attr 'name';
attr 'version';
attr 'summary';
attr 'description';
attr 'header';
attr 'footer';
attr 'arguments';
attr 'options';
attr 'choices';
attr 'routes';
attr 'data';

# BUILDERS

sub build_arg {
  my ($self, $data) = @_;

  return {
    name => $data,
  };
}

sub build_data {
  my ($self, $data) = @_;

  $data->{data} ||= [];
  $data->{arguments} ||= {};
  $data->{options} ||= {};
  $data->{choices} ||= {};
  $data->{routes} ||= {};

  return $data;
}

sub build_self {
  my ($self, $data) = @_;

  my $arguments = $self->arguments;

  $self->argument($_, $arguments->{$_}) for keys %{$arguments};

  my $choices = $self->choices;

  $self->choice($_, $choices->{$_}) for keys %{$choices};

  my $options = $self->options;

  $self->option($_, $options->{$_}) for keys %{$options};

  my $routes = $self->routes;

  $self->route($_, $routes->{$_}) for keys %{$routes};

  $self->reorder;

  return $self;
}

# HOOKS

sub _exit {
  POSIX::_exit(shift);
}

sub _print {
  do {local $| = 1; CORE::print(@_, "\n")}
}

sub _prompt {
  do {local $\ = ''; local $_ = <STDIN>; chomp; $_}
}

# METHODS

sub args {
  my ($self) = @_;

  my $parsed_arguments = $self->parsed_arguments;

  $self->parse if !$parsed_arguments || !@{$parsed_arguments};

  $parsed_arguments = $self->parsed_arguments;

  require Venus::Args;

  return Venus::Args->new(value => $parsed_arguments);
}

sub argument {
  my ($self, $name, @data) = @_;

  return undef if !$name;

  return $self->arguments->{$name} if !@data;

  return delete $self->arguments->{$name} if !defined $data[0];

  my $defaults = {
    name => $name,
    label => undef,
    help => undef,
    default => undef,
    multiples => 0,
    prompt => undef,
    range => undef,
    required => false,
    type => 'string',
    index => int(keys(%{$self->arguments})),
    wants => undef,
  };

  require Venus;

  my $overrides = Venus::merge_take({}, @data);

  $overrides->{wants} //= $overrides->{type} || 'string' if !exists $overrides->{wants};

  my $data = Venus::merge_take($self->arguments->{$name} || $defaults, $overrides);

  $data->{help} ||= "Expects a $data->{type} value";

  return $self->arguments->{$data->{name} ? $data->{name} : $name} = $data;
}

sub argument_choice {
  my ($self, $name) = @_;

  my $output = [];

  return $output if !$name;

  my $choices = {map +($$_{name}, $_), $self->argument_choices($name)};

  for my $value ($self->argument_value($name)) {
    if (exists $choices->{$value}) {
      push @{$output}, $value;
    }
    else {
      $output = [];
      last;
    }
  }

  return wantarray ? @{$output} : $output;
}

sub argument_choices {
  my ($self, $name) = @_;

  my $output = [];

  $output = [grep +($$_{argument} eq $name), $self->choice_list] if $name;

  return wantarray ? @{$output} : $output;
}

sub argument_count {
  my ($self) = @_;

  return int(scalar(keys(%{$self->arguments})));
}

sub argument_default {
  my ($self, $name) = @_;

  return '' if !$name;

  my $argument = $self->argument($name);

  return '' if !defined $argument;

  my $default = $argument->{default};

  return $default;
}

sub argument_errors {
  my ($self, $name) = @_;

  return [] if !$name;

  my $result = $self->argument_validate($name);

  $result = [$result] if ref $result ne 'ARRAY';

  @{$result} = grep defined, map $_->issue, @{$result};

  return wantarray ? (@{$result}) : $result;
}

sub argument_help {
  my ($self, $name) = @_;

  return '' if !$name;

  my $argument = $self->argument($name);

  return '' if !$argument;

  my $help = $argument->{help};

  return $help;
}

sub argument_label {
  my ($self, $name) = @_;

  return '' if !$name;

  my $argument = $self->argument($name);

  return '' if !$argument;

  my $label = $argument->{label};

  return $label;
}

sub argument_list {
  my ($self) = @_;

  my $output = [];

  my $arguments = $self->arguments;

  $output = [map $arguments->{$_}, $self->argument_names];

  return wantarray ? @{$output} : $output;
}

sub argument_multiples {
  my ($self, $name) = @_;

  return false if !$name;

  my $argument = $self->argument($name);

  return false if !$argument;

  my $multiples = $argument->{multiples};

  return $multiples ? true : false;
}

sub argument_name {
  my ($self, $name) = @_;

  return '' if !$name;

  my $argument = $self->argument($name);

  return '' if !$argument;

  $name = $argument->{name};

  return $name;
}

sub argument_names {
  my ($self) = @_;

  my $arguments = $self->arguments;

  my @names = sort {
    (exists $arguments->{$a}->{index} ? $arguments->{$a}->{index} : $a)
      <=> (exists $arguments->{$b}->{index} ? $arguments->{$b}->{index} : $b)
  } keys %{$arguments};

  return wantarray ? (@names) : [@names];
}

sub argument_prompt {
  my ($self, $name) = @_;

  return '' if !$name;

  my $argument = $self->argument($name);

  return '' if !$argument;

  my $prompt = $argument->{prompt};

  return $prompt;
}

sub argument_range {
  my ($self, $name) = @_;

  return '' if !$name;

  my $argument = $self->argument($name);

  return '' if !$argument;

  my $range = $argument->{range};

  return $range;
}

sub argument_required {
  my ($self, $name) = @_;

  return false if !$name;

  my $argument = $self->argument($name);

  return false if !$argument;

  my $required = $argument->{required};

  return $required ? true : false;
}

sub argument_type {
  my ($self, $name) = @_;

  return '' if !$name;

  my $argument = $self->argument($name);

  return '' if !$argument;

  my $type = $argument->{type};

  return $type;
}

sub argument_validate {
  my ($self, $name) = @_;

  return [] if !$name;

  my $argument = $self->argument($name);

  return [] if !$argument;

  require Venus::Validate;

  my $validate = Venus::Validate->new(input => [$self->argument_value($name)]);

  my $required = $argument->{required} ? 'required' : 'optional';

  my $value = $validate->each($required);

  my $type = 'string';

  $type = 'boolean' if $argument->{type} eq 'boolean';
  $type = 'float' if $argument->{type} eq 'float';
  $type = 'number' if $argument->{type} eq 'number';
  $type = 'any' if $argument->{type} eq 'string';
  $type = 'yesno' if $argument->{type} eq 'yesno';

  for my $value (@{$value}) {
    next if $required eq 'optional' && !defined $value->input->[0];
    $value->type($type);
  }

  my $multiples = $argument->{multiples};

  return $multiples ? (wantarray ? (@{$value}) : $value) : $value->[0];
}

sub argument_value {
  my ($self, $name) = @_;

  return undef if !$name;

  my $argument = $self->argument($name);

  return undef if !$argument;

  my $parsed_arguments = $self->parsed_arguments;

  my $range = $argument->{range};

  require Venus::Array;

  my $value = Venus::Array->new($parsed_arguments)->range($range);

  @{$value} = (grep defined, @{$value});

  my $default = $argument->{default};

  $value = defined $default
    ? ref $default eq 'ARRAY'
      ? $default
      : [$default // ()]
    : [$self->argument_value_prompt($name) // ()] if !@{$value};

  my $type = 'string';

  $type = 'boolean' if $argument->{type} eq 'boolean';
  $type = 'float' if $argument->{type} eq 'float';
  $type = 'number' if $argument->{type} eq 'number';
  $type = 'string' if $argument->{type} eq 'string';
  $type = 'yesno' if $argument->{type} eq 'yesno';

  require Scalar::Util;

  if ($type eq 'number') {
    @{$value} = map +(Scalar::Util::looks_like_number($_) ? (0+$_) : $_), @{$value};
  }

  if ($type eq 'boolean') {
    @{$value} = map +(Scalar::Util::looks_like_number($_) ? !!$_ ? true : false
      : $_ =~ /true/i ? true : false), @{$value};
  }

  my $multiples = $argument->{multiples};

  return $multiples ? (wantarray ? (@{$value}) : $value) : $value->[0];
}

sub argument_value_prompt {
  my ($self, $name) = @_;

  return undef if !$name;

  my $argument = $self->argument($name);

  return undef if !$argument;

  my $prompt = $argument->{prompt};

  return undef if !$prompt;

  _print($prompt);

  my $captured = _prompt;

  return $captured eq '' ? undef : $captured;
}

sub argument_wants {
  my ($self, $name) = @_;

  return '' if !$name;

  my $argument = $self->argument($name);

  return '' if !$argument;

  my $wants = $argument->{wants};

  return $wants;
}

sub assigned_arguments {
  my ($self) = @_;

  my $values = {};

  for my $name ($self->argument_names) {
    $values->{$name} = $self->argument_value($name);
  }

  return $values;
}

sub assigned_options {
  my ($self) = @_;

  my $values = {};

  for my $name ($self->option_names) {
    $values->{$name} = $self->option_value($name);
  }

  return $values;
}

sub boolean {
  my ($self, $next, @args) = @_;

  my $data = {type => 'boolean'};

  $data = {%{pop(@args)}, %{$data}} if ref $args[$#args] eq 'HASH';

  return $data if !$next;

  return $self->$next(undef, $data) if !@args;

  push @args, $data;

  return $self->$next(@args);
}

sub choice {
  my ($self, $name, @data) = @_;

  return undef if !$name;

  return $self->choices->{$name} if !@data;

  return delete $self->choices->{$name} if !defined $data[0];

  my $defaults = {
    name => $name,
    label => undef,
    help => undef,
    argument => undef,
    index => int(keys(%{$self->choices})),
    wants => undef,
  };

  require Venus;

  my $overrides = Venus::merge_take({}, @data);

  $overrides->{wants} //= $overrides->{type} || 'string' if !exists $overrides->{wants};

  my $data = Venus::merge_take($self->choices->{$name} || $defaults, $overrides);

  my $link = $self->argument($data->{argument}) if $data->{argument};

  $data->{help} ||= "Expects a $link->{type} value" if $link;

  return $self->choices->{$name} = $data;
}

sub choice_argument {
  my ($self, $name) = @_;

  return '' if !$name;

  my $choice = $self->choice($name);

  return '' if !$choice;

  my $argument = $choice->{argument};

  return $self->argument($argument);
}

sub choice_count {
  my ($self) = @_;

  return int(scalar(keys(%{$self->choices})));
}

sub choice_default {
  my ($self, $name) = @_;

  return '' if !$name;

  my $choice = $self->choice($name);

  return '' if !$choice;

  my $argument = $choice->{argument};

  return $self->argument_default($argument);
}

sub choice_errors {
  my ($self, $name) = @_;

  return [] if !$name;

  my $choice = $self->choice($name);

  return [] if !$choice;

  my $argument = $choice->{argument};

  return $self->argument_errors($argument);
}

sub choice_help {
  my ($self, $name) = @_;

  return '' if !$name;

  my $choice = $self->choice($name);

  return '' if !$choice;

  my $help = $choice->{help};

  return $help;
}

sub choice_label {
  my ($self, $name) = @_;

  return '' if !$name;

  my $choice = $self->choice($name);

  return '' if !$choice;

  my $label = $choice->{label};

  return $label;
}

sub choice_list {
  my ($self) = @_;

  my $output = [];

  my $choices = $self->choices;

  $output = [map $choices->{$_}, $self->choice_names];

  return wantarray ? @{$output} : $output;
}

sub choice_multiples {
  my ($self, $name) = @_;

  return false if !$name;

  my $choice = $self->choice($name);

  return false if !$choice;

  my $argument = $choice->{argument};

  return $self->argument_multiples($argument);
}

sub choice_name {
  my ($self, $name) = @_;

  return '' if !$name;

  my $choice = $self->choice($name);

  return '' if !$choice;

  $name = $choice->{name};

  return $name;
}

sub choice_names {
  my ($self) = @_;

  my $choices = $self->choices;

  my @names = sort {
    (exists $choices->{$a}->{index} ? $choices->{$a}->{index} : $a)
      <=> (exists $choices->{$b}->{index} ? $choices->{$b}->{index} : $b)
  } keys %{$choices};

  return wantarray ? (@names) : [@names];
}

sub choice_prompt {
  my ($self, $name) = @_;

  return '' if !$name;

  my $choice = $self->choice($name);

  return '' if !$choice;

  my $argument = $choice->{argument};

  return $self->argument_prompt($argument);
}

sub choice_range {
  my ($self, $name) = @_;

  return '' if !$name;

  my $choice = $self->choice($name);

  return '' if !$choice;

  my $argument = $choice->{argument};

  return $self->argument_range($argument);
}

sub choice_required {
  my ($self, $name) = @_;

  return false if !$name;

  my $choice = $self->choice($name);

  return false if !$choice;

  my $argument = $choice->{argument};

  return $self->argument_required($argument);
}

sub choice_type {
  my ($self, $name) = @_;

  return '' if !$name;

  my $choice = $self->choice($name);

  return '' if !$choice;

  my $argument = $choice->{argument};

  return $self->argument_type($argument);
}

sub choice_validate {
  my ($self, $name) = @_;

  return [] if !$name;

  my $choice = $self->choice($name);

  return [] if !$choice;

  my $argument = $choice->{argument};

  return $self->argument_validate($argument);
}

sub choice_value {
  my ($self, $name) = @_;

  return undef if !$name;

  my $choice = $self->choice($name);

  return undef if !$choice;

  my $argument = $choice->{argument};

  return $self->argument_value($argument);
}

sub choice_wants {
  my ($self, $name) = @_;

  return '' if !$name;

  my $choice = $self->choice($name);

  return '' if !$choice;

  my $argument = $choice->{argument};

  return $self->argument_wants($argument);
}

sub command {
  my ($self, $argument_name, $choice_name, $handler) = @_;

  return undef if !$argument_name;
  return undef if !$choice_name;
  return undef if !$handler;

  require Venus;

  my $choice_parts = ref $choice_name eq 'ARRAY'
    ? $choice_name
    : [split /\s+/, $choice_name];

  my $route_name = join ' ', @{$choice_parts};

  my $range = ':' . ($#{$choice_parts});

  $self->argument($argument_name, {range => $range, multiples => $#{$choice_parts} > 0 ? 1 : 0})
    if !$self->argument($argument_name);

  $self->choice($route_name, {argument => $argument_name})
    if !$self->choice($route_name);

  $self->route($route_name, {
    argument => $argument_name,
    choice => $route_name,
    handler => $handler,
    range => $range,
  });

  return $self->route($route_name);
}

sub dispatch {
  my ($self, @args) = @_;

  $self->parse(@args) if @args;

  my $parsed_arguments = $self->parsed_arguments;

  return undef if !$parsed_arguments || !@{$parsed_arguments};

  my $matched_route = undef;
  my $matched_length = -1;

  for my $route ($self->route_list) {
    my $choice = $route->{choice};

    next if !$choice;

    my @choice_parts = split /\s+/, $choice;
    my $choice_length = scalar @choice_parts;

    next if $choice_length > scalar @{$parsed_arguments};

    my $matches = 1;

    for my $i (0..$#choice_parts) {
      if ($parsed_arguments->[$i] ne $choice_parts[$i]) {
        $matches = 0;
        last;
      }
    }

    if ($matches && $choice_length > $matched_length) {
      $matched_route = $route;
      $matched_length = $choice_length;
    }
  }

  return undef if !$matched_route;

  my $handler = $matched_route->{handler};

  return undef if !$handler;

  if (ref $handler ) {
    if (ref $handler eq 'CODE') {
      return $handler->($self, $self->assigned_arguments, $self->assigned_options);
    }
    else {
      return undef;
    }
  }

  require Venus::Space;

  my $space = Venus::Space->new($handler);

  if ($handler !~ /\W/ && $self->can($handler)) {
    return $self->$handler($self->assigned_arguments, $self->assigned_options);
  }

  if ($space->lookslike_a_package && $space->tryload) {
    my $remaining_args = [@{$parsed_arguments}[$matched_length..$#{$parsed_arguments}]];

    my $remaining_data = [grep {$_ ne '--'} @{$self->data}];

    splice @{$remaining_data}, 0, $matched_length
      if @{$remaining_data} >= $matched_length;

    my $instance = $space->package->new;

    if ($instance->isa('Venus::Task')) {
      return $instance->handle(@{$remaining_data});
    }
    elsif ($instance->isa('Venus::Cli')) {
      return $instance->dispatch(@{$remaining_data});
    }
    else {
      return $instance;
    }
  }

  return undef;
}

sub exit {
  my ($self, $code, $method, @args) = @_;

  $self->$method(@args) if $method;

  $code ||= 0;

  _exit($code);
}

sub fail {
  my ($self, $method, @args) = @_;

  return $self->exit(1, $method, @args);
}

sub float {
  my ($self, $next, @args) = @_;

  my $data = {type => 'float'};

  $data = {%{pop(@args)}, %{$data}} if ref $args[$#args] eq 'HASH';

  return $data if !$next;

  return $self->$next(undef, $data) if !@args;

  push @args, $data;

  return $self->$next(@args);
}

sub has_input {
  my ($self) = @_;

  return !$self->no_input ? true : false;
}

sub has_input_arguments {
  my ($self) = @_;

  return !$self->no_input_arguments ? true : false;
}

sub has_input_options {
  my ($self) = @_;

  return !$self->no_input_options ? true : false;
}

sub has_output {
  my ($self) = @_;

  return !$self->no_output ? true : false;
}

sub has_output_debug_events {
  my ($self) = @_;

  return !$self->no_output_debug_events ? true : false;
}

sub has_output_error_events {
  my ($self) = @_;

  return !$self->no_output_error_events ? true : false;
}

sub has_output_fatal_events {
  my ($self) = @_;

  return !$self->no_output_fatal_events ? true : false;
}

sub has_output_info_events {
  my ($self) = @_;

  return !$self->no_output_info_events ? true : false;
}

sub has_output_trace_events {
  my ($self) = @_;

  return !$self->no_output_trace_events ? true : false;
}

sub has_output_warn_events {
  my ($self) = @_;

  return !$self->no_output_warn_events ? true : false;
}

sub help {
  my ($self) = @_;

  $self->log_info($self->usage);

  return $self;
}

sub input {
  my ($self) = @_;

  my ($arguments, $options) = ({}, {});

  for my $name ($self->argument_names) {
    $arguments->{$self->arguments->{$name}->{name}} = $self->argument_value($name);
  }

  for my $name ($self->option_names) {
    $options->{$self->options->{$name}->{name}} = $self->option_value($name);
  }

  return wantarray ? ($arguments, $options) : $arguments;
}

sub input_arguments {
  my ($self) = @_;

  return $self->{input_arguments} if $self->{input_arguments} && keys %{$self->{input_arguments}};

  my ($arguments, $options) = $self->input;

  return $self->{input_arguments} = $arguments;
}

sub input_arguments_defined {
  my ($self) = @_;

  my $arguments = $self->input_arguments;

  %{$arguments} = (
    map +(
        ref $arguments->{$_} eq 'ARRAY'
      ? !@{$arguments->{$_}}
          ? ()
          : ($_, $arguments->{$_})
      : ($_, $arguments->{$_})
    ),
    grep defined $arguments->{$_},
    keys %{$arguments},
  );

  return $arguments;
}

sub input_arguments_defined_count {
  my ($self) = @_;

  my $arguments = $self->input_arguments_defined;

  return 0 + (keys %{$arguments});
}

sub input_arguments_defined_list {
  my ($self) = @_;

  my $arguments = $self->input_arguments_defined;

  my $keys = [keys %{$arguments}];

  return wantarray ? (@{$keys}) : $keys;
}

sub input_argument_count {
  my ($self) = @_;

  my $arguments = $self->input_arguments;

  return 0 + (keys %{$arguments});
}

sub input_argument_list {
  my ($self) = @_;

  my $arguments = $self->input_arguments;

  my $keys = [keys %{$arguments}];

  return wantarray ? (@{$keys}) : $keys;
}

sub input_options {
  my ($self) = @_;

  return $self->{input_options} if $self->{input_options} && keys %{$self->{input_options}};

  my ($arguments, $options) = $self->input;

  return $self->{input_options} ||= $options;
}

sub input_options_defined {
  my ($self) = @_;

  my $options = $self->input_options;

  %{$options} = (
    map +(
        ref $options->{$_} eq 'ARRAY'
      ? !@{$options->{$_}}
          ? ()
          : ($_, $options->{$_})
      : ($_, $options->{$_})
    ),
    grep defined $options->{$_},
    keys %{$options},
  );

  return $options;
}

sub input_options_defined_count {
  my ($self) = @_;

  my $options = $self->input_options_defined;

  return 0 + (keys %{$options});
}

sub input_options_defined_list {
  my ($self) = @_;

  my $options = $self->input_options_defined;

  my $keys = [keys %{$options}];

  return wantarray ? (@{$keys}) : $keys;
}

sub input_option_count {
  my ($self) = @_;

  my $options = $self->input_options;

  return 0 + (keys %{$options});
}

sub input_option_list {
  my ($self) = @_;

  my $options = $self->input_options;

  my $keys = [keys %{$options}];

  return wantarray ? (@{$keys}) : $keys;
}

sub lines {
  my ($self, $text, $length, $indent) = @_;

  require Venus::String;

  my $string = Venus::String->new($text);

  return scalar $string->wrap($length, $indent);
}

sub log {
  my ($self) = @_;

  require Venus::Log;

  my $log = Venus::Log->new(handler => $self->log_handler, level => $self->log_level);

  return $log;
}

sub log_debug {
  my ($self, @args) = @_;

  my $log = $self->log;

  return $log->debug(@args);
}

sub log_error {
  my ($self, @args) = @_;

  my $log = $self->log;

  return $log->error(@args);
}

sub log_events {
  my ($self) = @_;

  my $logs = $self->{logs} ||= [];

  return $logs;
}

sub log_fatal {
  my ($self, @args) = @_;

  my $log = $self->log;

  return $log->fatal(@args);
}

sub log_flush {
  my ($self, $code) = @_;

  for my $event (@{$self->log_events}) {
    local $_ = $event;

    $self->$code($event) if $code;
  }

  @{$self->log_events} = ();

  return $self;
}

sub log_handler {
  my ($self, @args) = @_;

  my $log_events = $self->log_events;

  my $handler = sub {
    push @{$log_events}, [@_];
  };

  return $handler;
}

sub log_info {
  my ($self, @args) = @_;

  my $log = $self->log;

  return $log->info(@args);
}

sub log_level {

  return 'trace';
}

sub log_trace {
  my ($self, @args) = @_;

  my $log = $self->log;

  return $log->trace(@args);
}

sub log_warn {
  my ($self, @args) = @_;

  my $log = $self->log;

  return $log->warn(@args);
}

sub multiple {
  my ($self, $next, @args) = @_;

  my $data = {multiples => true};

  $data = {%{pop(@args)}, %{$data}} if ref $args[$#args] eq 'HASH';

  return $data if !$next;

  return $self->$next(undef, $data) if !@args;

  push @args, $data;

  return $self->$next(@args);
}

sub no_input {
  my ($self) = @_;

  my @data = $self->parsed;

  return (keys %{$data[0]}) || (@{$data[1]}) ? false : true;
}

sub no_input_arguments {
  my ($self) = @_;

  my @data = $self->parsed;

  return @{$data[1]} ? false : true;
}

sub no_input_options {
  my ($self) = @_;

  my @data = $self->parsed;

  return keys %{$data[0]} ? false : true;
}

sub no_output {
  my ($self) = @_;

  my @data = $self->output;

  return @data ? false : true;
}

sub no_output_debug_events {
  my ($self) = @_;

  my @data = $self->output('debug');

  return @data ? false : true;
}

sub no_output_error_events {
  my ($self) = @_;

  my @data = $self->output('error');

  return @data ? false : true;
}

sub no_output_fatal_events {
  my ($self) = @_;

  my @data = $self->output('fatal');

  return @data ? false : true;
}

sub no_output_info_events {
  my ($self) = @_;

  my @data = $self->output('info');

  return @data ? false : true;
}

sub no_output_trace_events {
  my ($self) = @_;

  my @data = $self->output('trace');

  return @data ? false : true;
}

sub no_output_warn_events {
  my ($self) = @_;

  my @data = $self->output('warn');

  return @data ? false : true;
}

sub number {
  my ($self, $next, @args) = @_;

  my $data = {type => 'number'};

  $data = {%{pop(@args)}, %{$data}} if ref $args[$#args] eq 'HASH';

  return $data if !$next;

  return $self->$next(undef, $data) if !@args;

  push @args, $data;

  return $self->$next(@args);
}

sub okay {
  my ($self, $method, @args) = @_;

  return $self->exit(0, $method, @args);
}

sub option {
  my ($self, $name, @data) = @_;

  return undef if !$name;

  return $self->options->{$name} if !@data;

  return delete $self->options->{$name} if !defined $data[0];

  my $defaults = {
    name => $name,
    label => undef,
    help => undef,
    default => undef,
    aliases => undef,
    multiples => 0,
    prompt => undef,
    range => undef,
    required => false,
    type => 'string',
    index => int(keys(%{$self->options})),
    wants => undef,
  };

  require Venus;

  my $overrides = Venus::merge_take({}, @data);

  $overrides->{aliases} //= [Venus::list($overrides->{alias})] if exists $overrides->{alias};

  $overrides->{wants} //= $overrides->{type} || 'string' if !exists $overrides->{wants};

  my $data = Venus::merge_take($self->options->{$name} || $defaults, $overrides);

  $data->{aliases} = [$data->{aliases} // ()] if !ref $data->{aliases};

  $data->{help} ||= "Expects a $data->{type} value";

  return $self->options->{$data->{name} ? $data->{name} : $name} = $data;
}

sub option_aliases {
  my ($self, $name) = @_;

  return [] if !$name;

  my $option = $self->option($name);

  return [] if !$option;

  my $aliases = $option->{aliases};

  return $aliases;
}

sub option_count {
  my ($self) = @_;

  return int(scalar(keys(%{$self->options})));
}

sub option_default {
  my ($self, $name) = @_;

  return '' if !$name;

  my $option = $self->option($name);

  return '' if !$option;

  my $default = $option->{default};

  return $default;
}

sub option_errors {
  my ($self, $name) = @_;

  return [] if !$name;

  my $result = $self->option_validate($name);

  $result = [$result] if ref $result ne 'ARRAY';

  $result = [grep defined, map $_->issue, @{$result}];

  return wantarray ? (@{$result}) : $result;
}

sub option_help {
  my ($self, $name) = @_;

  return '' if !$name;

  my $option = $self->option($name);

  return '' if !$option;

  my $help = $option->{help};

  return $help;
}

sub option_label {
  my ($self, $name) = @_;

  return '' if !$name;

  my $option = $self->option($name);

  return '' if !$option;

  my $label = $option->{label};

  return $label;
}

sub option_list {
  my ($self) = @_;

  my $output = [];

  my $options = $self->options;

  $output = [map $options->{$_}, $self->option_names];

  return wantarray ? @{$output} : $output;
}

sub option_multiples {
  my ($self, $name) = @_;

  return false if !$name;

  my $option = $self->option($name);

  return false if !$option;

  my $multiples = $option->{multiples};

  return $multiples ? true : false;
}

sub option_name {
  my ($self, $name) = @_;

  return '' if !$name;

  my $option = $self->option($name);

  return '' if !$option;

  $name = $option->{name};

  return $name;
}

sub option_names {
  my ($self) = @_;

  my $options = $self->options;

  my @names = sort {
    (exists $options->{$a}->{index} ? $options->{$a}->{index} : $a)
      <=> (exists $options->{$b}->{index} ? $options->{$b}->{index} : $b)
  } keys %{$options};

  return wantarray ? (@names) : [@names];
}

sub option_prompt {
  my ($self, $name) = @_;

  return '' if !$name;

  my $option = $self->option($name);

  return '' if !$option;

  my $prompt = $option->{prompt};

  return $prompt;
}

sub option_range {
  my ($self, $name) = @_;

  return '' if !$name;

  my $option = $self->option($name);

  return '' if !$option;

  my $range = $option->{range};

  return $range;
}

sub option_required {
  my ($self, $name) = @_;

  return false if !$name;

  my $option = $self->option($name);

  return false if !$option;

  my $required = $option->{required};

  return $required ? true : false;
}

sub option_type {
  my ($self, $name) = @_;

  return '' if !$name;

  my $option = $self->option($name);

  return '' if !$option;

  my $type = $option->{type};

  return $type;
}

sub option_validate {
  my ($self, $name) = @_;

  return [] if !$name;

  my $option = $self->option($name);

  return [] if !$option;

  require Venus::Validate;

  my $validate = Venus::Validate->new(input => [$self->option_value($name)]);

  my $required = $option->{required} ? 'required' : 'optional';

  my $value = $validate->each($required);

  my $type = 'string';

  $type = 'boolean' if $option->{type} eq 'boolean';
  $type = 'float' if $option->{type} eq 'float';
  $type = 'number' if $option->{type} eq 'number';
  $type = 'any' if $option->{type} eq 'string';
  $type = 'yesno' if $option->{type} eq 'yesno';

  for my $value (@{$value}) {
    next if $required eq 'optional' && !defined $value->input->[0];
    $value->type($type);
  }

  my $multiples = $option->{multiples};

  return $multiples ? (wantarray ? (@{$value}) : $value) : $value->[0];
}

sub option_value {
  my ($self, $name) = @_;

  return undef if !$name;

  my $option = $self->option($name);

  return undef if !$option;

  my $parsed_options = $self->parsed_options;

  my $default = $option->{default};

  my $value = exists $parsed_options->{$name}
    ? ref $parsed_options->{$name} eq 'ARRAY'
      ? $parsed_options->{$name}
      : [$parsed_options->{$name} // ()]
    : $default ? ref $default eq 'ARRAY' ? $default
      : [$default // ()]
    : [$self->option_value_prompt($name) // ()];

  my $type = 'string';

  $type = 'boolean' if $option->{type} eq 'boolean';
  $type = 'float' if $option->{type} eq 'float';
  $type = 'number' if $option->{type} eq 'number';
  $type = 'string' if $option->{type} eq 'string';
  $type = 'yesno' if $option->{type} eq 'yesno';

  require Scalar::Util;

  if ($type eq 'number') {
    @{$value} = map +(Scalar::Util::looks_like_number($_) ? (0+$_) : $_), @{$value};
  }

  if ($type eq 'boolean') {
    @{$value} = map +(Scalar::Util::looks_like_number($_) ? !!$_ ? true : false
      : $_ =~ /true/i ? true : false), @{$value};
  }

  my $multiples = $option->{multiples};

  return $multiples ? (wantarray ? (@{$value}) : $value) : $value->[0];
}

sub option_value_prompt {
  my ($self, $name) = @_;

  return undef if !$name;

  my $option = $self->option($name);

  return undef if !$option;

  my $prompt = $option->{prompt};

  return undef if !$prompt;

  _print($prompt);

  my $captured = _prompt;

  return $captured eq '' ? undef : $captured;
}

sub option_wants {
  my ($self, $name) = @_;

  return '' if !$name;

  my $option = $self->option($name);

  return '' if !$option;

  my $wants = $option->{wants};

  return $wants;
}

sub optional {
  my ($self, $next, @args) = @_;

  my $data = {required => false};

  $data = {%{pop(@args)}, %{$data}} if ref $args[$#args] eq 'HASH';

  return $data if !$next;

  return $self->$next(undef, $data) if !@args;

  push @args, $data;

  return $self->$next(@args);
}

sub opts {
  my ($self) = @_;

  my $parsed_options = $self->parsed_options;

  $self->parse if !$parsed_options || !keys %{$parsed_options};

  $parsed_options = $self->parsed_options;

  require Venus::Opts;

  return Venus::Opts->new(value => [], parsed => $parsed_options);
}

sub output {
  my ($self, $level) = @_;

  my $output = [];

  my $log_events = $self->log_events;

  push @{$output}, map {$$_[1]} ($level ? (grep {$$_[0] eq $level} @{$log_events}) : (@{$log_events}));

  return wantarray ? (@{$output}) : (@{$output})[-1];
}

sub output_debug_events {
  my ($self) = @_;

  my $output = [$self->output('debug')];

  return wantarray ? (@{$output}) : $output;
}

sub output_error_events {
  my ($self) = @_;

  my $output = [$self->output('error')];

  return wantarray ? (@{$output}) : $output;
}

sub output_fatal_events {
  my ($self) = @_;

  my $output = [$self->output('fatal')];

  return wantarray ? (@{$output}) : $output;
}

sub output_info_events {
  my ($self) = @_;

  my $output = [$self->output('info')];

  return wantarray ? (@{$output}) : $output;
}

sub output_trace_events {
  my ($self) = @_;

  my $output = [$self->output('trace')];

  return wantarray ? (@{$output}) : $output;
}

sub output_warn_events {
  my ($self) = @_;

  my $output = [$self->output('warn')];

  return wantarray ? (@{$output}) : $output;
}

sub parse {
  my ($self, @args) = @_;

  require Venus;
  require Getopt::Long;
  require Text::ParseWords;

  my $data = [@args ? @args : @ARGV];

  $self->data($data);

  my $arguments = [map $_, @{$data}];

  Getopt::Long::Configure(qw(default bundling no_auto_abbrev no_ignore_case));

  local $SIG{__WARN__} = sub {};

  my $options = {};

  my $returned = Getopt::Long::GetOptionsFromArray($arguments, $options, $self->parse_specification);

  $self->parsed_arguments($arguments);
  $self->parsed_options($options);

  return $self;
}

sub parse_specification {
  my ($self) = @_;

  my $spec = [];

  for my $option ($self->option_list) {
    my $spec_string = $option->{name};

    if ($option->{aliases}) {
      $spec_string = join '|', $spec_string, @{$option->{aliases}};
    }

    my $type
      = $option->{type} eq 'boolean' ? ''
      : $option->{type} eq 'float' ? 'f'
      : $option->{type} eq 'number' ? 'i'
      : $option->{type} eq 'yesno' ? 's'
      : $option->{type} eq 'string' ? 's'
      : '';

    $spec_string .= $type ? "=$type" : '';

    $spec_string .= $option->{multiples} ? '@' : '';

    push @{$spec}, $spec_string;
  }

  return wantarray ? (@{$spec}) : $spec;
}

sub parsed {
  my ($self) = @_;

  return wantarray ? ($self->parsed_options, $self->parsed_arguments) : $self->parsed_options;
}

sub parsed_arguments {
  my ($self, @args) = @_;

  $self->{parsed_arguments} = $args[0] if @args;

  $self->parse if !$self->{parsed_arguments};

  return $self->{parsed_arguments};
}

sub parsed_options {
  my ($self, @args) = @_;

  $self->{parsed_options} = $args[0] if @args;

  $self->parse if !$self->{parsed_options};

  return $self->{parsed_options};
}

sub pass {
  my ($self, $method, @args) = @_;

  return $self->exit(0, $method, @args);
}

sub reorder {
  my ($self) = @_;

  $self->reorder_arguments;
  $self->reorder_choices;
  $self->reorder_options;
  $self->reorder_routes;

  return $self;
}

sub reorder_arguments {
  my ($self) = @_;

  my $arguments = $self->arguments;

  my $index = 0;

  $self->argument($_, {%{$arguments->{$_}}, index => $index++}) for $self->argument_names;

  return $self;
}

sub reorder_choices {
  my ($self) = @_;

  my $choices = $self->choices;

  my $index = 0;

  $self->choice($_, {%{$choices->{$_}}, index => $index++}) for $self->choice_names;

  return $self;
}

sub reorder_options {
  my ($self) = @_;

  my $options = $self->options;

  my $index = 0;

  $self->option($_, {%{$options->{$_}}, index => $index++}) for $self->option_names;

  return $self;
}

sub reorder_routes {
  my ($self) = @_;

  my $routes = $self->routes;

  my $index = 0;

  $self->route($_, {%{$routes->{$_}}, index => $index++}) for $self->route_names;

  return $self;
}

sub route {
  my ($self, $name, @data) = @_;

  return undef if !$name;

  return $self->routes->{$name} if !@data;

  return delete $self->routes->{$name} if !defined $data[0];

  my $defaults = {
    name => $name,
    label => undef,
    help => undef,
    argument => undef,
    choice => undef,
    handler => undef,
    range => undef,
    index => int(keys(%{$self->routes})),
  };

  require Venus;

  my $overrides = Venus::merge_take({}, @data);

  my $data = Venus::merge_take($self->routes->{$name} || $defaults, $overrides);

  return $self->routes->{$name} = $data;
}

sub route_argument {
  my ($self, $name) = @_;

  return '' if !$name;

  my $route = $self->route($name);

  return '' if !$route;

  my $argument = $route->{argument};

  return $self->argument($argument);
}

sub route_choice {
  my ($self, $name) = @_;

  return '' if !$name;

  my $route = $self->route($name);

  return '' if !$route;

  my $choice = $route->{choice};

  return $self->choice($choice);
}

sub route_count {
  my ($self) = @_;

  return int(scalar(keys(%{$self->routes})));
}

sub route_handler {
  my ($self, $name) = @_;

  return undef if !$name;

  my $route = $self->route($name);

  return undef if !$route;

  my $handler = $route->{handler};

  return $handler;
}

sub route_help {
  my ($self, $name) = @_;

  return '' if !$name;

  my $route = $self->route($name);

  return '' if !$route;

  my $help = $route->{help};

  return $help;
}

sub route_label {
  my ($self, $name) = @_;

  return '' if !$name;

  my $route = $self->route($name);

  return '' if !$route;

  my $label = $route->{label};

  return $label;
}

sub route_list {
  my ($self) = @_;

  my $output = [];

  my $routes = $self->routes;

  $output = [map $routes->{$_}, $self->route_names];

  return wantarray ? @{$output} : $output;
}

sub route_name {
  my ($self, $name) = @_;

  return '' if !$name;

  my $route = $self->route($name);

  return '' if !$route;

  $name = $route->{name};

  return $name;
}

sub route_names {
  my ($self) = @_;

  my $routes = $self->routes;

  my @names = sort {
    (exists $routes->{$a}->{index} ? $routes->{$a}->{index} : $a)
      <=> (exists $routes->{$b}->{index} ? $routes->{$b}->{index} : $b)
  } keys %{$routes};

  return wantarray ? (@names) : [@names];
}

sub route_range {
  my ($self, $name) = @_;

  return '' if !$name;

  my $route = $self->route($name);

  return '' if !$route;

  my $range = $route->{range};

  return $range;
}

sub required {
  my ($self, $next, @args) = @_;

  my $data = {required => true};

  $data = {%{pop(@args)}, %{$data}} if ref $args[$#args] eq 'HASH';

  return $data if !$next;

  return $self->$next(undef, $data) if !@args;

  push @args, $data;

  return $self->$next(@args);
}

sub reset {
  my ($self) = @_;

  $self->data([]);
  $self->arguments({});
  $self->options({});
  $self->choices({});
  $self->routes({});
  $self->parsed_arguments([]);
  $self->parsed_options({});

  $self->{logs} = [];

  delete $self->{input_arguments};
  delete $self->{input_options};

  return $self;
}

sub single {
  my ($self, $next, @args) = @_;

  my $data = {multiples => false};

  $data = {%{pop(@args)}, %{$data}} if ref $args[$#args] eq 'HASH';

  return $data if !$next;

  return $self->$next(undef, $data) if !@args;

  push @args, $data;

  return $self->$next(@args);
}

sub spec {
  my ($self, $data) = @_;

  return $self if !$data || ref $data ne 'HASH';

  $self->name($data->{name}) if exists $data->{name};
  $self->version($data->{version}) if exists $data->{version};
  $self->summary($data->{summary}) if exists $data->{summary};
  $self->description($data->{description}) if exists $data->{description};
  $self->header($data->{header}) if exists $data->{header};
  $self->footer($data->{footer}) if exists $data->{footer};

  if ($data->{arguments} && ref $data->{arguments} eq 'ARRAY') {
    for my $item (@{$data->{arguments}}) {
      next if !$item || ref $item ne 'HASH';
      my $name = $item->{name};
      next if !$name;
      $self->argument($name, $item);
    }
  }

  if ($data->{options} && ref $data->{options} eq 'ARRAY') {
    for my $item (@{$data->{options}}) {
      next if !$item || ref $item ne 'HASH';
      my $name = $item->{name};
      next if !$name;
      $self->option($name, $item);
    }
  }

  if ($data->{choices} && ref $data->{choices} eq 'ARRAY') {
    for my $item (@{$data->{choices}}) {
      next if !$item || ref $item ne 'HASH';
      my $name = $item->{name};
      next if !$name;
      $self->choice($name, $item);
    }
  }

  if ($data->{routes} && ref $data->{routes} eq 'ARRAY') {
    for my $item (@{$data->{routes}}) {
      next if !$item || ref $item ne 'HASH';
      my $name = $item->{name};
      next if !$name;
      $self->route($name, $item);
    }
  }

  if ($data->{commands} && ref $data->{commands} eq 'ARRAY') {
    for my $item (@{$data->{commands}}) {
      next if !$item || ref $item ne 'ARRAY';
      my @parts = @{$item};
      next if @parts < 3;
      my $argument = shift @parts;
      my $handler = pop @parts;
      my $choice = [map {split /\s+/} map {ref $_ ? @{$_} : $_} @parts];
      $self->command($argument, $choice, $handler);
    }
  }

  $self->reorder;

  return $self;
}

sub string {
  my ($self, $next, @args) = @_;

  my $data = {type => 'string'};

  $data = {%{pop(@args)}, %{$data}} if ref $args[$#args] eq 'HASH';

  return $data if !$next;

  return $self->$next(undef, $data) if !@args;

  push @args, $data;

  return $self->$next(@args);
}

sub usage {
  my ($self) = @_;

  my @value;

  my @output;

  @value = grep length, $self->usage_gist;

  push @output, join " ", @value if @value;

  @value = grep length, $self->usage_line;

  push @output, join " ", @value if @value;

  @value = grep length, $self->usage_description;

  push @output, $self->lines(join " ", @value) if @value;

  @value = grep length, $self->usage_header;

  push @output, $self->lines(join " ", @value) if @value;

  @value = grep length, $self->usage_arguments;

  push @output, join " ", @value if @value;

  @value = grep length, $self->usage_options;

  push @output, join " ", @value if @value;

  @value = grep length, $self->usage_choices;

  push @output, join " ", @value if @value;

  @value = grep length, $self->usage_footer;

  push @output, $self->lines(join " ", @value) if @value;

  return join "\n\n", @output;
}

sub usage_argument_default {
  my ($self, $name) = @_;

  my $output = '';

  my $default = $self->argument_default($name);

  return $output if !defined $default || !length $default;

  $output = 'Default: ' . join ', ',
    ref $default ? @{$default} : $default;

  return $output;
}

sub usage_argument_help {
  my ($self, $name) = @_;

  my $output = '';

  my $help = $self->argument_help($name);

  return $output if !$help;

  return $help;
}

sub usage_argument_label {
  my ($self, $name) = @_;

  my $output = '';

  my $arg = $self->argument($name);

  return $output if !$arg;

  return $arg->{label} if $arg->{label};

  if ($arg->{required}) {
    if ($arg->{multiples}) {
      $output = "<$arg->{name}> ...";
    }
    else {
      $output = "<$arg->{name}>";
    }
  }
  else {
    if ($arg->{multiples}) {
      $output = "[<$arg->{name}> ...]";
    }
    else {
      $output = "[<$arg->{name}>]";
    }
  }

  return $output;
}

sub usage_argument_required {
  my ($self, $name) = @_;

  my $required = $self->argument_required($name);

  return $required ? '(required)' : '(optional)';
}

sub usage_argument_token {
  my ($self, $name) = @_;

  my $output = '';

  my $arg = $self->argument($name);

  return $output if !$arg;

  if ($arg->{required}) {
    if ($arg->{multiples}) {
      $output = "<$arg->{name}> ...";
    }
    else {
      $output = "<$arg->{name}>";
    }
  }
  else {
    if ($arg->{multiples}) {
      $output = "[<$arg->{name}> ...]";
    }
    else {
      $output = "[<$arg->{name}>]";
    }
  }

  return $output;
}

sub usage_arguments {
  my ($self) = @_;

  my @value;

  if ($self->argument_count > 0) {
    push @value, "Arguments:";
    for my $name ($self->argument_names) {
      push @value, grep length,
        $self->lines($self->usage_argument_label($name), 80, 2);
      push @value, grep length,
        $self->lines($self->usage_argument_help($name), 80, 4);
      push @value, grep length,
        $self->lines($self->usage_argument_required($name), 80, 4);
      push @value, grep length,
        $self->lines($self->usage_argument_default($name), 80, 4);
    }
  }

  return join "\n", @value;
}

sub usage_choice_help {
  my ($self, $name) = @_;

  return $self->choice_help($name);
}

sub usage_choice_label {
  my ($self, $name) = @_;

  my $cmd = $self->choice($name);

  return '' if !$cmd;

  return $cmd->{label} || $cmd->{name} || '';
}

sub usage_choice_required {
  my ($self, $name) = @_;

  my $output = '';

  my $cmd = $self->choice($name);

  return $output if !$cmd;

  return $self->usage_argument_label($cmd->{argument});
}

sub usage_choices {
  my ($self) = @_;

  my @value;

  if ($self->choice_count > 0) {
    my %cmd_groups;
    for my $name ($self->choice_names) {
      push @{$cmd_groups{$self->choice($name)->{argument}}}, $name;
    }
    for my $group (grep $cmd_groups{$_}, $self->argument_names) {
      my @group = "Choices for " . ($self->usage_argument_label($group)) . ":";
      for my $name (@{$cmd_groups{$group}}) {
        push @group, grep length,
          $self->lines($self->usage_choice_label($name), 80, 2);
        push @group, grep length,
          $self->lines($self->usage_choice_help($name), 80, 4);
        push @group, grep length,
          $self->lines($self->usage_choice_required($name), 80, 4);
      }
      push @value, join "\n", @group;
    }
  }

  return join "\n\n", @value;
}

sub usage_description {
  my ($self) = @_;

  my $description = $self->description // '';

  return $description;
}

sub usage_footer {
  my ($self) = @_;

  my $footer = $self->footer // '';

  return $footer;
}

sub usage_gist {
  my ($self) = @_;

  my $name = $self->usage_name;

  my $version = $self->usage_version;

  my $summary = $self->usage_summary;

  return '' if !$name;

  return "$name - $summary" if $summary && !$version;

  return "$name version $version" if !$summary && $version;

  return "$name version $version - $summary" if $summary && $version;

  return '';
}

sub usage_header {
  my ($self) = @_;

  my $header = $self->header // '';

  return $header;
}

sub usage_line {
  my ($self) = @_;

  my @lines;

  my $width = 80;

  my @name = $self->usage_name;

  return '' if !@name;

  my $line = my $usage = join ' ', 'Usage:', @name;

  my $indent = length($usage) + 1;

  for my $name ($self->argument_names) {
    my $part = $self->usage_argument_token($name);
    if (length($line) + length($part) + 1 > $width) {
      push @lines, $line;
      $line = (" " x $indent) . $part;
    }
    else {
      $line .= " $part";
    }
  }

  for my $name ($self->option_names) {
    my $part = $self->usage_option_token($name);
    if (length($line) + length($part) + 1 > $width) {
      push @lines, $line;
      $line = (" " x $indent) . $part;
    }
    else {
      $line .= " $part";
    }
  }

  return join "\n", @lines, $line;
}

sub usage_name {
  my ($self) = @_;

  my $name = $self->name // '';

  return $name;
}

sub usage_option_default {
  my ($self, $name) = @_;

  my $output = '';

  my $default = $self->option_default($name);

  return $output if !defined $default || !length $default;

  $output = 'Default: ' . join ', ',
    ref $default ? @{$default} : $default;

  return $output;
}

sub usage_option_help {
  my ($self, $name) = @_;

  return $self->option_help($name);
}

sub usage_option_label {
  my ($self, $name) = @_;

  my $output = '';

  my $opt = $self->option($name);

  return $output if !$opt;

  return $opt->{label} if $opt->{label};

  $output = join ', ', map length($_) > 1 ? "--$_" : "-$_", grep length,
    ref $opt->{aliases} ? @{$opt->{aliases}} : $opt->{aliases};

  if ($opt->{required}) {
    if ($opt->{multiples}) {
      if ($opt->{wants} && ($opt->{wants} ne 'boolean')) {
        $output = join ', ', ($output ? $output : ()), "--$opt->{name}=<$opt->{wants}> ...";
      }
      else {
        $output = join ', ', ($output ? $output : ()), "--$opt->{name} ...";
      }
    }
    else {
      if ($opt->{wants} && ($opt->{wants} ne 'boolean')) {
        $output = join ', ', ($output ? $output : ()), "--$opt->{name}=<$opt->{wants}>";
      }
      else {
        $output = join ', ', ($output ? $output : ()), "--$opt->{name}";
      }
    }
  }
  else {
    if ($opt->{multiples}) {
      if ($opt->{wants} && ($opt->{wants} ne 'boolean')) {
        $output = sprintf '[%s]',
          join ', ', ($output ? $output : ()), "--$opt->{name}=<$opt->{wants}> ...";
      }
      else {
        $output = sprintf '[%s]',
          join ', ', ($output ? $output : ()), "--$opt->{name} ...";
      }
    }
    else {
      if ($opt->{wants} && ($opt->{wants} ne 'boolean')) {
        $output = sprintf '[%s]',
          join ', ', ($output ? $output : ()), "--$opt->{name}=<$opt->{wants}>";
      }
      else {
        $output = sprintf '[%s]',
          join ', ', ($output ? $output : ()), "--$opt->{name}";
      }
    }
  }

  return $output;
}

sub usage_option_required {
  my ($self, $name) = @_;

  my $required = $self->option_required($name);

  return $required ? '(required)' : '(optional)';
}

sub usage_option_token {
  my ($self, $name) = @_;

  my $output = '';

  my $opt = $self->option($name);

  return $output if !$opt;

  if ($opt->{required}) {
    if ($opt->{multiples}) {
      $output = "--$opt->{name} ...";
    }
    else {
      $output = "--$opt->{name}";
    }
  }
  else {
    if ($opt->{multiples}) {
      $output = "[--$opt->{name} ...]";
    }
    else {
      $output = "[--$opt->{name}]";
    }
  }

  return $output;
}

sub usage_options {
  my ($self) = @_;

  my @value;

  if ($self->option_count > 0) {
    push @value, "Options:";
    for my $name ($self->option_names) {
      push @value, grep length,
        $self->lines($self->usage_option_label($name), 80, 2);
      push @value, grep length,
        $self->lines($self->usage_option_help($name), 80, 4);
      push @value, grep length,
        $self->lines($self->usage_option_required($name), 80, 4);
      push @value, grep length,
        $self->lines($self->usage_option_default($name), 80, 4);
    }
  }

  return join "\n", @value;
}

sub usage_summary {
  my ($self) = @_;

  my $summary = $self->summary;

  return $summary;
}

sub usage_version {
  my ($self) = @_;

  my $version = $self->version;

  return $version;
}

sub vars {
  my ($self) = @_;

  require Venus::Vars;

  return Venus::Vars->new;
}

sub yesno {
  my ($self, $next, @args) = @_;

  my $data = {type => 'yesno'};

  $data = {%{pop(@args)}, %{$data}} if ref $args[$#args] eq 'HASH';

  return $data if !$next;

  return $self->$next(undef, $data) if !@args;

  push @args, $data;

  return $self->$next(@args);
}

1;
