package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;

my $test = test(__FILE__);

=name

Venus::Core::Class

=cut

$test->for('name');

=tagline

Class Base Class

=cut

$test->for('tagline');

=abstract

Class Base Class for Perl 5

=cut

$test->for('abstract');

=includes

method: import
method: does
method: meta
method: new
method: unimport

=cut

$test->for('includes');

=synopsis

  package User;

  use base 'Venus::Core::Class';

  package main;

  my $user = User->new(
    fname => 'Elliot',
    lname => 'Alderson',
  );

  # bless({fname => 'Elliot', lname => 'Alderson'}, 'User')

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('User');
  ok UNIVERSAL::isa($result, 'HASH');
  ok $result->{fname} eq 'Elliot';
  ok $result->{lname} eq 'Alderson';

  $result
});

=description

This package provides a class base class with class building and object
construction lifecycle hooks.

=cut

$test->for('description');

=inherits

Venus::Core

=cut

$test->for('inherits');

=method import

The import method invokes the C<IMPORT> lifecycle hook and is invoked whenever
the L<perlfunc/use> declaration is used.

=signature import

  import(any @args) (any)

=metadata import

{
  since => '2.91',
}

=example-1 import

  package main;

  use User;

  # ()

=cut

$test->for('example', 1, 'import', sub {
  1
});

=method does

The does method returns true if the object is composed of the role provided.

=signature does

  does(string $name) (boolean)

=metadata does

{
  since => '1.00',
}

=example-1 does

  # given: synopsis

  my $does = $user->does('Identity');

  # 0

=cut

$test->for('example', 1, 'does', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->error(\my $error)->result);
  ok !$error;

  !$result
});

=method meta

The meta method returns a L<Venus::Meta> objects which describes the package's
configuration.

=signature meta

  meta() (Venus::Meta)

=metadata meta

{
  since => '1.00',
}

=example-1 meta

  package main;

  my $user = User->new(
    fname => 'Elliot',
    lname => 'Alderson',
  );

  my $meta = $user->meta;

  # bless({...}, 'Venus::Meta')

=cut

$test->for('example', 1, 'meta', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Meta');

  $result
});

=method new

The new method instantiates the class and returns a new object.

=signature new

  new(any %args | hashref $args) (object)

=metadata new

{
  since => '1.00',
}

=example-1 new

  package main;

  my $user = User->new(
    fname => 'Elliot',
    lname => 'Alderson',
  );

  # bless({fname => 'Elliot', lname => 'Alderson'}, 'User')

=cut

$test->for('example', 1, 'new', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('User');
  ok UNIVERSAL::isa($result, 'HASH');
  ok $result->{fname} eq 'Elliot';
  ok $result->{lname} eq 'Alderson';

  $result
});

=example-2 new

  package main;

  my $user = User->new({
    fname => 'Elliot',
    lname => 'Alderson',
  });

  # bless({fname => 'Elliot', lname => 'Alderson'}, 'User')

=cut

$test->for('example', 2, 'new', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('User');
  ok UNIVERSAL::isa($result, 'HASH');
  ok $result->{fname} eq 'Elliot';
  ok $result->{lname} eq 'Alderson';

  $result
});

=method unimport

The unimport method invokes the C<UNIMPORT> lifecycle hook and is invoked
whenever the L<perlfunc/no> declaration is used.

=signature unimport

  unimport(any @args) (any)

=metadata unimport

{
  since => '2.91',
}

=cut

=example-1 unimport

  package main;

  no User;

  # ()

=cut

$test->for('example', 1, 'unimport', sub {
  1
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Core/Class.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;
