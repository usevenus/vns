package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;
use Venus;

use Venus 'catch';

my $test = test(__FILE__);

=name

Venus::Check

=cut

$test->for('name');

=tagline

Check Class

=cut

$test->for('tagline');

=abstract

Check Class for Perl 5

=cut

$test->for('abstract');

=includes

method: any
method: accept
method: array
method: arrayref
method: attributes
method: bool
method: boolean
method: branch
method: clear
method: code
method: coded
method: coderef
method: consumes
method: defined
method: dirhandle
method: either
method: enum
method: eval
method: evaled
method: evaler
method: fail
method: failed
method: filehandle
method: float
method: glob
method: hash
method: hashkeys
method: hashref
method: identity
method: includes
method: inherits
method: integrates
method: maybe
method: new
method: number
method: object
method: package
method: pass
method: passed
method: reference
method: regexp
method: result
method: routines
method: scalar
method: scalarref
method: string
method: tuple
method: undef
method: value
method: what
method: within
method: yesno

=cut

$test->for('includes');

=synopsis

  package main;

  use Venus::Check;

  my $check = Venus::Check->new;

  # $check->float;

  # my $result = $check->result(rand);

  # 0.1234567890

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Check');

  $result
});

=description

This package provides a mechanism for performing runtime dynamic type checking
on data.

=cut

$test->for('description');

=inherits

Venus::Kind::Utility

=cut

$test->for('inherits');

=integrates

Venus::Role::Buildable

=cut

$test->for('integrates');

=attribute on_eval

The on_eval attribute is read-write, accepts C<(ArrayRef[CodeRef])> values, and
is optional.

=signature on_eval

  on_eval(within[arrayref, coderef] $data) (within[arrayref, coderef])

=metadata on_eval

{
  since => '3.55',
}

=cut

=example-1 on_eval

  # given: synopsis

  package main;

  my $set_on_eval = $check->on_eval([sub{1}]);

  # [sub{1}]

=cut

$test->for('example', 1, 'on_eval', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok ref $result eq 'ARRAY';
  is @{$result}, 1;
  ok ref $result->[0], 'CODE';

  $result
});

=example-2 on_eval

  # given: synopsis

  # given: example-1 on_eval

  package main;

  my $get_on_eval = $check->on_eval;

  # [sub{1}]

=cut

$test->for('example', 2, 'on_eval', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok ref $result eq 'ARRAY';
  is @{$result}, 1;
  ok ref $result->[0], 'CODE';

  $result
});

=method any

The any method configures the object to accept any value and returns the
invocant.

=signature any

  any() (Venus::Check)

=metadata any

{
  since => '3.55',
}

=example-1 any

  # given: synopsis

  package main;

  $check = $check->any;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(1);

  # true

=cut

$test->for('example', 1, 'any', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(0), true;
  is $result->eval(1), true;
  is $result->eval({}), true;
  is $result->eval([]), true;
  is $result->eval(bless{}), true;

  $result
});

=example-2 any

  # given: synopsis

  package main;

  $check = $check->any;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(bless{});

  # true

=cut

$test->for('example', 2, 'any', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');

  $result
});

=method accept

The accept method configures the object to accept the conditions or identity
provided and returns the invocant. This method dispatches to the method(s)
specified, or to the L</identity> method otherwise.

=signature accept

  accept(string $name, string | within[arrayref, string] @args) (Venus::Check)

=metadata accept

{
  since => '3.55',
}

=example-1 accept

  # given: synopsis

  package main;

  $check = $check->accept('string');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('okay');

  # true

=cut

$test->for('example', 1, 'accept', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval('okay'), 1;
  is $result->eval(''), 1;
  is $result->eval(12345), 0;

  $result
});

=example-2 accept

  # given: synopsis

  package main;

  $check = $check->accept('string');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(12345);

  # false

=cut

$test->for('example', 2, 'accept', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(12345), 0;

  $result
});

=example-3 accept

  # given: synopsis

  package main;

  $check = $check->accept('string');

  # bless(..., 'Venus::Check')

  # my $result = $check->result('okay');

  # 'okay'

=cut

$test->for('example', 3, 'accept', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result('okay');
  is_deeply $return, 'okay';

  $result
});

=example-4 accept

  # given: synopsis

  package main;

  $check = $check->accept('string');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(12345);

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'accept', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 12345);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method array

The array method configures the object to accept array references and returns
the invocant.

=signature array

  array(coderef @code) (Venus::Check)

=metadata array

{
  since => '3.55',
}

=example-1 array

  # given: synopsis

  package main;

  $check = $check->array;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval([]);

  # true

=cut

$test->for('example', 1, 'array', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval([]), 1;
  is $result->eval(0), 0;
  is $result->eval({}), 0;
  is $result->eval(bless{}), 0;

  $result
});

=example-2 array

  # given: synopsis

  package main;

  $check = $check->array;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({});

  # false

=cut

$test->for('example', 2, 'array', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({}), 0;

  $result
});

=example-3 array

  # given: synopsis

  package main;

  $check = $check->array;

  # bless(..., 'Venus::Check')

  # my $result = $check->result([1..4]);

  # [1..4]

=cut

$test->for('example', 3, 'array', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result([1..4]);
  is_deeply $return, [1..4];

  $result
});

=example-4 array

  # given: synopsis

  package main;

  $check = $check->array;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({1..4});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'array', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {1..4});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method arrayref

The arrayref method configures the object to accept array references and returns
the invocant.

=signature arrayref

  arrayref(coderef @code) (Venus::Check)

=metadata arrayref

{
  since => '3.55',
}

=example-1 arrayref

  # given: synopsis

  package main;

  $check = $check->arrayref;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval([]);

  # true

=cut

$test->for('example', 1, 'arrayref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval([]), 1;
  is $result->eval(0), 0;
  is $result->eval({}), 0;
  is $result->eval(bless{}), 0;

  $result
});

=example-2 arrayref

  # given: synopsis

  package main;

  $check = $check->arrayref;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({});

  # false

=cut

$test->for('example', 2, 'arrayref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({}), 0;

  $result
});

=example-3 arrayref

  # given: synopsis

  package main;

  $check = $check->arrayref;

  # bless(..., 'Venus::Check')

  # my $result = $check->result([1..4]);

  # [1..4]

=cut

$test->for('example', 3, 'arrayref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result([1..4]);
  is_deeply $return, [1..4];

  $result
});

=example-4 arrayref

  # given: synopsis

  package main;

  $check = $check->arrayref;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({1..4});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'arrayref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {1..4});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method attributes

The attributes method configures the object to accept objects containing
attributes whose values' match the attribute names and types specified, and
returns the invocant.

=signature attributes

  attributes(string | within[arrayref, string] @args) (Venus::Check)

=metadata attributes

{
  since => '3.55',
}

=example-1 attributes

  # given: synopsis

  package Example;

  use Venus::Class 'attr';

  attr 'name';

  package main;

  $check = $check->attributes('name', 'string');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Example->new(name => 'test'));

  # true

=cut

$test->for('example', 1, 'attributes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Example->new(name => 'test')), 1;

  require Venus::Space;
  Venus::Space->new('Example')->unload;

  $result
});

=example-2 attributes

  # given: synopsis

  package Example;

  use Venus::Class 'attr';

  attr 'name';

  package main;

  $check = $check->attributes('name', 'string');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Example->new);

  # false

=cut

$test->for('example', 2, 'attributes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Example->new), 0;

  require Venus::Space;
  Venus::Space->new('Example')->unload;

  $result
});

=example-3 attributes

  # given: synopsis

  package Example;

  use Venus::Class 'attr';

  attr 'name';

  package main;

  $check = $check->attributes('name', 'string');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Example->new(name => 'test'));

  # bless(..., 'Example')

=cut

$test->for('example', 3, 'attributes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(Example->new(name => 'test'));
  ok $return->isa('Example');

  require Venus::Space;
  Venus::Space->new('Example')->unload;

  $result
});

=example-4 attributes

  # given: synopsis

  package Example;

  use Venus::Class 'attr';

  attr 'name';

  package main;

  $check = $check->attributes('name', 'string');

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'attributes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  require Venus::Space;
  Venus::Space->new('Example')->unload;

  $result
});

=example-5 attributes

  # given: synopsis

  package Example;

  use Venus::Class 'attr';

  attr 'name';

  package main;

  $check = $check->attributes('name', 'string', 'age');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Example->new);

  # Exception! (isa Venus::Check::Error) (see error_on_pairs)

=cut

$test->for('example', 5, 'attributes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', Example->new);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.pairs';

  require Venus::Space;
  Venus::Space->new('Example')->unload;

  $result
});

=example-6 attributes

  # given: synopsis

  package Example;

  use Venus::Class;

  package main;

  $check = $check->attributes('name', 'string');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Example->new);

  # Exception! (isa Venus::Check::Error) (see error_on_missing)

=cut

$test->for('example', 6, 'attributes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', Example->new);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.missing';

  require Venus::Space;
  Venus::Space->new('Example')->unload;

  $result
});

=example-7 attributes

  # given: synopsis

  package Example;

  use Venus::Class 'attr';

  attr 'name';

  package main;

  $check = $check->attributes('name', 'string');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Example->new(name => rand));

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 7, 'attributes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', Example->new(name => rand));
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  require Venus::Space;
  Venus::Space->new('Example')->unload;

  $result
});

=method bool

The bool method configures the object to accept boolean values and returns the
invocant.

=signature bool

  bool(coderef @code) (Venus::Check)

=metadata bool

{
  since => '3.55',
}

=example-1 bool

  # given: synopsis

  package main;

  use Venus;

  $check = $check->bool;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(true);

  # true

=cut

$test->for('example', 1, 'bool', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(true), 1;
  is $result->eval(false), 1;
  is $result->eval(0), 0;
  is $result->eval(1), 0;
  is $result->eval(bless{}), 0;

  $result
});

=example-2 bool

  # given: synopsis

  package main;

  use Venus;

  $check = $check->bool;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(1);

  # false

=cut

$test->for('example', 2, 'bool', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(9), 0;

  $result
});

=example-3 bool

  # given: synopsis

  package main;

  use Venus;

  $check = $check->bool;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(true);

  # true

=cut

$test->for('example', 3, 'bool', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(true);
  is $return, 1;

  $result
});

