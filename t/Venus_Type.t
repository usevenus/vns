package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;

my $test = test(__FILE__);

=name

Venus::Type

=cut

$test->for('name');

=tagline

Type Class

=cut

$test->for('tagline');

=abstract

Type Class for Perl 5

=cut

$test->for('abstract');

=includes

method: code
method: coded
method: deduce
method: deduce_deep
method: detract
method: detract_deep
method: identify
method: package

=cut

$test->for('includes');

=synopsis

  package main;

  use Venus::Type;

  my $type = Venus::Type->new([]);

  # $type->code;

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;

  $result
});

=description

This package provides methods for casting native data types to objects and the
reverse.

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

$test->for('integrates');

=method code

The code method returns the name of the value's data type.

=signature code

  code() (string | undef)

=metadata code

{
  since => '0.01',
}

=example-1 code

  # given: synopsis;

  my $code = $type->code;

  # "ARRAY"

=cut

$test->for('example', 1, 'code', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "ARRAY";

  $result
});

=example-2 code

  package main;

  use Venus::Type;

  my $type = Venus::Type->new(value => {});

  my $code = $type->code;

  # "HASH"

=cut

$test->for('example', 2, 'code', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "HASH";

  $result
});

=example-3 code

  package main;

  use Venus::Type;

  my $type = Venus::Type->new(value => qr//);

  my $code = $type->code;

  # "REGEXP"

=cut

$test->for('example', 3, 'code', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "REGEXP";

  $result
});

=method coded

The coded method return true or false if the data type name provided matches
the result of L</code>.

=signature coded

  coded(string $code) (boolean)

=metadata coded

{
  since => '1.23',
}

=example-1 coded

  # given: synopsis;

  my $coded = $type->coded('ARRAY');

  # 1

=cut

$test->for('example', 1, 'coded', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-2 coded

  # given: synopsis;

  my $coded = $type->coded('HASH');

  # 0

=cut

$test->for('example', 2, 'coded', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);

  !$result
});

=method deduce

The deduce methods returns the argument as a data type object.

=signature deduce

  deduce() (object)

=metadata deduce

{
  since => '0.01',
}

=example-1 deduce

  # given: synopsis;

  my $deduce = $type->deduce;

  # bless({ value => [] }, "Venus::Array")

=cut

$test->for('example', 1, 'deduce', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Array');

  $result
});

=example-2 deduce

  package main;

  use Venus::Type;

  my $type = Venus::Type->new(value => {});

  my $deduce = $type->deduce;

  # bless({ value => {} }, "Venus::Hash")

=cut

$test->for('example', 2, 'deduce', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Hash');

  $result
});

=example-3 deduce

  package main;

  use Venus::Type;

  my $type = Venus::Type->new(value => qr//);

  my $deduce = $type->deduce;

  # bless({ value => qr// }, "Venus::Regexp")

=cut

$test->for('example', 3, 'deduce', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Regexp');

  $result
});

=example-4 deduce

  package main;

  use Venus::Type;

  my $type = Venus::Type->new(value => '1.23');

  my $deduce = $type->deduce;

  # bless({ value => "1.23" }, "Venus::Float")

=cut

$test->for('example', 4, 'deduce', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Float');

  $result
});

=method deduce_deep

The deduce_deep function returns any arguments as data type objects, including
nested data.

=signature deduce_deep

  deduce_deep() (object)

=metadata deduce_deep

{
  since => '0.01',
}

=example-1 deduce_deep

  package main;

  use Venus::Type;

  my $type = Venus::Type->new(value => [1..4]);

  my $deduce_deep = $type->deduce_deep;

  # bless({
  #   value => [
  #     bless({ value => 1 }, "Venus::Number"),
  #     bless({ value => 2 }, "Venus::Number"),
  #     bless({ value => 3 }, "Venus::Number"),
  #     bless({ value => 4 }, "Venus::Number"),
  #   ],
  # }, "Venus::Array")

=cut

$test->for('example', 1, 'deduce_deep', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Array');
  ok $result->get(0)->isa('Venus::Number');
  ok $result->get(1)->isa('Venus::Number');
  ok $result->get(2)->isa('Venus::Number');
  ok $result->get(3)->isa('Venus::Number');

  $result
});

=example-2 deduce_deep

  package main;

  use Venus::Type;

  my $type = Venus::Type->new(value => {1..4});

  my $deduce_deep = $type->deduce_deep;

  # bless({
  #   value => {
  #     1 => bless({ value => 2 }, "Venus::Number"),
  #     3 => bless({ value => 4 }, "Venus::Number"),
  #   },
  # }, "Venus::Hash")

=cut

$test->for('example', 2, 'deduce_deep', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Hash');
  ok $result->get(1)->isa('Venus::Number');
  ok $result->get(1)->get == 2;
  ok $result->get(3)->isa('Venus::Number');
  ok $result->get(3)->get == 4;

  $result
});

