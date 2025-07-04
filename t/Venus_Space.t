package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;
use Venus;
use File::Temp;
use Venus;

my $test = test(__FILE__);
my $path = File::Temp::tempdir(CLEANUP => 1);

=name

Venus::Space

=cut

$test->for('name');

=tagline

Space Class

=cut

$test->for('tagline');

=abstract

Space Class for Perl 5

=cut

$test->for('abstract');

=includes

method: all
method: append
method: array
method: arrays
method: attributes
method: authority
method: basename
method: blessed
method: build
method: call
method: chain
method: child
method: children
method: cop
method: data
method: eval
method: explain
method: hash
method: hashes
method: id
method: lfile
method: init
method: inherits
method: included
method: inject
method: integrates
method: load
method: loaded
method: locate
method: meta
method: mock
method: name
method: new
method: parent
method: parse
method: parts
method: patch
method: patched
method: pfile
method: prepend
method: purge
method: rebase
method: reload
method: require
method: root
method: routine
method: routines
method: scalar
method: scalars
method: sibling
method: siblings
method: splice
method: swap
method: tfile
method: tryload
method: use
method: unload
method: unloaded
method: unpatch
method: variables
method: visible
method: version

=cut

$test->for('includes');

=synopsis

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/bar');

  # $space->package; # Foo::Bar

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;

  $result
});

=description

This package provides methods for parsing and manipulating package namespaces.

=cut

$test->for('description');

=inherits

Venus::Name

=cut

$test->for('inherits');

=method all

The all method executes any available method on the instance and all instances
representing packages inherited by the package represented by the invocant.
This method supports dispatching, i.e. providing a method name and arguments
whose return value will be acted on by this method.

=signature all

  all(string $method, any @args) (within[arrayref, tuple[string, any]])

=metadata all

{
  since => '0.01',
}

=example-1 all

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Venus');

  my $all = $space->all('id');

  # [["Venus", "Venus"]]

=cut

$test->for('example', 1, 'all', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [["Venus", "Venus"]];

  $result
});

=example-2 all

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Venus/Space');

  my $all = $space->all('inherits');

  # [
  #   [
  #     "Venus::Space", ["Venus::Name"]
  #   ],
  #   [
  #     "Venus::Name", ["Venus::Kind::Utility"]
  #   ],
  # ]

=cut

$test->for('example', 2, 'all', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [
    ["Venus::Space", ["Venus::Name", "Venus::Core::Class"]],
    ["Venus::Name", ["Venus::Kind::Utility", "Venus::Core::Class"]],
    ["Venus::Core::Class", ["Venus::Core"]]
  ];

  $result
});

=example-3 all

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Venus/Space');

  my $all = $space->all('locate');

  # [
  #   [
  #     "Venus::Space",
  #     "/path/to/lib/Venus/Space.pm",
  #   ],
  #   [
  #     "Venus::Name",
  #     "/path/to/lib/Venus/Name.pm",
  #   ],
  # ]

=cut

 $test->for('example', 3, 'all', sub {
   my ($tryable) = @_;
   ok my $result = $tryable->result;
   ok @$result == 3;
   ok @{$result->[0]} == 2;
   ok $result->[0][0] eq 'Venus::Space';
   ok $result->[0][1] =~ 'Venus/Space';
   ok @{$result->[1]} == 2;
   ok $result->[1][0] eq 'Venus::Name';
   ok $result->[1][1] =~ 'Venus/Name';

   $result
 });

=method append

The append method modifies the object by appending to the package namespace
parts.

=signature append

  append(string @path) (Venus::Space)

=metadata append

{
  since => '0.01',
}

=example-1 append

  # given: synopsis;

  my $append = $space->append('baz');

  # bless({ value => "Foo/Bar/Baz" }, "Venus::Space")

=cut

$test->for('example', 1, 'append', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok $result =~ m{Foo::Bar::Baz};

  $result
});

=example-2 append

  # given: synopsis;

  my $append = $space->append('baz', 'bax');

  # bless({ value => "Foo/Bar/Baz/Bax" }, "Venus::Space")

=cut

$test->for('example', 2, 'append', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok $result =~ m{Foo::Bar::Baz::Bax};

  $result
});

=method array

The array method gets or sets the value for the given package array variable name.

=signature array

  array(string $name, any @data) (arrayref)

=metadata array

{
  since => '0.01',
}

=example-1 array

  # given: synopsis;

  package Foo::Bar;

  our @handler = 'start';

  package main;

  my $array = $space->array('handler');

  # ["start"]

=cut

$test->for('example', 1, 'array', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ['start'];

  $result
});

=example-2 array

  # given: synopsis;

  package Foo::Bar;

  our @handler = 'start';

  package main;

  my $array = $space->array('handler', 'restart');

  # ["restart"]

=cut

$test->for('example', 2, 'array', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ['restart'];

  $result
});

=method arrays

The arrays method searches the package namespace for arrays and returns their
names.

=signature arrays

  arrays() (arrayref)

=metadata arrays

{
  since => '0.01',
}

=example-1 arrays

  # given: synopsis;

  package Foo::Bar;

  our @handler = 'start';
  our @initial = ('next', 'prev');

  package main;

  my $arrays = $space->arrays;

  # ["handler", "initial"]

=cut

$test->for('example', 1, 'arrays', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["handler", "initial"];

  $result
});

=method attributes

The attributes method searches the package namespace for attributes and returns
their names. This will not include attributes from roles, mixins, or superclasses.

=signature attributes

  attributes() (arrayref)

=metadata attributes

{
  since => '1.02',
}

=example-1 attributes

  package Foo::Attrs;

  use Venus::Class 'attr';

  attr 'start';
  attr 'abort';

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/attrs');

  my $attributes = $space->attributes;

  # ["start", "abort"]

=cut

$test->for('example', 1, 'attributes', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["start", "abort"];

  $result
});

=example-2 attributes

  package Foo::Base;

  use Venus::Class 'attr', 'base';

  attr 'start';
  attr 'abort';

  package Foo::Attrs;

  use Venus::Class 'attr';

  attr 'show';
  attr 'hide';

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/attrs');

  my $attributes = $space->attributes;

  # ["show", "hide"]

=cut

$test->for('example', 2, 'attributes', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["show", "hide"];

  $result
});

=method authority

The authority method returns the C<AUTHORITY> declared on the target package,
if any.

=signature authority

  authority() (maybe[string])

=metadata authority

{
  since => '0.01',
}

=example-1 authority

  package Foo::Boo;

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/boo');

  my $authority = $space->authority;

  # undef

=cut

$test->for('example', 1, 'authority', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);

  !$result
});

=example-2 authority

  package Foo::Boo;

  our $AUTHORITY = 'cpan:CPANERY';

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/boo');

  my $authority = $space->authority;

  # "cpan:CPANERY"

=cut