=example-4 bool

  # given: synopsis

  package main;

  use Venus;

  $check = $check->bool;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(1);

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'bool', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 1);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method boolean

The boolean method configures the object to accept boolean values and returns
the invocant.

=signature boolean

  boolean(coderef @code) (Venus::Check)

=metadata boolean

{
  since => '3.55',
}

=example-1 boolean

  # given: synopsis

  package main;

  use Venus;

  $check = $check->boolean;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(true);

  # true

=cut

$test->for('example', 1, 'boolean', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(true), 1;
  is $result->eval(false), 1;
  is $result->eval(0), 0;
  is $result->eval(1), 0;
  is $result->eval(bless{}), 0;

  $result
});

=example-2 boolean

  # given: synopsis

  package main;

  use Venus;

  $check = $check->boolean;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(1);

  # false

=cut

$test->for('example', 2, 'boolean', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(9), 0;

  $result
});

=example-3 boolean

  # given: synopsis

  package main;

  use Venus;

  $check = $check->boolean;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(true);

  # true

=cut

$test->for('example', 3, 'boolean', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(true);
  is $return, 1;

  $result
});

=example-4 boolean

  # given: synopsis

  package main;

  use Venus;

  $check = $check->boolean;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(1);

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'boolean', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 1);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method branch

The branch method returns a new L<Venus::Check> object configured to evaluate a
branch of logic from its source.

=signature branch

  branch(string @args) (Venus::Check)

=metadata branch

{
  since => '3.55',
}

=example-1 branch

  # given: synopsis

  package main;

  my $branch = $check->branch('nested');

  # bless(..., 'Venus::Check')

=cut

$test->for('example', 1, 'branch', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is_deeply $result->{'$branch'}, ['nested'];

  $result
});

=method clear

The clear method resets all registered conditions and returns the invocant.

=signature clear

  clear() (Venus::Check)

=metadata clear

{
  since => '3.55',
}

=example-1 clear

  # given: synopsis

  package main;

  $check->any;

  $check = $check->clear;

  # bless(..., 'Venus::Check')

=cut

$test->for('example', 1, 'clear', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is_deeply $result->on_eval, [];

  $result
});

=method code

The code method configures the object to accept code references and returns
the invocant.

=signature code

  code(coderef @code) (Venus::Check)

=metadata code

{
  since => '3.55',
}

=example-1 code

  # given: synopsis

  package main;

  $check = $check->code;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(sub{});

  # true

=cut

$test->for('example', 1, 'code', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(sub{}), true;
  is $result->eval(undef), false;
  is $result->eval(0), false;
  is $result->eval(1), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 code

  # given: synopsis

  package main;

  $check = $check->code;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({});

  # false

=cut

$test->for('example', 2, 'code', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({}), false;

  $result
});

=example-3 code

  # given: synopsis

  package main;

  $check = $check->code;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(sub{});

  # sub{}

=cut

$test->for('example', 3, 'code', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(sub{});
  ok ref $return eq 'CODE';

  $result
});

=example-4 code

  # given: synopsis

  package main;

  $check = $check->code;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'code', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method coded

The coded method accepts a value and a type name returns the result of a
L<Venus::What/coded> operation.

=signature coded

  coded(any $data, string $name) (Venus::Check)

=metadata coded

{
  since => '3.55',
}

=example-1 coded

  # given: synopsis

  package main;

  $check = $check->coded('hello', 'string');

  # true

=cut

$test->for('example', 1, 'coded', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, true;

  $result
});

=example-2 coded

  # given: synopsis

  package main;

  $check = $check->coded(12345, 'string');

  # false

=cut

$test->for('example', 2, 'coded', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, false;

  !$result
});

=method coderef

The coderef method configures the object to accept code references and returns
the invocant.

=signature coderef

  coderef(coderef @code) (Venus::Check)

=metadata coderef

{
  since => '3.55',
}

=example-1 coderef

  # given: synopsis

  package main;

  $check = $check->coderef;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(sub{});

  # true

=cut

$test->for('example', 1, 'coderef', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(sub{}), true;
  is $result->eval(undef), false;
  is $result->eval(0), false;
  is $result->eval(1), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 coderef

  # given: synopsis

  package main;

  $check = $check->coderef;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({});

  # false

=cut

$test->for('example', 2, 'coderef', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({}), false;

  $result
});

=example-3 coderef

  # given: synopsis

  package main;

  $check = $check->coderef;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(sub{});

  # sub{}

=cut

$test->for('example', 3, 'coderef', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(sub{});
  ok ref $return eq 'CODE';

  $result
});

=example-4 coderef

  # given: synopsis

  package main;

  $check = $check->coderef;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'coderef', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method consumes

The consumes method configures the object to accept objects which consume the
role provided, and returns the invocant.

=signature consumes

  consumes(string $role) (Venus::Check)

=metadata consumes

{
  since => '3.55',
}

=example-1 consumes

  # given: synopsis

  package Example;

  use Venus::Class 'base';

  base 'Venus::Kind';

  package main;

  $check = $check->consumes('Venus::Role::Throwable');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Example->new);

  # true

=cut

$test->for('example', 1, 'consumes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Example->new), true;
  is $result->eval(undef), false;
  is $result->eval(0), false;
  is $result->eval(1), false;
  is $result->eval(bless{}), false;

  require Venus::Space;
  Venus::Space->new('Example')->unload;

  $result
});

=example-2 consumes

  # given: synopsis

  package Example;

  use Venus::Class 'base';

  base 'Venus::Kind';

  package main;

  $check = $check->consumes('Venus::Role::Knowable');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Example->new);

  # false

=cut

$test->for('example', 2, 'consumes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Example->new), false;

  require Venus::Space;
  Venus::Space->new('Example')->unload;

  $result
});

=example-3 consumes

  # given: synopsis

  package Example;

  use Venus::Class 'base';

  base 'Venus::Kind';

  package main;

  $check = $check->consumes('Venus::Role::Throwable');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Example->new);

  # bless(..., 'Example')

=cut

$test->for('example', 3, 'consumes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(Example->new);
  ok $return->isa('Example');

  require Venus::Space;
  Venus::Space->new('Example')->unload;

  $result
});

=example-4 consumes

  # given: synopsis

  package main;

  $check = $check->consumes('Venus::Role::Knowable');

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'consumes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=example-5 consumes

  # given: synopsis

  package Example;

  use Venus::Class 'base';

  base 'Venus::Kind';

  package main;

  $check = $check->consumes('Venus::Role::Knowable');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Example->new);

  # Exception! (isa Venus::Check::Error) (see error_on_consumes)

=cut

$test->for('example', 5, 'consumes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', Example->new);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.consumes';

  require Venus::Space;
  Venus::Space->new('Example')->unload;

  $result
});

=method defined

The defined method configures the object to accept any value that's not
undefined and returns the invocant.

=signature defined

  defined(coderef @code) (Venus::Check)

=metadata defined

{
  since => '3.55',
}

=example-1 defined

  # given: synopsis

  package main;

  $check = $check->defined;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('');

  # true

=cut

$test->for('example', 1, 'defined', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(''), true;
  is $result->eval(0), true;
  is $result->eval(undef), false;
  is $result->eval(1), true;
  is $result->eval(bless{}), true;

  $result
});

=example-2 defined

  # given: synopsis

  package main;

  $check = $check->defined;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(undef);

  # false

=cut

$test->for('example', 2, 'defined', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(undef), false;

  $result
});

=example-3 defined

  # given: synopsis

  package main;

  $check = $check->defined;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('');

  # ''

=cut

$test->for('example', 3, 'defined', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result('');
  is $return, '';

  $result
});

=example-4 defined

  # given: synopsis

  package main;

  $check = $check->defined;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(undef);

  # Exception! (isa Venus::Check::Error) (see error_on_defined)

=cut

$test->for('example', 4, 'defined', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', undef);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.defined';

  $result
});

=method dirhandle

The dirhandle method configures the object to accept dirhandles and returns the
invocant.

=signature dirhandle

  dirhandle(coderef @code) (Venus::Check)

=metadata dirhandle

{
  since => '4.15',
}

=cut

=example-1 dirhandle

  # given: synopsis

  package main;

  $check = $check->dirhandle;

  # bless(..., 'Venus::Check')

  # opendir my $dh, './t';

  # my $result = $check->eval($dh);

  # true

=cut

$test->for('example', 1, 'dirhandle', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  opendir my $dh, './t';
  is $result->eval($dh), true;
  is $result->eval(\*STDIN), false;
  is $result->eval(\*STDOUT), false;
  is $result->eval(\*STDERR), false;

  $result
});

=example-2 dirhandle

  # given: synopsis

  package main;

  $check = $check->dirhandle;

  # bless(..., 'Venus::Check')

  # opendir my $dh, './xyz';

  # my $result = $check->eval($dh);

  # false

=cut

$test->for('example', 2, 'dirhandle', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  opendir my $dh, './xyz';
  is $result->eval($dh), false;
  is $result->eval(\*STDIN), false;
  is $result->eval(\*STDOUT), false;
  is $result->eval(\*STDERR), false;

  $result
});

=example-3 dirhandle

  # given: synopsis

  package main;

  $check = $check->dirhandle;

  # bless(..., 'Venus::Check')

  # opendir my $dh, './t';

  # my $result = $check->result($dh);

  # \*{'::$dh'}

=cut

$test->for('example', 3, 'dirhandle', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  opendir my $dh, './t';
  is $result->result($dh), $dh;

  $result
});

=example-4 dirhandle

  # given: synopsis

  package main;

  $check = $check->dirhandle;

  # bless(..., 'Venus::Check')

  # opendir my $dh, './xyz';

  # my $result = $check->result($dh);

  # Exception! (isa Venus::Check::Error) (see error_on_dirhandle)

=cut

$test->for('example', 4, 'dirhandle', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  opendir my $dh, './xyz';
  my $return = $result->catch('result', $dh);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.dirhandle';

  $result
});

=method either

The either method configures the object to accept "either" of the conditions
provided, which may be a string or arrayref representing a method call, and
returns the invocant.

=signature either

  either(string | within[arrayref, string] @args) (Venus::Check)

=metadata either

{
  since => '3.55',
}

=example-1 either

  # given: synopsis

  package main;

  $check = $check->either('string', 'number');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('hello');

  # true

=cut

$test->for('example', 1, 'either', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval('hello'), true;
  is $result->eval(12345), true;
  is $result->eval(bless{}), false;

  $result
});

