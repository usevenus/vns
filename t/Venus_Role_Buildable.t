package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;
use Venus;

my $test = test(__FILE__);

=name

Venus::Role::Buildable

=cut

$test->for('name');

=tagline

Buildable Role

=cut

$test->for('tagline');

=abstract

Buildable Role for Perl 5

=cut

$test->for('abstract');

=includes

method: build_arg
method: build_args
method: build_data
method: build_self
method: build_nil

=cut

$test->for('includes');

=synopsis

  package Example;

  use Venus::Class;

  with 'Venus::Role::Buildable';

  attr 'test';

  package main;

  my $example = Example->new;

  # $example->test;

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Example');
  ok $result->does('Venus::Role::Buildable');

  $result
});

=description

This package modifies the consuming package and provides methods for hooking
into object construction of the consuming class, e.g. handling single-arg
object construction.

=cut

$test->for('description');

=method build_arg

The build_arg method, if defined, is only called during object construction
when a single non-hashref is provided.


=signature build_arg

  build_arg(any $data) (hashref)

=metadata build_arg

{
  since => '0.01',
}

=example-1 build_arg

  package Example1;

  use Venus::Class;

  attr 'x';
  attr 'y';

  with 'Venus::Role::Buildable';

  sub build_arg {
    my ($self, $data) = @_;

    $data = { x => $data, y => $data };

    return $data;
  }

  package main;

  my $example = Example1->new(10);

  # $example->x;
  # $example->y;

=cut

$test->for('example', 1, 'build_arg', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Example1');
  ok $result->does('Venus::Role::Buildable');
  ok $result->x == 10;
  ok $result->y == 10;

  $result
});

=method build_args

The build_args method, if defined, is only called during object construction to
hook into the handling of the arguments provided.

=signature build_args

  build_args(hashref $data) (hashref)

=metadata build_args

{
  since => '0.01',
}

=example-1 build_args

  package Example2;

  use Venus::Class;

  attr 'x';
  attr 'y';

  with 'Venus::Role::Buildable';

  sub build_args {
    my ($self, $data) = @_;

    $data->{x} ||= int($data->{x} || 100);
    $data->{y} ||= int($data->{y} || 100);

    return $data;
  }

  package main;

  my $example = Example2->new(x => 10, y => 10);

  # $example->x;
  # $example->y;

=cut

$test->for('example', 1, 'build_args', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Example2');
  ok $result->does('Venus::Role::Buildable');
  ok $result->x == 10;
  ok $result->y == 10;

  $result
});

=method build_data

The build_data method, if defined, is only called during object construction to
hook into the handling of the arguments provided. This method is passed two
hashrefs, the first containing expected arguments provided to the constructor
(e.g. attributes), and the second containing all unexpected arguments. The
hashref or key/value pairs returned from this method will be used in subsequent
automation.

=signature build_data

  build_data(hashref $args, hashref $xargs) (hashref)

=metadata build_data

{
  since => '4.15',
}

=example-1 build_data

  package Example5;

  use Venus::Class;

  attr 'x';
  attr 'y';

  with 'Venus::Role::Buildable';

  sub build_data {
    my ($self, $args, $xargs) = @_;

    $args->{z} = delete $xargs->{z} if !exists $args->{z} && exists $xargs->{z};

    return $args;
  }

  package main;

  my $example = Example5->new(x => 10, y => 10, z => 10);

  # $example->x;
  # $example->y;

=cut

$test->for('example', 1, 'build_data', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Example5');
  ok $result->does('Venus::Role::Buildable');
  ok $result->x == 10;
  ok $result->y == 10;
  ok $result->{z} == 10;

  $result
});

=method build_self

The build_self method, if defined, is only called during object construction
after all arguments have been handled and set.

=signature build_self

  build_self(hashref $data) (object)

=metadata build_self

{
  since => '0.01',
}

=example-1 build_self

  package Example3;

  use Venus::Class;

  attr 'x';
  attr 'y';

  with 'Venus::Role::Buildable';

  sub build_self {
    my ($self, $data) = @_;

    die if !$self->x;
    die if !$self->y;

    return $self;
  }

  package main;

  my $example = Example3->new(x => 10, y => 10);

  # $example->x;
  # $example->y;

=cut

$test->for('example', 1, 'build_self', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Example3');
  ok $result->does('Venus::Role::Buildable');
  ok $result->x == 10;
  ok $result->y == 10;

  $result
});

=method build_nil

The build_nil method, if defined, is only called during object construction
when a single empty hashref is provided.

=signature build_nil

  build_nil(hashref $data) (any)

=metadata build_nil

{
  since => '0.01',
}

=example-1 build_nil

  package Example4;

  use Venus::Class;

  attr 'x';
  attr 'y';

  with 'Venus::Role::Buildable';

  sub build_nil {
    my ($self, $data) = @_;

    $data = { x => 10, y => 10 };

    return $data;
  }

  package main;

  my $example = Example4->new({});

  # $example->x;
  # $example->y;

=cut

$test->for('example', 1, 'build_nil', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Example4');
  ok $result->does('Venus::Role::Buildable');
  ok $result->x == 10;
  ok $result->y == 10;

  $result
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Role/Buildable.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;