$test->for('example', 2, 'authority', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'cpan:CPANERY';

  $result
});

=method basename

The basename method returns the last segment of the package namespace parts.

=signature basename

  basename() (string)

=metadata basename

{
  since => '0.01',
}

=example-1 basename

  # given: synopsis;

  my $basename = $space->basename;

  # "Bar"

=cut

$test->for('example', 1, 'basename', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'Bar';

  $result
});

=method blessed

The blessed method blesses the given value into the package namespace and
returns an object. If no value is given, an empty hashref is used.

=signature blessed

  blessed(Ref $data) (Self)

=metadata blessed

{
  since => '0.01',
}

=example-1 blessed

  # given: synopsis;

  package Foo::Bar;

  sub import;

  package main;

  my $blessed = $space->blessed;

  # bless({}, "Foo::Bar")

=cut

$test->for('example', 1, 'blessed', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Foo::Bar');

  $result
});

=example-2 blessed

  # given: synopsis;

  package Foo::Bar;

  sub import;

  package main;

  my $blessed = $space->blessed({okay => 1});

  # bless({ okay => 1 }, "Foo::Bar")

=cut

$test->for('example', 2, 'blessed', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Foo::Bar');
  ok exists $result->{okay};
  ok $result->{okay} == 1;

  $result
});

=method build

The build method attempts to call C<new> on the package namespace and if
successful returns the resulting object.

=signature build

  build(any @args) (Self)

=metadata build

{
  since => '0.01',
}

=example-1 build

  # given: synopsis;

  package Foo::Bar::Baz;

  sub new {
    bless {}, $_[0];
  }

  package main;

  my $build = $space->child('baz')->build;

  # bless({}, "Foo::Bar::Baz")

=cut

$test->for('example', 1, 'build', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Foo::Bar::Baz');

  $result
});

=example-2 build

  # given: synopsis;

  package Foo::Bar::Bax;

  sub new {
    bless $_[1], $_[0];
  }

  package main;

  my $build = $space->child('bax')->build({okay => 1});

  # bless({ okay => 1 }, "Foo::Bar::Bax")

=cut

$test->for('example', 2, 'build', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Foo::Bar::Bax');
  ok exists $result->{okay};
  ok $result->{okay} == 1;

  $result
});

=example-3 build

  # given: synopsis;

  package Foo::Bar::Bay;

  sub new {
    bless $_[1], $_[0];
  }

  package main;

  my $build = $space->child('bay')->build([okay => 1]);

  # bless(["okay", 1], "Foo::Bar::Bay")

=cut

$test->for('example', 3, 'build', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Foo::Bar::Bay');
  ok $#$result == 1;
  ok $result->[0] eq 'okay';
  ok $result->[1] == 1;

  $result
});

=method call

The call method attempts to call the given subroutine on the package namespace
and if successful returns the resulting value.

=signature call

  call(any @args) (any)

=metadata call

{
  since => '0.01',
}

=example-1 call

  package Foo;

  sub import;

  sub start {
    'started'
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo');

  my $result = $space->call('start');

  # "started"

=cut

$test->for('example', 1, 'call', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'started';

  $result
});

=example-2 call

  package Zoo;

  sub import;

  sub AUTOLOAD {
    bless {};
  }

  sub DESTROY {
    ; # noop
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('zoo');

  my $result = $space->call('start');

  # bless({}, "Zoo")

=cut

$test->for('example', 2, 'call', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Zoo');

  $result
});

=example-3 call

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo');

  my $result = $space->call('missing');

  # Exception! (isa Venus::Space::Error) (see error_on_call_missing)

=cut

$test->for('example', 3, 'call', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Space::Error');
  ok $error->isa('Venus::Error');

  $result
});

=method chain

The chain method chains one or more method calls and returns the result.

=signature chain

  chain(string | tuple[string, any] @steps) (any)

=metadata chain

{
  since => '0.01',
}

=example-1 chain

  package Chu::Chu0;

  sub import;

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Chu::Chu0');

  my $result = $space->chain('blessed');

  # bless({}, "Chu::Chu0")

=cut

$test->for('example', 1, 'chain', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Chu::Chu0');

  $result
});

=example-2 chain

  package Chu::Chu1;

  sub new {
    bless pop;
  }

  sub frame {
    [@_]
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Chu::Chu1');

  my $result = $space->chain(['blessed', {1..4}], 'frame');

  # [bless({ 1 => 2, 3 => 4 }, "Chu::Chu1")]

=cut

$test->for('example', 2, 'chain', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result == 1;
  ok $result->[0]->isa('Chu::Chu1');
  ok exists $result->[0]{1};
  ok $result->[0]{1} == 2;
  ok exists $result->[0]{3};
  ok $result->[0]{3} == 4;

  $result
});

=example-3 chain

  package Chu::Chu2;

  sub new {
    bless pop;
  }

  sub frame {
    [@_]
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Chu::Chu2');

  my $chain = $space->chain('blessed', ['frame', {1..4}]);

  # [bless({}, "Chu::Chu2"), { 1 => 2, 3 => 4 }]

=cut

$test->for('example', 3, 'chain', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result == 2;
  ok $result->[0]->isa('Chu::Chu2');
  ok exists $result->[1]{1};
  ok $result->[1]{1} == 2;
  ok exists $result->[1]{3};
  ok $result->[1]{3} == 4;

  $result
});

=method child

The child method returns a new L<Venus::Space> object for the child
package namespace.

=signature child

  child(string @path) (Venus::Space)

=metadata child

{
  since => '0.01',
}

=example-1 child

  # given: synopsis;

  my $child = $space->child('baz');

  # bless({ value => "Foo/Bar/Baz" }, "Venus::Space")

=cut

$test->for('example', 1, 'child', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok $result =~ 'Foo::Bar::Baz';

  $result
});

=method children

The children method searches C<%INC> and C<@INC> and retuns a list of
L<Venus::Space> objects for each child namespace found (one level deep).

=signature children

  children() (within[arrayref, object])

=metadata children

{
  since => '0.01',
}

=example-1 children

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('c_p_a_n');

  my $children = $space->children;

  # [
  #   bless({ value => "CPAN/Author" }, "Venus::Space"),
  #   bless({ value => "CPAN/Bundle" }, "Venus::Space"),
  #   bless({ value => "CPAN/CacheMgr" }, "Venus::Space"),
  #   ...
  # ]

=cut

$test->for('example', 1, 'children', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result > 0;
  ok $_->isa('Venus::Space') for @$result;

  $result
});

=method cop

The cop method attempts to curry the given subroutine on the package namespace
and if successful returns a closure. This method supports dispatching, i.e.
providing a method name and arguments whose return value will be acted on by
this method.

=signature cop

  cop(string $method, any @args) (coderef)

=metadata cop

{
  since => '0.01',
}

