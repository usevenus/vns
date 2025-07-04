package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;
use Venus;

my $test = test(__FILE__);

=name

Venus::Opts

=cut

$test->for('name');

=tagline

Opts Class

=cut

$test->for('tagline');

=abstract

Opts Class for Perl 5

=cut

$test->for('abstract');

=includes

method: default
method: exists
method: get
method: name
method: new
method: parse
method: reparse
method: set
method: unnamed

=cut

$test->for('includes');

=synopsis

  package main;

  use Venus::Opts;

  my $opts = Venus::Opts->new(
    value => ['--resource', 'users', '--help'],
    specs => ['resource|r=s', 'help|h'],
    named => { method => 'resource' } # optional
  );

  # $opts->method; # $resource
  # $opts->get('resource'); # $resource

  # $opts->help; # $help
  # $opts->get('help'); # $help

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Opts');

  is $result->method, 'users';
  is $result->help, 1;

  $result
});

=description

This package provides methods for handling command-line arguments.

=cut

$test->for('description');

=inherits

Venus::Kind::Utility

=cut

$test->for('inherits');

=integrates

Venus::Role::Accessible
Venus::Role::Buildable
Venus::Role::Proxyable
Venus::Role::Valuable

=cut

$test->for('integrates');

=attributes

named: rw, opt, HashRef, C<{}>
parsed: rw, opt, HashRef, C<{}>
specs: rw, opt, ArrayRef, C<[]>
warns: rw, opt, ArrayRef, C<[]>
unused: rw, opt, ArrayRef, C<[]>

=cut

$test->for('attributes');

=method default

The default method returns the default value, i.e. C<[@ARGV]>.

=signature default

  default() (arrayref)

=metadata default

{
  since => '0.01',
}

=example-1 default

  # given: synopsis;

  my $default = $opts->default;

  # []

=cut

$test->for('example', 1, 'default', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok ref($result) eq 'ARRAY';

  $result
});

=method exists

The exists method takes a name or index and returns truthy if an associated
value exists.

=signature exists

  exists(string $key) (boolean)

=metadata exists

{
  since => '0.01',
}

=example-1 exists

  # given: synopsis;

  my $exists = $opts->exists('resource');

  # 1

=cut

$test->for('example', 1, 'exists', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-2 exists

  # given: synopsis;

  my $exists = $opts->exists('method');

  # 1

=cut

$test->for('example', 2, 'exists', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-3 exists

  # given: synopsis;

  my $exists = $opts->exists('resources');

  # undef

=cut

$test->for('example', 3, 'exists', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok !defined $result;

  !$result
});

=method get

The get method takes a name or index and returns the associated value.

=signature get

  get(string $key) (any)

=metadata get

{
  since => '0.01',
}

=example-1 get

  # given: synopsis;

  my $get = $opts->get('resource');

  # "users"

=cut

$test->for('example', 1, 'get', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "users";

  $result
});

=example-2 get

  # given: synopsis;

  my $get = $opts->get('method');

  # "users"

=cut

$test->for('example', 2, 'get', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "users";

  $result
});

=example-3 get

  # given: synopsis;

  my $get = $opts->get('resources');

  # undef

=cut

$test->for('example', 3, 'get', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok !defined $result;

  !$result
});

=method new

The new method constructs an instance of the package.

=signature new

  new(any @args) (Venus::Opts)

=metadata new

{
  since => '4.15',
}

=cut

=example-1 new

  package main;

  use Venus::Opts;

  my $new = Venus::Opts->new;

  # bless(..., "Venus::Opts")

=cut

$test->for('example', 1, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Opts');
  ok $result->value;

  $result
});

=example-2 new

  package main;

  use Venus::Opts;

  my $new = Venus::Opts->new(
    ['--resource', 'users', '--help'],
  );

  # bless(..., "Venus::Opts")

=cut

$test->for('example', 2, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Opts');
  is_deeply $result->value, ['--resource', 'users', '--help'];

  $result
});

