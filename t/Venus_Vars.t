package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;
use Venus;

my $test = test(__FILE__);

=name

Venus::Vars

=cut

$test->for('name');

=tagline

Vars Class

=cut

$test->for('tagline');

=abstract

Vars Class for Perl 5

=cut

$test->for('abstract');

=includes

method: default
method: exists
method: get
method: name
method: new
method: set
method: unnamed

=cut

$test->for('includes');

=synopsis

  package main;

  use Venus::Vars;

  my $vars = Venus::Vars->new(
    value => { USER => 'awncorp', HOME => '/home/awncorp', },
    named => { iam => 'USER', root => 'HOME', },
  );

  # $vars->root; # $ENV{HOME}
  # $vars->home; # $ENV{HOME}
  # $vars->get('home'); # $ENV{HOME}
  # $vars->get('HOME'); # $ENV{HOME}

  # $vars->iam; # $ENV{USER}
  # $vars->user; # $ENV{USER}
  # $vars->get('user'); # $ENV{USER}
  # $vars->get('USER'); # $ENV{USER}

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Vars');
  is $result->iam, 'awncorp';
  is $result->root, '/home/awncorp';

  $result
});

=description

This package provides methods for accessing C<%ENV> items.

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

=cut

$test->for('attributes');

=method default

The default method returns the default value, i.e. C<{%ENV}>.

=signature default

  default() (hashref)

=metadata default

{
  since => '0.01',
}

=example-1 default

  # given: synopsis;

  my $default = $vars->default;

  # { USER => 'awncorp', HOME => '/home/awncorp', ... }

=cut

$test->for('example', 1, 'default', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok ref($result) eq 'HASH';

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

  my $exists = $vars->exists('iam');;

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

  my $exists = $vars->exists('USER');;

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

  my $exists = $vars->exists('PATH');

  # undef

=cut

$test->for('example', 3, 'exists', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok !defined $result;

  !$result
});

=example-4 exists

  # given: synopsis;

  my $exists = $vars->exists('user');

  # 1

=cut

$test->for('example', 4, 'exists', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
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

  my $get = $vars->get('iam');

  # "awncorp"

=cut

$test->for('example', 1, 'get', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "awncorp";

  $result
});

=example-2 get

  # given: synopsis;

  my $get = $vars->get('USER');

  # "awncorp"

=cut

$test->for('example', 2, 'get', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "awncorp";

  $result
});

=example-3 get

  # given: synopsis;

  my $get = $vars->get('PATH');

  # undef

=cut

$test->for('example', 3, 'get', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok !defined $result;

  !$result
});

=example-4 get

  # given: synopsis;

  my $get = $vars->get('user');

  # "awncorp"

=cut

$test->for('example', 4, 'get', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "awncorp";

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

  my $name = $vars->name('iam');

  # "USER"

=cut

$test->for('example', 1, 'name', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "USER";

  $result
});

=example-2 name

  # given: synopsis;

  my $name = $vars->name('USER');

  # "USER"

=cut

$test->for('example', 2, 'name', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "USER";

  $result
});

=example-3 name

  # given: synopsis;

  my $name = $vars->name('PATH');

  # undef

=cut

$test->for('example', 3, 'name', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok !defined $result;

  !$result
});

=example-4 name

  # given: synopsis;

  my $name = $vars->name('user');

  # "USER"

=cut

$test->for('example', 4, 'name', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "USER";

  $result
});

=method new

The new method constructs an instance of the package.

=signature new

  new(any @args) (Venus::Vars)

=metadata new

{
  since => '4.15',
}

=cut

=example-1 new

  package main;

  use Venus::Vars;

  my $new = Venus::Vars->new;

  # bless(..., "Venus::Vars")

=cut

$test->for('example', 1, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Vars');

  $result
});

=example-2 new

  package main;

  use Venus::Vars;

  my $new = Venus::Vars->new(
    {USER => 'awncorp', HOME => '/home/awncorp'},
  );

  # bless(..., "Venus::Vars")

=cut

$test->for('example', 2, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Vars');
  is $result->value->{USER}, 'awncorp';
  is $result->value->{HOME}, '/home/awncorp';

  $result
});

=example-3 new

  package main;

  use Venus::Vars;

  my $new = Venus::Vars->new(
    value => {USER => 'awncorp', HOME => '/home/awncorp'},
  );

  # bless(..., "Venus::Vars")

=cut

$test->for('example', 3, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Vars');
  ok $result->isa('Venus::Vars');
  is $result->value->{USER}, 'awncorp';
  is $result->value->{HOME}, '/home/awncorp';

  $result
});

=method set

The set method takes a name or index and sets the value provided if the
associated argument exists.

=signature set

  set(string $key, any $value) (any)

=metadata set

{
  since => '0.01',
}

=example-1 set

  # given: synopsis;

  my $set = $vars->set('iam', 'root');

  # "root"

=cut

$test->for('example', 1, 'set', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "root";

  $result
});

=example-2 set

  # given: synopsis;

  my $set = $vars->set('USER', 'root');

  # "root"

=cut

$test->for('example', 2, 'set', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "root";

  $result
});

=example-3 set

  # given: synopsis;

  my $set = $vars->set('PATH', '/tmp');

  # undef

=cut

$test->for('example', 3, 'set', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok !defined $result;

  !$result
});

=example-4 set

  # given: synopsis;

  my $set = $vars->set('user', 'root');

  # "root"

=cut

$test->for('example', 4, 'set', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "root";

  $result
});

=method unnamed

The unnamed method returns an arrayref of values which have not been named
using the C<named> attribute.

=signature unnamed

  unnamed() (hashref)

=metadata unnamed

{
  since => '0.01',
}

=example-1 unnamed

  package main;

  use Venus::Vars;

  my $vars = Venus::Vars->new(
    value => { USER => 'awncorp', HOME => '/home/awncorp', },
    named => { root => 'HOME', },
  );

  my $unnamed = $vars->unnamed;

  # { USER => "awncorp" }

=cut

$test->for('example', 1, 'unnamed', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, { USER => "awncorp" };

  $result
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Vars.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;