=example-1 cop

  package Foo::Bar;

  sub import;

  sub handler {
    [@_]
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/bar');

  my $code = $space->cop('handler', $space->blessed);

  # sub { Foo::Bar::handler(..., @_) }

=cut

$test->for('example', 1, 'cop', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok ref($result) eq 'CODE';
  my $returns = $result->(1..4);
  ok ref($returns) eq 'ARRAY';
  ok ref($returns->[0]) eq 'Foo::Bar';
  ok $returns->[1] == 1;
  ok $returns->[2] == 2;
  ok $returns->[3] == 3;
  ok $returns->[4] == 4;

  $result
});

=example-2 cop

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/bar');

  my $code = $space->cop('missing', $space->blessed);

  # Exception! (isa Venus::Space::Error) (see error_on_cop_missing)

=cut

$test->for('example', 2, 'cop', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Space::Error');
  ok $error->isa('Venus::Error');

  $result
});

=method data

The data method attempts to read and return any content stored in the C<DATA>
section of the package namespace.

=signature data

  data() (string)

=metadata data

{
  since => '0.01',
}

=example-1 data

  # given: synopsis;

  my $data = $space->data;

  # ""

=cut

$test->for('example', 1, 'data', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);

  !$result
});

=method eval

The eval method takes a list of strings and evaluates them under the namespace
represented by the instance.

=signature eval

  eval(string @data) (any)

=metadata eval

{
  since => '0.01',
}

=example-1 eval

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo');

  my $eval = $space->eval('our $VERSION = 0.01');

  # 0.01

=cut

$test->for('example', 1, 'eval', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, 0.01;
  is "Foo"->VERSION, 0.01;

  $result
});

=example-2 eval

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo');

  my $eval = $space->eval('die');

  # Exception! (isa Venus::Space::Error) (see error_on_eval)

=cut

$test->for('example', 2, 'eval', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Space::Error');
  ok $error->isa('Venus::Error');

  $result
});

=method explain

The explain method returns the package name and is used in stringification
operations.

=signature explain

  explain() (string)

=metadata explain

{
  since => '0.01',
}

=example-1 explain

  # given: synopsis;

  my $explain = $space->explain;

  # "Foo::Bar"

=cut

$test->for('example', 1, 'explain', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'Foo::Bar';

  $result
});

=method hash

The hash method gets or sets the value for the given package hash variable name.

=signature hash

  hash(string $name, any @data) (hashref)

=metadata hash

{
  since => '0.01',
}

=example-1 hash

  # given: synopsis;

  package Foo::Bar;

  our %settings = (
    active => 1
  );

  package main;

  my $hash = $space->hash('settings');

  # { active => 1 }

=cut

$test->for('example', 1, 'hash', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, { active => 1 };

  $result
});

=example-2 hash

  # given: synopsis;

  package Foo::Bar;

  our %settings = (
    active => 1
  );

  package main;

  my $hash = $space->hash('settings', inactive => 1);

  # { inactive => 1 }

=cut

$test->for('example', 2, 'hash', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, { inactive => 1 };

  $result
});

=method hashes

The hashes method searches the package namespace for hashes and returns their
names.

=signature hashes

  hashes() (arrayref)

=metadata hashes

{
  since => '0.01',
}

=example-1 hashes

  # given: synopsis;

  package Foo::Bar;

  our %defaults = (
    active => 0
  );

  our %settings = (
    active => 1
  );

  package main;

  my $hashes = $space->hashes;

  # ["defaults", "settings"]

=cut

$test->for('example', 1, 'hashes', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["defaults", "settings"];

  $result
});

=method id

The id method returns the fully-qualified package name as a label.

=signature id

  id() (string)

=metadata id

{
  since => '0.01',
}

=example-1 id

  # given: synopsis;

  my $id = $space->id;

  # "Foo_Bar"

=cut

$test->for('example', 1, 'id', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'Foo_Bar';

  $result
});

=method lfile

The lfile method returns a C<.pm> file path for the underlying package.

=signature lfile

  lfile() (string)

=metadata lfile

{
  since => '1.30',
}

=example-1 lfile

  # given: synopsis

  package main;

  my $lfile = $space->lfile;

  # "Foo/Bar.pm"

=cut

$test->for('example', 1, 'lfile', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, "Foo/Bar.pm";

  $result
});

=method init

The init method ensures that the package namespace is loaded and, whether
created in-memory or on-disk, is flagged as being loaded and loadable.

=signature init

  init() (string)

=metadata init

{
  since => '0.01',
}

=example-1 init

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('kit');

  my $init = $space->init;

  # "Kit"

=cut

$test->for('example', 1, 'init', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'Kit';

  $result
});

=method inherits

The inherits method returns the list of superclasses the target package is
derived from.

=signature inherits

  inherits() (arrayref)

=metadata inherits

{
  since => '0.01',
}

=example-1 inherits

  package Bar;

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('bar');

  my $inherits = $space->inherits;

  # []

=cut

$test->for('example', 1, 'inherits', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=example-2 inherits

  package Foo;

  sub import;

  package Bar;

  use base 'Foo';

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('bar');

  my $inherits = $space->inherits;

  # ["Foo"]

=cut

$test->for('example', 2, 'inherits', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ['Foo'];

  $result
});

=method included

The included method returns the path of the namespace if it exists in C<%INC>.

=signature included

  included() (string | undef)

=metadata included

{
  since => '0.01',
}

=example-1 included

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Venus/Space');

  my $included = $space->included;

  # "/path/to/lib/Venus/Space.pm"

=cut

$test->for('example', 1, 'included', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result =~ m{lib/Venus/Space.pm$};

  $result
});

=method inject

The inject method monkey-patches the package namespace, installing a named
subroutine into the package which can then be called normally, returning the
fully-qualified subroutine name.

=signature inject

  inject(string $name, maybe[coderef] $coderef) (any)

=metadata inject

{
  since => '0.01',
}

=example-1 inject

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('kit');

  my $inject = $space->inject('build', sub { 'finished' });

  # *Kit::build

=cut

$test->for('example', 1, 'inject', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq '*Kit::build';

  my $package = 'Kit';
  is $package->build, 'finished';

  $result
});

=method integrates

The integrates method returns the list of roles integrated into the target
package.

=signature integrates

  integrates() (arrayref)

=metadata integrates

{
  since => '1.30',
}

=example-1 integrates

  # given: synopsis

  package main;

  my $integrates = $space->integrates;

  # []

=cut

$test->for('example', 1, 'integrates', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok !@$result;

  $result
});

=example-2 integrates

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Venus::Test');

  my $integrates = $space->integrates;

  # [...]

=cut

$test->for('example', 2, 'integrates', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result;

  $result
});

=method load