=example-2 either

  # given: synopsis

  package main;

  $check = $check->either('string', 'number');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(rand);

  # false

=cut

$test->for('example', 2, 'either', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(rand), false;

  $result
});

=example-3 either

  # given: synopsis

  package main;

  $check = $check->either('string', 'number');

  # bless(..., 'Venus::Check')

  # my $result = $check->result('hello');

  # 'hello'

=cut

$test->for('example', 3, 'either', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result('hello');
  is $return, 'hello';

  $result
});

=example-4 either

  # given: synopsis

  package main;

  $check = $check->either('string', 'number');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(rand);

  # Exception! (isa Venus::Check::Error) (see error_on_either)

=cut

$test->for('example', 4, 'either', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', rand);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.either';

  $result
});

=method enum

The enum method configures the object to accept any one of the provide options,
and returns the invocant.

=signature enum

  enum(string @args) (Venus::Check)

=metadata enum

{
  since => '3.55',
}

=example-1 enum

  # given: synopsis

  package main;

  $check = $check->enum('black', 'white', 'grey');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('black');

  # true

=cut

$test->for('example', 1, 'enum', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval('black'), true;
  is $result->eval('white'), true;
  is $result->eval('grey'), true;
  is $result->eval('purple'), false;

  $result
});

=example-2 enum

  # given: synopsis

  package main;

  $check = $check->enum('black', 'white', 'grey');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('purple');

  # false

=cut

$test->for('example', 2, 'enum', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval('purple'), false;

  $result
});

=example-3 enum

  # given: synopsis

  package main;

  $check = $check->enum('black', 'white', 'grey');

  # bless(..., 'Venus::Check')

  # my $result = $check->result('black');

  # 'black'

=cut

$test->for('example', 3, 'enum', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result('black');
  is $return, 'black';

  $result
});

=example-4 enum

  # given: synopsis

  package main;

  $check = $check->enum('black', 'white', 'grey');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(undef);

  # Exception! (isa Venus::Check::Error) (see error_on_defined)

=cut

$test->for('example', 4, 'enum', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', undef);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.defined';

  $result
});

=example-5 enum

  # given: synopsis

  package main;

  $check = $check->enum('black', 'white', 'grey');

  # bless(..., 'Venus::Check')

  # my $result = $check->result('purple');

  # Exception! (isa Venus::Check::Error) (see error_on_enum)

=cut

$test->for('example', 5, 'enum', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 'purple');
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.enum';

  $result
});

=method eval

The eval method returns true or false if the data provided passes the
registered conditions.

=signature eval

  eval(any $data) (any)

=metadata eval

{
  since => '3.55',
}

=example-1 eval

  # given: synopsis

  package main;

  my $eval = $check->eval;

  # false

=cut

$test->for('example', 1, 'eval', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, false;

  !$result
});

=example-2 eval

  # given: synopsis

  package main;

  my $eval = $check->any->eval('');

  # true

=cut

$test->for('example', 2, 'eval', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, true;

  $result
});

=method evaled

The evaled method returns true if L</eval> has previously been executed, and
false otherwise.

=signature evaled

  evaled() (boolean)

=metadata evaled

{
  since => '3.35',
}

=cut

=example-1 evaled

  # given: synopsis

  package main;

  my $evaled = $check->evaled;

  # false

=cut

$test->for('example', 1, 'evaled', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, false;

  !$result
});

=example-2 evaled

  # given: synopsis

  package main;

  $check->any->eval;

  my $evaled = $check->evaled;

  # true

=cut

$test->for('example', 2, 'evaled', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, true;

  $result
});

=method evaler

The evaler method returns a coderef which calls the L</eval> method with the
invocant when called.

=signature evaler

  evaler(any @args) (coderef)

=metadata evaler

{
  since => '3.55',
}

=example-1 evaler

  # given: synopsis

  package main;

  my $evaler = $check->evaler;

  # sub{...}

  # my $result = $evaler->();

  # false

=cut

$test->for('example', 1, 'evaler', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok ref $result eq 'CODE';
  is $result->(), false;

  $result
});

=example-2 evaler

  # given: synopsis

  package main;

  my $evaler = $check->any->evaler;

  # sub{...}

  # my $result = $evaler->();

  # true

=cut

$test->for('example', 2, 'evaler', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok ref $result eq 'CODE';
  is $result->(), true;

  $result
});

=method fail

The fail method captures data related to a failure and returns false.

=signature fail

  fail(any $data, hashref $meta) (boolean)

=metadata fail

{
  since => '3.55',
}

=example-1 fail

  # given: synopsis

  package main;

  my $fail = $check->fail('...', {
    from => 'caller',
  });

  # false

=cut

$test->for('example', 1, 'fail', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, false;

  !$result
});

=method failed

The failed method returns true if the result of the last operation was a
failure, otherwise returns false.

=signature failed

  failed() (boolean)

=metadata failed

{
  since => '3.55',
}

=example-1 failed

  # given: synopsis

  package main;

  my $failed = $check->failed;

  # false

=cut

$test->for('example', 1, 'failed', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, false;

  !$result
});

=example-2 failed

  # given: synopsis

  package main;

  $check->string->eval(12345);

  my $failed = $check->failed;

  # true

=cut

$test->for('example', 2, 'failed', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, true;

  $result
});

=example-3 failed

  # given: synopsis

  package main;

  $check->string->eval('hello');

  my $failed = $check->failed;

  # false

=cut

$test->for('example', 3, 'failed', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, false;

  !$result
});

=method filehandle

The filehandle method configures the object to accept filehandles and returns the
invocant.

=signature filehandle

  filehandle(coderef @code) (Venus::Check)

=metadata filehandle

{
  since => '4.15',
}

=cut

=example-1 filehandle

  # given: synopsis

  package main;

  $check = $check->filehandle;

  # bless(..., 'Venus::Check')

  # open my $fh, './t/Venus.t';

  # my $result = $check->eval($fh);

  # true

=cut

$test->for('example', 1, 'filehandle', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  open my $fh, '<', './t/Venus.t';
  is $result->eval($fh), true;
  is $result->eval(\*STDIN), true;
  is $result->eval(\*STDOUT), true;
  is $result->eval(\*STDERR), true;

  $result
});

=example-2 filehandle

  # given: synopsis

  package main;

  $check = $check->filehandle;

  # bless(..., 'Venus::Check')

  # open my $fh, './xyz/Venus.t';

  # my $result = $check->eval($fh);

  # false

=cut

$test->for('example', 2, 'filehandle', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  open my $fh, '<', './xyz/Venus.t';
  is $result->eval($fh), false;
  is $result->eval(\*STDIN), true;
  is $result->eval(\*STDOUT), true;
  is $result->eval(\*STDERR), true;

  $result
});

=example-3 filehandle

  # given: synopsis

  package main;

  $check = $check->filehandle;

  # bless(..., 'Venus::Check')

  # open my $fh, './t/Venus.t';

  # my $result = $check->result($fh);

  # \*{'::$fh'}

=cut

$test->for('example', 3, 'filehandle', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  open my $fh, '<', './t/Venus.t';
  is $result->result($fh), $fh;

  $result
});

=example-4 filehandle

  # given: synopsis

  package main;

  $check = $check->filehandle;

  # bless(..., 'Venus::Check')

  # open my $fh, './xyz/Venus.t';

  # my $result = $check->result($fh);

  # Exception! (isa Venus::Check::Error) (see error_on_filehandle)

=cut

$test->for('example', 4, 'filehandle', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  open my $fh, '<', './xyz/Venus.t';
  my $return = $result->catch('result', $fh);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.filehandle';

  $result
});

=method float

The float method configures the object to accept floating-point values and
returns the invocant.

=signature float

  float(coderef @code) (Venus::Check)

=metadata float

{
  since => '3.55',
}

=example-1 float

  # given: synopsis

  package main;

  $check = $check->float;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(1.2345);

  # true

=cut

$test->for('example', 1, 'float', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(1.2345), true;
  is $result->eval(1.23), true;
  is $result->eval(rand || '0.0'), true;
  is $result->eval(1), false;
  is $result->eval('0'), false;
  is $result->eval('1'), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 float

  # given: synopsis

  package main;

  $check = $check->float;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(12345);

  # false

=cut

$test->for('example', 2, 'float', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(12345), false;

  $result
});

=example-3 float

  # given: synopsis

  package main;

  $check = $check->float;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(1.2345);

  # 1.2345

=cut

$test->for('example', 3, 'float', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(1.2345);
  is $return, 1.2345;

  $result
});

=example-4 float

  # given: synopsis

  package main;

  $check = $check->float;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(12345);

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'float', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 12345);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method glob

The glob method configures the object to accept typeglobs and returns the
invocant.

=signature glob

  glob(coderef @code) (Venus::Check)

=metadata glob

{
  since => '4.15',
}

=cut

=example-1 glob

  # given: synopsis

  package main;

  $check = $check->glob;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(\*main);

  # true

=cut

$test->for('example', 1, 'glob', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(\*main), true;
  is $result->eval(0), false;
  is $result->eval({}), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 glob

  # given: synopsis

  package main;

  $check = $check->glob;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(*main);

  # false

=cut

$test->for('example', 2, 'glob', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(*main), false;

  $result
});

=example-3 glob

  # given: synopsis

  package main;

  $check = $check->glob;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(\*main);

  # \*::main

=cut

$test->for('example', 3, 'glob', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->result(\*main), \*main;

  $result
});

=example-4 glob

  # given: synopsis

  package main;

  $check = $check->glob;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(*main);

  # Exception! (isa Venus::Check::Error) (see error_on_typeglob)

=cut

$test->for('example', 4, 'glob', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', *main);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.typeglob';

  $result
});

=method hash

The hash method configures the object to accept hash references and returns
the invocant.

=signature hash

  hash(coderef @code) (Venus::Check)

=metadata hash

{
  since => '3.55',
}

=example-1 hash

  # given: synopsis

  package main;

  $check = $check->hash;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({});

  # true

=cut

$test->for('example', 1, 'hash', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({}), true;
  is $result->eval(0), false;
  is $result->eval([]), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 hash

  # given: synopsis

  package main;

  $check = $check->hash;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval([]);

  # false

=cut

$test->for('example', 2, 'hash', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval([]), false;

  $result
});

