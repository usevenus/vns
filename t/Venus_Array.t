package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;
use Venus;

my $test = test(__FILE__);

=name

Venus::Array

=cut

$test->for('name');

=tagline

Array Class

=cut

$test->for('tagline');

=abstract

Array Class for Perl 5

=cut

$test->for('abstract');

=includes

method: all
method: any
method: call
method: cast
method: count
method: default
method: delete
method: each
method: empty
method: eq
method: exists
method: find
method: first
method: ge
method: gele
method: gets
method: grep
method: gt
method: gtlt
method: head
method: iterator
method: join
method: keyed
method: keys
method: last
method: le
method: length
method: list
method: lt
method: map
method: merge
method: ne
method: new
method: none
method: one
method: order
method: pairs
method: part
method: path
method: pop
method: push
method: puts
method: random
method: range
method: reverse
method: rotate
method: rsort
method: sets
method: shift
method: shuffle
method: slice
method: sort
method: tail
method: tv
method: unique
method: unshift

=cut

$test->for('includes');

=synopsis

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([1..9]);

  # $array->random;

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Array');

  $result
});

=description

This package provides methods for manipulating array data.

=cut

$test->for('description');

=inherits

Venus::Kind::Value

=cut

$test->for('inherits');

=integrates

Venus::Role::Mappable

=cut

$test->for('integrates');

=method all

The all method returns true if the callback returns true for all of the
elements.

=signature all

  all(coderef $code) (boolean)

=metadata all

{
  since => '0.01',
}

=example-1 all

  # given: synopsis;

  my $all = $array->all(sub {
    $_ > 0;
  });

  # 1

=cut

$test->for('example', 1, 'all', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-2 all

  # given: synopsis;

  my $all = $array->all(sub {
    my ($key, $value) = @_;

    $value > 0;
  });

  # 1

=cut

$test->for('example', 2, 'all', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method any

The any method returns true if the callback returns true for any of the
elements.

=signature any

  any(coderef $code) (boolean)

=metadata any

{
  since => '0.01',
}

=example-1 any

  # given: synopsis;

  my $any = $array->any(sub {
    $_ > 4;
  });

=cut

$test->for('example', 1, 'any', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-2 any

  # given: synopsis;

  my $any = $array->any(sub {
    my ($key, $value) = @_;

    $value > 4;
  });

=cut

$test->for('example', 2, 'any', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method call

The call method executes the given method (named using the first argument)
which performs an iteration (i.e. takes a callback) and calls the method (named
using the second argument) on the object (or value) and returns the result of
the iterable method.

=signature call

  call(string $iterable, string $method) (any)

=metadata call

{
  since => '1.02',
}

=example-1 call

  # given: synopsis

  package main;

  my $call = $array->call('map', 'incr');

  # [2..10]

=cut

$test->for('example', 1, 'call', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [2..10];

  $result
});

=example-2 call

  # given: synopsis

  package main;

  my $call = $array->call('grep', 'gt', 4);

  # [4..9]

=cut

$test->for('example', 2, 'call', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [5..9];

  $result
});

=method cast

The cast method converts L<"value"|Venus::Kind::Value> objects between
different I<"value"> object types, based on the name of the type provided. This
method will return C<undef> if the invocant is not a L<Venus::Kind::Value>.

=signature cast

  cast(string $kind) (object | undef)

=metadata cast

{
  since => '0.08',
}

=example-1 cast

  package main;

  use Venus::Array;

  my $array = Venus::Array->new;

  my $cast = $array->cast('array');

  # bless({ value => [] }, "Venus::Array")

=cut

$test->for('example', 1, 'cast', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Kind::Value');
  ok $result->isa('Venus::Array');
  is_deeply $result->get, [];

  $result
});

=example-2 cast

  package main;

  use Venus::Array;

  my $array = Venus::Array->new;

  my $cast = $array->cast('boolean');

  # bless({ value => 1 }, "Venus::Boolean")

=cut

$test->for('example', 2, 'cast', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Kind::Value');
  ok $result->isa('Venus::Boolean');
  is $result->get, 1;

  $result
});

=example-3 cast

  package main;

  use Venus::Array;

  my $array = Venus::Array->new;

  my $cast = $array->cast('code');

  # bless({ value => sub { ... } }, "Venus::Code")

=cut

$test->for('example', 3, 'cast', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Kind::Value');
  ok $result->isa('Venus::Code');
  is_deeply $result->get->(), [];

  $result
});

=example-4 cast

  package main;

  use Venus::Array;

  my $array = Venus::Array->new;

  my $cast = $array->cast('float');

  # bless({ value => "1.0" }, "Venus::Float")

=cut

$test->for('example', 4, 'cast', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Kind::Value');
  ok $result->isa('Venus::Float');
  is $result->get, '1.0';

  $result
});

=example-5 cast

  package main;

  use Venus::Array;

  my $array = Venus::Array->new;

  my $cast = $array->cast('hash');

  # bless({ value => {} }, "Venus::Hash")

=cut

$test->for('example', 5, 'cast', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Kind::Value');
  ok $result->isa('Venus::Hash');
  is_deeply $result->get, {};

  $result
});

=example-6 cast

  package main;

  use Venus::Array;

  my $array = Venus::Array->new;

  my $cast = $array->cast('number');

  # bless({ value => 2 }, "Venus::Number")

=cut

$test->for('example', 6, 'cast', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Kind::Value');
  ok $result->isa('Venus::Number');
  is $result->get, 2;

  $result
});

=example-7 cast

  package main;

  use Venus::Array;

  my $array = Venus::Array->new;

  my $cast = $array->cast('regexp');

  # bless({ value => qr/(?^u:\[\])/ }, "Venus::Regexp")

=cut

$test->for('example', 7, 'cast', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Kind::Value');
  ok $result->isa('Venus::Regexp');
  is $result->get, qr/\[\]/;

  $result
});

=example-8 cast

  package main;

  use Venus::Array;

  my $array = Venus::Array->new;

  my $cast = $array->cast('scalar');

  # bless({ value => \[] }, "Venus::Scalar")

=cut

$test->for('example', 8, 'cast', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Kind::Value');
  ok $result->isa('Venus::Scalar');
  is_deeply $result->get, \[];

  $result
});

=example-9 cast

  package main;

  use Venus::Array;

  my $array = Venus::Array->new;

  my $cast = $array->cast('string');

  # bless({ value => "[]" }, "Venus::String")

=cut

$test->for('example', 9, 'cast', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Kind::Value');
  ok $result->isa('Venus::String');
  is $result->get, '[]';

  $result
});

=example-10 cast

  package main;

  use Venus::Array;

  my $array = Venus::Array->new;

  my $cast = $array->cast('undef');

  # bless({ value => undef }, "Venus::Undef")

=cut

$test->for('example', 10, 'cast', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok $result->isa('Venus::Kind::Value');
  ok $result->isa('Venus::Undef');

  !$result
});

=method count

The count method returns the number of elements within the array.

=signature count

  count() (number)

=metadata count

{
  since => '0.01',
}

=example-1 count

  # given: synopsis;

  my $count = $array->count;

  # 9

=cut

$test->for('example', 1, 'count', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 9;

  $result
});

=method default

The default method returns the default value, i.e. C<[]>.

=signature default

  default() (arrayref)

=metadata default

{
  since => '0.01',
}

=example-1 default

  # given: synopsis;

  my $default = $array->default;

  # []

=cut

