package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;
use Venus;

my $test = test(__FILE__);

=name

Venus::Gather

=cut

$test->for('name');

=tagline

Gather Class

=cut

$test->for('tagline');

=abstract

Gather Class for Perl 5

=cut

$test->for('abstract');

=includes

method: clear
method: count
method: data
method: defined
method: expr
method: just
method: new
method: none
method: object
method: only
method: reduce
method: result
method: skip
method: take
method: test
method: then
method: type
method: when
method: where

=cut

$test->for('includes');

=synopsis

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->when(sub{$_ eq 1})->then(sub{"one"});
  $gather->when(sub{$_ eq 2})->then(sub{"two"});

  $gather->none(sub{"?"});

  my $result = $gather->result;

  # ["?"]

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["?"];

  $result
});

=description

This package provides an object-oriented interface for complex pattern matching
operations on collections of data, e.g. array references. See L<Venus::Match>
for operating on scalar values.

=cut

$test->for('description');

=inherits

Venus::Kind::Utility

=cut

$test->for('inherits');

=integrates

Venus::Role::Accessible
Venus::Role::Buildable
Venus::Role::Valuable

=cut

$test->for('inherits');

=attributes

on_none: rw, opt, CodeRef, C<sub{}>
on_only: rw, opt, CodeRef, C<sub{1}>
on_then: rw, opt, ArrayRef[CodeRef], C<[]>
on_when: rw, opt, ArrayRef[CodeRef], C<[]>

=cut

$test->for('attributes');

=method clear

The clear method resets all gather conditions and returns the invocant.

=signature clear

  clear() (Venus::Gather)

=metadata clear

{
  since => '1.55',
}

=example-1 clear

  # given: synopsis

  package main;

  my $clear = $gather->clear;

  # bless(..., "Venus::Gather")

=cut

$test->for('example', 1, 'clear', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->on_none;
  ok !$result->on_none->();
  ok $result->on_only;
  ok $result->on_only->() == 1;
  ok $result->on_then;
  ok ref($result->on_then) eq 'ARRAY';
  ok $#{$result->on_then} == -1;
  ok $result->on_when;
  ok ref($result->on_when) eq 'ARRAY';
  ok $#{$result->on_when} == -1;

  $result
});

=method count

The count method calls L</result> and returns the number of items gathered.

=signature count

  count(any $data) (number)

=metadata count

{
  since => '4.15',
}

=example-1 count

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->expr(qr/^t/)->take;

  my $result = $gather->count;

  # 2

=cut

$test->for('example', 1, 'count', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, 2;

  $result
});

=method data

The data method takes a hashref (i.e. lookup table) and creates gather
conditions and actions based on the keys and values found.

=signature data

  data(hashref $data) (Venus::Gather)

=metadata data

{
  since => '1.55',
}

=example-1 data

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->data({
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
    "zero" => 0,
  });

  my $result = $gather->none('?')->result;

  # [1..9, 0]

=cut

$test->for('example', 1, 'data', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1..9,0];

  $result
});

=example-2 data

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->data({
    "zero" => 0,
  });

  my $result = $gather->none('?')->result;

  # [0]

=cut

$test->for('example', 2, 'data', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [0];

  $result
});

=method defined

The defined method registers a L</when> condition which only allows matching if
the value presented is C<defined>.

=signature defined

  defined() (Venus::Gather)

=metadata defined

{
  since => '4.15',
}

=example-1 defined

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new;

  $gather->defined->take;

  my $result = $gather->result([0, "", undef, false]);

  # [0, "", false]

=cut

$test->for('example', 1, 'defined', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [0, "", false];

  $result
});

=method expr

The expr method registers a L</when> condition that check if the match value is
an exact string match of the C<$topic> if the topic is a string, or that it
matches against the topic if the topic is a regular expression.

=signature expr

  expr(string | regexp $expr) (Venus::Gather)

=metadata expr

{
  since => '1.55',
}

