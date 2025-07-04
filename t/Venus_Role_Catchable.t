package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;
use Venus;

my $test = test(__FILE__);

=name

Venus::Role::Catchable

=cut

$test->for('name');

=tagline

Catchable Role

=cut

$test->for('tagline');

=abstract

Catchable Role for Perl 5

=cut

$test->for('abstract');

=includes

method: catch
method: caught
method: maybe

=cut

$test->for('includes');

=synopsis

  package Example;

  use Venus::Class;

  use Venus 'error';

  with 'Venus::Role::Tryable';
  with 'Venus::Role::Catchable';

  sub pass {
    true;
  }

  sub fail {
    error;
  }

  package main;

  my $example = Example->new;

  # my $error = $example->catch('fail');

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Example');
  ok $result->does('Venus::Role::Catchable');

  $result
});

=description

This package modifies the consuming package and provides methods for trapping
errors thrown from dispatched method calls.

=cut

$test->for('description');

=method catch

The catch method traps any errors raised by executing the dispatched method
call and returns the error string or error object. This method can return a
list of values in list-context. This method supports dispatching, i.e.
providing a method name and arguments whose return value will be acted on by
this method.

=signature catch

  catch(string $method, any @args) (any)

=metadata catch

{
  since => '0.01',
}

=example-1 catch

  package main;

  my $example = Example->new;

  my $catch = $example->catch('fail');

  # bless({...}, "Venus::Error")

=cut

$test->for('example', 1, 'catch', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Error');

  $result
});

=example-2 catch

  package main;

  my $example = Example->new;

  my $catch = $example->catch('pass');

  # undef

=cut

$test->for('example', 2, 'catch', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok !defined $result;

  !$result
});

=example-3 catch

  package main;

  my $example = Example->new;

  my ($catch, $result) = $example->catch('pass');

  # (undef, 1)

=cut

$test->for('example', 3, 'catch', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  ok !defined $result[0];
  ok $result[1] == 1;

  @result
});

=example-4 catch

  package main;

  my $example = Example->new;

  my ($catch, $result) = $example->catch('fail');

  # (bless({...}, "Venus::Error"), undef)

=cut

$test->for('example', 4, 'catch', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  ok $result[0]->isa('Venus::Error');
  ok !defined $result[1];

  @result
});

=method caught

The caught method evaluates the value provided and validates its identity and
name (if provided) then executes the code block (if provided) returning the
result of the callback. If no callback is provided this function returns the
exception object on success and C<undef> on failure.

=signature caught

  caught(object $error, string | tuple[string, string] $identity, coderef $block) (any)

=metadata caught

{
  since => '4.15',
}

=example-1 caught

  package main;

  my $example = Example->new;

  my $catch = $example->catch('fail');

  my $result = $example->caught($catch);

  # bless(..., 'Venus::Error')

=cut

$test->for('example', 1, 'caught', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Error');
  ok !$result->name;

  $result
});

=example-2 caught

  package main;

  my $example = Example->new;

  my $catch = $example->catch('fail');

  my $result = $example->caught($catch, 'Venus::Error');

  # bless(..., 'Venus::Error')

=cut

$test->for('example', 2, 'caught', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Error');
  ok !$result->name;

  $result
});

=example-3 caught

  package main;

  my $example = Example->new;

  my $catch = $example->catch('fail');

  my $result = $example->caught($catch, 'Venus::Error', sub{
    $example->{caught} = $_;
  });

  ($example, $result)

  # (bless(..., 'Example'), bless(..., 'Venus::Error'))

=cut

$test->for('example', 3, 'caught', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  ok $result[0]->isa('Example');
  ok exists $result[0]->{caught};
  ok $result[1]->isa('Venus::Error');
  ok !$result[1]->name;

  @result
});

=example-4 caught

  package main;

  my $example = Example->new;

  my $catch = $example->catch('fail');

  $catch->name('on.issue');

  my $result = $example->caught($catch, ['Venus::Error', 'on.issue']);

  # bless(..., 'Venus::Error')

=cut

$test->for('example', 4, 'caught', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Error');
  is $result->name, 'on.issue';

  $result
});

=example-5 caught

  package main;

  my $example = Example->new;

  my $catch = $example->catch('fail');

  $catch->name('on.issue');

  my $result = $example->caught($catch, ['Venus::Error', 'on.issue'], sub{
    $example->{caught} = $_;
  });

  ($example, $result)

  # (bless(..., 'Example'), bless(..., 'Venus::Error'))

=cut

$test->for('example', 5, 'caught', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  ok $result[0]->isa('Example');
  ok exists $result[0]->{caught};
  ok $result[1]->isa('Venus::Error');
  is $result[1]->name, 'on.issue';

  @result
});

=example-6 caught

  package main;

  my $example = Example->new;

  my $catch = $example->catch('fail');

  my $result = $example->caught($catch, ['Venus::Error', 'on.issue']);

  # undef

=cut

$test->for('example', 6, 'caught', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok !defined $result;

  !$result
});

=example-6 caught

  package main;

  my $example = Example->new;

  my $catch = $example->catch('fail');

  my $result = $example->caught($catch, 'Venus::Error');

  # undef

=cut

$test->for('example', 6, 'caught', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok !defined $result;

  !$result
});

=example-7 caught

  package main;

  my $example = Example->new;

  my $catch;

  my $result = $example->caught($catch);

  # undef

=cut

$test->for('example', 7, 'caught', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok !defined $result;

  !$result
});

=method maybe

The maybe method traps any errors raised by executing the dispatched method
call and returns undefined on error, effectively supressing the error. This
method can return a list of values in list-context. This method supports
dispatching, i.e.  providing a method name and arguments whose return value
will be acted on by this method.

=signature maybe

  maybe(string $method, any @args) (any)

=metadata maybe

{
  since => '2.91',
}

=example-1 maybe

  package main;

  my $example = Example->new;

  my $maybe = $example->maybe('fail');

  # undef

=cut

$test->for('example', 1, 'maybe', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok !defined $result;

  !$result
});

=example-2 maybe

  package main;

  my $example = Example->new;

  my $maybe = $example->maybe('pass');

  # true

=cut

$test->for('example', 2, 'maybe', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, 1;

  $result
});

=example-3 maybe

  package main;

  my $example = Example->new;

  my (@maybe) = $example->maybe(sub {1..4});

  # (1..4)

=cut

$test->for('example', 3, 'maybe', sub {
  my ($tryable) = @_;
  my @result = $tryable->result;
  is_deeply [@result], [1..4];

  @result
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Role/Catchable.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;