The load method checks whether the package namespace is already loaded and if
not attempts to load the package. If the package is not loaded and is not
loadable, this method will throw an exception using confess. If the package is
loadable, this method returns truthy with the package name. As a workaround for
packages that only exist in-memory, if the package contains a C<new>, C<with>,
C<meta>, or C<import> routine it will be recognized as having been loaded.

=signature load

  load() (string)

=metadata load

{
  since => '0.01',
}

=example-1 load

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('c_p_a_n');

  my $load = $space->load;

  # "CPAN"

=cut

$test->for('example', 1, 'load', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'CPAN';

  $result
});

=example-2 load

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('no/thing');

  my $load = $space->load;

  # Exception! (isa Venus::Space::Error) (see error_on_load)

=cut

$test->for('example', 2, 'load', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Space::Error');
  ok $error->isa('Venus::Error');

  $result
});

=method loaded

The loaded method checks whether the package namespace is already loaded and
returns truthy or falsy.

=signature loaded

  loaded() (boolean)

=metadata loaded

{
  since => '0.01',
}

=example-1 loaded

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Kit');

  $space->init;

  $space->unload;

  my $loaded = $space->loaded;

  # 0

=cut

$test->for('example', 1, 'loaded', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);

  !$result
});

=example-2 loaded

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Kit');

  $space->init;

  my $loaded = $space->loaded;

  # 1

=cut

$test->for('example', 2, 'loaded', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method locate

The locate method checks whether the package namespace is available in
C<@INC>, i.e. on disk. This method returns the file if found or an empty
string.

=signature locate

  locate() (string)

=metadata locate

{
  since => '0.01',
}

=example-1 locate

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('xyz');

  my $locate = $space->locate;

  # ""

=cut

$test->for('example', 1, 'locate', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);

  !$result
});

=example-2 locate

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('data/dumper');

  $space->load;

  my $locate = $space->locate;

  # "/path/to/lib/Data/Dumper.pm"

=cut

$test->for('example', 2, 'locate', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result =~ m{Data/Dumper.pm$};

  $result
});

=method meta

The meta method returns a L<Venus::Meta> object representing the underlying
package namespace. To access the meta object for the instance itself, use the
superclass' L<Venus::Core/META> method.

=signature meta

  meta() (Venus::Meta)

=metadata meta

{
  since => '1.02',
}

=example-1 meta

  # given: synopsis

  package main;

  my $meta = $space->meta;

  # bless({'name' => 'Foo::Bar'}, 'Venus::Meta')

=cut

$test->for('example', 1, 'meta', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Meta');
  ok $result->{name} eq 'Foo::Bar';

  $result
});

=example-2 meta

  # given: synopsis

  package main;

  my $meta = $space->META;

  # bless({'name' => 'Venus::Space'}, 'Venus::Meta')

=cut

$test->for('example', 2, 'meta', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Meta');
  ok $result->{name} eq 'Venus::Space';

  $result
});

=method mock

The mock method returns a L<Venus::Space> object representing an anonymous
package that derives from the invoking package.

=signature mock

  mock() (Venus::Space)

=metadata mock

{
  since => '1.50',
}

=example-1 mock

  # given: synopsis

  package main;

  my $mock = $space->mock;

  # bless({'name' => 'Venus::Space::Mock::0001::Foo::Bar'}, 'Venus::Space')

  # $mock->isa('Foo::Bar') # true

=cut

$test->for('example', 1, 'mock', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok $result->package->isa('Venus::Space::Mock::0001::Foo::Bar');
  ok $result->package->isa('Foo::Bar');

  $result
});

=method name

The name method returns the fully-qualified package name.

=signature name

  name() (string)

=metadata name

{
  since => '0.01',
}

=example-1 name

  # given: synopsis;

  my $name = $space->name;

  # "Foo::Bar"

=cut

$test->for('example', 1, 'name', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'Foo::Bar';

  $result
});

=method new

The new method constructs an instance of the package.

=signature new

  new(any @args) (Venus::Space)

=metadata new

{
  since => '4.15',
}

=cut

=example-1 new

  package main;

  use Venus::Space;

  my $new = Venus::Space->new('Foo::Bar');

  # bless(..., "Venus::Space")

=cut

$test->for('example', 1, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  is $result->value, 'Foo::Bar';

  $result
});

=example-2 new

  package main;

  use Venus::Space;

  my $new = Venus::Space->new(value => 'Foo::Bar');

  # bless(..., "Venus::Space")

=cut

$test->for('example', 2, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  is $result->value, 'Foo::Bar';

  $result
});

=method parent

The parent method returns a new L<Venus::Space> object for the parent package
namespace.

=signature parent

  parent() (Venus::Space)

=metadata parent

{
  since => '0.01',
}

=example-1 parent

  # given: synopsis;

  my $parent = $space->parent;

  # bless({ value => "Foo" }, "Venus::Space")

=cut

$test->for('example', 1, 'parent', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok $result eq 'Foo';

  $result
});

=method parse

The parse method parses the string argument and returns an arrayref of package
namespace segments (parts).

=signature parse

  parse() (arrayref)

=metadata parse

{
  since => '0.01',
}

=example-1 parse

  # given: synopsis;

  my $parse = $space->parse;

  # ["Foo", "Bar"]

=cut

$test->for('example', 1, 'parse', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["Foo", "Bar"];

  $result
});

=example-2 parse

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Foo/Bar');

  my $parse = $space->parse;

  # ["Foo", "Bar"]

=cut

$test->for('example', 2, 'parse', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["Foo", "Bar"];

  $result
});

=example-3 parse

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Foo\Bar');

  my $parse = $space->parse;

  # ["Foo", "Bar"]

=cut

$test->for('example', 3, 'parse', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["Foo", "Bar"];

  $result
});

=example-4 parse

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Foo-Bar');

  my $parse = $space->parse;

  # ["FooBar"]

=cut

$test->for('example', 4, 'parse', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["FooBar"];

  $result
});

=example-5 parse

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Foo_Bar');

  my $parse = $space->parse;

  # ["FooBar"]

=cut

$test->for('example', 5, 'parse', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["FooBar"];

  $result
});

=method parts

The parts method returns an arrayref of package namespace segments (parts).

=signature parts

  parts() (arrayref)

=metadata parts

{
  since => '0.01',
}

=example-1 parts

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Foo');

  my $parts = $space->parts;

  # ["Foo"]

=cut

$test->for('example', 1, 'parts', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["Foo"];

  $result
});

=example-2 parts

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Foo/Bar');

  my $parts = $space->parts;

  # ["Foo", "Bar"]

=cut

$test->for('example', 2, 'parts', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["Foo", "Bar"];

  $result
});

=example-3 parts

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Foo_Bar');

  my $parts = $space->parts;

  # ["FooBar"]

=cut

$test->for('example', 3, 'parts', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["FooBar"];

  $result
});

=method patch