=example-1 expr

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->expr('one')->then(sub{[split //]});

  my $result = $gather->result;

  # [["o", "n", "e"]]

=cut

$test->for('example', 1, 'expr', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [["o", "n", "e"]];

  $result
});

=example-2 expr

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->expr(qr/^o/)->then(sub{[split //]});

  my $result = $gather->result;

  # [["o", "n", "e"]]

=cut

$test->for('example', 2, 'expr', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [["o", "n", "e"]];

  $result
});

=method just

The just method registers a L</when> condition that check if the match value is
an exact string match of the C<$topic> provided.

=signature just

  just(string $topic) (Venus::Gather)

=metadata just

{
  since => '1.55',
}

=example-1 just

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just('one')->then(1);
  $gather->just('two')->then(2);
  $gather->just('three')->then(3);

  my $result = $gather->result;

  # [1,2,3]

=cut

$test->for('example', 1, 'just', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,2,3];

  $result
});

=example-2 just

  package main;

  use Venus::Gather;
  use Venus::String;

  my $gather = Venus::Gather->new([
    Venus::String->new("one"),
    Venus::String->new("two"),
    Venus::String->new("three"),
    Venus::String->new("four"),
    Venus::String->new("five"),
    Venus::String->new("six"),
    Venus::String->new("seven"),
    Venus::String->new("eight"),
    Venus::String->new("nine"),
    Venus::String->new("zero"),
  ]);

  $gather->just('one')->then(1);
  $gather->just('two')->then(2);
  $gather->just('three')->then(3);

  my $result = $gather->result;

  # [1,2,3]

=cut

$test->for('example', 2, 'just', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,2,3];

  $result
});

=example-3 just

  package main;

  use Venus::Gather;
  use Venus::String;

  my $gather = Venus::Gather->new([
    Venus::String->new("one"),
    Venus::String->new("two"),
    Venus::String->new("three"),
    Venus::String->new("four"),
    Venus::String->new("five"),
    Venus::String->new("six"),
    Venus::String->new("seven"),
    Venus::String->new("eight"),
    Venus::String->new("nine"),
    Venus::String->new("zero"),
  ]);

  $gather->just('one')->then(1);
  $gather->just('six')->then(6);

  my $result = $gather->result;

  # [1,6]

=cut

$test->for('example', 3, 'just', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,6];

  $result
});

=method new

The new method constructs an instance of the package.

=signature new

  new(any @args) (Venus::Gather)

=metadata new

{
  since => '4.15',
}

=cut

=example-1 new

  package main;

  use Venus::Gather;

  my $new = Venus::Gather->new;

  # bless(..., "Venus::Gather")

=cut

$test->for('example', 1, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Gather');

  $result
});

=example-2 new

  package main;

  use Venus::Gather;

  my $new = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  # bless(..., "Venus::Gather")

=cut

$test->for('example', 2, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Gather');
  is_deeply $result->value, [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ];

  $result
});

=example-3 new

  package main;

  use Venus::Gather;

  my $new = Venus::Gather->new(value => [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  # bless(..., "Venus::Gather")

=cut

$test->for('example', 3, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Gather');
  is_deeply $result->value, [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ];

  $result
});

=method none

The none method registers a special condition that returns a result only when
no other conditions have been matched.

=signature none

  none(any | coderef $code) (Venus::Gather)

=metadata none

{
  since => '1.55',
}

=example-1 none

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just('ten')->then(10);

  $gather->none('none');

  my $result = $gather->result;

  # ["none"]

=cut

$test->for('example', 1, 'none', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ['none'];

  $result
});

=example-2 none

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just('ten')->then(10);

  $gather->none(sub{[map "no $_", @$_]});

  my $result = $gather->result;

  # [
  #   "no one",
  #   "no two",
  #   "no three",
  #   "no four",
  #   "no five",
  #   "no six",
  #   "no seven",
  #   "no eight",
  #   "no nine",
  #   "no zero",
  # ]

=cut

$test->for('example', 2, 'none', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [
    "no one",
    "no two",
    "no three",
    "no four",
    "no five",
    "no six",
    "no seven",
    "no eight",
    "no nine",
    "no zero",
  ];

  $result
});

=method object

The object method registers a L</when> condition which only allows matching if
the value presented is an object.

=signature object

  object() (Venus::Gather)

=metadata object

{
  since => '4.15',
}

=example-1 object

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new;

  $gather->object->take;

  my $result = $gather->result([0, "", undef, false, bless{}]);

  # [bless({}, 'main')]

=cut

$test->for('example', 1, 'object', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is scalar(@$result), 1;
  ok $result->[0]->isa('main');

  $result
});

=method only

The only method registers a special condition that only allows matching on the
value only if the code provided returns truthy.