=method detract

The detract method returns the argument as native Perl data type value.

=signature detract

  detract() (any)

=metadata detract

{
  since => '0.01',
}

=example-1 detract

  package main;

  use Venus::Type;
  use Venus::Hash;

  my $type = Venus::Type->new(Venus::Hash->new({1..4}));

  my $detract = $type->detract;

  # { 1 => 2, 3 => 4 }

=cut

$test->for('example', 1, 'detract', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, { 1 => 2, 3 => 4 };

  $result
});

=example-2 detract

  package main;

  use Venus::Type;
  use Venus::Array;

  my $type = Venus::Type->new(Venus::Array->new([1..4]));

  my $detract = $type->detract;

  # [1..4]

=cut

$test->for('example', 2, 'detract', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1..4];

  $result
});

=example-3 detract

  package main;

  use Venus::Type;
  use Venus::Regexp;

  my $type = Venus::Type->new(Venus::Regexp->new(qr/\w+/));

  my $detract = $type->detract;

  # qr/\w+/

=cut

$test->for('example', 3, 'detract', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq qr/\w+/;

  $result
});

=example-4 detract

  package main;

  use Venus::Type;
  use Venus::Float;

  my $type = Venus::Type->new(Venus::Float->new('1.23'));

  my $detract = $type->detract;

  # "1.23"

=cut

$test->for('example', 4, 'detract', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq '1.23';

  $result
});

=method detract_deep

The detract_deep method returns any arguments as native Perl data type values,
including nested data.

=signature detract_deep

  detract_deep() (any)

=metadata detract_deep

{
  since => '0.01',
}

=example-1 detract_deep

  package main;

  use Venus::Type;
  use Venus::Hash;

  my $type = Venus::Type->new(Venus::Hash->new({1..4}));

  my $detract_deep = Venus::Type->new($type->deduce_deep)->detract_deep;

  # { 1 => 2, 3 => 4 }

=cut

$test->for('example', 1, 'detract_deep', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, { 1 => 2, 3 => 4 };

  $result
});

=example-2 detract_deep

  package main;

  use Venus::Type;
  use Venus::Array;

  my $type = Venus::Type->new(Venus::Array->new([1..4]));

  my $detract_deep = Venus::Type->new($type->deduce_deep)->detract_deep;

  # [1..4]

=cut

$test->for('example', 2, 'detract_deep', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1..4];

  $result
});

=method identify

The identify method returns the value's data type, or L</code>, in scalar
context. In list context, this method will return a tuple with (defined,
blessed, and data type) elements. B<Note:> For globs and file handles this
method will return "scalar" as the data type.

=signature identify

  identify() (boolean, boolean, string)

=metadata identify

{
  since => '1.23',
}

=example-1 identify

  # given: synopsis

  package main;

  my ($defined, $blessed, $typename) = $type->identify;

  # (1, 0, 'ARRAY')

=cut

$test->for('example', 1, 'identify', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  ok $result[0] == 1;
  ok $result[1] == 0;
  ok $result[2] eq 'ARRAY';

  @result == 3
});

=example-2 identify

  package main;

  use Venus::Type;

  my $type = Venus::Type->new(value => {});

  my ($defined, $blessed, $typename) = $type->identify;

  # (1, 0, 'HASH')

=cut

$test->for('example', 2, 'identify', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  ok $result[0] == 1;
  ok $result[1] == 0;
  ok $result[2] eq 'HASH';

  @result == 3
});

=example-3 identify

  package main;

  use Venus::Type;

  my $type = Venus::Type->new(value => qr//);

  my ($defined, $blessed, $typename) = $type->identify;

  # (1, 1, 'REGEXP')

=cut

$test->for('example', 3, 'identify', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  ok $result[0] == 1;
  ok $result[1] == 1;
  ok $result[2] eq 'REGEXP';

  @result == 3
});

=example-4 identify

  package main;

  use Venus::Type;

  my $type = Venus::Type->new(value => bless{});

  my ($defined, $blessed, $typename) = $type->identify;

  # (1, 1, 'OBJECT')

=cut

$test->for('example', 4, 'identify', sub {
  my ($tryable) = @_;
  ok my @result = $tryable->result;
  ok $result[0] == 1;
  ok $result[1] == 1;
  ok $result[2] eq 'OBJECT';

  @result == 3
});

=method package

The code method returns the package name of the objectified value, i.e.
C<ref()>.

=signature package

  package() (string)

=metadata package

{
  since => '0.01',
}

=example-1 package

  # given: synopsis;

  my $package = $type->package;

  # "Venus::Array"

=cut

$test->for('example', 1, 'package', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "Venus::Array";

  $result
});

=example-2 package

  package main;

  use Venus::Type;

  my $type = Venus::Type->new(value => {});

  my $package = $type->package;

  # "Venus::Hash"

=cut

$test->for('example', 2, 'package', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "Venus::Hash";

  $result
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Type.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;