The patch method overwrites the named subroutine in the underlying package
using the L</swap> operation, stashing the original subroutine reference to be
reset later using L</unpatch>.

=signature patch

  patch(string $name, coderef $code) (Venus::Space)

=metadata patch

{
  since => '0.01',
}

=cut

=example-1 patch

  package Foo::Far;

  use Venus::Class;

  sub execute {
    1
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/far');

  my $patch = $space->patch('execute', sub {
    $_[0]->() + 1
  });

  # bless(..., "Venus::Space")

  # $patch->patched;

  # true

  # Foo::Far->new->execute;

  # 2

=cut

$test->for('example', 1, 'patch', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  isa_ok $result, "Venus::Space";
  is $result->patched, true;
  is Foo::Far->new->execute, 2;
  ok $result->unpatch('execute');
  is Foo::Far->new->execute, 1;
  $result->unload;

  $result
});

=method patched

The patched method confirms whether a subroutine in the underlying namespace
has been patched using the L</patch> operation. If no name is provided, this
method will return true if any subroutines have been patched.  If a name is
provided, this method will return true only if the named subroutine has been
patched, and otherwise returns false.

=signature patched

  patched(string $name) (boolean)

=metadata patched

{
  since => '3.55',
}

=cut

=example-1 patched

  package Foo::Far;

  use Venus::Class;

  sub execute {
    1
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/far');

  $space->patch('execute', sub {
    $_[0]->() + 1
  });

  my $patched = $space->patched;

  # true

=cut

$test->for('example', 1, 'patched', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, true;
  Venus::Space->new('foo/far')->unload;

  $result
});

=example-2 patched

  package Foo::Far;

  use Venus::Class;

  sub execute {
    1
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/far');

  $space->patch('execute', sub {
    $_[0]->() + 1
  });

  my $patched = $space->patched('execute');

  # true

=cut

$test->for('example', 2, 'patched', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, true;
  Venus::Space->new('foo/far')->unload;

  $result
});

=example-3 patched

  package Foo::Far;

  use Venus::Class;

  sub execute {
    1
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/far');

  $space->patch('execute', sub {
    $_[0]->() + 1
  });

  my $patched = $space->patched('prepare');

  # false

=cut

$test->for('example', 3, 'patched', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  is $result, false;
  Venus::Space->new('foo/far')->unload;

  !$result
});

=method pfile

The pfile method returns a C<.pod> file path for the underlying package.

=signature pfile

  pfile() (string)

=metadata pfile

{
  since => '1.30',
}

=example-1 pfile

  # given: synopsis

  package main;

  my $pfile = $space->pfile;

  # "Foo/Bar.pod"

=cut

$test->for('example', 1, 'pfile', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, "Foo/Bar.pod";

  $result
});

=method prepend

The prepend method modifies the object by prepending to the package namespace
parts.

=signature prepend

  prepend(string @path) (Venus::Space)

=metadata prepend

{
  since => '0.01',
}

=example-1 prepend

  # given: synopsis;

  my $prepend = $space->prepend('etc');

  # bless({ value => "Etc/Foo/Bar" }, "Venus::Space")

=cut

$test->for('example', 1, 'prepend', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok "$result" eq 'Etc::Foo::Bar';

  $result
});

=example-2 prepend

  # given: synopsis;

  my $prepend = $space->prepend('etc', 'tmp');

  # bless({ value => "Etc/Tmp/Foo/Bar" }, "Venus::Space")

=cut

$test->for('example', 2, 'prepend', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok "$result" eq 'Etc::Tmp::Foo::Bar';

  $result
});

=method purge

The purge method purges a package space by expunging its symbol table and
removing it from C<%INC>.

=signature purge

  purge() (Self)

=metadata purge

{
  since => '1.02',
}

=example-1 purge

  package main;

  use Venus::Space;

  # Bar::Gen is generated with $VERSION as 0.01

  my $space = Venus::Space->new('Bar/Gen');

  $space->load;

  my $purge = $space->purge;

  # bless({ value => "Bar::Gen" }, "Venus::Space")

  # Bar::Gen->VERSION was 0.01, now undef

  # Symbol table is gone, $space->visible is 0

=cut

$test->for('example', 1, 'purge', sub {
  require File::Spec::Functions;
  mkdir File::Spec::Functions::catdir($path, 'Bar');
  my $file = File::Spec::Functions::catfile($path, 'Bar', 'Gen.pm');
  open my $fh, '>', $file or die "File error: $!";
  my @subs = map "sub $_ {1}", 'a'..'d';
  print $fh join ";\n\n", 'package Bar::Gen', 'our $VERSION = 0.01', @subs, 1;
  close $fh;
  push @INC, $path;

  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok !$result->visible;
  is Bar::Gen->VERSION, undef;

  $result
});

=method rebase

The rebase method returns an object by prepending the package namespace
specified to the base of the current object's namespace.

=signature rebase

  rebase(string @path) (Venus::Space)

=metadata rebase

{
  since => '0.01',
}

=example-1 rebase

  # given: synopsis;

  my $rebase = $space->rebase('zoo');

  # bless({ value => "Zoo/Bar" }, "Venus::Space")

=cut

$test->for('example', 1, 'rebase', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok "$result" eq 'Zoo::Bar';

  $result
});

=method reload

The reload method attempts to delete and reload the package namespace using the
L</load> method. B<Note:> Reloading is additive and will overwrite existing
symbols but does not remove symbols.

=signature reload

  reload() (string)

=metadata reload

{
  since => '0.01',
}

=example-1 reload

  package main;

  use Venus::Space;

  # Foo::Gen is generated with $VERSION as 0.01

  my $space = Venus::Space->new('Foo/Gen');

  my $reload = $space->reload;

  # Foo::Gen
  # Foo::Gen->VERSION is 0.01

=cut

$test->for('example', 1, 'reload', sub {
  require File::Spec::Functions;
  mkdir File::Spec::Functions::catdir($path, 'Foo');
  my $file = File::Spec::Functions::catfile($path, 'Foo', 'Gen.pm');
  open my $fh, '>', $file or die "File error: $!";
  my @subs = map "sub $_ {1}", 'a'..'d';
  print $fh join ";\n\n", 'package Foo::Gen', 'our $VERSION = 0.01', @subs, 1;
  close $fh;
  push @INC, $path;

  my ($tryable) = @_;
  ok(my $result = $tryable->result);
  is($result, 'Foo::Gen');
  is($Foo::Gen::VERSION, 0.01);
  is(Foo::Gen->VERSION, 0.01);
  ok(Foo::Gen->can($_)) for 'a'..'d';

  $result
});

=example-2 reload

  package main;

  use Venus::Space;

  # Foo::Gen is generated with $VERSION as 0.02

  my $space = Venus::Space->new('Foo/Gen');

  my $reload = $space->reload;

  # Foo::Gen
  # Foo::Gen->VERSION is 0.02

