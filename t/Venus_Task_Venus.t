package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;
use Venus::Space;
use Venus;

my $test = test(__FILE__);

=name

Venus::Task::Venus

=cut

$test->for('name');

=tagline

vns

=cut

$test->for('tagline');

=abstract

Task Class for Venus CLI

=cut

$test->for('abstract');

=includes

method: new
method: perform

=cut

=synopsis

  package main;

  use Venus::Task::Venus;

  my $task = Venus::Task::Venus->new;

  # bless({...}, 'Venus::Task::Venus')

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Task::Venus');

  $result
});

=description

This package is the task class for the C<vns> CLI.

=cut

$test->for('description');

=inherits

Venus::Task

=cut

$test->for('inherits');

=method new

The new method constructs an instance of the package.

=signature new

  new(any @args) (Venus::Task::Venus)

=metadata new

{
  since => '4.15',
}

=cut

=example-1 new

  package main;

  use Venus::Task::Venus;

  my $task = Venus::Task::Venus->new;

  # bless({...}, 'Venus::Task::Venus')

=cut

$test->for('example', 1, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Task::Venus');
  ok $result->isa('Venus::Task');

  $result
});

=method perform

The perform method executes the CLI logic.

=signature perform

  perform() (Venus::Task::Venus)

=metadata perform

{
  since => '4.15',
}

=example-1 perform

  # given: synopsis

  package main;

  $task->prepare;

  $task->parse('');

  my $perform = $task->perform;

  # bless({...}, 'Venus::Task::Venus')

  # ''

=cut

$test->for('example', 1, 'perform', sub {
  my ($tryable) = @_;
  my $handled = [];
  my $patched = Venus::Space->new('Venus::Task::Venus')->patch('handle_command', sub {
    my ($code, $task, @args) = @_; $handled = [@args];
  });
  my $result = $tryable->result;
  ok $result->isa('Venus::Task::Venus');
  ok !$result->has_output_error_events;
  my $error = $result->output_error_events;
  is_deeply $error, [];
  is_deeply $handled, ['vns-run', ''];
  $patched->unpatch;

  $result
});

=example-2 perform

  # given: synopsis

  package main;

  $task->prepare;

  $task->parse('die');

  my $perform = $task->perform;

  # bless({...}, 'Venus::Task::Venus')

  # ''

=cut

$test->for('example', 2, 'perform', sub {
  my ($tryable) = @_;
  my $handled = [];
  my $patched = Venus::Space->new('Venus::Task::Venus')->patch('handle_command', sub {
    my ($code, $task, @args) = @_; $handled = [@args];
  });
  my $result = $tryable->result;
  ok $result->isa('Venus::Task::Venus');
  ok !$result->has_output_error_events;
  my $error = $result->output_error_events;
  is_deeply $error, [];
  is_deeply $handled, ['vns-run', 'die'];
  $patched->unpatch;

  $result
});

=example-3 perform

  # given: synopsis

  package main;

  $task->prepare;

  $task->parse('gen', '--stdout', '--class');

  my $perform = $task->perform;

  # bless({...}, 'Venus::Task::Venus')

  # '...'

=cut

$test->for('example', 3, 'perform', sub {
  my ($tryable) = @_;
  my $handled = [];
  my $patched = Venus::Space->new('Venus::Task::Venus')->patch('handle_command', sub {
    my ($code, $task, @args) = @_; $handled = [@args];
  });
  my $result = $tryable->result;
  ok $result->isa('Venus::Task::Venus');
  ok !$result->has_output_error_events;
  my $error = $result->output_error_events;
  is_deeply $error, [];
  is_deeply $handled, ['vns-gen', '--stdout', '--class'];
  $patched->unpatch;

  $result
});

=example-4 perform

  # given: synopsis

  package main;

  $task->prepare;

  $task->parse('get', 'perl.repl');

  my $perform = $task->perform;

  # bless({...}, 'Venus::Task::Venus')

  # '...'

=cut

$test->for('example', 4, 'perform', sub {
  my ($tryable) = @_;
  my $handled = [];
  my $patched = Venus::Space->new('Venus::Task::Venus')->patch('handle_command', sub {
    my ($code, $task, @args) = @_; $handled = [@args];
  });
  my $result = $tryable->result;
  ok $result->isa('Venus::Task::Venus');
  ok !$result->has_output_error_events;
  my $error = $result->output_error_events;
  is_deeply $error, [];
  is_deeply $handled, ['vns-get', 'perl.repl'];
  $patched->unpatch;

  $result
});

=example-5 perform

  # given: synopsis

  package main;

  $task->prepare;

  $task->parse('new', 'yaml');

  my $perform = $task->perform;

  # bless({...}, 'Venus::Task::Venus')

  # '...'

=cut

$test->for('example', 5, 'perform', sub {
  my ($tryable) = @_;
  my $handled = [];
  my $patched = Venus::Space->new('Venus::Task::Venus')->patch('handle_command', sub {
    my ($code, $task, @args) = @_; $handled = [@args];
  });
  my $result = $tryable->result;
  ok $result->isa('Venus::Task::Venus');
  ok !$result->has_output_error_events;
  my $error = $result->output_error_events;
  is_deeply $error, [];
  is_deeply $handled, ['vns-new', 'yaml'];
  $patched->unpatch;

  $result
});

=example-6 perform

  # given: synopsis

  package main;

  $task->prepare;

  $task->parse('run', 'okay', 't/Venus.t');

  my $perform = $task->perform;

  # bless({...}, 'Venus::Task::Venus')

  # '...'

=cut

$test->for('example', 6, 'perform', sub {
  my ($tryable) = @_;
  my $handled = [];
  my $patched = Venus::Space->new('Venus::Task::Venus')->patch('handle_command', sub {
    my ($code, $task, @args) = @_; $handled = [@args];
  });
  my $result = $tryable->result;
  ok $result->isa('Venus::Task::Venus');
  ok !$result->has_output_error_events;
  my $error = $result->output_error_events;
  is_deeply $error, [];
  is_deeply $handled, ['vns-run', 'okay', 't/Venus.t'];
  $patched->unpatch;

  $result
});

=example-7 perform

  # given: synopsis

  package main;

  $task->prepare;

  $task->parse('set', 'perl.repl', '$PERL -dE0');

  my $perform = $task->perform;

  # bless({...}, 'Venus::Task::Venus')

  # '...'

=cut

$test->for('example', 7, 'perform', sub {
  my ($tryable) = @_;
  my $handled = [];
  my $patched = Venus::Space->new('Venus::Task::Venus')->patch('handle_command', sub {
    my ($code, $task, @args) = @_; $handled = [@args];
  });
  my $result = $tryable->result;
  ok $result->isa('Venus::Task::Venus');
  ok !$result->has_output_error_events;
  my $error = $result->output_error_events;
  is_deeply $error, [];
  is_deeply $handled, ['vns-set', 'perl.repl', '$PERL -dE0'];
  $patched->unpatch;

  $result
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

$test->render('lib/Venus/Task/Venus.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;