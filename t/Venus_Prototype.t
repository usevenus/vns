package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;
use Venus;

my $test = test(__FILE__);

=name

Venus::Prototype

=cut

$test->for('name');

=tagline

Prototype Class

=cut

$test->for('tagline');

=abstract

Prototype Class for Perl 5

=cut

$test->for('abstract');

=includes

method: apply
method: call
method: extend
method: new

=cut

$test->for('includes');

=synopsis

  package main;

  use Venus::Prototype;

  my $prototype = Venus::Prototype->new(
    '$counter' => 0,
    '&decrement' => sub { $_[0]->counter($_[0]->counter - 1) },
    '&increment' => sub { $_[0]->counter($_[0]->counter + 1) },
  );

  # bless({value => {...}}, 'Venus::Prototype')

  # $prototype->counter # 0
  # $prototype->increment # 1
  # $prototype->counter # 1
  # $prototype->decrement # 0
  # $prototype->counter # 0

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Prototype');
  ok exists $result->value->{'$counter'};
  ok exists $result->value->{'&decrement'};
  ok exists $result->value->{'&increment'};
  is $result->counter, 0;
  is $result->increment, 1;
  is $result->counter, 1;
  is $result->decrement, 0;
  is $result->counter, 0;

  $result
});

=description

This package provides a simple construct for enabling prototype-base
programming. Properties can be called as methods when prefixed with a dollar or
ampersand symbol. See L</call> for more details.

=cut

$test->for('description');

=inherits

Venus::Kind::Utility

=cut

$test->for('inherits');

=integrates

Venus::Role::Buildable
Venus::Role::Proxyable
Venus::Role::Valuable

=cut

$test->for('integrates');

=method apply

The apply method extends the underlying data structure by merging the data
provided, and then returns the invocant.

=signature apply

  apply(hashref $data) (Venus::Prototype)

=metadata apply

{
  since => '1.50',
}

=example-1 apply

  package main;

  my $person = Venus::Prototype->new({
    '$name' => '',
  });

  $person->apply;

  # bless({value => {'$name' => ''}}, 'Venus::Prototype')

=cut

$test->for('example', 1, 'apply', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Prototype');
  is $result->name, '';

  $result
});

=example-2 apply

  package main;

  my $person = Venus::Prototype->new({
    '$name' => '',
  });

  $person->apply({
    '$name' => 'Elliot Alderson',
  });

  # bless({value => {'$name' => 'Elliot Alderson'}}, 'Venus::Prototype')

=cut

$test->for('example', 2, 'apply', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Prototype');
  is $result->name, 'Elliot Alderson';

  $result
});

=example-3 apply

  package main;

  my $person = Venus::Prototype->new({
    '$name' => '',
    '&greet' => sub {'hello'},
  });

  $person->apply({
    '$name' => 'Elliot Alderson',
  });

  # bless({value => {...}}, 'Venus::Prototype')

=cut

$test->for('example', 3, 'apply', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Prototype');
  is $result->name, 'Elliot Alderson';
  is $result->greet, 'hello';

  $result
});

=method call

The call method dispatches method calls based on the method name provided and
the state of the object, and returns the results. If the method name provided
matches an object property of the same name with an ampersand prefix, denoting
a method, then the dispatched method call acts as a method call providing the
invocant as the first argument. If the method name provided matches an object
property of the same name with a dollar sign prefix, denoting an attribute,
then the dispatched method call acts as an attribute accessor call. This method
is also useful for calling virtual methods when those virtual methods conflict
with the L<Venus::Prototype> methods.

=signature call

  call(string $method, any @args) (any)

=metadata call

{
  since => '1.50',
}

=example-1 call

  package main;

  my $person = Venus::Prototype->new({
    '$name' => 'anonymous',
  });

  my $name = $person->call('name');

  # "anonymous"

=cut

$test->for('example', 1, 'call', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 'anonymous';

  $result
});

=example-2 call

  package main;

  my $person = Venus::Prototype->new({
    '$name' => 'anonymous',
  });

  my $name = $person->call('name', 'unidentified');

  # "unidentified"

=cut

$test->for('example', 2, 'call', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 'unidentified';

  $result
});

=method extend

The extend method copies the underlying data structure, merging the data
provided if any, and then returns a new prototype object.

=signature extend

  extend(hashref $data) (Venus::Prototype)

=metadata extend

{
  since => '1.50',
}

=example-1 extend

  package main;

  my $mrrobot = Venus::Prototype->new({
    '$name' => 'Edward Alderson',
    '$group' => 'fsociety',
  });

  my $elliot = $mrrobot->extend({
    '$name' => 'Elliot Alderson',
  });

  # bless({value => {...}}, 'Venus::Prototype')

=cut

$test->for('example', 1, 'extend', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Prototype');
  is $result->name, 'Elliot Alderson';
  is $result->group, 'fsociety';

  $result
});

=example-2 extend

  package main;

  my $mrrobot = Venus::Prototype->new({
    '$name' => 'Edward Alderson',
    '$group' => 'fsociety',
    '$login' => { username => 'admin', password => 'secret', },
  });

  my $elliot = $mrrobot->extend({
    '$name' => 'Elliot Alderson',
    '$login' => { password => '$ecr3+', },
  });

  # bless({value => {...}}, 'Venus::Prototype')

=cut

$test->for('example', 2, 'extend', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Prototype');
  is $result->name, 'Elliot Alderson';
  is $result->group, 'fsociety';
  ok !$result->login->{username};
  is $result->login->{password}, '$ecr3+';

  $result
});

=example-3 extend

  package main;

  my $ability = {
    '&access' => sub {time},
  };

  my $person = Venus::Prototype->new;

  my $mrrobot = $person->extend($ability);

  my $elliot = $mrrobot->extend($ability);

  # bless({value => {...}}, 'Venus::Prototype')

=cut

$test->for('example', 3, 'extend', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Prototype');
  ok $result->access;

  $result
});

=method new

The new method constructs an instance of the package.

=signature new

  new(any @args) (Venus::Prototype)

=metadata new

{
  since => '4.15',
}

=cut

=example-1 new

  package main;

  use Venus::Prototype;

  my $new = Venus::Prototype->new;

  # bless(..., "Venus::Prototype")

=cut

$test->for('example', 1, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Prototype');
  is_deeply $result->value, {};

  $result
});

=example-2 new

  package main;

  use Venus::Prototype;

  my $new = Venus::Prototype->new(
    '$counter' => 0,
    '&decrement' => sub { $_[0]->counter($_[0]->counter - 1) },
    '&increment' => sub { $_[0]->counter($_[0]->counter + 1) },
  );

  # bless(..., "Venus::Prototype")

=cut

$test->for('example', 2, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Prototype');
  ok exists $result->value->{'$counter'};
  ok exists $result->value->{'&decrement'};
  ok exists $result->value->{'&increment'};

  $result
});

=example-3 new

  package main;

  use Venus::Prototype;

  my $new = Venus::Prototype->new(value => {
    '$counter' => 0,
    '&decrement' => sub { $_[0]->counter($_[0]->counter - 1) },
    '&increment' => sub { $_[0]->counter($_[0]->counter + 1) },
  });

  # bless(..., "Venus::Prototype")

=cut

$test->for('example', 3, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Prototype');
  ok exists $result->value->{'$counter'};
  ok exists $result->value->{'&decrement'};
  ok exists $result->value->{'&increment'};

  $result
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Prototype.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;