=example-3 new

  package main;

  use Venus::Opts;

  my $new = Venus::Opts->new(
    value => ['--resource', 'users', '--help'],
  );

  # bless(..., "Venus::Opts")

=cut

$test->for('example', 3, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Opts');
  is_deeply $result->value, ['--resource', 'users', '--help'];

  $result
});

=method parse

The parse method optionally takes additional L<Getopt::Long> parser
configuration options and retuns the options found based on the object C<args>
and C<spec> values.

=signature parse

  parse(arrayref $args) (Venus::Opts)

=metadata parse

{
  since => '0.01',
}

=example-1 parse

  # given: synopsis;

  my $parse = $opts->parse;

  # bless({...}, 'Venus::Opts')

=cut

$test->for('example', 1, 'parse', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  isa_ok $result, 'Venus::Opts';
  is_deeply $result->parsed, { help => 1, resource => "users" };

  $result
});

=example-2 parse

  # given: synopsis;

  my $parse = $opts->parse(['bundling']);

  # bless({...}, 'Venus::Opts')

=cut

$test->for('example', 2, 'parse', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  isa_ok $result, 'Venus::Opts';
  is_deeply $result->parsed, { help => 1, resource => "users" };

  $result
});

=method reparse

The reparse method resets the parser, calls the L</parse> method and returns
the result.

=signature reparse

  reparse(arrayref $specs, arrayref $args) (Venus::Opts)

=metadata reparse

{
  since => '2.55',
}

=cut

=example-1 reparse

  # given: synopsis;

  my $reparse = $opts->reparse(['resource|r=s']);

  # bless({...}, 'Venus::Opts')

=cut

$test->for('example', 1, 'reparse', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  isa_ok $result, 'Venus::Opts';
  is_deeply $result->parsed, { resource => "users" };

  $result
});

=example-2 reparse

  # given: synopsis;

  my $reparse = $opts->reparse(['resource|r=s'], ['bundling']);

  # bless({...}, 'Venus::Opts')

=cut

$test->for('example', 2, 'reparse', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  isa_ok $result, 'Venus::Opts';
  is_deeply $result->parsed, { resource => "users" };

  $result
});

=method name

The name method takes a name or index and returns index if the the associated
value exists.

=signature name

  name(string $key) (string | undef)

=metadata name

{
  since => '0.01',
}

=example-1 name

  # given: synopsis;

  my $name = $opts->name('resource');

  # "resource"

=cut

$test->for('example', 1, 'name', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "resource";

  $result
});

=example-2 name

  # given: synopsis;

  my $name = $opts->name('method');

  # "resource"

=cut

$test->for('example', 2, 'name', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "resource";

  $result
});

=example-3 name

  # given: synopsis;

  my $name = $opts->name('resources');

  # undef

=cut

$test->for('example', 3, 'name', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok !defined $result;

  !$result
});

=method set

The set method takes a name or index and sets the value provided if the
associated argument exists.

=signature set

  set(string $key, any $data) (any)

=metadata set

{
  since => '0.01',
}

=example-1 set

  # given: synopsis;

  my $set = $opts->set('method', 'people');

  # "people"

=cut

$test->for('example', 1, 'set', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "people";

  $result
});

=example-2 set

  # given: synopsis;

  my $set = $opts->set('resource', 'people');

  # "people"

=cut

$test->for('example', 2, 'set', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "people";

  $result
});

=example-3 set

  # given: synopsis;

  my $set = $opts->set('resources', 'people');

  # undef

=cut

$test->for('example', 3, 'set', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok !defined $result;

  !$result
});

=method unnamed

The unnamed method returns an arrayref of values which have not been named
using the C<named> attribute.

=signature unnamed

  unnamed() (arrayref)

=metadata unnamed

{
  since => '0.01',
}

=example-1 unnamed

  # given: synopsis;

  my $unnamed = $opts->unnamed;

  # [1]

=cut

$test->for('example', 1, 'unnamed', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [1];

  $result
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Opts.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;