=signature only

  only(coderef $code) (Venus::Gather)

=metadata only

{
  since => '1.55',
}

=example-1 only

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->only(sub{grep /^[A-Z]/, @$_});

  $gather->just('one')->then(1);

  my $result = $gather->result;

  # []

=cut

$test->for('example', 1, 'only', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=example-2 only

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->only(sub{grep /e$/, @$_});

  $gather->expr(qr/e$/)->take;

  my $result = $gather->result;

  # [
  #   "one",
  #   "three",
  #   "five",
  #   "nine",
  # ]

=cut

$test->for('example', 2, 'only', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [
    "one",
    "three",
    "five",
    "nine",
  ];

  $result
});

=method reduce

The reduce method returns a new L<Venus::Gather> object using the values
returned via the L</result> method.

=signature reduce

  reduce(any $data) (Venus::Gather)

=metadata reduce

{
  since => '4.15',
}

=cut

=example-1 reduce

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->expr(qr/^s/)->take;

  my $reduce = $gather->reduce;

  # bless(..., "Venus::Gather")

=cut

$test->for('example', 1, 'reduce', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Gather');
  my $value = $result->value;
  is_deeply $value, ['six', 'seven'];

  $result
});

=method result

The result method evaluates the registered conditions and returns the result of
the action (i.e. the L</then> code) or the special L</none> condition if there
were no matches. In list context, this method returns both the result and
whether or not a condition matched. Optionally, when passed an argument this
method assign the argument as the value/topic and then perform the operation.

=signature result

  result(any $data) (any)

=metadata result

{
  since => '1.55',
}

=example-1 result

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just('one')->then(1);
  $gather->just('six')->then(6);

  my $result = $gather->result;

  # [1,6]

=cut

$test->for('example', 1, 'result', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,6];

  $result
});

=example-2 result

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just('one')->then(1);
  $gather->just('six')->then(6);

  my ($result, $gathered) = $gather->result;

  # ([1,6], 2)

=cut

$test->for('example', 2, 'result', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  is_deeply $result[0], [1,6];
  is $result[1], 2;

  $result[0]
});

=example-3 result

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just('One')->then(1);
  $gather->just('Six')->then(6);

  my ($result, $gathered) = $gather->result;

  # ([], 0)

=cut

$test->for('example', 3, 'result', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  is_deeply $result[0], [];
  is $result[1], 0;

  $result[0]
});

=example-4 result

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just(1)->then(1);
  $gather->just(6)->then(6);

  my $result = $gather->result([1..9, 0]);

  # [1,6]

=cut

$test->for('example', 4, 'result', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,6];

  $result
});

=example-5 result

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just('one')->then(1);
  $gather->just('six')->then(6);

  my $result = $gather->result([10..20]);

  # []

=cut

$test->for('example', 5, 'result', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=method test

The test method evaluates the registered conditions and returns truthy if a
match can be made, without executing any of the actions (i.e. the L</then>
code) or the special L</none> condition.

=signature test

  test() (boolean)

=metadata test

{
  since => '1.55',
}

=example-1 test

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just('one')->then(1);
  $gather->just('six')->then(6);

  my $test = $gather->test;

  # 2

=cut

$test->for('example', 1, 'test', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 2;

  $result
});

=example-2 test

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just('One')->then(1);
  $gather->just('Six')->then(6);

  my $test = $gather->test;

  # 0

=cut

$test->for('example', 2, 'test', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=method skip

The skip method registers a L</then> condition which ignores (i.e. skips) the
matched line item.

=signature skip

  skip() (Venus::Gather)

=metadata skip

{
  since => '1.55',
}

=example-1 skip

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->expr(qr/e$/)->skip;

  $gather->expr(qr/.*/)->take;

  my $result = $gather->result;

  # ["two", "four", "six", "seven", "eight", "zero"]

=cut

$test->for('example', 1, 'skip', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["two", "four", "six", "seven", "eight", "zero"];

  $result
});

=method take

The take method registers a L</then> condition which returns (i.e. takes) the
matched line item as-is.

=signature take

  take() (Venus::Gather)

=metadata take

{
  since => '1.55',
}

=example-1 take

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->expr(qr/e$/)->take;

  my $result = $gather->result;

  # ["one", "three", "five", "nine"]

=cut

$test->for('example', 1, 'take', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["one", "three", "five", "nine"];

  $result
});