=example-3 hash

  # given: synopsis

  package main;

  $check = $check->hash;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # {}

=cut

$test->for('example', 3, 'hash', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result({});
  is_deeply $return, {};

  $result
});

=example-4 hash

  # given: synopsis

  package main;

  $check = $check->hash;

  # bless(..., 'Venus::Check')

  # my $result = $check->result([]);

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'hash', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', []);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method hashkeys

The hashkeys method configures the object to accept hash based values
containing the keys whose values' match the specified types, and returns the
invocant.

=signature hashkeys

  hashkeys(string | within[arrayref, string] @args) (Venus::Check)

=metadata hashkeys

{
  since => '3.55',
}

=example-1 hashkeys

  # given: synopsis

  package main;

  $check = $check->hashkeys('rand', 'float');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({rand => rand});

  # true

=cut

$test->for('example', 1, 'hashkeys', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({rand => rand}), true;
  is $result->eval({}), false;

  $result
});

=example-2 hashkeys

  # given: synopsis

  package main;

  $check = $check->hashkeys('rand', 'float');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({});

  # false

=cut

$test->for('example', 2, 'hashkeys', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({}), false;

  $result
});

=example-3 hashkeys

  # given: synopsis

  package main;

  $check = $check->hashkeys('rand', 'float');

  # bless(..., 'Venus::Check')

  # my $result = $check->result({rand => rand});

  # {rand => rand}

=cut

$test->for('example', 3, 'hashkeys', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $random = rand;
  my $return = $result->result({rand => $random});
  is_deeply $return, {rand => $random};

  $result
});

=example-4 hashkeys

  # given: synopsis

  package main;

  $check = $check->hashkeys('rand', 'float');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(undef);

  # Exception! (isa Venus::Check::Error) (see error_on_defined)

=cut

$test->for('example', 4, 'hashkeys', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', undef);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.defined';

  $result
});

=example-5 hashkeys

  # given: synopsis

  package main;

  $check = $check->hashkeys('rand', 'float');

  # bless(..., 'Venus::Check')

  # my $result = $check->result([]);

  # Exception! (isa Venus::Check::Error) (see error_on_hashref)

=cut

$test->for('example', 5, 'hashkeys', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', []);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.hashref';

  $result
});

=example-6 hashkeys

  # given: synopsis

  package main;

  $check = $check->hashkeys('rand', 'float', 'name');

  # bless(..., 'Venus::Check')

  # my $result = $check->result({rand => rand});

  # Exception! (isa Venus::Check::Error) (see error_on_pairs)

=cut

$test->for('example', 6, 'hashkeys', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {rand => rand});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.pairs';

  $result
});

=example-7 hashkeys

  # given: synopsis

  package main;

  $check = $check->hashkeys('rand', 'float');

  # bless(..., 'Venus::Check')

  # my $result = $check->result({rndm => rand});

  # Exception! (isa Venus::Check::Error) (see error_on_missing)

=cut

$test->for('example', 7, 'hashkeys', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {rndm => rand});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.missing';

  $result
});

=method hashref

The hashref method configures the object to accept hash references and returns
the invocant.

=signature hashref

  hashref(coderef @code) (Venus::Check)

=metadata hashref

{
  since => '3.55',
}

=example-1 hashref

  # given: synopsis

  package main;

  $check = $check->hashref;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({});

  # true

=cut

$test->for('example', 1, 'hashref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({}), true;
  is $result->eval(0), false;
  is $result->eval([]), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 hashref

  # given: synopsis

  package main;

  $check = $check->hashref;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval([]);

  # false

=cut

$test->for('example', 2, 'hashref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval([]), false;

  $result
});

=example-3 hashref

  # given: synopsis

  package main;

  $check = $check->hashref;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # {}

=cut

$test->for('example', 3, 'hashref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result({});
  is_deeply $return, {};

  $result
});

=example-4 hashref

  # given: synopsis

  package main;

  $check = $check->hashref;

  # bless(..., 'Venus::Check')

  # my $result = $check->result([]);

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'hashref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', []);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method identity

The identity method configures the object to accept objects of the type
specified as the argument, and returns the invocant.

=signature identity

  identity(string $name) (Venus::Check)

=metadata identity

{
  since => '3.55',
}

=example-1 identity

  # given: synopsis

  package main;

  $check = $check->identity('Venus::Check');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Venus::Check->new);

  # true

=cut

$test->for('example', 1, 'identity', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Venus::Check->new), true;
  is $result->eval(undef), false;
  is $result->eval(0), false;
  is $result->eval(1), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 identity

  # given: synopsis

  package main;

  use Venus::Config;

  $check = $check->identity('Venus::Check');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Venus::Config->new);

  # false

=cut

$test->for('example', 2, 'identity', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Venus::Config->new), false;

  $result
});

=example-3 identity

  # given: synopsis

  package main;

  $check = $check->identity('Venus::Check');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Venus::Check->new);

  # bless(..., 'Venus::Check')

=cut

$test->for('example', 3, 'identity', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(Venus::Check->new);
  ok $return->isa('Venus::Check');

  $result
});

=example-4 identity

  # given: synopsis

  package main;

  $check = $check->identity('Venus::Check');

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'identity', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=example-5 identity

  # given: synopsis

  package main;

  use Venus::Config;

  $check = $check->identity('Venus::Check');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Venus::Config->new);

  # Exception! (isa Venus::Check::Error) (see error_on_identity)

=cut

$test->for('example', 5, 'identity', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', Venus::Config->new);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.identity';

  $result
});

=method includes

The include method configures the object to accept "all" of the conditions
provided, which may be a string or arrayref representing a method call, and
returns the invocant.

=signature includes

  includes(string | within[arrayref, string] @args) (Venus::Check)

=metadata includes

{
  since => '3.55',
}

=example-1 includes

  # given: synopsis

  package main;

  $check = $check->includes('string', 'yesno');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('yes');

  # true

=cut

$test->for('example', 1, 'includes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval('yes'), true;
  is $result->eval('y'), true;
  is $result->eval(1), false;

  $result
});

=example-2 includes

  # given: synopsis

  package main;

  $check = $check->includes('string', 'yesno');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(0);

  # false

=cut

$test->for('example', 2, 'includes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(0), false;

  $result
});

=example-3 includes

  # given: synopsis

  package main;

  $check = $check->includes('string', 'yesno');

  # bless(..., 'Venus::Check')

  # my $result = $check->result('Yes');

  # 'Yes'

=cut

$test->for('example', 3, 'includes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result('Yes');
  is $return, 'Yes';

  $result
});

=example-4 includes

  # given: synopsis

  package main;

  $check = $check->includes('string', 'yesno');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(1);

  # Exception! (isa Venus::Check::Error) (see error_on_includes)

=cut

$test->for('example', 4, 'includes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 1);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.includes';

  $result
});

=method inherits

The inherits method configures the object to accept objects of the type
specified as the argument, and returns the invocant. This method is a proxy for
the L</identity> method.

=signature inherits

  inherits(string $base) (Venus::Check)

=metadata inherits

{
  since => '3.55',
}

=example-1 inherits

  # given: synopsis

  package main;

  $check = $check->inherits('Venus::Kind::Utility');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Venus::Check->new);

  # true

=cut

$test->for('example', 1, 'inherits', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Venus::Check->new), true;
  is $result->eval(undef), false;
  is $result->eval(0), false;
  is $result->eval(1), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 inherits

  # given: synopsis

  package main;

  $check = $check->inherits('Venus::Kind::Value');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Venus::Check->new);

  # false

=cut

$test->for('example', 2, 'inherits', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Venus::Check->new), false;

  $result
});

=example-3 inherits

  # given: synopsis

  package main;

  $check = $check->inherits('Venus::Kind::Utility');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Venus::Check->new);

  # bless(..., 'Venus::Check')

=cut

$test->for('example', 3, 'inherits', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(Venus::Check->new);
  ok $return->isa('Venus::Check');

  $result
});

=example-4 inherits

  # given: synopsis

  package main;

  $check = $check->inherits('Venus::Kind::Value');

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'inherits', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=example-5 inherits

  # given: synopsis

  package main;

  $check = $check->inherits('Venus::Kind::Value');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Venus::Check->new);

  # Exception! (isa Venus::Check::Error) (see error_on_inherits)

=cut

$test->for('example', 5, 'inherits', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', Venus::Check->new);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.inherits';

  $result
});

=method integrates

The integrates method configures the object to accept objects that support the
C<"does"> behavior and consumes the "role" specified as the argument, and
returns the invocant.

=signature integrates

  integrates(string $role) (Venus::Check)

=metadata integrates

{
  since => '3.55',
}

=example-1 integrates

  # given: synopsis

  package main;

  $check = $check->integrates('Venus::Role::Throwable');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Venus::Check->new);

  # true

=cut

$test->for('example', 1, 'integrates', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Venus::Check->new), true;
  is $result->eval(undef), false;
  is $result->eval(0), false;
  is $result->eval(1), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 integrates

  # given: synopsis

  package main;

  $check = $check->integrates('Venus::Role::Knowable');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Venus::Check->new);

  # false

=cut

$test->for('example', 2, 'integrates', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Venus::Check->new), false;

  $result
});

=example-3 integrates

  # given: synopsis

  package main;

  $check = $check->integrates('Venus::Role::Throwable');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Venus::Check->new);

  # bless(..., 'Venus::Check')

=cut

$test->for('example', 3, 'integrates', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(Venus::Check->new);
  ok $return->isa('Venus::Check');

  $result
});

=example-4 integrates

  # given: synopsis

  package main;

  $check = $check->integrates('Venus::Role::Knowable');

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'integrates', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=example-5 integrates

  # given: synopsis

  package main;

  $check = $check->integrates('Venus::Role::Knowable');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Venus::Check->new);

  # Exception! (isa Venus::Check::Error) (see error_on_consumes)

=cut

$test->for('example', 5, 'integrates', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', Venus::Check->new);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.consumes';

  $result
});

=method maybe

The maybe method configures the object to accept the type provided as an
argument, or undef, and returns the invocant.

=signature maybe

  maybe(string | within[arrayref, string] @args) (Venus::Check)

=metadata maybe

{
  since => '3.55',
}

=example-1 maybe

  # given: synopsis

  package main;

  $check = $check->maybe('string');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('');

  # true

=cut