=cut

$test->for('example', 2, 'reload', sub {
  require File::Spec::Functions;
  mkdir File::Spec::Functions::catdir($path, 'Foo');
  my $file = File::Spec::Functions::catfile($path, 'Foo', 'Gen.pm');
  open my $fh, '>', $file or die "File error: $!";
  my @subs = map "sub $_ {1}", 'a'..'d';
  print $fh join ";\n\n", 'package Foo::Gen', 'our $VERSION = 0.02', @subs, 1;
  close $fh;
  push @INC, $path;

  my ($tryable) = @_;
  ok(my $result = $tryable->result);
  is($result, 'Foo::Gen');
  is($Foo::Gen::VERSION, 0.02);
  is(Foo::Gen->VERSION, 0.02);
  ok(Foo::Gen->can($_)) for 'a'..'d';

  $result
});

=method require

The require method executes a C<require> statement within the package namespace
specified.

=signature require

  require(string $target) (any)

=metadata require

{
  since => '0.01',
}

=example-1 require

  # given: synopsis;

  my $require = $space->require('Venus');

  # 1

=cut

$test->for('example', 1, 'require', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method root

The root method returns the root package namespace segments (parts). Sometimes
separating the C<root> from the C<parts> helps identify how subsequent child
objects were derived.

=signature root

  root() (string)

=metadata root

{
  since => '0.01',
}

=example-1 root

  # given: synopsis;

  my $root = $space->root;

  # "Foo"

=cut

$test->for('example', 1, 'root', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'Foo';

  $result
});

=method routine

The routine method gets or sets the subroutine reference for the given subroutine
name.

=signature routine

  routine(string $name, coderef $code) (coderef)

=metadata routine

{
  since => '0.01',
}

=example-1 routine

  package Foo;

  sub cont {
    [@_]
  }

  sub abort {
    [@_]
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo');

  my $routine = $space->routine('cont');

  # sub { ... }

=cut

$test->for('example', 1, 'routine', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result->('begin'), ['begin'];

  $result
});

=example-2 routine

  package Foo;

  sub cont {
    [@_]
  }

  sub abort {
    [@_]
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo');

  my $routine = $space->routine('report', sub{[@_]});

  # sub { ... }

=cut

$test->for('example', 2, 'routine', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result->('begin'), ['begin'];
  is_deeply Foo::report('begin'), ['begin'];

  $result
});

=method routines

The routines method searches the package namespace for routines and returns
their names.

=signature routines

  routines() (arrayref)

=metadata routines

{
  since => '0.01',
}

=example-1 routines

  package Foo::Subs;

  sub start {
    1
  }

  sub abort {
    1
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/subs');

  my $routines = $space->routines;

  # ["abort", "start"]

=cut

$test->for('example', 1, 'routines', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["abort", "start"];

  $result
});

=method scalar

The scalar method gets or sets the value for the given package scalar variable name.

=signature scalar

  scalar(string $name, any @data) (any)

=metadata scalar

{
  since => '0.01',
}

=example-1 scalar

  # given: synopsis;

  package Foo::Bar;

  our $root = '/path/to/file';

  package main;

  my $scalar = $space->scalar('root');

  # "/path/to/file"

=cut

$test->for('example', 1, 'scalar', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "/path/to/file";

  $result
});

=example-2 scalar

  # given: synopsis;

  package Foo::Bar;

  our $root = '/path/to/file';

  package main;

  my $scalar = $space->scalar('root', '/tmp/path/to/file');

  # "/tmp/path/to/file"

=cut

$test->for('example', 2, 'scalar', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "/tmp/path/to/file";

  $result
});

=method scalars

The scalars method searches the package namespace for scalars and returns their
names.

=signature scalars

  scalars() (arrayref)

=metadata scalars

{
  since => '0.01',
}

=example-1 scalars

  # given: synopsis;

  package Foo::Bar;

  our $root = 'root';
  our $base = 'path/to';
  our $file = 'file';

  package main;

  my $scalars = $space->scalars;

  # ["base", "file", "root"]

=cut

$test->for('example', 1, 'scalars', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["base", "file", "root"];

  $result
});

=method sibling

The sibling method returns a new L<Venus::Space> object for the sibling package
namespace.

=signature sibling

  sibling(string $path) (Venus::Space)

=metadata sibling

{
  since => '0.01',
}

=example-1 sibling

  # given: synopsis;

  my $sibling = $space->sibling('baz');

  # bless({ value => "Foo/Baz" }, "Venus::Space")

=cut

$test->for('example', 1, 'sibling', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok "$result" eq "Foo::Baz";

  $result
});

=method siblings

The siblings method searches C<%INC> and C<@INC> and retuns a list of
L<Venus::Space> objects for each sibling namespace found (one level deep).

=signature siblings

  siblings() (within[arrayref, object])

=metadata siblings

{
  since => '0.01',
}

=example-1 siblings

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('encode/m_i_m_e');

  my $siblings = $space->siblings;

  # [
  #   bless({ value => "Encode/MIME/Header" }, "Venus::Space"),
  #   bless({ value => "Encode/MIME/Name" }, "Venus::Space"),
  #   ...
  # ]

=cut

$test->for('example', 1, 'siblings', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result > 0;

  ok $result->[0]->isa('Venus::Space');
  ok $result->[1]->isa('Venus::Space');

  $result
});

=method splice

The splice method perform a Perl L<perlfunc/splice> operation on the package
namespace.

=signature splice

  splice(number $offset, number $length, any @list) (Venus::Space)

=metadata splice

{
  since => '0.09',
}

=example-1 splice

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/baz');

  my $splice = $space->splice(1, 0, 'bar');

  # bless({ value => "Foo/Bar/Baz" }, "Venus::Space")

=cut

$test->for('example', 1, 'splice', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok "$result" eq "Foo::Bar::Baz";

  $result
});

=example-2 splice

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/baz');

  my $splice = $space->splice(1, 1);

  # bless({ value => "Foo" }, "Venus::Space")

=cut

$test->for('example', 2, 'splice', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok "$result" eq "Foo";

  $result
});

=example-3 splice

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/baz');

  my $splice = $space->splice(-2, 1);

  # bless({ value => "Baz" }, "Venus::Space")

=cut

$test->for('example', 3, 'splice', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok "$result" eq "Baz";

  $result
});

=example-4 splice

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/baz');

  my $splice = $space->splice(1);

  # bless({ value => "Foo" }, "Venus::Space")

=cut

$test->for('example', 4, 'splice', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok "$result" eq "Foo";

  $result
});

=method swap

The swap method overwrites the named subroutine in the underlying package with
the code reference provided and returns the original subroutine as a code
reference. The code provided will be passed a reference to the original
subroutine as its first argument.

=signature swap

  swap(string $name, coderef $code) (coderef)