=method then

The then method registers an action to be executed if the corresponding gather
condition returns truthy.

=signature then

  then(any | coderef $code) (Venus::Gather)

=metadata then

{
  since => '1.55',
}

=example-1 then

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just('one');
  $gather->then(1);

  $gather->just('two');
  $gather->then(2);

  my $result = $gather->result;

  # [1,2]

=cut

$test->for('example', 1, 'then', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,2];

  $result
});

=example-2 then

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->just('one');
  $gather->then(1);

  $gather->just('two');
  $gather->then(2);
  $gather->then(0);

  my $result = $gather->result;

  # [1,0]

=cut

$test->for('example', 2, 'then', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,0];

  $result
});

=method type

The type method accepts a L<"type expression"|Venus::Type> and registers a
L</when> condition which matches values conforming to the type expression
specified.

=signature type

  type(string $expr) (Venus::Gather)

=metadata type

{
  since => '4.15',
}

=example-1 type

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([1, "1"]);

  $gather->type('string');
  $gather->then('string');

  $gather->type('number');
  $gather->then('number');

  my $result = $gather->result;

  # ["number", "string"]

=cut

$test->for('example', 1, 'type', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, ["number", "string"];

  $result
});

=method when

The when method registers a match condition that will be passed the match value
during evaluation. If the match condition returns truthy the corresponding
action will be used to return a result. If the match value is an object, this
method can take a method name and arguments which will be used as a match
condition.

=signature when

  when(string | coderef $code, any @args) (Venus::Gather)

=metadata when

{
  since => '1.55',
}

=example-1 when

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new([
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "zero",
  ]);

  $gather->when(sub{$_ eq 'one'});
  $gather->then(1);

  $gather->when(sub{$_ eq 'two'});
  $gather->then(2);

  $gather->when(sub{$_ eq 'six'});
  $gather->then(6);

  my $result = $gather->result;

  # [1,2,6]

=cut

$test->for('example', 1, 'when', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,2,6];

  $result
});

=method where

The where method registers an action as a sub-match operation, to be executed
if the corresponding match condition returns truthy. This method returns the
sub-match object.

=signature where

  where() (Venus::Gather)

=metadata where

{
  since => '1.55',
}

=example-1 where

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new;

  my $subgather1 = $gather->expr(qr/^p([a-z]+)ch/)->where;

  $subgather1->just('peach')->then('peach-123');
  $subgather1->just('patch')->then('patch-456');
  $subgather1->just('punch')->then('punch-789');

  my $subgather2 = $gather->expr(qr/^m([a-z]+)ch/)->where;

  $subgather2->just('merch')->then('merch-123');
  $subgather2->just('march')->then('march-456');
  $subgather2->just('mouch')->then('mouch-789');

  my $result = $gather->result(['peach', 'preach']);

  # ["peach-123"]

=cut

$test->for('example', 1, 'where', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["peach-123"];

  $result
});

=example-2 where

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new;

  my $subgather1 = $gather->expr(qr/^p([a-z]+)ch/)->where;

  $subgather1->just('peach')->then('peach-123');
  $subgather1->just('patch')->then('patch-456');
  $subgather1->just('punch')->then('punch-789');

  my $subgather2 = $gather->expr(qr/^m([a-z]+)ch/)->where;

  $subgather2->just('merch')->then('merch-123');
  $subgather2->just('march')->then('march-456');
  $subgather2->just('mouch')->then('mouch-789');

  my $result = $gather->result(['march', 'merch']);

  # ["march-456", "merch-123"]

=cut

$test->for('example', 2, 'where', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["march-456", "merch-123"];

  $result
});

=example-3 where

  package main;

  use Venus::Gather;

  my $gather = Venus::Gather->new;

  my $subgather1 = $gather->expr(qr/^p([a-z]+)ch/)->where;

  $subgather1->just('peach')->then('peach-123');
  $subgather1->just('patch')->then('patch-456');
  $subgather1->just('punch')->then('punch-789');

  my $subgather2 = $gather->expr(qr/^m([a-z]+)ch/)->where;

  $subgather2->just('merch')->then('merch-123');
  $subgather2->just('march')->then('march-456');
  $subgather2->just('mouch')->then('mouch-789');

  my $result = $gather->result(['pirch']);

  # []

=cut

$test->for('example', 3, 'where', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Gather.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;