$test->for('example', 1, 'maybe', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(''), true;
  is $result->eval(undef), true;
  is $result->eval(sub{}), false;
  is $result->eval(0), false;
  is $result->eval(1), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 maybe

  # given: synopsis

  package main;

  $check = $check->maybe('string');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval([]);

  # false

=cut

$test->for('example', 2, 'maybe', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval([]), false;

  $result
});

=example-3 maybe

  # given: synopsis

  package main;

  $check = $check->maybe('string');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(undef);

  # undef

=cut

$test->for('example', 3, 'maybe', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result('');
  is $return, '';

  $result
});

=example-4 maybe

  # given: synopsis

  package main;

  $check = $check->maybe('string');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(0);

  # Exception! (isa Venus::Check::Error) (see error_on_either)

=cut

$test->for('example', 4, 'maybe', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 0);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.either';

  $result
});

=example-5 maybe

  # given: synopsis

  package main;

  $check = $check->maybe('string');

  # bless(..., 'Venus::Check')

  # my $result = $check->result([]);

  # Exception! (isa Venus::Check::Error) (see error_on_either)

=cut

$test->for('example', 5, 'maybe', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', []);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.either';

  $result
});

=method new

The new method constructs an instance of the package.

=signature new

  new(any @args) (Venus::Check)

=metadata new

{
  since => '4.15',
}

=cut

=example-1 new

  package main;

  use Venus::Check;

  my $new = Venus::Check->new;

  # bless(..., "Venus::Check")

=cut

$test->for('example', 1, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Check');

  $result
});

=method number

The number method configures the object to accept numberic values and returns
the invocant.

=signature number

  number(coderef @code) (Venus::Check)

=metadata number

{
  since => '3.55',
}

=example-1 number

  # given: synopsis

  package main;

  $check = $check->number;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(1234);

  # true

=cut

$test->for('example', 1, 'number', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(1234), true;
  is $result->eval(0), true;
  is $result->eval(1), true;
  is $result->eval('0'), false;
  is $result->eval('1'), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 number

  # given: synopsis

  package main;

  $check = $check->number;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(1.234);

  # false

=cut

$test->for('example', 2, 'number', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(1.234), false;

  $result
});

=example-3 number

  # given: synopsis

  package main;

  $check = $check->number;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(1234);

  # 1234

=cut

$test->for('example', 3, 'number', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(1234);
  is $return, 1234;

  $result
});

=example-4 number

  # given: synopsis

  package main;

  $check = $check->number;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(1.234);

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'number', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 1.234);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method object

The object method configures the object to accept objects and returns the
invocant.

=signature object

  object(coderef @code) (Venus::Check)

=metadata object

{
  since => '3.55',
}

=example-1 object

  # given: synopsis

  package main;

  $check = $check->object;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(bless{});

  # true

=cut

$test->for('example', 1, 'object', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(bless{}), true;
  is $result->eval(1), false;
  is $result->eval('main'), false;
  is $result->eval({}), false;
  is $result->eval([]), false;

  $result
});

=example-2 object

  # given: synopsis

  package main;

  $check = $check->object;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({});

  # false

=cut

$test->for('example', 2, 'object', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({}), false;

  $result
});

=example-3 object

  # given: synopsis

  package main;

  $check = $check->object;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(bless{});

  # bless{}

=cut

$test->for('example', 3, 'object', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(bless{});
  ok $return->isa('main');

  $result
});

=example-4 object

  # given: synopsis

  package main;

  $check = $check->object;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'object', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method package

The package method configures the object to accept package names (which are
loaded) and returns the invocant.

=signature package

  package(coderef @code) (Venus::Check)

=metadata package

{
  since => '3.55',
}

=example-1 package

  # given: synopsis

  package main;

  $check = $check->package;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('Venus::Check');

  # true

=cut

$test->for('example', 1, 'package', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval('Venus::Check'), true;
  is $result->eval('Example'), false;
  is $result->eval(1), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 package

  # given: synopsis

  package main;

  $check = $check->package;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('MyApp::Check');

  # false

=cut

$test->for('example', 2, 'package', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval('MyApp::Check'), false;

  $result
});

=example-3 package

  # given: synopsis

  package main;

  $check = $check->package;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('Venus::Check');

  # 'Venus::Check'

=cut

$test->for('example', 3, 'package', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result('Venus::Check');
  is $return, 'Venus::Check';

  $result
});

=example-4 package

  # given: synopsis

  package main;

  $check = $check->package;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(0);

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'package', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 0);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=example-5 package

  # given: synopsis

  package main;

  $check = $check->package;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('main');

  # Exception! (isa Venus::Check::Error) (see error_on_package)

=cut

$test->for('example', 5, 'package', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 'main');
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.package';

  $result
});

=example-6 package

  # given: synopsis

  package main;

  $check = $check->package;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('MyApp::Check');

  # Exception! (isa Venus::Check::Error) (see error_on_package_loaded)

=cut

$test->for('example', 6, 'package', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 'MyApp::Check');
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.package.loaded';

  $result
});

=method pass

The pass method captures data related to a success and returns true.

=signature pass

  pass(any $data, hashref $meta) (boolean)

=metadata pass

{
  since => '3.55',
}

=example-1 pass

  # given: synopsis

  package main;

  my $pass = $check->pass('...', {
    from => 'caller',
  });

  # true

=cut

$test->for('example', 1, 'pass', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, true;

  $result
});

=method passed

The passed method returns true if the result of the last operation was a
success, otherwise returns false.

=signature passed

  passed() (boolean)

=metadata passed

{
  since => '3.55',
}

=example-1 passed

  # given: synopsis

  package main;

  my $passed = $check->passed;

  # false

=cut

$test->for('example', 1, 'passed', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, false;

  !$result
});

=example-2 passed

  # given: synopsis

  package main;

  $check->string->eval('hello');

  my $passed = $check->passed;

  # true

=cut

$test->for('example', 2, 'passed', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, true;

  $result
});

=example-3 passed

  # given: synopsis

  package main;

  $check->string->eval(12345);

  my $passed = $check->passed;

  # false

=cut

$test->for('example', 3, 'passed', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, false;

  !$result
});

=method reference

The reference method configures the object to accept references and returns the
invocant.

=signature reference

  reference(coderef @code) (Venus::Check)

=metadata reference

{
  since => '3.55',
}

=example-1 reference

  # given: synopsis

  package main;

  $check = $check->reference;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval([]);

  # true

=cut

$test->for('example', 1, 'reference', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval([]), true;
  is $result->eval(sub{}), true;
  is $result->eval({}), true;
  is $result->eval(1), false;
  is $result->eval('main'), false;
  is $result->eval(true), false;
  is $result->eval(bless{}), true;

  $result
});

=example-2 reference

  # given: synopsis

  package main;

  $check = $check->reference;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('');

  # false

=cut

$test->for('example', 2, 'reference', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(''), false;

  $result
});

=example-3 reference

  # given: synopsis

  package main;

  $check = $check->reference;

  # bless(..., 'Venus::Check')

  # my $result = $check->result([]);

  # []

=cut

$test->for('example', 3, 'reference', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result([]);
  is_deeply $return, [];

  $result
});

=example-4 reference

  # given: synopsis

  package main;

  $check = $check->reference;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(undef);

  # Exception! (isa Venus::Check::Error) (see error_on_defined)

=cut

$test->for('example', 4, 'reference', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', undef);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.defined';

  $result
});

=example-5 reference

  # given: synopsis

  package main;

  $check = $check->reference;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('');

  # Exception! (isa Venus::Check::Error) (see error_on_reference)

=cut

$test->for('example', 5, 'reference', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', '');
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.reference';

  $result
});

=method regexp

The regexp method configures the object to accept regular expression objects
and returns the invocant.

=signature regexp

  regexp(coderef @code) (Venus::Check)

=metadata regexp

{
  since => '3.55',
}

=example-1 regexp

  # given: synopsis

  package main;

  $check = $check->regexp;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(qr//);

  # true

=cut

$test->for('example', 1, 'regexp', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(qr//), true;
  is $result->eval(''), false;
  is $result->eval([]), false;
  is $result->eval(1), false;
  is $result->eval('main'), false;
  is $result->eval(true), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 regexp

  # given: synopsis

  package main;

  $check = $check->regexp;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('');

  # false

=cut

$test->for('example', 2, 'regexp', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(''), false;

  $result
});

=example-3 regexp

  # given: synopsis

  package main;

  $check = $check->regexp;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(qr//);

  # qr//

=cut

$test->for('example', 3, 'regexp', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(qr//);
  is $return, qr//;

  $result
});

=example-4 regexp

  # given: synopsis

  package main;

  $check = $check->regexp;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('');

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'regexp', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', '');
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method result

The result method performs an L</eval> operation and returns the value provided
on success, and on failure raises an exception.

=signature result

  result(any @args) (any)

=metadata result

{
  since => '3.55',
}

=example-1 result

  # given: synopsis

  package main;

  $check->string;

  my $string = $check->result('hello');

  # 'hello'

=cut

$test->for('example', 1, 'result', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, 'hello';

  $result
});

=example-2 result

  # given: synopsis

  package main;

  $check->string;

  my $string = $check->result(12345);

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 2, 'result', sub {
  my ($tryable) = @_;
  my $result = $tryable->error->result;
  ok defined $result;
  ok $result->isa('Venus::Check::Error');
  is $result->name, 'on.coded';

  $result
});

=method routines

The routines method configures the object to accept an object having all of the
routines provided, and returns the invocant.

=signature routines

  routines(string @names) (Venus::Check)

=metadata routines

{
  since => '3.55',
}

=example-1 routines

  # given: synopsis

  package main;

  $check = $check->routines('result');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Venus::Check->new);

  # true

=cut

$test->for('example', 1, 'routines', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Venus::Check->new), true;
  is $result->eval(bless{}), false;
  is $result->eval(1), false;
  is $result->eval('main'), false;
  is $result->eval({}), false;
  is $result->eval([]), false;

  $result
});

=example-2 routines

  # given: synopsis

  package main;

  use Venus::Config;

  $check = $check->routines('result');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Venus::Config->new);

  # false

=cut

$test->for('example', 2, 'routines', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Venus::Config->new), false;

  $result
});

=example-3 routines

  # given: synopsis

  package main;

  $check = $check->routines('result');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Venus::Check->new);

  # bless(..., 'Venus::Check')