=metadata swap

{
  since => '1.95',
}

=example-1 swap

  package Foo::Swap;

  use Venus::Class;

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/swap');

  my $subroutine = $space->swap('new', sub {
    my ($next, @args) = @_;
    my $self = $next->(@args);
    $self->{swapped} = 1;
    return $self;
  });

  # sub { ... }

=cut

$test->for('example', 1, 'swap', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok ref $result eq 'CODE';
  my $return = $result->('Foo::Swap');
  ok $return->isa('Foo::Swap');
  ok !exists $return->{swapped};
  my $swap = Foo::Swap->new;
  ok exists $swap->{swapped};
  ok $swap->{swapped} == 1;

  $result
});

=example-2 swap

  package Foo::Swap;

  use Venus::Class;

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/swap');

  my $subroutine = $space->swap('something', sub {
    my ($next, @args) = @_;
    my $self = $next->(@args);
    $self->{swapped} = 1;
    return $self;
  });

  # Exception! (isa Venus::Space::Error) (see error_on_swap)

=cut

$test->for('example', 2, 'swap', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Space::Error');
  ok $error->isa('Venus::Error');
  ok $error->is('on.swap');

  $result
});

=method tfile

The tfile method returns a C<.t> file path for the underlying package.

=signature tfile

  tfile() (string)

=metadata tfile

{
  since => '1.30',
}

=example-1 tfile

  # given: synopsis

  package main;

  my $tfile = $space->tfile;

  # "Foo_Bar.t"

=cut

$test->for('example', 1, 'tfile', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is $result, "Foo_Bar.t";

  $result
});

=method tryload

The tryload method attempt to C<load> the represented package using the
L</load> method and returns truthy/falsy based on whether the package was
loaded.

=signature tryload

  tryload() (boolean)

=metadata tryload

{
  since => '0.01',
}

=example-1 tryload

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('c_p_a_n');

  my $tryload = $space->tryload;

  # 1

=cut

$test->for('example', 1, 'tryload', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-2 tryload

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('n_a_p_c');

  my $tryload = $space->tryload;

  # 0

=cut

$test->for('example', 2, 'tryload', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);

  !$result
});

=method use

The use method executes a C<use> statement within the package namespace
specified.

=signature use

  use(string | tuple[string, string] $target, any @params) (Venus::Space)

=metadata use

{
  since => '0.01',
}

=example-1 use

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/goo');

  my $use = $space->use('Venus');

  # bless({ value => "foo/goo" }, "Venus::Space")

=cut

$test->for('example', 1, 'use', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok "$result" eq 'Foo::Goo';
  is $result->package, 'Foo::Goo';
  ok !$result->package->can('error');
  ok $result->package->can('false');
  ok !$result->package->can('raise');
  ok $result->package->can('true');

  $result
});

=example-2 use

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/hoo');

  my $use = $space->use('Venus', 'error');

  # bless({ value => "foo/hoo" }, "Venus::Space")

=cut

$test->for('example', 2, 'use', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok "$result" eq 'Foo::Hoo';
  is $result->package, 'Foo::Hoo';
  ok $result->package->can('error');
  ok $result->package->can('false');
  ok !$result->package->can('raise');
  ok $result->package->can('true');

  $result
});

=example-3 use

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/foo');

  my $use = $space->use(['Venus', 9.99], 'error');

=cut

$test->for('example', 3, 'use', sub {
  my $failed = 0;
  my ($tryable) = @_;
  $tryable->default(sub {
    my ($error) = @_;
    $failed++;
    Venus::Space->new('foo/foo');
  });
  ok my $result = $tryable->result;
  is $result->package, 'Foo::Foo';
  ok $failed;
  ok !$result->package->can('error');
  ok !$result->package->can('false');
  ok !$result->package->can('raise');
  ok !$result->package->can('true');

  $result
});

=method unload

The unload method unloads a package space by nullifying its symbol table and
removing it from C<%INC>.

=signature unload

  unload() (Self)

=metadata unload

{
  since => '1.02',
}

=example-1 unload

  package main;

  use Venus::Space;

  # Bar::Gen is generated with $VERSION as 0.01

  my $space = Venus::Space->new('Bar/Gen');

  $space->load;

  my $unload = $space->unload;

  # bless({ value => "Bar::Gen" }, "Venus::Space")

  # Bar::Gen->VERSION was 0.01, now undef

  # Symbol table remains, $space->visible is 1

=cut

$test->for('example', 1, 'unload', sub {
  require File::Spec::Functions;
  mkdir File::Spec::Functions::catdir($path, 'Bar');
  my $file = File::Spec::Functions::catfile($path, 'Bar', 'Gen.pm');
  open my $fh, '>', $file or die "File error: $!";
  my @subs = map "sub $_ {1}", 'a'..'d';
  print $fh join ";\n\n", 'package Bar::Gen', 'our $VERSION = 0.01', @subs, 1;
  close $fh;
  push @INC, $path;

  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Space');
  ok $result->visible;
  is Bar::Gen->VERSION, undef;

  $result
});

=method unloaded

The unloaded method checks whether the package namespace is not loaded and
returns truthy or falsy.

=signature unloaded

  unloaded() (boolean)

=metadata unloaded

{
  since => '1.02',
}

=example-1 unloaded

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Kit');

  $space->init;

  $space->unload;

  my $unloaded = $space->unloaded;

  # 1

=cut

$test->for('example', 1, 'unloaded', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-2 unloaded

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('Kit');

  $space->init;

  my $unloaded = $space->unloaded;

  # 0

=cut

$test->for('example', 2, 'unloaded', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok $result == 0;

  !$result
});

=method unpatch

The unpatch method restores a subroutine which has been patched using the
L</patch> operation to its original subroutine reference. If no name is
provided, this method will restore all subroutines have been patched. If a name
is provided, this method will only restore the named subroutine has been
patched.

=signature unpatch

  unpatch(string @names) (Venus::Space)

=metadata unpatch

{
  since => '3.55',
}

=cut

=example-1 unpatch

  package Foo::Far;

  use Venus::Class;

  sub execute {
    1
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/far');

  $space->patch('execute', sub {
    $_[0]->() + 1
  });

  my $unpatch = $space->unpatch;

  # bless(..., "Venus::Space")

=cut

$test->for('example', 1, 'unpatch', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  isa_ok $result, "Venus::Space";
  is $result->patched, false;
  Venus::Space->new('foo/far')->unload;

  $result
});

=example-2 unpatch

  package Foo::Far;

  use Venus::Class;

  sub execute {
    1
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/far');

  $space->patch('execute', sub {
    $_[0]->() + 1
  });

  my $unpatch = $space->unpatch('execute');

  # bless(..., "Venus::Space")

=cut

$test->for('example', 2, 'unpatch', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  isa_ok $result, "Venus::Space";
  is $result->patched, false;
  Venus::Space->new('foo/far')->unload;

  $result
});