$test->for('example', 1, 'default', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=method delete

The delete method returns the value of the element at the index specified after
removing it from the array.

=signature delete

  delete(number $index) (any)

=metadata delete

{
  since => '0.01',
}

=example-1 delete

  # given: synopsis;

  my $delete = $array->delete(2);

  # 3

=cut

$test->for('example', 1, 'delete', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 3;

  $result
});

=method each

The each method executes a callback for each element in the array passing the
index and value as arguments. This method can return a list of values in
list-context.

=signature each

  each(coderef $code) (arrayref)

=metadata each

{
  since => '0.01',
}

=example-1 each

  # given: synopsis;

  my $each = $array->each(sub {
    [$_]
  });

  # [[1], [2], [3], [4], [5], [6], [7], [8], [9]]

=cut

$test->for('example', 1, 'each', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [[1], [2], [3], [4], [5], [6], [7], [8], [9]];

  $result
});

=example-2 each

  # given: synopsis;

  my $each = $array->each(sub {
    my ($key, $value) = @_;

    [$key, $value]
  });

  # [
  #   [0, 1],
  #   [1, 2],
  #   [2, 3],
  #   [3, 4],
  #   [4, 5],
  #   [5, 6],
  #   [6, 7],
  #   [7, 8],
  #   [8, 9],
  # ]

=cut

$test->for('example', 2, 'each', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [
    [0, 1],
    [1, 2],
    [2, 3],
    [3, 4],
    [4, 5],
    [5, 6],
    [6, 7],
    [7, 8],
    [8, 9],
  ];

  $result
});

=method empty

The empty method drops all elements from the array.

=signature empty

  empty() (Venus::Array)

=metadata empty

{
  since => '0.01',
}

=example-1 empty

  # given: synopsis;

  my $empty = $array->empty;

  # bless({ value => [] }, "Venus::Array")

=cut

$test->for('example', 1, 'empty', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Array');
  is_deeply $result->value, [];

  $result
});

=method eq

The eq method performs an I<"equals"> operation using the argument provided.

=signature eq

  eq(any $arg) (boolean)

=metadata eq

{
  since => '0.08',
}

=example-1 eq

  package main;

  use Venus::Array;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Array->new;

  my $result = $lvalue->eq($rvalue);

  # 1

=cut