=cut

$test->for('example', 3, 'routines', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(Venus::Check->new);
  ok $return->isa('Venus::Check');

  $result
});

=example-4 routines

  # given: synopsis

  package main;

  use Venus::Config;

  $check = $check->routines('result');

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'routines', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=example-5 routines

  # given: synopsis

  package main;

  use Venus::Config;

  $check = $check->routines('result');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Venus::Config->new);

  # Exception! (isa Venus::Check::Error) (see error_on_missing)

=cut

$test->for('example', 5, 'routines', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', Venus::Config->new);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.missing';

  $result
});

=method scalar

The scalar method configures the object to accept scalar references and returns
the invocant.

=signature scalar

  scalar(coderef @code) (Venus::Check)

=metadata scalar

{
  since => '3.55',
}

=example-1 scalar

  # given: synopsis

  package main;

  $check = $check->scalar;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(\'');

  # true

=cut

$test->for('example', 1, 'scalar', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(\''), true;
  ok $result->eval(\1);
  is $result->eval(0), false;
  is $result->eval({}), false;
  is $result->eval([]), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 scalar

  # given: synopsis

  package main;

  $check = $check->scalar;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('');

  # false

=cut

$test->for('example', 2, 'scalar', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(''), false;

  $result
});

=example-3 scalar

  # given: synopsis

  package main;

  $check = $check->scalar;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(\'');

  # \''

=cut

$test->for('example', 3, 'scalar', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(\'');
  ok ref $return eq 'SCALAR';

  $result
});

=example-4 scalar

  # given: synopsis

  package main;

  $check = $check->scalar;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('');

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'scalar', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', '');
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method scalarref

The scalarref method configures the object to accept scalar references and returns
the invocant.

=signature scalarref

  scalarref(coderef @code) (Venus::Check)

=metadata scalarref

{
  since => '3.55',
}

=example-1 scalarref

  # given: synopsis

  package main;

  $check = $check->scalarref;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(\'');

  # true

=cut

$test->for('example', 1, 'scalarref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(\''), true;
  ok $result->eval(\1);
  is $result->eval(0), false;
  is $result->eval({}), false;
  is $result->eval([]), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 scalarref

  # given: synopsis

  package main;

  $check = $check->scalarref;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('');

  # false

=cut

$test->for('example', 2, 'scalarref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(''), false;

  $result
});

=example-3 scalarref

  # given: synopsis

  package main;

  $check = $check->scalarref;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(\'');

  # \''

=cut

$test->for('example', 3, 'scalarref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(\'');
  ok ref $return eq 'SCALAR';

  $result
});

=example-4 scalarref

  # given: synopsis

  package main;

  $check = $check->scalarref;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('');

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'scalarref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', '');
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method string

The string method configures the object to accept string values and returns the
invocant.

=signature string

  string(coderef @code) (Venus::Check)

=metadata string

{
  since => '3.55',
}

=example-1 string

  # given: synopsis

  package main;

  $check = $check->string;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('hello');

  # true

=cut

$test->for('example', 1, 'string', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval('hello'), true;
  is $result->eval(''), true;
  is $result->eval('hello world'), true;
  is $result->eval(0), false;
  is $result->eval(1), false;
  is $result->eval(qr//), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 string

  # given: synopsis

  package main;

  $check = $check->string;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(12345);

  # false

=cut

$test->for('example', 2, 'string', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(12345), false;

  $result
});

=example-3 string

  # given: synopsis

  package main;

  $check = $check->string;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('hello');

  # 'hello'

=cut

$test->for('example', 3, 'string', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result('hello');
  is $return, 'hello';

  $result
});

=example-4 string

  # given: synopsis

  package main;

  $check = $check->string;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(12345);

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'string', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 12345);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method tuple

The tuple method configures the object to accept array references which conform
to a tuple specification, and returns the invocant. The value being evaluated
must contain at-least one element to match.

=signature tuple

  tuple(string | within[arrayref, string] @args) (Venus::Check)

=metadata tuple

{
  since => '3.55',
}

=example-1 tuple

  # given: synopsis

  package main;

  $check = $check->tuple('string', 'number');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(['hello', 12345]);

  # true

=cut

$test->for('example', 1, 'tuple', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(['hello', 12345]), true;
  is $result->eval(['200', 0]), true;
  is $result->eval(['hello', []]), false;
  is $result->eval(['200', [], sub{}]), false;
  is $result->eval(['hello', 1.2345]), false;
  is $result->eval(['hello', bless{}]), false;
  is $result->eval(0), false;
  is $result->eval(1), false;
  is $result->eval(qr//), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 tuple

  # given: synopsis

  package main;

  $check = $check->tuple('string', 'number');

  # bless(..., 'Venus::Check')

  # my $result = $check->eval([]);

  # false

=cut

$test->for('example', 2, 'tuple', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval([]), false;

  $result
});

=example-3 tuple

  # given: synopsis

  package main;

  $check = $check->tuple('string', 'number');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(['hello', 12345]);

  # ['hello', 12345]

=cut

$test->for('example', 3, 'tuple', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(['hello', 12345]);
  is_deeply $return, ['hello', 12345];

  $result
});

=example-4 tuple

  # given: synopsis

  package main;

  $check = $check->tuple('string', 'number');

  # bless(..., 'Venus::Check')

  # my $result = $check->result(undef);

  # Exception! (isa Venus::Check::Error) (see error_on_defined)

=cut

$test->for('example', 4, 'tuple', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', undef);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.defined';

  $result
});

=example-5 tuple

  # given: synopsis

  package main;

  $check = $check->tuple('string', 'number');

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_arrayref)

=cut

$test->for('example', 5, 'tuple', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.arrayref';

  $result
});

=example-6 tuple

  # given: synopsis

  package main;

  $check = $check->tuple('string', 'number');

  # bless(..., 'Venus::Check')

  # my $result = $check->result([]);

  # Exception! (isa Venus::Check::Error) (see error_on_arrayref_count)

=cut

$test->for('example', 6, 'tuple', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', []);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.arrayref.count';

  $result
});

=method undef

The undef method configures the object to accept undefined values and returns
the invocant.

=signature undef

  undef(coderef @code) (Venus::Check)

=metadata undef

{
  since => '3.55',
}

=example-1 undef

  # given: synopsis

  package main;

  $check = $check->undef;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(undef);

  # true

=cut

$test->for('example', 1, 'undef', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(undef), true;
  is $result->eval(true), false;
  is $result->eval(false), false;
  is $result->eval(0), false;
  is $result->eval(1), false;
  is $result->eval(bless{}), false;

  $result
});

=example-2 undef

  # given: synopsis

  package main;

  $check = $check->undef;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('');

  # false

=cut

$test->for('example', 2, 'undef', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(''), false;

  $result
});

=example-3 undef

  # given: synopsis

  package main;

  $check = $check->undef;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(undef);

  # undef

=cut

$test->for('example', 3, 'undef', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(undef);
  is $return, undef;

  $result
});

=example-4 undef

  # given: synopsis

  package main;

  $check = $check->undef;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('');

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 4, 'undef', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', '');
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=method value

The value method configures the object to accept defined, non-reference,
values, and returns the invocant.

=signature value

  value(coderef @code) (Venus::Check)

=metadata value

{
  since => '3.55',
}

=example-1 value

  # given: synopsis

  package main;

  $check = $check->value;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(1);

  # true

=cut

$test->for('example', 1, 'value', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(1), true;
  is $result->eval(1_000_000), true;
  is $result->eval({}), false;
  is $result->eval([]), false;
  is $result->eval('main'), true;
  is $result->eval(true), true;
  is $result->eval(bless{}), false;

  $result
});

=example-2 value

  # given: synopsis

  package main;

  $check = $check->value;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({});

  # false

=cut

$test->for('example', 2, 'value', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({}), false;

  $result
});

=example-3 value

  # given: synopsis

  package main;

  $check = $check->value;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(1);

  # 1

=cut

$test->for('example', 3, 'value', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(1);
  is $return, 1;

  $result
});

=example-4 value

  # given: synopsis

  package main;

  $check = $check->value;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(undef);

  # Exception! (isa Venus::Check::Error) (see error_on_defined)

=cut

$test->for('example', 4, 'value', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', undef);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.defined';

  $result
});

=example-5 value

  # given: synopsis

  package main;

  $check = $check->value;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_value)

=cut

$test->for('example', 5, 'value', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.value';

  $result
});

=method what

The type method returns the canonical data type name for the value provided.

=signature what

  what(any $data) (string)

=metadata what

{
  since => '3.55',
}

=example-1 what

  # given: synopsis

  package main;

  my $what = $check->what({});

  # 'hashref'

=cut

$test->for('example', 1, 'what', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, 'hashref';

  $result
});

=example-2 what

  # given: synopsis

  package main;

  my $what = $check->what([]);

  # 'arrayref'

=cut

$test->for('example', 2, 'what', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, 'arrayref';

  $result
});

=example-3 what

  # given: synopsis

  package main;

  my $what = $check->what('Venus::Check');

  # 'string'

=cut

$test->for('example', 3, 'what', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, 'string';

  $result
});

=example-4 what

  # given: synopsis

  package main;

  my $what = $check->what(Venus::Check->new);

  # 'object'

=cut

$test->for('example', 4, 'what', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, 'object';

  $result
});

=method within

The within method configures the object, registering a constraint action as a
sub-match operation, to accept array references, hash references, or mappable
values (see L<Venus::Role::Mappable>), and returns a new L<Venus::Check>
instance for the sub-match operation (not the invocant). This operation can
traverse blessed array or hash based values, or objects derived from classes
which consume the "mappable" role. The value being evaluated must contain
at-least one element to match.

=signature within

  within(string $type, string | within[arrayref, string] @args) (Venus::Check)

=metadata within

{
  since => '3.55',
}

=example-1 within

  # given: synopsis

  package main;

  my $within = $check->within('arrayref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(['hello']);

  # true

=cut

$test->for('example', 1, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(['hello']), true;
  is $result->eval([]), false;
  is $result->eval([__PACKAGE__]), true;
  is $result->eval([{}]), false;
  is $result->eval([sub{}, 1]), false;
  is $result->eval(undef), false;
  is $result->eval(0), false;
  is $result->eval(1), false;
  is $result->eval(bless{}), false;
  is $result->eval(bless[]), false;
  is $result->eval(bless['hello']), true;
  is $result->eval(bless[{}]), false;

  $result
});