=example-3 unpatch

  package Foo::Far;

  use Venus::Class;

  sub execute {
    1
  }

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/far');

  $space->patch('execute', sub {
    $_[0]->() + 1
  });

  my $unpatch = $space->unpatch('prepare');

  # bless(..., "Venus::Space")

=cut

$test->for('example', 3, 'unpatch', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok defined $result;
  isa_ok $result, "Venus::Space";
  is $result->patched, true;
  Venus::Space->new('foo/far')->unload;

  $result
});

=method variables

The variables method searches the package namespace for variables and returns
their names.

=signature variables

  variables() (within[arrayref, tuple[string, arrayref]])

=metadata variables

{
  since => '0.01',
}

=example-1 variables

  package Etc;

  our $init = 0;
  our $func = 1;

  our @does = (1..4);
  our %sets = (1..4);

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('etc');

  my $variables = $space->variables;

  # [
  #   ["arrays", ["does"]],
  #   ["hashes", ["sets"]],
  #   ["scalars", ["func", "init"]],
  # ]

=cut

$test->for('example', 1, 'variables', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  my $arrays = ['arrays', ['does']];
  my $hashes = ['hashes', ['sets']];
  my $scalars = ['scalars', ['func', 'init']];
  is_deeply $result, [$arrays, $hashes, $scalars];

  $result
});

=method visible

The visible method returns truthy is the package namespace is visible, i.e. has
symbols defined.

=signature visible

  visible() (boolean)

=metadata visible

{
  since => '1.02',
}

=example-1 visible

  # given: synopsis

  package main;

  my $visible = $space->visible;

  # 1

=cut

$test->for('example', 1, 'visible', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-2 visible

  package Foo::Fe;

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/fe');

  my $visible = $space->visible;

  # 0

=cut

$test->for('example', 2, 'visible', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok $result == 0;

  !$result
});

=example-3 visible

  package Foo::Fe;

  our $VERSION = 0.01;

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/fe');

  my $visible = $space->visible;

  # 1

=cut

$test->for('example', 3, 'visible', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-4 visible

  package Foo::Fi;

  sub import;

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/fi');

  my $visible = $space->visible;

  # 1

=cut

$test->for('example', 4, 'visible', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method version

The version method returns the C<VERSION> declared on the target package, if
any.

=signature version

  version() (maybe[string])

=metadata version

{
  since => '0.01',
}

=example-1 version

  package Foo::Boo;

  sub import;

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/boo');

  my $version = $space->version;

  # undef

=cut

$test->for('example', 1, 'version', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);

  !$result
});

=example-2 version

  package Foo::Boo;

  our $VERSION = 0.01;

  package main;

  use Venus::Space;

  my $space = Venus::Space->new('foo/boo');

  my $version = $space->version;

  # 0.01

=cut

$test->for('example', 2, 'version', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq '0.01';

  $result
});

=error error_on_call_missing

This package may raise an C<on.call.missing> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_call_missing> method.

=cut

$test->for('error', 'error_on_call_missing');

=example-1 error_on_call_missing

  # given: synopsis;

  my $error = $space->error_on_call_missing({
    package => 'Example',
    routine => 'execute',
  });

  # ...

  # my $name = $error->name;

  # "on.call.missing"

  # my $render = $error->render;

  # "Unable to locate class method \"execute\" via package \"Example\""

=cut

$test->for('example', 1, 'error_on_call_missing', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.call.missing";
  my $render = $result->render;
  is $render, "Unable to locate class method \"execute\" via package \"Example\"";

  $result
});

=error error_on_call_undefined

This package may raise an C<on.call.undefined> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_call_undefined> method.

=cut

$test->for('error', 'error_on_call_undefined');

=example-1 error_on_call_undefined

  # given: synopsis;

  my $error = $space->error_on_call_undefined({
    package => 'Example',
    routine => 'execute',
  });

  # ...

  # my $name = $error->name;

  # "on.call.undefined"

  # my $render = $error->render;

  # "Attempt to call undefined class method in package \"Example\""

=cut

$test->for('example', 1, 'error_on_call_undefined', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.call.undefined";
  my $render = $result->render;
  is $render, "Attempt to call undefined class method in package \"Example\"";

  $result
});

=error error_on_cop_missing

This package may raise an C<on.cop.missing> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_cop_missing> method.

=cut

$test->for('error', 'error_on_cop_missing');

=example-1 error_on_cop_missing

  # given: synopsis;

  my $error = $space->error_on_cop_missing({
    package => 'Example',
    routine => 'execute',
  });

  # ...

  # my $name = $error->name;

  # "on.cop.missing"

  # my $render = $error->render;

  # "Unable to locate object method \"execute\" via package \"Example\""

=cut

$test->for('example', 1, 'error_on_cop_missing', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.cop.missing";
  my $render = $result->render;
  is $render, "Unable to locate object method \"execute\" via package \"Example\"";

  $result
});

=error error_on_cop_undefined

This package may raise an C<on.cop.undefined> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_cop_undefined> method.

=cut

$test->for('error', 'error_on_cop_undefined');

=example-1 error_on_cop_undefined

  # given: synopsis;

  my $error = $space->error_on_cop_undefined({
    package => 'Example',
    routine => 'execute',
  });

  # ...

  # my $name = $error->name;

  # "on.cop.undefined"

  # my $render = $error->render;

  # "Attempt to cop undefined object method from package \"$class\""

=cut

$test->for('example', 1, 'error_on_cop_undefined', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.cop.undefined";
  my $render = $result->render;
  is $render, "Attempt to cop undefined object method from package \"Example\"";

  $result
});

=error error_on_eval

This package may raise an C<on.eval> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_eval> method.

=cut

$test->for('error', 'error_on_eval');

=example-1 error_on_eval

  # given: synopsis;

  my $error = $space->error_on_eval({
    error => 'Exception!',
    package => 'Example',
  });

  # ...

  # my $name = $error->name;

  # "on.eval"

  # my $render = $error->render;

  # "Exception!"

=cut

$test->for('example', 1, 'error_on_eval', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.eval";
  my $render = $result->render;
  is $render, "Exception!";

  $result
});

=error error_on_load

This package may raise an C<on.load> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_load> method.

=cut

$test->for('error', 'error_on_load');

=example-1 error_on_load

  # given: synopsis;

  my $error = $space->error_on_load({
    package => 'Example',
    error => 'cause unknown',
  });

  # ...

  # my $name = $error->name;

  # "on.load"

  # my $render = $error->render;

  # "Error attempting to load Example: \"cause unknown\""

=cut

$test->for('example', 1, 'error_on_load', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.load";
  my $render = $result->render;
  is $render, "Error attempting to load Example: \"cause unknown\"";

  $result
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Space.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;