$test->for('example', 1, 'eq', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-2 eq

  package main;

  use Venus::Array;
  use Venus::Code;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Code->new;

  my $result = $lvalue->eq($rvalue);

  # 0

=cut

$test->for('example', 2, 'eq', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-3 eq

  package main;

  use Venus::Array;
  use Venus::Float;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Float->new;

  my $result = $lvalue->eq($rvalue);

  # 0

=cut

$test->for('example', 3, 'eq', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-4 eq

  package main;

  use Venus::Array;
  use Venus::Hash;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Hash->new;

  my $result = $lvalue->eq($rvalue);

  # 0

=cut

$test->for('example', 4, 'eq', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-5 eq

  package main;

  use Venus::Array;
  use Venus::Number;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Number->new;

  my $result = $lvalue->eq($rvalue);

  # 0

=cut

$test->for('example', 5, 'eq', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-6 eq

  package main;

  use Venus::Array;
  use Venus::Regexp;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Regexp->new;

  my $result = $lvalue->eq($rvalue);

  # 0

=cut

$test->for('example', 6, 'eq', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-7 eq

  package main;

  use Venus::Array;
  use Venus::Scalar;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Scalar->new;

  my $result = $lvalue->eq($rvalue);

  # 0

=cut

$test->for('example', 7, 'eq', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-8 eq

  package main;

  use Venus::Array;
  use Venus::String;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::String->new;

  my $result = $lvalue->eq($rvalue);

  # 0

=cut

$test->for('example', 8, 'eq', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-9 eq

  package main;

  use Venus::Array;
  use Venus::Undef;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Undef->new;

  my $result = $lvalue->eq($rvalue);

  # 0

=cut

$test->for('example', 9, 'eq', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=method exists

The exists method returns true if the element at the index specified exists,
otherwise it returns false.

=signature exists

  exists(number $index) (boolean)

=metadata exists

{
  since => '0.01',
}

=example-1 exists

  # given: synopsis;

  my $exists = $array->exists(0);

  # 1

=cut

$test->for('example', 1, 'exists', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method find

The find method traverses the data structure using the keys and indices
provided, returning the value found or undef. In list-context, this method
returns a tuple, i.e. the value found and boolean representing whether the
match was successful.

=signature find

  find(string @keys) (any)

=metadata find

{
  since => '0.01',
}

=example-1 find

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([{'foo' => {'bar' => 'baz'}}, 'bar', ['baz']]);

  my $find = $array->find(0, 'foo');

  # { bar => "baz" }

=cut

$test->for('example', 1, 'find', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, { bar => "baz" };

  $result
});

=example-2 find

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([{'foo' => {'bar' => 'baz'}}, 'bar', ['baz']]);

  my $find = $array->find(0, 'foo', 'bar');

  # "baz"

=cut

$test->for('example', 2, 'find', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'baz';

  $result
});

=example-3 find

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([{'foo' => {'bar' => 'baz'}}, 'bar', ['baz']]);

  my $find = $array->find(2, 0);

  # "baz"

=cut

$test->for('example', 3, 'find', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'baz';

  $result
});

=method ge

The ge method performs a I<"greater-than-or-equal-to"> operation using the
argument provided.

=signature ge

  ge(any $arg) (boolean)

=metadata ge

{
  since => '0.08',
}

=example-1 ge

  package main;

  use Venus::Array;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Array->new;

  my $result = $lvalue->ge($rvalue);

  # 1

=cut

$test->for('example', 1, 'ge', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-2 ge

  package main;

  use Venus::Array;
  use Venus::Code;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Code->new;

  my $result = $lvalue->ge($rvalue);

  # 0

=cut

$test->for('example', 2, 'ge', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-3 ge

  package main;

  use Venus::Array;
  use Venus::Float;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Float->new;

  my $result = $lvalue->ge($rvalue);

  # 1

=cut

$test->for('example', 3, 'ge', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-4 ge

  package main;

  use Venus::Array;
  use Venus::Hash;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Hash->new;

  my $result = $lvalue->ge($rvalue);

  # 0

=cut

$test->for('example', 4, 'ge', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-5 ge

  package main;

  use Venus::Array;
  use Venus::Number;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Number->new;

  my $result = $lvalue->ge($rvalue);

  # 1

=cut

$test->for('example', 5, 'ge', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-6 ge

  package main;

  use Venus::Array;
  use Venus::Regexp;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Regexp->new;

  my $result = $lvalue->ge($rvalue);

  # 0

=cut

$test->for('example', 6, 'ge', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-7 ge

  package main;

  use Venus::Array;
  use Venus::Scalar;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Scalar->new;

  my $result = $lvalue->ge($rvalue);

  # 0

=cut

$test->for('example', 7, 'ge', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-8 ge

  package main;

  use Venus::Array;
  use Venus::String;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::String->new;

  my $result = $lvalue->ge($rvalue);

  # 1

=cut

$test->for('example', 8, 'ge', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-9 ge

  package main;

  use Venus::Array;
  use Venus::Undef;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Undef->new;

  my $result = $lvalue->ge($rvalue);

  # 1

=cut

$test->for('example', 9, 'ge', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=method gele

The gele method performs a I<"greater-than-or-equal-to"> operation on the 1st
argument, and I<"lesser-than-or-equal-to"> operation on the 2nd argument.

=signature gele

  gele(any $arg1, any $arg2) (boolean)

=metadata gele

{
  since => '0.08',
}

=example-1 gele

  package main;

  use Venus::Array;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Array->new;

  my $result = $lvalue->gele($rvalue);

  # 0

=cut

$test->for('example', 1, 'gele', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-2 gele

  package main;

  use Venus::Array;
  use Venus::Code;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Code->new;

  my $result = $lvalue->gele($rvalue);

  # 0

=cut

$test->for('example', 2, 'gele', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-3 gele

  package main;

  use Venus::Array;
  use Venus::Float;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Float->new;

  my $result = $lvalue->gele($rvalue);

  # 0

=cut

$test->for('example', 3, 'gele', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-4 gele

  package main;

  use Venus::Array;
  use Venus::Hash;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Hash->new;

  my $result = $lvalue->gele($rvalue);

  # 0

=cut

$test->for('example', 4, 'gele', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-5 gele

  package main;

  use Venus::Array;
  use Venus::Number;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Number->new;

  my $result = $lvalue->gele($rvalue);

  # 0

=cut

$test->for('example', 5, 'gele', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-6 gele

  package main;

  use Venus::Array;
  use Venus::Regexp;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Regexp->new;

  my $result = $lvalue->gele($rvalue);

  # 0

=cut

$test->for('example', 6, 'gele', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-7 gele

  package main;

  use Venus::Array;
  use Venus::Scalar;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Scalar->new;

  my $result = $lvalue->gele($rvalue);

  # 0

=cut

$test->for('example', 7, 'gele', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-8 gele

  package main;

  use Venus::Array;
  use Venus::String;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::String->new;

  my $result = $lvalue->gele($rvalue);

  # 0

=cut

$test->for('example', 8, 'gele', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-9 gele

  package main;

  use Venus::Array;
  use Venus::Undef;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Undef->new;

  my $result = $lvalue->gele($rvalue);

  # 0

=cut

$test->for('example', 9, 'gele', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=method first

The first method returns the value of the first element.

=signature first

  first() (any)

=metadata first

{
  since => '0.01',
}

=example-1 first

  # given: synopsis;

  my $first = $array->first;

  # 1

=cut

$test->for('example', 1, 'first', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method gets

The gets method select values from within the underlying data structure using
L<Venus::Array/path>, where each argument is a selector, returns all the values
selected. Returns a list in list context.

=signature gets

  gets(string @args) (arrayref)

=metadata gets

{
  since => '4.15',
}

=cut

=example-1 gets

  package main;

  use Venus::Array;

  my $array = Venus::Array->new(['foo', {'bar' => 'baz'}, 'bar', ['baz']]);

  my $gets = $array->gets('3', '1.bar');

  # [['baz'], 'baz']

=cut

$test->for('example', 1, 'gets', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [['baz'], 'baz'];

  $result
});

=example-2 gets

  package main;

  use Venus::Array;

  my $array = Venus::Array->new(['foo', {'bar' => 'baz'}, 'bar', ['baz']]);

  my ($baz, $one_bar) = $array->gets('3', '1.bar');

  # (['baz'], 'baz')

=cut

$test->for('example', 2, 'gets', sub {
  my ($tryable) = @_;
  my @result = $tryable->result;
  is_deeply \@result, [['baz'], 'baz'];

  @result
});

=example-3 gets

  package main;

  use Venus::Array;

  my $array = Venus::Array->new(['foo', {'bar' => 'baz'}, 'bar', ['baz']]);

  my $gets = $array->gets('3', '1.bar', '1.bar.baz');

  # [['baz'], 'baz', undef]

=cut

$test->for('example', 3, 'gets', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [['baz'], 'baz', undef];

  $result
});

=method grep

The grep method executes a callback for each element in the array passing the
value as an argument, returning a new array reference containing the elements
for which the returned true. This method can return a list of values in
list-context.

=signature grep

  grep(coderef $code) (arrayref)

=metadata grep

{
  since => '0.01',
}

=example-1 grep

  # given: synopsis;

  my $grep = $array->grep(sub {
    $_ > 3
  });

  # [4..9]

=cut

$test->for('example', 1, 'grep', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [4..9];

  $result
});

=example-2 grep

  # given: synopsis;

  my $grep = $array->grep(sub {
    my ($key, $value) = @_;

    $value > 3
  });

  # [4..9]

=cut

$test->for('example', 2, 'grep', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [4..9];

  $result
});

=method gt

The gt method performs a I<"greater-than"> operation using the argument provided.

=signature gt

  gt(any $arg) (boolean)

=metadata gt

{
  since => '0.08',
}

=example-1 gt

  package main;

  use Venus::Array;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Array->new;

  my $result = $lvalue->gt($rvalue);

  # 0

=cut

$test->for('example', 1, 'gt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-2 gt

  package main;

  use Venus::Array;
  use Venus::Code;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Code->new;

  my $result = $lvalue->gt($rvalue);

  # 0

=cut

$test->for('example', 2, 'gt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-3 gt

  package main;

  use Venus::Array;
  use Venus::Float;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Float->new;

  my $result = $lvalue->gt($rvalue);

  # 1

=cut

$test->for('example', 3, 'gt', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-4 gt

  package main;

  use Venus::Array;
  use Venus::Hash;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Hash->new;

  my $result = $lvalue->gt($rvalue);

  # 0

=cut

$test->for('example', 4, 'gt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-5 gt

  package main;

  use Venus::Array;
  use Venus::Number;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Number->new;

  my $result = $lvalue->gt($rvalue);

  # 1

=cut

$test->for('example', 5, 'gt', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-6 gt

  package main;

  use Venus::Array;
  use Venus::Regexp;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Regexp->new;

  my $result = $lvalue->gt($rvalue);

  # 0

=cut

$test->for('example', 6, 'gt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-7 gt

  package main;

  use Venus::Array;
  use Venus::Scalar;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Scalar->new;

  my $result = $lvalue->gt($rvalue);

  # 0

=cut

$test->for('example', 7, 'gt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-8 gt

  package main;

  use Venus::Array;
  use Venus::String;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::String->new;

  my $result = $lvalue->gt($rvalue);

  # 1

=cut

$test->for('example', 8, 'gt', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-9 gt

  package main;

  use Venus::Array;
  use Venus::Undef;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Undef->new;

  my $result = $lvalue->gt($rvalue);

  # 1

=cut

$test->for('example', 9, 'gt', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=method gtlt

The gtlt method performs a I<"greater-than"> operation on the 1st argument, and
I<"lesser-than"> operation on the 2nd argument.

=signature gtlt

  gtlt(any $arg1, any $arg2) (boolean)

=metadata gtlt

{
  since => '0.08',
}

=example-1 gtlt

  package main;

  use Venus::Array;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Array->new;

  my $result = $lvalue->gtlt($rvalue);

  # 0

=cut

$test->for('example', 1, 'gtlt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-2 gtlt

  package main;

  use Venus::Array;
  use Venus::Code;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Code->new;

  my $result = $lvalue->gtlt($rvalue);

  # 0

=cut

$test->for('example', 2, 'gtlt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-3 gtlt

  package main;

  use Venus::Array;
  use Venus::Float;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Float->new;

  my $result = $lvalue->gtlt($rvalue);

  # 0

=cut

$test->for('example', 3, 'gtlt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-4 gtlt

  package main;

  use Venus::Array;
  use Venus::Hash;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Hash->new;

  my $result = $lvalue->gtlt($rvalue);

  # 0

=cut

$test->for('example', 4, 'gtlt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-5 gtlt

  package main;

  use Venus::Array;
  use Venus::Number;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Number->new;

  my $result = $lvalue->gtlt($rvalue);

  # 0

=cut

$test->for('example', 5, 'gtlt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-6 gtlt

  package main;

  use Venus::Array;
  use Venus::Regexp;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Regexp->new;

  my $result = $lvalue->gtlt($rvalue);

  # 0

=cut

$test->for('example', 6, 'gtlt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-7 gtlt

  package main;

  use Venus::Array;
  use Venus::Scalar;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Scalar->new;

  my $result = $lvalue->gtlt($rvalue);

  # 0

=cut

$test->for('example', 7, 'gtlt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-8 gtlt

  package main;

  use Venus::Array;
  use Venus::String;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::String->new;

  my $result = $lvalue->gtlt($rvalue);

  # 0

=cut

$test->for('example', 8, 'gtlt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-9 gtlt

  package main;

  use Venus::Array;
  use Venus::Undef;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Undef->new;

  my $result = $lvalue->gtlt($rvalue);

  # 0

=cut

$test->for('example', 9, 'gtlt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=method head

The head method returns the topmost elements, limited by the desired size
specified.

=signature head

  head(number $size) (arrayref)

=metadata head

{
  since => '1.23',
}

=example-1 head

  # given: synopsis;

  my $head = $array->head;

  # [1]

=cut

$test->for('example', 1, 'head', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1];

  $result
});

=example-2 head

  # given: synopsis;

  my $head = $array->head(1);

  # [1]

=cut

$test->for('example', 2, 'head', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1];

  $result
});

=example-3 head

  # given: synopsis;

  my $head = $array->head(2);

  # [1,2]

=cut

$test->for('example', 3, 'head', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,2];

  $result
});

=example-4 head

  # given: synopsis;

  my $head = $array->head(5);

  # [1..5]

=cut

$test->for('example', 4, 'head', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,2,3,4,5];

  $result
});

=example-5 head

  # given: synopsis;

  my $head = $array->head(20);

  # [1..9]

=cut

$test->for('example', 5, 'head', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,2,3,4,5,6,7,8,9];

  $result
});

=method iterator

The iterator method returns a code reference which can be used to iterate over
the array. Each time the iterator is executed it will return the next element
in the array until all elements have been seen, at which point the iterator
will return an undefined value. This method can return a tuple with the key and
value in list-context.

=signature iterator

  iterator() (coderef)

=metadata iterator

{
  since => '0.01',
}

=example-1 iterator

  # given: synopsis;

  my $iterator = $array->iterator;

  # sub { ... }

  # while (my $value = $iterator->()) {
  #   say $value; # 1
  # }

=cut

$test->for('example', 1, 'iterator', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  while (my $value = $result->()) {
    ok $value =~ m{\d};
  }

  $result
});

=example-2 iterator

  # given: synopsis;

  my $iterator = $array->iterator;

  # sub { ... }

  # while (grep defined, my ($key, $value) = $iterator->()) {
  #   say $value; # 1
  # }

=cut

$test->for('example', 2, 'iterator', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  while (grep defined, my ($key, $value) = $result->()) {
    ok $key =~ m{\d};
    ok $value =~ m{\d};
  }

  $result
});

=method join

The join method returns a string consisting of all the elements in the array
joined by the join-string specified by the argument. Note: If the argument is
omitted, an empty string will be used as the join-string.

=signature join

  join(string $seperator) (string)

=metadata join

{
  since => '0.01',
}

=example-1 join

  # given: synopsis;

  my $join = $array->join;

  # 123456789

=cut

$test->for('example', 1, 'join', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 123456789;

  $result
});

=example-2 join

  # given: synopsis;

  my $join = $array->join(', ');

  # "1, 2, 3, 4, 5, 6, 7, 8, 9"

=cut

$test->for('example', 2, 'join', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "1, 2, 3, 4, 5, 6, 7, 8, 9";

  $result
});

=method keyed

The keyed method returns a hash reference where the arguments become the keys,
and the elements of the array become the values.

=signature keyed

  keyed(string @keys) (hashref)

=metadata keyed

{
  since => '0.01',
}

=example-1 keyed

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([1..4]);

  my $keyed = $array->keyed('a'..'d');

  # { a => 1, b => 2, c => 3, d => 4 }

=cut

$test->for('example', 1, 'keyed', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, { a => 1, b => 2, c => 3, d => 4 };

  $result
});

=method keys

The keys method returns an array reference consisting of the indicies of the
array.

=signature keys

  keys() (arrayref)

=metadata keys

{
  since => '0.01',
}

=example-1 keys

  # given: synopsis;

  my $keys = $array->keys;

  # [0..8]

=cut

$test->for('example', 1, 'keys', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [0..8];

  $result
});

=method last

The last method returns the value of the last element in the array.

=signature last

  last() (any)

=metadata last

{
  since => '0.01',
}

=example-1 last

  # given: synopsis;

  my $last = $array->last;

  # 9

=cut

$test->for('example', 1, 'last', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 9;

  $result
});

=method le

The le method performs a I<"lesser-than-or-equal-to"> operation using the
argument provided.

=signature le

  le(any $arg) (boolean)

=metadata le

{
  since => '0.08',
}

=example-1 le

  package main;

  use Venus::Array;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Array->new;

  my $result = $lvalue->le($rvalue);

  # 1

=cut

$test->for('example', 1, 'le', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-2 le

  package main;

  use Venus::Array;
  use Venus::Code;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Code->new;

  my $result = $lvalue->le($rvalue);

  # 1

=cut

$test->for('example', 2, 'le', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-3 le

  package main;

  use Venus::Array;
  use Venus::Float;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Float->new;

  my $result = $lvalue->le($rvalue);

  # 0

=cut

$test->for('example', 3, 'le', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-4 le

  package main;

  use Venus::Array;
  use Venus::Hash;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Hash->new;

  my $result = $lvalue->le($rvalue);

  # 0

=cut

$test->for('example', 4, 'le', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-5 le

  package main;

  use Venus::Array;
  use Venus::Number;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Number->new;

  my $result = $lvalue->le($rvalue);

  # 0

=cut

$test->for('example', 5, 'le', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-6 le

  package main;

  use Venus::Array;
  use Venus::Regexp;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Regexp->new;

  my $result = $lvalue->le($rvalue);

  # 1

=cut

$test->for('example', 6, 'le', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-7 le

  package main;

  use Venus::Array;
  use Venus::Scalar;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Scalar->new;

  my $result = $lvalue->le($rvalue);

  # 0

=cut

$test->for('example', 7, 'le', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-8 le

  package main;

  use Venus::Array;
  use Venus::String;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::String->new;

  my $result = $lvalue->le($rvalue);

  # 0

=cut

$test->for('example', 8, 'le', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-9 le

  package main;

  use Venus::Array;
  use Venus::Undef;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Undef->new;

  my $result = $lvalue->le($rvalue);

  # 0

=cut

$test->for('example', 9, 'le', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=method length

The length method returns the number of elements within the array, and is an
alias for the L</count> method.

=signature length

  length() (number)

=metadata length

{
  since => '0.08',
}

=example-1 length

  # given: synopsis;

  my $length = $array->length;

  # 9

=cut

$test->for('example', 1, 'length', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 9;

  $result
});

=method list

The list method returns a shallow copy of the underlying array reference as an
array reference.

=signature list

  list() (any)

=metadata list

{
  since => '0.01',
}

=example-1 list

  # given: synopsis;

  my $list = $array->list;

  # 9

=cut

$test->for('example', 1, 'list', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 9;

  $result
});

=example-2 list

  # given: synopsis;

  my @list = $array->list;

  # (1..9)

=cut

$test->for('example', 2, 'list', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  is_deeply [@result], [1..9];

  @result
});

=method lt

The lt method performs a I<"lesser-than"> operation using the argument provided.

=signature lt

  lt(any $arg) (boolean)

=metadata lt

{
  since => '0.08',
}

=example-1 lt

  package main;

  use Venus::Array;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Array->new;

  my $result = $lvalue->lt($rvalue);

  # 0

=cut

$test->for('example', 1, 'lt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-2 lt

  package main;

  use Venus::Array;
  use Venus::Code;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Code->new;

  my $result = $lvalue->lt($rvalue);

  # 1

=cut

$test->for('example', 2, 'lt', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-3 lt

  package main;

  use Venus::Array;
  use Venus::Float;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Float->new;

  my $result = $lvalue->lt($rvalue);

  # 0

=cut

$test->for('example', 3, 'lt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-4 lt

  package main;

  use Venus::Array;
  use Venus::Hash;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Hash->new;

  my $result = $lvalue->lt($rvalue);

  # 0

=cut

$test->for('example', 4, 'lt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-5 lt

  package main;

  use Venus::Array;
  use Venus::Number;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Number->new;

  my $result = $lvalue->lt($rvalue);

  # 0

=cut

$test->for('example', 5, 'lt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-6 lt

  package main;

  use Venus::Array;
  use Venus::Regexp;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Regexp->new;

  my $result = $lvalue->lt($rvalue);

  # 1

=cut

$test->for('example', 6, 'lt', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-7 lt

  package main;

  use Venus::Array;
  use Venus::Scalar;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Scalar->new;

  my $result = $lvalue->lt($rvalue);

  # 0

=cut

$test->for('example', 7, 'lt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-8 lt

  package main;

  use Venus::Array;
  use Venus::String;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::String->new;

  my $result = $lvalue->lt($rvalue);

  # 0

=cut

$test->for('example', 8, 'lt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-9 lt

  package main;

  use Venus::Array;
  use Venus::Undef;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Undef->new;

  my $result = $lvalue->lt($rvalue);

  # 0

=cut

$test->for('example', 9, 'lt', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=method map

The map method iterates over each element in the array, executing the code
reference supplied in the argument, passing the routine the value at the
current position in the loop and returning a new array reference containing the
elements for which the argument returns a value or non-empty list. This method
can return a list of values in list-context.

=signature map

  map(coderef $code) (arrayref)

=metadata map

{
  since => '0.01',
}

=example-1 map

  # given: synopsis;

  my $map = $array->map(sub {
    $_ * 2
  });

  # [2, 4, 6, 8, 10, 12, 14, 16, 18]

=cut

$test->for('example', 1, 'map', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result,[2, 4, 6, 8, 10, 12, 14, 16, 18];

  $result
});

=example-2 map

  # given: synopsis;

  my $map = $array->map(sub {
    my ($key, $value) = @_;

    [$key, ($value * 2)]
  });

  # [
  #   [0, 2],
  #   [1, 4],
  #   [2, 6],
  #   [3, 8],
  #   [4, 10],
  #   [5, 12],
  #   [6, 14],
  #   [7, 16],
  #   [8, 18],
  # ]

=cut

$test->for('example', 2, 'map', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [
    [0, 2],
    [1, 4],
    [2, 6],
    [3, 8],
    [4, 10],
    [5, 12],
    [6, 14],
    [7, 16],
    [8, 18],
  ];

  $result
});

=method merge

The merge method returns an array reference where the elements in the array and
the elements in the argument(s) are merged. This operation performs a deep
merge and clones the datasets to ensure no side-effects.

=signature merge

  merge(arrayref @data) (arrayref)

=metadata merge

{
  since => '3.30',
}

=example-1 merge

  # given: synopsis;

  my $merge = $array->merge([10..15]);

  # [10..15,7,8,9]

=cut

$test->for('example', 1, 'merge', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [10..15,7,8,9];

  $result
});

=example-2 merge

  # given: synopsis;

  my $merge = $array->merge([1,2,{1..4},4..9]);

  # [1,2,{1..4},4..9]

=cut

$test->for('example', 2, 'merge', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,2,{1..4},4..9];

  $result
});

=method ne

The ne method performs a I<"not-equal-to"> operation using the argument provided.

=signature ne

  ne(any $arg) (boolean)

=metadata ne

{
  since => '0.08',
}

=example-1 ne

  package main;

  use Venus::Array;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Array->new;

  my $result = $lvalue->ne($rvalue);

  # 0

=cut

$test->for('example', 1, 'ne', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-2 ne

  package main;

  use Venus::Array;
  use Venus::Code;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Code->new;

  my $result = $lvalue->ne($rvalue);

  # 1

=cut

$test->for('example', 2, 'ne', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-3 ne

  package main;

  use Venus::Array;
  use Venus::Float;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Float->new;

  my $result = $lvalue->ne($rvalue);

  # 1

=cut

$test->for('example', 3, 'ne', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-4 ne

  package main;

  use Venus::Array;
  use Venus::Hash;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Hash->new;

  my $result = $lvalue->ne($rvalue);

  # 1

=cut

$test->for('example', 4, 'ne', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-5 ne

  package main;

  use Venus::Array;
  use Venus::Number;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Number->new;

  my $result = $lvalue->ne($rvalue);

  # 1

=cut

$test->for('example', 5, 'ne', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-6 ne

  package main;

  use Venus::Array;
  use Venus::Regexp;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Regexp->new;

  my $result = $lvalue->ne($rvalue);

  # 1

=cut

$test->for('example', 6, 'ne', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-7 ne

  package main;

  use Venus::Array;
  use Venus::Scalar;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Scalar->new;

  my $result = $lvalue->ne($rvalue);

  # 1

=cut

$test->for('example', 7, 'ne', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-8 ne

  package main;

  use Venus::Array;
  use Venus::String;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::String->new;

  my $result = $lvalue->ne($rvalue);

  # 1

=cut

$test->for('example', 8, 'ne', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-9 ne

  package main;

  use Venus::Array;
  use Venus::Undef;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Undef->new;

  my $result = $lvalue->ne($rvalue);

  # 1

=cut

$test->for('example', 9, 'ne', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=method new

The new method constructs an instance of the package.

=signature new

  new(any @args) (Venus::Array)

=metadata new

{
  since => '4.15',
}

=cut

=example-1 new

  package main;

  use Venus::Array;

  my $new = Venus::Array->new;

  # bless(..., "Venus::Array")

=cut

$test->for('example', 1, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Array');
  is_deeply $result->value, [];

  $result
});

=example-2 new

  package main;

  use Venus::Array;

  my $new = Venus::Array->new([1..9]);

  # bless(..., "Venus::Array")

=cut

$test->for('example', 2, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Array');
  is_deeply $result->value, [1..9];

  $result
});

=example-3 new

  package main;

  use Venus::Array;

  my $new = Venus::Array->new(value => [1..9]);

  # bless(..., "Venus::Array")

=cut

$test->for('example', 3, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Array');
  is_deeply $result->value, [1..9];

  $result
});

=method none

The none method returns true if none of the elements in the array meet the
criteria set by the operand and rvalue.

=signature none

  none(coderef $code) (boolean)

=metadata none

{
  since => '0.01',
}

=example-1 none

  # given: synopsis;

  my $none = $array->none(sub {
    $_ < 1
  });

  # 1

=cut

$test->for('example', 1, 'none', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-2 none

  # given: synopsis;

  my $none = $array->none(sub {
    my ($key, $value) = @_;

    $value < 1
  });

  # 1

=cut

$test->for('example', 2, 'none', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method one

The one method returns true if only one of the elements in the array meet the
criteria set by the operand and rvalue.

=signature one

  one(coderef $code) (boolean)

=metadata one

{
  since => '0.01',
}

=example-1 one

  # given: synopsis;

  my $one = $array->one(sub {
    $_ == 1
  });

  # 1

=cut

$test->for('example', 1, 'one', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-2 one

  # given: synopsis;

  my $one = $array->one(sub {
    my ($key, $value) = @_;

    $value == 1
  });

  # 1

=cut

$test->for('example', 2, 'one', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method order

The order method reorders the array items based on the indices provided and
returns the invocant.

=signature order

  order(number @indices) (Venus::Array)

=metadata order

{
  since => '2.01',
}

=example-1 order

  # given: synopsis;

  my $order = $array->order;

  # bless({ value => [1..9] }, "Venus::Array")

=cut

$test->for('example', 1, 'order', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result->get, [1..9];

  $result
});

=example-2 order

  # given: synopsis;

  my $order = $array->order(8,7,6);

  # bless({ value => [9,8,7,1,2,3,4,5,6] }, "Venus::Array")

=cut

$test->for('example', 2, 'order', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result->get, [9,8,7,1,2,3,4,5,6];

  $result
});

=example-3 order

  # given: synopsis;

  my $order = $array->order(0,2,1);

  # bless({ value => [1,3,2,4,5,6,7,8,9] }, "Venus::Array")

=cut

$test->for('example', 3, 'order', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result->get, [1,3,2,4,5,6,7,8,9];

  $result
});

=method pairs

The pairs method is an alias to the pairs_array method. This method can return
a list of values in list-context.

=signature pairs

  pairs() (arrayref)

=metadata pairs

{
  since => '0.01',
}

=example-1 pairs

  # given: synopsis;

  my $pairs = $array->pairs;

  # [
  #   [0, 1],
  #   [1, 2],
  #   [2, 3],
  #   [3, 4],
  #   [4, 5],
  #   [5, 6],
  #   [6, 7],
  #   [7, 8],
  #   [8, 9],
  # ]

=cut

$test->for('example', 1, 'pairs', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [
    [0, 1],
    [1, 2],
    [2, 3],
    [3, 4],
    [4, 5],
    [5, 6],
    [6, 7],
    [7, 8],
    [8, 9],
  ];

  $result
});

=method path

The path method traverses the data structure using the path expr provided,
returning the value found or undef. In list-context, this method returns a
tuple, i.e. the value found and boolean representing whether the match was
successful.

=signature path

  path(string $expr) (any)

=metadata path

{
  since => '0.01',
}

=example-1 path

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([{'foo' => {'bar' => 'baz'}}, 'bar', ['baz']]);

  my $path = $array->path('/0/foo');

  # { bar => "baz" }

=cut

$test->for('example', 1, 'path', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, { bar => "baz" };

  $result
});

=example-2 path

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([{'foo' => {'bar' => 'baz'}}, 'bar', ['baz']]);

  my $path = $array->path('/0/foo/bar');

  # "baz"

=cut

$test->for('example', 2, 'path', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'baz';

  $result
});

=example-3 path

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([{'foo' => {'bar' => 'baz'}}, 'bar', ['baz']]);

  my $path = $array->path('/2/0');

  # "baz"

=cut

$test->for('example', 3, 'path', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'baz';

  $result
});

=example-4 path

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([{'foo' => {'bar' => 'baz'}}, 'bar', ['baz']]);

  my @path = $array->path('/3/0');

  # (undef, 0)

=cut

$test->for('example', 4, 'path', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  ok @result == 2;
  ok !defined $result[0];
  ok $result[1] == 0;

  @result
});

=method part

The part method iterates over each element in the array, executing the code
reference supplied in the argument, using the result of the code reference to
partition to array into two distinct array references. This method can return a
list of values in list-context.

=signature part

  part(coderef $code) (tuple[arrayref, arrayref])

=metadata part

{
  since => '0.01',
}

=example-1 part

  # given: synopsis;

  my $part = $array->part(sub {
    $_ > 5
  });

  # [[6..9], [1..5]]

=cut

$test->for('example', 1, 'part', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [[6..9], [1..5]];

  $result
});

=example-2 part

  # given: synopsis;

  my $part = $array->part(sub {
    my ($key, $value) = @_;

    $value < 5
  });

  # [[1..4], [5..9]]

=cut

$test->for('example', 2, 'part', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [[1..4], [5..9]];

  $result
});

=method pop

The pop method returns the last element of the array shortening it by one.
Note, this method modifies the array.

=signature pop

  pop() (any)

=metadata pop

{
  since => '0.01',
}

=example-1 pop

  # given: synopsis;

  my $pop = $array->pop;

  # 9

=cut

$test->for('example', 1, 'pop', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 9;

  $result
});

=method push

The push method appends the array by pushing the agruments onto it and returns
itself.

=signature push

  push(any @data) (arrayref)

=metadata push

{
  since => '0.01',
}

=example-1 push

  # given: synopsis;

  my $push = $array->push(10);

  # [1..10]

=cut

$test->for('example', 1, 'push', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1..10];

  $result
});

=method puts

The puts method select values from within the underlying data structure using
L<Venus::Array/path>, optionally assigning the value to the preceeding scalar
reference and returns all the values selected.

=signature puts

  puts(any @args) (arrayref)

=metadata puts

{
  since => '3.20',
}

=cut

=example-1 puts

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([
    {
      fruit => "apple",
      size => "small",
      color => "red",
    },
    {
      fruit => "lemon",
      size => "large",
      color => "yellow",
    },
  ]);

  my $puts = $array->puts(undef, '0.fruit', undef, '1.fruit');

  # ["apple", "lemon"]

=cut

$test->for('example', 1, 'puts', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, ["apple", "lemon"];

  $result
});

=example-2 puts

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([
    {
      fruit => "apple",
      size => "small",
      color => "red",
    },
    {
      fruit => "lemon",
      size => "large",
      color => "yellow",
    },
  ]);

  $array->puts(\my $fruit1, '0.fruit', \my $fruit2, '1.fruit');

  my $puts = [$fruit1, $fruit2];

  # ["apple", "lemon"]

=cut

$test->for('example', 2, 'puts', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, ["apple", "lemon"];

  $result
});

=example-3 puts

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([
    {
      fruit => "apple",
      size => "small",
      color => "red",
    },
    {
      fruit => "lemon",
      size => "large",
      color => "yellow",
    },
  ]);

  $array->puts(
    \my $fruit1, '0.fruit',
    \my $fruit2, '1.fruit',
    \my $fruit3, '2.fruit',
  );

  my $puts = [$fruit1, $fruit2, $fruit3];

  # ["apple", "lemon", undef]

=cut

$test->for('example', 3, 'puts', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, ["apple", "lemon", undef];

  $result
});

=example-4 puts

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([1..20]);

  $array->puts(
    \my $a, '0',
    \my $b, '1',
    \my $m, ['', '2:-2'],
    \my $x, '18',
    \my $y, '19',
  );

  my $puts = [$a, $b, $m, $x, $y];

  # [1, 2, [3..19], 19, 20]

=cut

$test->for('example', 4, 'puts', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [1, 2, [3..19], 19, 20];

  $result
});

=example-5 puts

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([[{1..4}, {1..4}]]);

  $array->puts(\my $a, '0');

  my $puts = $a;

  # [{1..4}, {1..4}]

=cut

$test->for('example', 5, 'puts', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [{1..4}, {1..4}];

  $result
});

=method random

The random method returns a random element from the array.

=signature random

  random() (any)

=metadata random

{
  since => '0.01',
}

=example-1 random

  # given: synopsis;

  my $random = $array->random;

  # 2

  # my $random = $array->random;

  # 1

=cut

$test->for('example', 1, 'random', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;

  $result
});

=method range

The range method accepts a I<"range expression"> and returns the result of
calling the L</slice> method with the computed range.

=signature range

  range(number | string @args) (arrayref)

=metadata range

{
  since => '2.55',
}

=cut

=example-1 range

  # given: synopsis

  package main;

  my $range = $array->range;

  # []

=cut

$test->for('example', 1, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=example-2 range

  # given: synopsis

  package main;

  my $range = $array->range(0);

  # [1]

=cut

$test->for('example', 2, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [1];

  $result
});

=example-3 range

  # given: synopsis

  package main;

  my $range = $array->range('0:');

  # [1..9]

=cut

$test->for('example', 3, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [1..9];

  $result
});

=example-4 range

  # given: synopsis

  package main;

  my $range = $array->range(':4');

  # [1..5]

=cut

$test->for('example', 4, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [1..5];

  $result
});

=example-5 range

  # given: synopsis

  package main;

  my $range = $array->range('8:');

  # [9]

=cut

$test->for('example', 5, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [9];

  $result
});

=example-6 range

  # given: synopsis

  package main;

  my $range = $array->range('4:');

  # [5..9]

=cut

$test->for('example', 6, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [5..9];

  $result
});

=example-7 range

  # given: synopsis

  package main;

  my $range = $array->range('0:2');

  # [1..3]

=cut

$test->for('example', 7, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [1..3];

  $result
});

=example-8 range

  # given: synopsis

  package main;

  my $range = $array->range('2:4');

  # [3..5]

=cut

$test->for('example', 8, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [3..5];

  $result
});

=example-9 range

  # given: synopsis

  package main;

  my $range = $array->range(0..3);

  # [1..4]

=cut

$test->for('example', 9, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [1..4];

  $result
});

=example-10 range

  # given: synopsis

  package main;

  my $range = $array->range('-1:8');

  # [9]

=cut

$test->for('example', 10, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [9];

  $result
});

=example-11 range

  # given: synopsis

  package main;

  my $range = $array->range('0:8');

  # [1..9]

=cut

$test->for('example', 11, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [1..9];

  $result
});

=example-12 range

  # given: synopsis

  package main;

  my $range = $array->range('0:-2');

  # [1..8]

=cut

$test->for('example', 12, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [1..8];

  $result
});

=example-13 range

  # given: synopsis

  package main;

  my $range = $array->range('-2:-2');

  # [8]

=cut

$test->for('example', 13, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [8];

  $result
});

=example-14 range

  # given: synopsis

  package main;

  my $range = $array->range('0:-20');

  # []

=cut

$test->for('example', 14, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=example-15 range

  # given: synopsis

  package main;

  my $range = $array->range('-2:-20');

  # []

=cut

$test->for('example', 15, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=example-16 range

  # given: synopsis

  package main;

  my $range = $array->range('-2:-6');

  # []

=cut

$test->for('example', 16, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=example-17 range

  # given: synopsis

  package main;

  my $range = $array->range('-2:-8');

  # []

=cut

$test->for('example', 17, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=example-18 range

  # given: synopsis

  package main;

  my $range = $array->range('-2:-9');

  # []

=cut

$test->for('example', 18, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=example-19 range

  # given: synopsis

  package main;

  my $range = $array->range('-5:-1');

  # [5..9]

=cut

$test->for('example', 19, 'range', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, [5..9];

  $result
});

=method reverse

The reverse method returns an array reference containing the elements in the
array in reverse order.

=signature reverse

  reverse() (arrayref)

=metadata reverse

{
  since => '0.01',
}

=example-1 reverse

  # given: synopsis;

  my $reverse = $array->reverse;

  # [9, 8, 7, 6, 5, 4, 3, 2, 1]

=cut

$test->for('example', 1, 'reverse', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [9, 8, 7, 6, 5, 4, 3, 2, 1];

  $result
});

=method rotate

The rotate method rotates the elements in the array such that first elements
becomes the last element and the second element becomes the first element each
time this method is called.

=signature rotate

  rotate() (arrayref)

=metadata rotate

{
  since => '0.01',
}

=example-1 rotate

  # given: synopsis;

  my $rotate = $array->rotate;

  # [2..9, 1]

=cut

$test->for('example', 1, 'rotate', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [2..9, 1];

  $result
});

=method rsort

The rsort method returns an array reference containing the values in the array
sorted alphanumerically in reverse.

=signature rsort

  rsort() (arrayref)

=metadata rsort

{
  since => '0.01',
}

=example-1 rsort

  # given: synopsis;

  my $rsort = $array->rsort;

  # [9, 8, 7, 6, 5, 4, 3, 2, 1]

=cut

$test->for('example', 1, 'rsort', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [9, 8, 7, 6, 5, 4, 3, 2, 1];

  $result
});

=method sets

The sets method find values from within the underlying data structure using
L<Venus::Array/path>, where each argument pair is a selector and value, and
returns all the values provided. Returns a list in list context. Note, nested
data structures can be updated but not created.

=signature sets

  sets(string @args) (arrayref)

=metadata sets

{
  since => '4.15',
}

=cut

=example-1 sets

  package main;

  use Venus::Array;

  my $array = Venus::Array->new(['foo', {'bar' => 'baz'}, 'bar', ['baz']]);

  my $sets = $array->sets('3' => 'bar', '1.bar' => 'bar');

  # ['bar', 'bar']

=cut

$test->for('example', 1, 'sets', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, ['bar', 'bar'];
  my $array = Venus::Array->new(['foo', {'bar' => 'baz'}, 'bar', ['baz']]);
  $array->sets('3' => 'bar', '1.bar' => 'bar');
  is_deeply $array->get, ['foo', {'bar' => 'bar'}, 'bar', 'bar'];

  $result
});

=example-2 sets

  package main;

  use Venus::Array;

  my $array = Venus::Array->new(['foo', {'bar' => 'baz'}, 'bar', ['baz']]);

  my ($baz, $one_bar) = $array->sets('3' => 'bar', '1.bar' => 'bar');

  # ('bar', 'bar')

=cut

$test->for('example', 2, 'sets', sub {
  my ($tryable) = @_;
  my @result = $tryable->result;
  is_deeply \@result, ['bar', 'bar'];
  my $array = Venus::Array->new(['foo', {'bar' => 'baz'}, 'bar', ['baz']]);
  $array->sets('3' => 'bar', '1.bar' => 'bar');
  is_deeply $array->get, ['foo', {'bar' => 'bar'}, 'bar', 'bar'];

  @result
});

=example-3 sets

  package main;

  use Venus::Array;

  my $array = Venus::Array->new(['foo', {'bar' => 'baz'}, 'bar', ['baz']]);

  my $sets = $array->sets('3' => 'bar', '1.bar' => 'bar', '1.baz' => 'box');

  # ['bar', 'bar', 'box']

=cut

$test->for('example', 3, 'sets', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, ['bar', 'bar', 'box'];
  my $array = Venus::Array->new(['foo', {'bar' => 'baz'}, 'bar', ['baz']]);
  $array->sets('3' => 'bar', '1.bar' => 'bar', '1.baz' => 'box');
  is_deeply $array->get, ['foo', {'bar' => 'bar', 'baz' => 'box'}, 'bar', 'bar'];

  $result
});

=example-4 sets

  package main;

  use Venus::Array;

  my $array = Venus::Array->new(['foo', {'bar' => 'baz'}, 'bar', ['baz']]);

  my $sets = $array->sets('3' => 'bar', '1.bar' => 'bar', '1.bar.baz' => 'box');

  # ['bar', 'bar', 'box']

=cut

$test->for('example', 4, 'sets', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is_deeply $result, ['bar', 'bar', 'box'];
  my $array = Venus::Array->new(['foo', {'bar' => 'baz'}, 'bar', ['baz']]);
  $array->sets('3' => 'bar', '1.bar' => 'bar', '1.bar.baz' => 'box');
  is_deeply $array->get, ['foo', {'bar' => 'bar'}, 'bar', 'bar'];

  $result
});

=method shift

The shift method returns the first element of the array shortening it by one.

=signature shift

  shift() (any)

=metadata shift

{
  since => '0.01',
}

=example-1 shift

  # given: synopsis;

  my $shift = $array->shift;

  # 1

=cut

$test->for('example', 1, 'shift', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method shuffle

The shuffle method returns an array with the items in a randomized order.

=signature shuffle

  shuffle() (arrayref)

=metadata shuffle

{
  since => '1.40',
}

=example-1 shuffle

  # given: synopsis

  package main;

  my $shuffle = $array->shuffle;

  # [4, 5, 8, 7, 2, 9, 6, 3, 1]

=cut

$test->for('example', 1, 'shuffle', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  isnt "@$result", "1 2 3 4 5 6 7 8 9";

  $result
});

=method slice

The slice method returns a hash reference containing the elements in the array
at the index(es) specified in the arguments.

=signature slice

  slice(string @keys) (arrayref)

=metadata slice

{
  since => '0.01',
}

=example-1 slice

  # given: synopsis;

  my $slice = $array->slice(2, 4);

  # [3, 5]

=cut

$test->for('example', 1, 'slice', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [3, 5];

  $result
});

=method sort

The sort method returns an array reference containing the values in the array
sorted alphanumerically.

=signature sort

  sort() (arrayref)

=metadata sort

{
  since => '0.01',
}

=example-1 sort

  package main;

  use Venus::Array;

  my $array = Venus::Array->new(['d','c','b','a']);

  my $sort = $array->sort;

  # ["a".."d"]

=cut

$test->for('example', 1, 'sort', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["a".."d"];

  $result
});

=method tail

The tail method returns the bottommost elements, limited by the desired size
specified.

=signature tail

  tail(number $size) (arrayref)

=metadata tail

{
  since => '1.23',
}

=example-1 tail

  # given: synopsis;

  my $tail = $array->tail;

  # [9]

=cut

$test->for('example', 1, 'tail', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [9];

  $result
});

=example-2 tail

  # given: synopsis;

  my $tail = $array->tail(1);

  # [9]

=cut

$test->for('example', 2, 'tail', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [9];

  $result
});

=example-3 tail

  # given: synopsis;

  my $tail = $array->tail(2);

  # [8,9]

=cut

$test->for('example', 3, 'tail', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [8,9];

  $result
});

=example-4 tail

  # given: synopsis;

  my $tail = $array->tail(5);

  # [5..9]

=cut

$test->for('example', 4, 'tail', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [5..9];

  $result
});

=example-5 tail

  # given: synopsis;

  my $tail = $array->tail(20);

  # [1..9]

=cut

$test->for('example', 5, 'tail', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1,2,3,4,5,6,7,8,9];

  $result
});

=method tv

The tv method performs a I<"type-and-value-equal-to"> operation using argument
provided.

=signature tv

  tv(any $arg) (boolean)

=metadata tv

{
  since => '0.08',
}

=example-1 tv

  package main;

  use Venus::Array;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Array->new;

  my $result = $lvalue->tv($rvalue);

  # 1

=cut

$test->for('example', 1, 'tv', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

=example-2 tv

  package main;

  use Venus::Array;
  use Venus::Code;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Code->new;

  my $result = $lvalue->tv($rvalue);

  # 0

=cut

$test->for('example', 2, 'tv', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-3 tv

  package main;

  use Venus::Array;
  use Venus::Float;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Float->new;

  my $result = $lvalue->tv($rvalue);

  # 0

=cut

$test->for('example', 3, 'tv', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-4 tv

  package main;

  use Venus::Array;
  use Venus::Hash;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Hash->new;

  my $result = $lvalue->tv($rvalue);

  # 0

=cut

$test->for('example', 4, 'tv', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-5 tv

  package main;

  use Venus::Array;
  use Venus::Number;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Number->new;

  my $result = $lvalue->tv($rvalue);

  # 0

=cut

$test->for('example', 5, 'tv', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-6 tv

  package main;

  use Venus::Array;
  use Venus::Regexp;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Regexp->new;

  my $result = $lvalue->tv($rvalue);

  # 0

=cut

$test->for('example', 6, 'tv', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-7 tv

  package main;

  use Venus::Array;
  use Venus::Scalar;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Scalar->new;

  my $result = $lvalue->tv($rvalue);

  # 0

=cut

$test->for('example', 7, 'tv', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-8 tv

  package main;

  use Venus::Array;
  use Venus::String;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::String->new;

  my $result = $lvalue->tv($rvalue);

  # 0

=cut

$test->for('example', 8, 'tv', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=example-9 tv

  package main;

  use Venus::Array;
  use Venus::Undef;

  my $lvalue = Venus::Array->new;
  my $rvalue = Venus::Undef->new;

  my $result = $lvalue->tv($rvalue);

  # 0

=cut

$test->for('example', 9, 'tv', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  is $result, 0;

  !$result
});

=method unique

The unique method returns an array reference consisting of the unique elements
in the array.

=signature unique

  unique() (arrayref)

=metadata unique

{
  since => '0.01',
}

=example-1 unique

  package main;

  use Venus::Array;

  my $array = Venus::Array->new([1,1,1,1,2,3,1]);

  my $unique = $array->unique;

  # [1, 2, 3]

=cut

$test->for('example', 1, 'unique', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1, 2, 3];

  $result
});

=method unshift

The unshift method prepends the array by pushing the agruments onto it and
returns itself.

=signature unshift

  unshift(any @data) (arrayref)

=metadata unshift

{
  since => '0.01',
}

=example-1 unshift

  # given: synopsis;

  my $unshift = $array->unshift(-2,-1,0);

  # [-2..9]

=cut

$test->for('example', 1, 'unshift', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [-2..9];

  $result
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Array.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;