=example-2 within

  # given: synopsis

  package main;

  my $within = $check->within('arrayref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval([]);

  # false

=cut

$test->for('example', 2, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval([]), false;

  $result
});

=example-3 within

  # given: synopsis

  package main;

  my $within = $check->within('arrayref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(['hello']);

  # ['hello']

=cut

$test->for('example', 3, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result(['hello']);
  is_deeply $return, ['hello'];

  $result
});

=example-4 within

  # given: synopsis

  package main;

  my $within = $check->within('arrayref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(undef);

  # Exception! (isa Venus::Check::Error) (see error_on_defined)

=cut

$test->for('example', 4, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', undef);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.defined';

  $result
});

=example-5 within

  # given: synopsis

  package main;

  my $within = $check->within('arrayref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_arrayref)

=cut

$test->for('example', 5, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.arrayref';

  $result
});

=example-6 within

  # given: synopsis

  package main;

  my $within = $check->within('arrayref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result([]);

  # Exception! (isa Venus::Check::Error) (see error_on_arrayref_count)

=cut

$test->for('example', 6, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', []);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.arrayref.count';

  $result
});

=example-7 within

  # given: synopsis

  package main;

  my $within = $check->within('arrayref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result([rand]);

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 7, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', [rand]);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=example-8 within

  # given: synopsis

  package main;

  my $within = $check->within('hashref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({title => 'hello'});

  # true

=cut

$test->for('example', 8, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({title => 'hello'}), true;

  $result
});

=example-9 within

  # given: synopsis

  package main;

  my $within = $check->within('hashref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval({});

  # false

=cut

$test->for('example', 9, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval({}), false;

  $result
});

=example-10 within

  # given: synopsis

  package main;

  my $within = $check->within('hashref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({title => 'hello'});

  # {title => 'hello'}

=cut

$test->for('example', 10, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result({title => 'hello'});
  is_deeply $return, {title => 'hello'};

  $result
});

=example-11 within

  # given: synopsis

  package main;

  my $within = $check->within('hashref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(undef);

  # Exception! (isa Venus::Check::Error) (see error_on_defined)

=cut

$test->for('example', 11, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', undef);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.defined';

  $result
});

=example-12 within

  # given: synopsis

  package main;

  my $within = $check->within('hashref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result([]);

  # Exception! (isa Venus::Check::Error) (see error_on_hashref)

=cut

$test->for('example', 12, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', []);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.hashref';

  $result
});

=example-13 within

  # given: synopsis

  package main;

  my $within = $check->within('hashref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({});

  # Exception! (isa Venus::Check::Error) (see error_on_hashref_empty)

=cut

$test->for('example', 13, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.hashref.empty';

  $result
});

=example-14 within

  # given: synopsis

  package main;

  my $within = $check->within('hashref', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({title => rand});

  # Exception! (isa Venus::Check::Error) (see error_on_coded)

=cut

$test->for('example', 14, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {title => rand});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.coded';

  $result
});

=example-15 within

  # given: synopsis

  package main;

  my $within = $check->within('Venus::Hash', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result({title => 'engineer'});

  # Exception! (isa Venus::Check::Error) (see error_on_mappable_isa)

=cut

$test->for('example', 15, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', {title => 'engineer'});
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.mappable.isa';

  $result
});

=example-16 within

  # given: synopsis

  package main;

  use Venus::Hash;

  my $within = $check->within('Venus::Hash', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(Venus::Hash->new);

  # Exception! (isa Venus::Check::Error) (see error_on_mappable_empty)

=cut

$test->for('example', 16, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', Venus::Hash->new);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.mappable.empty';

  $result
});

=example-17 within

  # given: synopsis

  package main;

  use Venus::Hash;

  my $within = $check->within('Venus::Hash', 'string');

  # bless(..., 'Venus::Check')

  $check;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval(Venus::Hash->new({title => 'engineer'}));

  # true

=cut

$test->for('example', 17, 'within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval(Venus::Hash->new({title => 'engineer'})), true;

  $result
});

=method yesno

The yesno method configures the object to accept a string value, that's case
insensitive, and that's either C<"y"> or C<"yes"> or C<1> or C<"n"> or C<"no">
or C<0>, and returns the invocant.

=signature yesno

  yesno(coderef @code) (Venus::Check)

=metadata yesno

{
  since => '3.55',
}

=example-1 yesno

  # given: synopsis

  package main;

  $check = $check->yesno;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('yes');

  # true

=cut

$test->for('example', 1, 'yesno', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval('yes'), true;
  is $result->eval(undef), false;
  is $result->eval(0), true;
  is $result->eval('No'), true;
  is $result->eval('n'), true;
  is $result->eval(1), true;
  is $result->eval('Yes'), true;
  is $result->eval('y'), true;
  is $result->eval('Okay'), false;

  $result
});

=example-2 yesno

  # given: synopsis

  package main;

  $check = $check->yesno;

  # bless(..., 'Venus::Check')

  # my $result = $check->eval('yup');

  # false

=cut

$test->for('example', 2, 'yesno', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  is $result->eval('yup'), false;

  $result
});

=example-3 yesno

  # given: synopsis

  package main;

  $check = $check->yesno;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('yes');

  # 'yes'

=cut

$test->for('example', 3, 'yesno', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->result('yes');
  is $return, 'yes';

  $result
});

=example-4 yesno

  # given: synopsis

  package main;

  $check = $check->yesno;

  # bless(..., 'Venus::Check')

  # my $result = $check->result(undef);

  # Exception! (isa Venus::Check::Error) (see error_on_defined)

=cut

$test->for('example', 4, 'yesno', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', undef);
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.defined';

  $result
});

=example-5 yesno

  # given: synopsis

  package main;

  $check = $check->yesno;

  # bless(..., 'Venus::Check')

  # my $result = $check->result('yup');

  # Exception! (isa Venus::Check::Error) (see error_on_yesno)

=cut

$test->for('example', 5, 'yesno', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  ok $result->isa('Venus::Check');
  my $return = $result->catch('result', 'yup');
  ok $return->isa('Venus::Check::Error');
  is $return->name, 'on.yesno';

  $result
});

=error error_on_arrayref

This package may raise an C<on.arrayref> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_arrayref> method.

=cut

$test->for('error', 'error_on_arrayref');

=example-1 error_on_arrayref

  # given: synopsis;

  my $error = $check->error_on_arrayref({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.arrayref"

  # my $render = $error->render;

  # "Failed checking test, value provided is not an arrayref or arrayref derived, at ."

=cut

$test->for('example', 1, 'error_on_arrayref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.arrayref";
  my $render = $result->render;
  is $render, "Failed checking test, value provided is not an arrayref or arrayref derived, at .";

  $result
});

=error error_on_arrayref_count

This package may raise an C<on.arrayref.count> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_arrayref_count> method.

=cut

$test->for('error', 'error_on_arrayref_count');

=example-1 error_on_arrayref_count

  # given: synopsis;

  my $error = $check->error_on_arrayref_count({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.arrayref.count"

  # my $render = $error->render;

  # "Failed checking test, incorrect item count in arrayref or arrayref derived object, at ."

=cut

$test->for('example', 1, 'error_on_arrayref_count', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.arrayref.count";
  my $render = $result->render;
  is $render, "Failed checking test, incorrect item count in arrayref or arrayref derived object, at .";

  $result
});

=error error_on_coded

This package may raise an C<on.coded> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_coded> method.

=cut

$test->for('error', 'error_on_coded');

=example-1 error_on_coded

  # given: synopsis;

  my $error = $check->error_on_coded({
    at => '.',
    from => 'test',
    expected => 'string',
    received => 'number',
  });

  # ...

  # my $name = $error->name;

  # "on.coded"

  # my $render = $error->render;

  # "Failed checking test, expected string, received number, at ."

=cut

$test->for('example', 1, 'error_on_coded', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.coded";
  my $render = $result->render;
  is $render, "Failed checking test, expected string, received number, at .";

  $result
});

=error error_on_consumes

This package may raise an C<on.consumes> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_consumes> method.

=cut

$test->for('error', 'error_on_consumes');

=example-1 error_on_consumes

  # given: synopsis;

  my $error = $check->error_on_consumes({
    at => '.',
    from => 'test',
    role => 'Example::Role',
  });

  # ...

  # my $name = $error->name;

  # "on.consumes"

  # my $render = $error->render;

  # "Failed checking test, object does not consume the role \"Example::Role\", at ."

=cut

$test->for('example', 1, 'error_on_consumes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.consumes";
  my $render = $result->render;
  is $render, "Failed checking test, object does not consume the role \"Example::Role\", at .";

  $result
});

=error error_on_defined

This package may raise an C<on.defined> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_defined> method.

=cut

$test->for('error', 'error_on_defined');

=example-1 error_on_defined

  # given: synopsis;

  my $error = $check->error_on_defined({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.defined"

  # my $render = $error->render;

  # "Failed checking test, value provided is undefined, at ."

=cut

$test->for('example', 1, 'error_on_defined', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.defined";
  my $render = $result->render;
  is $render, "Failed checking test, value provided is undefined, at .";

  $result
});

=error error_on_dirhandle

This package may raise an C<on.dirhandle> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_dirhandle> method.

=cut

$test->for('error', 'error_on_dirhandle');

=example-1 error_on_dirhandle

  # given: synopsis;

  my $error = $check->error_on_dirhandle({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.dirhandle"

  # my $render = $error->render;

  # "Failed checking test, value provided is not a dirhandle (or is not open), at ."

=cut

$test->for('example', 1, 'error_on_dirhandle', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.dirhandle";
  my $render = $result->render;
  is $render, "Failed checking test, value provided is not a dirhandle (or is not open), at .";

  $result
});

=error error_on_either

This package may raise an C<on.either> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_either> method.

=cut

$test->for('error', 'error_on_either');

=example-1 error_on_either

  # given: synopsis;

  my $error = $check->error_on_either({
    at => '.',
    from => 'test',
    errors => [
      'Failed condition 1',
      'Failed condition 2',
    ],
  });

  # ...

  # my $name = $error->name;

  # "on.either"

  # my $render = $error->render;

  # "Failed checking either-or condition:\n\nFailed condition 1\n\nFailed condition 2"

=cut

$test->for('example', 1, 'error_on_either', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.either";
  my $render = $result->render;
  is $render, "Failed checking either-or condition:\n\nFailed condition 1\n\nFailed condition 2";

  $result
});

=error error_on_enum

This package may raise an C<on.enum> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_enum> method.

=cut

$test->for('error', 'error_on_enum');

=example-1 error_on_enum

  # given: synopsis;

  my $error = $check->error_on_enum({
    at => '.',
    from => 'test',
    data => 'black',
    enum => ['this', 'that'],
  });

  # ...

  # my $name = $error->name;

  # "on.enum"

  # my $render = $error->render;

  # "Failed checking test, received black, valid options are this, that, at ."

=cut

$test->for('example', 1, 'error_on_enum', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.enum";
  my $render = $result->render;
  is $render, "Failed checking test, received black, valid options are this, that, at .";

  $result
});

=error error_on_filehandle

This package may raise an C<on.filehandle> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_filehandle> method.

=cut

$test->for('error', 'error_on_filehandle');

=example-1 error_on_filehandle

  # given: synopsis;

  my $error = $check->error_on_filehandle({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.filehandle"

  # my $render = $error->render;

  # "Failed checking test, value provided is not a filehandle (or is not open), at ."

=cut

$test->for('example', 1, 'error_on_filehandle', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.filehandle";
  my $render = $result->render;
  is $render, "Failed checking test, value provided is not a filehandle (or is not open), at .";

  $result
});

=error error_on_hashref

This package may raise an C<on.hashref> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_hashref> method.

=cut

$test->for('error', 'error_on_hashref');

=example-1 error_on_hashref

  # given: synopsis;

  my $error = $check->error_on_hashref({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.hashref"

  # my $render = $error->render;

  # "Failed checking test, value provided is not a hashref or hashref derived, at ."

=cut

$test->for('example', 1, 'error_on_hashref', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.hashref";
  my $render = $result->render;
  is $render, "Failed checking test, value provided is not a hashref or hashref derived, at .";

  $result
});

=error error_on_hashref_empty

This package may raise an C<on.hashref.empty> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_hashref_empty> method.

=cut

$test->for('error', 'error_on_hashref_empty');

=example-1 error_on_hashref_empty

  # given: synopsis;

  my $error = $check->error_on_hashref_empty({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.hashref.empty"

  # my $render = $error->render;

  # "Failed checking test, no items found in hashref or hashref derived object, at ."

=cut

$test->for('example', 1, 'error_on_hashref_empty', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.hashref.empty";
  my $render = $result->render;
  is $render, "Failed checking test, no items found in hashref or hashref derived object, at .";

  $result
});

=error error_on_includes

This package may raise an C<on.includes> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_includes> method.

=cut

$test->for('error', 'error_on_includes');

=example-1 error_on_includes

  # given: synopsis;

  my $error = $check->error_on_includes({
    at => '.',
    from => 'test',
    errors => [
      'Failed condition 1',
      'Failed condition 2',
    ],
  });

  # ...

  # my $name = $error->name;

  # "on.includes"

  # my $render = $error->render;

  # "Failed checking union-includes condition:\n\nFailed condition 1\n\nFailed condition 2"

=cut

$test->for('example', 1, 'error_on_includes', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.includes";
  my $render = $result->render;
  is $render, "Failed checking union-includes condition:\n\nFailed condition 1\n\nFailed condition 2";

  $result
});

=error error_on_identity

This package may raise an C<on.identity> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_identity> method.

=cut

$test->for('error', 'error_on_identity');

=example-1 error_on_identity

  # given: synopsis;

  my $error = $check->error_on_identity({
    at => '.',
    from => 'test',
    name => 'Example',
  });

  # ...

  # my $name = $error->name;

  # "on.identity"

  # my $render = $error->render;

  # "Failed checking test, object is not a Example or derived object, at ."

=cut

$test->for('example', 1, 'error_on_identity', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.identity";
  my $render = $result->render;
  is $render, "Failed checking test, object is not a Example or derived object, at .";

  $result
});

=error error_on_inherits

This package may raise an C<on.inherits> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_inherits> method.

=cut

$test->for('error', 'error_on_inherits');

=example-1 error_on_inherits

  # given: synopsis;

  my $error = $check->error_on_inherits({
    at => '.',
    from => 'test',
    name => 'Example',
  });

  # ...

  # my $name = $error->name;

  # "on.inherits"

  # my $render = $error->render;

  # "Failed checking test, object is not a Example derived object, at ."

=cut

$test->for('example', 1, 'error_on_inherits', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.inherits";
  my $render = $result->render;
  is $render, "Failed checking test, object is not a Example derived object, at .";

  $result
});

=error error_on_missing

This package may raise an C<on.missing> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_missing> method.

=cut

$test->for('error', 'error_on_missing');

=example-1 error_on_missing

  # given: synopsis;

  my $error = $check->error_on_missing({
    at => '.',
    from => 'test',
    name => 'execute',
  });

  # ...

  # my $name = $error->name;

  # "on.missing"

  # my $render = $error->render;

  # "Failed checking test, "execute" is missing, at ."

=cut

$test->for('example', 1, 'error_on_missing', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.missing";
  my $render = $result->render;
  is $render, "Failed checking test, \"execute\" is missing, at .";

  $result
});

=error error_on_package

This package may raise an C<on.package> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_package> method.

=cut

$test->for('error', 'error_on_package');

=example-1 error_on_package

  # given: synopsis;

  my $error = $check->error_on_package({
    at => '.',
    data => 'main',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.package"

  # my $render = $error->render;

  # "Failed checking test, \"main\" is not a valid package name, at ."

=cut

$test->for('example', 1, 'error_on_package', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.package";
  my $render = $result->render;
  is $render, "Failed checking test, \"main\" is not a valid package name, at .";

  $result
});

=error error_on_package_loaded

This package may raise an C<on.package.loaded> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_package_loaded> method.

=cut

$test->for('error', 'error_on_package_loaded');

=example-1 error_on_package_loaded

  # given: synopsis;

  my $error = $check->error_on_package_loaded({
    at => '.',
    data => 'main',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.package.loaded"

  # my $render = $error->render;

  # "Failed checking test, \"main\" is not loaded, at ."

=cut

$test->for('example', 1, 'error_on_package_loaded', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.package.loaded";
  my $render = $result->render;
  is $render, "Failed checking test, \"main\" is not loaded, at .";

  $result
});

=error error_on_pairs

This package may raise an C<on.pairs> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_pairs> method.

=cut

$test->for('error', 'error_on_pairs');

=example-1 error_on_pairs

  # given: synopsis;

  my $error = $check->error_on_pairs({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.pairs"

  # my $render = $error->render;

  # "Failed checking test, imblanced key/value pairs provided, at ."

=cut

$test->for('example', 1, 'error_on_pairs', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.pairs";
  my $render = $result->render;
  is $render, "Failed checking test, imblanced key/value pairs provided, at .";

  $result
});

=error error_on_reference

This package may raise an C<on.reference> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_reference> method.

=cut

$test->for('error', 'error_on_reference');

=example-1 error_on_reference

  # given: synopsis;

  my $error = $check->error_on_reference({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.reference"

  # my $render = $error->render;

  # "Failed checking test, value provided is not a reference, at ."

=cut

$test->for('example', 1, 'error_on_reference', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.reference";
  my $render = $result->render;
  is $render, "Failed checking test, value provided is not a reference, at .";

  $result
});

=error error_on_typeglob

This package may raise an C<on.typeglob> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_typeglob> method.

=cut

$test->for('error', 'error_on_typeglob');

=example-1 error_on_typeglob

  # given: synopsis;

  my $error = $check->error_on_typeglob({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.typeglob"

  # my $render = $error->render;

  # "Failed checking test, value provided is not a typeglob, at ."

=cut

$test->for('example', 1, 'error_on_typeglob', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.typeglob";
  my $render = $result->render;
  is $render, "Failed checking test, value provided is not a typeglob, at .";

  $result
});

=error error_on_value

This package may raise an C<on.value> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_value> method.

=cut

$test->for('error', 'error_on_value');

=example-1 error_on_value

  # given: synopsis;

  my $error = $check->error_on_value({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.value"

  # my $render = $error->render;

  # "Failed checking test, value provided is a reference, at ."

=cut

$test->for('example', 1, 'error_on_value', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.value";
  my $render = $result->render;
  is $render, "Failed checking test, value provided is a reference, at .";

  $result
});

=error error_on_within

This package may raise an C<on.within> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_within> method.

=cut

$test->for('error', 'error_on_within');

=example-1 error_on_within

  # given: synopsis;

  my $error = $check->error_on_within({
    at => '.',
    from => 'test',
    type => 'scalarref',
  });

  # ...

  # my $name = $error->name;

  # "on.within"

  # my $render = $error->render;

  # "Invalid type \"scalarref\" provided to the \"within\" method"

=cut

$test->for('example', 1, 'error_on_within', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.within";
  my $render = $result->render;
  is $render, "Invalid type \"scalarref\" provided to the \"within\" method";

  $result
});

=error error_on_unknown

This package may raise an C<on.unknown> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_unknown> method.

=cut

$test->for('error', 'error_on_unknown');

=example-1 error_on_unknown

  # given: synopsis;

  my $error = $check->error_on_unknown;

  # ...

  # my $name = $error->name;

  # "on.unknown"

  # my $render = $error->render;

  # "Failed performing check for unknown reason"

=cut

$test->for('example', 1, 'error_on_unknown', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.unknown";
  my $render = $result->render;
  is $render, "Failed performing check for unknown reason";

  $result
});

=error error_on_yesno

This package may raise an C<on.yesno> error, as an instance of
C<Venus::Check::Error>, via the C<error_on_yesno> method.

=cut

$test->for('error', 'error_on_yesno');

=example-1 error_on_yesno

  # given: synopsis;

  my $error = $check->error_on_yesno({
    at => '.',
    from => 'test',
  });

  # ...

  # my $name = $error->name;

  # "on.yesno"

  # my $render = $error->render;

  # "Failed checking test, value provided is not a recognized \"yes\" or \"no\" value, at ."

=cut

$test->for('example', 1, 'error_on_yesno', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.yesno";
  my $render = $result->render;
  is $render, "Failed checking test, value provided is not a recognized \"yes\" or \"no\" value, at .";

  $result
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Check.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;
