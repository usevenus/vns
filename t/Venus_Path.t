package main;

use 5.018;

use strict;
use warnings;

use Test::More;
use Venus::Test;
use Venus;

my $test = test(__FILE__);
my $fsds = qr/[:\\\/\.]+/;

=name

Venus::Path

=cut

$test->for('name');

=tagline

Path Class

=cut

$test->for('tagline');

=abstract

Path Class for Perl 5

=cut

$test->for('abstract');

=includes

method: absolute
method: basename
method: child
method: chmod
method: chown
method: children
method: copy
method: default
method: directories
method: exists
method: explain
method: extension
method: find
method: files
method: glob
method: is_absolute
method: is_directory
method: is_file
method: is_relative
method: lines
method: lineage
method: open
method: mkcall
method: mkdir
method: mkdirs
method: mkfile
method: mktemp_dir
method: mktemp_file
method: move
method: name
method: new
method: parent
method: parents
method: parts
method: read
method: relative
method: rename
method: rmdir
method: rmdirs
method: rmfiles
method: root
method: seek
method: sibling
method: siblings
method: test
method: unlink
method: write

=cut

$test->for('includes');

=synopsis

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/planets');

  # my $planets = $path->files;
  # my $mercury = $path->child('mercury');
  # my $content = $mercury->read;

=cut

$test->for('synopsis', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;

  $result
});

=description

This package provides methods for working with file system paths.

=cut

$test->for('description');

=inherits

Venus::Kind::Utility

=cut

$test->for('inherits');

=integrates

Venus::Role::Accessible
Venus::Role::Buildable
Venus::Role::Explainable
Venus::Role::Valuable

=cut

$test->for('integrates');

=method absolute

The absolute method returns a path object where the value (path) is absolute.

=signature absolute

  absolute() (Venus::Path)

=metadata absolute

{
  since => '0.01',
}

=example-1 absolute

  # given: synopsis;

  $path = $path->absolute;

  # bless({ value => "/path/to/t/data/planets" }, "Venus::Path")

=cut

$test->for('example', 1, 'absolute', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result =~ m{t${fsds}data${fsds}planets};

  $result
});

=method basename

The basename method returns the path base name.

=signature basename

  basename() (string)

=metadata basename

{
  since => '0.01',
}

=example-1 basename

  # given: synopsis;

  my $basename = $path->basename;

  # planets

=cut

$test->for('example', 1, 'basename', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 'planets';

  $result
});

=method child

The child method returns a path object representing the child path provided.

=signature child

  child(string $path) (Venus::Path)

=metadata child

{
  since => '0.01',
}

=example-1 child

  # given: synopsis;

  $path = $path->child('earth');

  # bless({ value => "t/data/planets/earth" }, "Venus::Path")

=cut

$test->for('example', 1, 'child', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result =~ m{t${fsds}data${fsds}planets${fsds}earth};

  $result
});

=method chmod

The chmod method changes the file permissions of the file or directory.

=signature chmod

  chmod(string $mode) (Venus::Path)

=metadata chmod

{
  since => '0.01',
}

=example-1 chmod

  # given: synopsis;

  $path = $path->chmod(0755);

  # bless({ value => "t/data/planets" }, "Venus::Path")

=cut

$test->for('example', 1, 'chmod', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result =~ m{t${fsds}data${fsds}planets};

  $result
});

=method chown

The chown method changes the group and/or owner or the file or directory.

=signature chown

  chown(string @args) (Venus::Path)

=metadata chown

{
  since => '0.01',
}

=example-1 chown

  # given: synopsis;

  $path = $path->chown(-1, -1);

  # bless({ value => "t/data/planets" }, "Venus::Path")

=cut

$test->for('example', 1, 'chown', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result =~ m{t${fsds}data${fsds}planets};

  $result
});

=method children

The children method returns the files and directories under the path. This
method can return a list of values in list-context.

=signature children

  children() (within[arrayref, Venus::Path])

=metadata children

{
  since => '0.01',
}

=example-1 children

  # given: synopsis;

  my $children = $path->children;

  # [
  #   bless({ value => "t/data/planets/ceres" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/earth" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/eris" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/haumea" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/jupiter" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/makemake" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/mars" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/mercury" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/neptune" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/planet9" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/pluto" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/saturn" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/uranus" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/venus" }, "Venus::Path"),
  # ]

=cut

$test->for('example', 1, 'children', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result;
  ok @$result == 14;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr/t${fsds}data${fsds}planets${fsds}ceres/;

  ok $result->[1]->isa('Venus::Path');
  like $result->[1], qr/t${fsds}data${fsds}planets${fsds}earth/;

  ok $result->[2]->isa('Venus::Path');
  like $result->[2], qr/t${fsds}data${fsds}planets${fsds}eris/;

  ok $result->[3]->isa('Venus::Path');
  like $result->[3], qr/t${fsds}data${fsds}planets${fsds}haumea/;

  ok $result->[4]->isa('Venus::Path');
  like $result->[4], qr/t${fsds}data${fsds}planets${fsds}jupiter/;

  ok $result->[5]->isa('Venus::Path');
  like $result->[5], qr/t${fsds}data${fsds}planets${fsds}makemake/;

  ok $result->[6]->isa('Venus::Path');
  like $result->[6], qr/t${fsds}data${fsds}planets${fsds}mars/;

  ok $result->[7]->isa('Venus::Path');
  like $result->[7], qr/t${fsds}data${fsds}planets${fsds}mercury/;

  ok $result->[8]->isa('Venus::Path');
  like $result->[8], qr/t${fsds}data${fsds}planets${fsds}neptune/;

  ok $result->[9]->isa('Venus::Path');
  like $result->[9], qr/t${fsds}data${fsds}planets${fsds}planet9/;

  ok $result->[10]->isa('Venus::Path');
  like $result->[10], qr/t${fsds}data${fsds}planets${fsds}pluto/;

  ok $result->[11]->isa('Venus::Path');
  like $result->[11], qr/t${fsds}data${fsds}planets${fsds}saturn/;

  ok $result->[12]->isa('Venus::Path');
  like $result->[12], qr/t${fsds}data${fsds}planets${fsds}uranus/;

  ok $result->[13]->isa('Venus::Path');
  like $result->[13], qr/t${fsds}data${fsds}planets${fsds}venus/;

  $result
});

=method copy

The copy method uses L<File::Copy/copy> to copy the file represented by the
invocant to the path provided and returns the invocant.

=signature copy

  copy(string | Venus::Path $path) (Venus::Path)

=metadata copy

{
  since => '2.80',
}

=cut

=example-1 copy

  # given: synopsis

  package main;

  my $copy = $path->child('mercury')->copy($path->child('yrucrem'));

  # bless({...}, 'Venus::Path')

=cut

$test->for('example', 1, 'copy', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Path';
  like "$result", qr{t${fsds}data${fsds}planets${fsds}mercury};
  $result->parent->child('yrucrem')->unlink;

  $result
});

=method default

The default method returns the default value, i.e. C<$ENV{PWD}>.

=signature default

  default() (string)

=metadata default

{
  since => '0.01',
}

=example-1 default

  # given: synopsis;

  my $default = $path->default;

  # $ENV{PWD}

=cut

$test->for('example', 1, 'default', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;

  $result
});

=method directories

The directories method returns a list of children under the path which are
directories. This method can return a list of values in list-context.

=signature directories

  directories() (within[arrayref, Venus::Path])

=metadata directories

{
  since => '0.01',
}

=example-1 directories

  # given: synopsis;

  my $directories = $path->directories;

  # []

=cut

$test->for('example', 1, 'directories', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, [];

  $result
});

=method exists

The exists method returns truthy or falsy if the path exists.

=signature exists

  exists() (boolean)

=metadata exists

{
  since => '0.01',
}

=example-1 exists

  # given: synopsis;

  my $exists = $path->exists;

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

  my $exists = $path->child('random')->exists;

  # 0

=cut

$test->for('example', 2, 'exists', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok $result == 0;

  !$result
});

=method explain

The explain method returns the path string and is used in stringification
operations.

=signature explain

  explain() (string)

=metadata explain

{
  since => '0.01',
}

=example-1 explain

  # given: synopsis;

  my $explain = $path->explain;

  # t/data/planets

=cut

$test->for('example', 1, 'explain', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result =~ m{t${fsds}data${fsds}planets};

  $result
});

=method extension

The extension method returns a new path object using the extension name
provided. If no argument is provided this method returns the extension for the
path represented by the invocant, otherwise returns undefined.

=signature extension

  extension(string $name) (string | Venus::Path)

=metadata extension

{
  since => '2.55',
}

=cut

=example-1 extension

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/Venus_Path.t');

  my $extension = $path->extension;

  # "t"

=cut

$test->for('example', 1, 'extension', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  is $result, "t";

  $result
});

=example-2 extension

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/mercury');

  my $extension = $path->extension('txt');

  # bless({ value => "t/data/mercury.txt"}, "Venus::Path")

=cut

$test->for('example', 2, 'extension', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Path';
  ok $result =~ m{t${fsds}data${fsds}mercury\.txt};

  $result
});

=example-3 extension

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data');

  my $extension = $path->extension;

  # undef

=cut

$test->for('example', 3, 'extension', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok !defined $result;

  !$result
});

=example-4 extension

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data');

  my $extension = $path->extension('txt');

  # bless({ value => "t/data.txt"}, "Venus::Path")

=cut

$test->for('example', 4, 'extension', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Path';
  ok $result =~ m{t${fsds}data\.txt};

  $result
});

=method find

The find method does a recursive depth-first search and returns a list of paths
found, matching the expression provided, which defaults to C<*>. This method
can return a list of values in list-context.

=signature find

  find(string | regexp $expr) (within[arrayref, Venus::Path])

=metadata find

{
  since => '0.01',
}

=example-1 find

  # given: synopsis;

  my $find = $path->find;

  # [
  #   bless({ value => "t/data/planets/ceres" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/earth" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/eris" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/haumea" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/jupiter" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/makemake" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/mars" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/mercury" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/neptune" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/planet9" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/pluto" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/saturn" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/uranus" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/venus" }, "Venus::Path"),
  # ]

=cut

$test->for('example', 1, 'find', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result;
  ok @$result == 14;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr{t${fsds}data${fsds}planets${fsds}ceres};

  ok $result->[1]->isa('Venus::Path');
  like $result->[1], qr{t${fsds}data${fsds}planets${fsds}earth};

  ok $result->[2]->isa('Venus::Path');
  like $result->[2], qr{t${fsds}data${fsds}planets${fsds}eris};

  ok $result->[3]->isa('Venus::Path');
  like $result->[3], qr{t${fsds}data${fsds}planets${fsds}haumea};

  ok $result->[4]->isa('Venus::Path');
  like $result->[4], qr{t${fsds}data${fsds}planets${fsds}jupiter};

  ok $result->[5]->isa('Venus::Path');
  like $result->[5], qr{t${fsds}data${fsds}planets${fsds}makemake};

  ok $result->[6]->isa('Venus::Path');
  like $result->[6], qr{t${fsds}data${fsds}planets${fsds}mars};

  ok $result->[7]->isa('Venus::Path');
  like $result->[7], qr{t${fsds}data${fsds}planets${fsds}mercury};

  ok $result->[8]->isa('Venus::Path');
  like $result->[8], qr{t${fsds}data${fsds}planets${fsds}neptune};

  ok $result->[9]->isa('Venus::Path');
  like $result->[9], qr{t${fsds}data${fsds}planets${fsds}planet9};

  ok $result->[10]->isa('Venus::Path');
  like $result->[10], qr{t${fsds}data${fsds}planets${fsds}pluto};

  ok $result->[11]->isa('Venus::Path');
  like $result->[11], qr{t${fsds}data${fsds}planets${fsds}saturn};

  ok $result->[12]->isa('Venus::Path');
  like $result->[12], qr{t${fsds}data${fsds}planets${fsds}uranus};

  ok $result->[13]->isa('Venus::Path');
  like $result->[13], qr{t${fsds}data${fsds}planets${fsds}venus};

  $result
});

=example-2 find

  # given: synopsis;

  my $find = $path->find('[:\/\\\.]+m[^:\/\\\.]*$');

  # [
  #   bless({ value => "t/data/planets/makemake" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/mars" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/mercury" }, "Venus::Path"),
  # ]

=cut

$test->for('example', 2, 'find', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result;
  ok @$result == 3;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr{t${fsds}data${fsds}planets${fsds}makemake};

  ok $result->[1]->isa('Venus::Path');
  like $result->[1], qr{t${fsds}data${fsds}planets${fsds}mars};

  ok $result->[2]->isa('Venus::Path');
  like $result->[2], qr{t${fsds}data${fsds}planets${fsds}mercury};

  $result
});

=example-3 find

  # given: synopsis;

  my $find = $path->find('earth');

  # [
  #   bless({ value => "t/data/planets/earth" }, "Venus::Path"),
  # ]

=cut

$test->for('example', 3, 'find', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result;
  ok @$result == 1;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr{t${fsds}data${fsds}planets${fsds}earth};

  $result
});

=method files

The files method returns a list of children under the path which are files.
This method can return a list of values in list-context.

=signature files

  files() (within[arrayref, Venus::Path])

=metadata files

{
  since => '0.01',
}

=example-1 files

  # given: synopsis;

  my $files = $path->files;

  # [
  #   bless({ value => "t/data/planets/ceres" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/earth" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/eris" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/haumea" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/jupiter" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/makemake" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/mars" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/mercury" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/neptune" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/planet9" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/pluto" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/saturn" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/uranus" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/venus" }, "Venus::Path"),
  # ]

=cut

$test->for('example', 1, 'files', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result;
  ok @$result == 14;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr/t${fsds}data${fsds}planets${fsds}ceres/;

  ok $result->[1]->isa('Venus::Path');
  like $result->[1], qr/t${fsds}data${fsds}planets${fsds}earth/;

  ok $result->[2]->isa('Venus::Path');
  like $result->[2], qr/t${fsds}data${fsds}planets${fsds}eris/;

  ok $result->[3]->isa('Venus::Path');
  like $result->[3], qr/t${fsds}data${fsds}planets${fsds}haumea/;

  ok $result->[4]->isa('Venus::Path');
  like $result->[4], qr/t${fsds}data${fsds}planets${fsds}jupiter/;

  ok $result->[5]->isa('Venus::Path');
  like $result->[5], qr/t${fsds}data${fsds}planets${fsds}makemake/;

  ok $result->[6]->isa('Venus::Path');
  like $result->[6], qr/t${fsds}data${fsds}planets${fsds}mars/;

  ok $result->[7]->isa('Venus::Path');
  like $result->[7], qr/t${fsds}data${fsds}planets${fsds}mercury/;

  ok $result->[8]->isa('Venus::Path');
  like $result->[8], qr/t${fsds}data${fsds}planets${fsds}neptune/;

  ok $result->[9]->isa('Venus::Path');
  like $result->[9], qr/t${fsds}data${fsds}planets${fsds}planet9/;

  ok $result->[10]->isa('Venus::Path');
  like $result->[10], qr/t${fsds}data${fsds}planets${fsds}pluto/;

  ok $result->[11]->isa('Venus::Path');
  like $result->[11], qr/t${fsds}data${fsds}planets${fsds}saturn/;

  ok $result->[12]->isa('Venus::Path');
  like $result->[12], qr/t${fsds}data${fsds}planets${fsds}uranus/;

  ok $result->[13]->isa('Venus::Path');
  like $result->[13], qr/t${fsds}data${fsds}planets${fsds}venus/;

  $result
});

=method glob

The glob method returns the files and directories under the path matching the
expression provided, which defaults to C<*>. This method can return a list of
values in list-context.

=signature glob

  glob(string | regexp $expr) (within[arrayref, Venus::Path])

=metadata glob

{
  since => '0.01',
}

=example-1 glob

  # given: synopsis;

  my $glob = $path->glob;

  # [
  #   bless({ value => "t/data/planets/ceres" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/earth" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/eris" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/haumea" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/jupiter" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/makemake" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/mars" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/mercury" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/neptune" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/planet9" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/pluto" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/saturn" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/uranus" }, "Venus::Path"),
  #   bless({ value => "t/data/planets/venus" }, "Venus::Path"),
  # ]

=cut

$test->for('example', 1, 'glob', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result;
  ok @$result == 14;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr/t${fsds}data${fsds}planets${fsds}ceres/;

  ok $result->[1]->isa('Venus::Path');
  like $result->[1], qr/t${fsds}data${fsds}planets${fsds}earth/;

  ok $result->[2]->isa('Venus::Path');
  like $result->[2], qr/t${fsds}data${fsds}planets${fsds}eris/;

  ok $result->[3]->isa('Venus::Path');
  like $result->[3], qr/t${fsds}data${fsds}planets${fsds}haumea/;

  ok $result->[4]->isa('Venus::Path');
  like $result->[4], qr/t${fsds}data${fsds}planets${fsds}jupiter/;

  ok $result->[5]->isa('Venus::Path');
  like $result->[5], qr/t${fsds}data${fsds}planets${fsds}makemake/;

  ok $result->[6]->isa('Venus::Path');
  like $result->[6], qr/t${fsds}data${fsds}planets${fsds}mars/;

  ok $result->[7]->isa('Venus::Path');
  like $result->[7], qr/t${fsds}data${fsds}planets${fsds}mercury/;

  ok $result->[8]->isa('Venus::Path');
  like $result->[8], qr/t${fsds}data${fsds}planets${fsds}neptune/;

  ok $result->[9]->isa('Venus::Path');
  like $result->[9], qr/t${fsds}data${fsds}planets${fsds}planet9/;

  ok $result->[10]->isa('Venus::Path');
  like $result->[10], qr/t${fsds}data${fsds}planets${fsds}pluto/;

  ok $result->[11]->isa('Venus::Path');
  like $result->[11], qr/t${fsds}data${fsds}planets${fsds}saturn/;

  ok $result->[12]->isa('Venus::Path');
  like $result->[12], qr/t${fsds}data${fsds}planets${fsds}uranus/;

  ok $result->[13]->isa('Venus::Path');
  like $result->[13], qr/t${fsds}data${fsds}planets${fsds}venus/;

  $result
});

=method is_absolute

The is_absolute method returns truthy or falsy is the path is absolute.

=signature is_absolute

  is_absolute() (boolean)

=metadata is_absolute

{
  since => '0.01',
}

=example-1 is_absolute

  # given: synopsis;

  my $is_absolute = $path->is_absolute;

  # 0

=cut

$test->for('example', 1, 'is_absolute', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok $result == 0;

  !$result
});

=method is_directory

The is_directory method returns truthy or falsy is the path is a directory.

=signature is_directory

  is_directory() (boolean)

=metadata is_directory

{
  since => '0.01',
}

=example-1 is_directory

  # given: synopsis;

  my $is_directory = $path->is_directory;

  # 1

=cut

$test->for('example', 1, 'is_directory', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method is_file

The is_file method returns truthy or falsy is the path is a file.

=signature is_file

  is_file() (boolean)

=metadata is_file

{
  since => '0.01',
}

=example-1 is_file

  # given: synopsis;

  my $is_file = $path->is_file;

  # 0

=cut

$test->for('example', 1, 'is_file', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok $result == 0;

  !$result
});

=method is_relative

The is_relative method returns truthy or falsy is the path is relative.

=signature is_relative

  is_relative() (boolean)

=metadata is_relative

{
  since => '0.01',
}

=example-1 is_relative

  # given: synopsis;

  my $is_relative = $path->is_relative;

  # 1

=cut

$test->for('example', 1, 'is_relative', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method lines

The lines method returns the list of lines from the underlying file. By default
the file contents are separated by newline.

=signature lines

  lines(string | regexp $separator, string $binmode) (within[arrayref, string])

=metadata lines

{
  since => '1.23',
}

=example-1 lines

  # given: synopsis;

  my $lines = $path->child('mercury')->lines;

  # ['mercury']

=cut

$test->for('example', 1, 'lines', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ['mercury'];

  $result
});

=example-2 lines

  # given: synopsis;

  my $lines = $path->child('planet9')->lines;

  # ['planet', 'nine']

=cut

$test->for('example', 2, 'lines', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;

  is_deeply $result, ['planet', 'nine'];

  $result
});

=method lineage

The lineage method returns the list of parent paths up to the root path. This
method can return a list of values in list-context.

=signature lineage

  lineage() (within[arrayref, Venus::Path])

=metadata lineage

{
  since => '0.01',
}

=example-1 lineage

  # given: synopsis;

  my $lineage = $path->lineage;

  # [
  #   bless({ value => "t/data/planets" }, "Venus::Path"),
  #   bless({ value => "t/data" }, "Venus::Path"),
  #   bless({ value => "t" }, "Venus::Path"),
  # ]

=cut

$test->for('example', 1, 'lineage', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result;
  ok @$result == 3;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr/t${fsds}data${fsds}planets$/;

  ok $result->[1]->isa('Venus::Path');
  like $result->[1], qr/t${fsds}data$/;

  ok $result->[2]->isa('Venus::Path');
  like $result->[2], qr/t$/;

  $result
});

=method open

The open method creates and returns an open filehandle.

=signature open

  open(any @data) (FileHandle)

=metadata open

{
  since => '0.01',
}

=example-1 open

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/planets/earth');

  my $fh = $path->open;

  # bless(..., "IO::File");

=cut

$test->for('example', 1, 'open', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('IO::File');

  $result
});

=example-2 open

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/planets/earth');

  my $fh = $path->open('<');

  # bless(..., "IO::File");

=cut

$test->for('example', 2, 'open', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('IO::File');

  $result
});

=example-3 open

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/planets/earth');

  my $fh = $path->open('>');

  # bless(..., "IO::File");

=cut

$test->for('example', 3, 'open', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('IO::File');

  $result
});

=example-4 open

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('/path/to/xyz');

  my $fh = $path->open('>');

  # Exception! (isa Venus::Path::Error) (see error_on_open)

=cut

$test->for('example', 4, 'open', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Path::Error');
  ok $error->isa('Venus::Error');

  $result
});

=method mkcall

The mkcall method returns the result of executing the path as an executable. In
list context returns the call output and exit code.

=signature mkcall

  mkcall(any @data) (any)

=metadata mkcall

{
  since => '0.01',
}

=example-1 mkcall

  package main;

  use Venus::Path;

  my $path = Venus::Path->new($^X);

  my $output = $path->mkcall('--help');

  # Usage: perl ...

=cut

$test->for('example', 1, 'mkcall', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result =~ m{\w+};

  $result
});

=example-2 mkcall

  package main;

  use Venus::Path;

  my $path = Venus::Path->new($^X);

  my ($call_output, $exit_code) = $path->mkcall('t/data/sun', '--heat-death');

  # ("", 1)

=cut

$test->for('example', 2, 'mkcall', sub {
  my ($tryable) = @_;
  ok my @result = ($tryable->result);
  is_deeply [@result], ['', 1];

  !$result[0]
});

=example-3 mkcall

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('.help');

  my $output = $path->mkcall;

  # Exception! (isa Venus::Path::Error) (see error_on_mkcall)

=cut

$test->for('example', 3, 'mkcall', sub {
  plan skip_all => 'skip Path#mkcall on win32' if $^O =~ /win32/i;
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->safe('result');
  ok $error->isa('Venus::Path::Error');
  ok $error->isa('Venus::Error');

  $result
});

=method mkdir

The mkdir method makes the path as a directory.

=signature mkdir

  mkdir(maybe[string] $mode) (Venus::Path)

=metadata mkdir

{
  since => '0.01',
}

=example-1 mkdir

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/systems');

  $path = $path->mkdir;

  # bless({ value => "t/data/systems" }, "Venus::Path")

=cut

rmdir 't/data/systems';
$test->for('example', 1, 'mkdir', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Path');
  ok $result->exists;

  rmdir 't/data/systems';
  $result
});

=example-2 mkdir

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('/path/to/xyz');

  $path = $path->mkdir;

  # Exception! (isa Venus::Path::Error) (see error_on_mkdir)

=cut

$test->for('example', 2, 'mkdir', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Path::Error');
  ok $error->isa('Venus::Error');

  $result
});

=method mkdirs

The mkdirs method creates parent directories and returns the list of created
directories. This method can return a list of values in list-context.

=signature mkdirs

  mkdirs(maybe[string] $mode) (within[arrayref, Venus::Path])

=metadata mkdirs

{
  since => '0.01',
}

=example-1 mkdirs

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/systems');

  my $mkdirs = $path->mkdirs;

  # [
  #   bless({ value => "t/data/systems" }, "Venus::Path")
  # ]

=cut

rmdir 't/data/systems';
$test->for('example', 1, 'mkdirs', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result == 1;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr/t${fsds}data${fsds}systems$/;

  rmdir 't/data/systems';
  $result
});

=example-2 mkdirs

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/systems/solar');

  my $mkdirs = $path->mkdirs;

  # [
  #   bless({ value => "t/data/systems" }, "Venus::Path"),
  #   bless({ value => "t/data/systems/solar" }, "Venus::Path"),
  # ]

=cut

rmdir 't/data/systems/solar';
rmdir 't/data/systems';
$test->for('example', 2, 'mkdirs', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result == 2;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr/t${fsds}data${fsds}systems$/;

  ok $result->[1]->isa('Venus::Path');
  like $result->[1], qr/t${fsds}data${fsds}systems${fsds}solar$/;

  rmdir 't/data/systems/solar';
  rmdir 't/data/systems';
  $result
});

=method mkfile

The mkfile method makes the path as an empty file.

=signature mkfile

  mkfile() (Venus::Path)

=metadata mkfile

{
  since => '0.01',
}

=example-1 mkfile

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/moon');

  $path = $path->mkfile;

  # bless({ value => "t/data/moon" }, "Venus::Path")

=cut

$test->for('example', 1, 'mkfile', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->exists;

  $result
});

=example-2 mkfile

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('/path/to/xyz');

  $path = $path->mkfile;

  # Exception! (isa Venus::Path::Error) (see error_on_mkfile)

=cut

$test->for('example', 2, 'mkfile', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Path::Error');
  ok $error->isa('Venus::Error');

  $result
});

=method mktemp_dir

The mktemp_dir method uses L<File::Temp/tempdir> to create a temporary
directory which isn't automatically removed and returns a new path object.

=signature mktemp_dir

  mktemp_dir() (Venus::Path)

=metadata mktemp_dir

{
  since => '2.80',
}

=cut

=example-1 mktemp_dir

  # given: synopsis

  package main;

  my $mktemp_dir = $path->mktemp_dir;

  # bless({value => "/tmp/ZnKTxBpuBE"}, "Venus::Path")

=cut

$test->for('example', 1, 'mktemp_dir', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Path';
  ok $result->test('de');
  $result->rmdir;

  $result
});

=method mktemp_file

The mktemp_file method uses L<File::Temp/tempfile> to create a temporary file
which isn't automatically removed and returns a new path object.

=signature mktemp_file

  mktemp_file() (Venus::Path)

=metadata mktemp_file

{
  since => '2.80',
}

=cut

=example-1 mktemp_file

  # given: synopsis

  package main;

  my $mktemp_file = $path->mktemp_file;

  # bless({value => "/tmp/y5MvliBQ2F"}, "Venus::Path")

=cut

$test->for('example', 1, 'mktemp_file', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Path';
  ok $result->test('fe');
  $result->unlink;

  $result
});

=method move

The move method uses L<File::Copy/move> to move the file represented by the
invocant to the path provided and returns the invocant.

=signature move

  move(string | Venus::Path $path) (Venus::Path)

=metadata move

{
  since => '2.80',
}

=cut

=example-1 move

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data');

  my $unknown = $path->child('unknown')->mkfile->move($path->child('titan'));

  # bless({value => 't/data/titan'}, 'Venus::Path')

=cut

$test->for('example', 1, 'move', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Path';
  like "$result", qr{t${fsds}data${fsds}titan};
  ok $result->exists;
  my $unknown = $result->parent->child('unknown');
  ok !$unknown->exists;
  ok $result->unlink;

  $result
});

=method name

The name method returns the path as an absolute path.

=signature name

  name() (string)

=metadata name

{
  since => '0.01',
}

=example-1 name

  # given: synopsis;

  my $name = $path->name;

  # /path/to/t/data/planets

=cut

$test->for('example', 1, 'name', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result =~ m{.+t${fsds}data${fsds}planets$};

  $result
});

=method new

The new method constructs an instance of the package.

=signature new

  new(any @args) (Venus::Path)

=metadata new

{
  since => '4.15',
}

=cut

=example-1 new

  package main;

  use Venus::Path;

  my $new = Venus::Path->new;

  # bless(..., "Venus::Path")

=cut

$test->for('example', 1, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Path');

  $result
});

=example-2 new

  package main;

  use Venus::Path;

  my $new = Venus::Path->new('t/data/planets');

  # bless(..., "Venus::Path")

=cut

$test->for('example', 2, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Path');
  is $result->value, 't/data/planets';

  $result
});

=example-3 new

  package main;

  use Venus::Path;

  my $new = Venus::Path->new(value => 't/data/planets');

  # bless(..., "Venus::Path")

=cut

$test->for('example', 3, 'new', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  ok $result->isa('Venus::Path');
  is $result->value, 't/data/planets';

  $result
});

=method parent

The parent method returns a path object representing the parent directory.

=signature parent

  parent() (Venus::Path)

=metadata parent

{
  since => '0.01',
}

=example-1 parent

  # given: synopsis;

  my $parent = $path->parent;

  # bless({ value => "t/data" }, "Venus::Path")

=cut

$test->for('example', 1, 'parent', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Path');
  ok $result =~ m{t${fsds}data$};

  $result
});

=method parents

The parents method returns is a list of parent directories. This method can
return a list of values in list-context.

=signature parents

  parents() (within[arrayref, Venus::Path])

=metadata parents

{
  since => '0.01',
}

=example-1 parents

  # given: synopsis;

  my $parents = $path->parents;

  # [
  #   bless({ value => "t/data" }, "Venus::Path"),
  #   bless({ value => "t" }, "Venus::Path"),
  # ]

=cut

$test->for('example', 1, 'parents', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result == 2;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr/t${fsds}data$/;

  ok $result->[1]->isa('Venus::Path');
  like $result->[1], qr/t$/;

  $result
});

=method parts

The parts method returns an arrayref of path parts.

=signature parts

  parts() (within[arrayref, string])

=metadata parts

{
  since => '0.01',
}

=example-1 parts

  # given: synopsis;

  my $parts = $path->parts;

  # ["t", "data", "planets"]

=cut

$test->for('example', 1, 'parts', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  is_deeply $result, ["t", "data", "planets"];

  $result
});

=method read

The read method reads the file and returns its contents.

=signature read

  read() (string)

=metadata read

{
  since => '0.01',
}

=example-1 read

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/planets/mars');

  my $content = $path->read;

=cut

$test->for('example', 1, 'read', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result =~ m{mars};

  $result
});

=example-2 read

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('/path/to/xyz');

  my $content = $path->read;

  # Exception! (isa Venus::Path::Error) (see error_on_read_open)

=cut

$test->for('example', 2, 'read', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Path::Error');
  ok $error->isa('Venus::Error');

  $result
});

=method relative

The relative method returns a path object representing a relative path
(relative to the path provided).

=signature relative

  relative(string $root) (Venus::Path)

=metadata relative

{
  since => '0.01',
}

=example-1 relative

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('/path/to/t/data/planets/mars');

  my $relative = $path->relative('/path');

  # bless({ value => "to/t/data/planets/mars" }, "Venus::Path")

=cut

$test->for('example', 1, 'relative', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Path');
  ok $result =~ m{to${fsds}t${fsds}data${fsds}planets${fsds}mars$};

  $result
});

=example-2 relative

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('/path/to/t/data/planets/mars');

  my $relative = $path->relative('/path/to/t');

  # bless({ value => "data/planets/mars" }, "Venus::Path")

=cut

$test->for('example', 2, 'relative', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Path');
  ok $result =~ m{data${fsds}planets${fsds}mars$};

  $result
});

=method rename

The rename method performs a L</move> unless the path provided is only a file
name, in which case it attempts a rename under the directory of the invocant.

=signature rename

  rename(string | Venus::Path $path) (Venus::Path)

=metadata rename

{
  since => '2.91',
}

=cut

=example-1 rename

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/path/001');

  my $rename = $path->rename('002');

  # bless({value => 't/path/002'}, 'Venus::Path')

=cut

$test->for('example', 1, 'rename', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Path';
  like "$result", qr{t${fsds}path${fsds}002};
  my $former = $result->parent->child('001');
  ok !$former->exists;
  $result->rename('001');

  $result
});

=method rmdir

The rmdir method removes the directory and returns a path object representing
the deleted directory.

=signature rmdir

  rmdir() (Venus::Path)

=metadata rmdir

{
  since => '0.01',
}

=example-1 rmdir

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/stars');

  my $rmdir = $path->mkdir->rmdir;

  # bless({ value => "t/data/stars" }, "Venus::Path")

=cut

$test->for('example', 1, 'rmdir', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Path');

  $result
});

=example-2 rmdir

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('/path/to/xyz');

  my $rmdir = $path->mkdir->rmdir;

  # Exception! (isa Venus::Path::Error) (see error_on_rmdir)

=cut

$test->for('example', 2, 'rmdir', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Path::Error');
  ok $error->isa('Venus::Error');

  $result
});

=method rmdirs

The rmdirs method removes that path and its child files and directories and
returns all paths removed. This method can return a list of values in
list-context.

=signature rmdirs

  rmdirs() (within[arrayref, Venus::Path])

=metadata rmdirs

{
  since => '0.01',
}

=example-1 rmdirs

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/stars');

  $path->child('dwarfs')->mkdirs;

  my $rmdirs = $path->rmdirs;

  # [
  #   bless({ value => "t/data/stars/dwarfs" }, "Venus::Path"),
  #   bless({ value => "t/data/stars" }, "Venus::Path"),
  # ]

=cut

$test->for('example', 1, 'rmdirs', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result == 2;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr/t${fsds}data${fsds}stars${fsds}dwarfs$/;

  ok $result->[1]->isa('Venus::Path');
  like $result->[1], qr/t${fsds}data${fsds}stars$/;

  $result
});

=method rmfiles

The rmfiles method recursively removes files under the path and returns the
paths removed. This method does not remove the directories found. This method
can return a list of values in list-context.

=signature rmfiles

  rmfiles() (within[arrayref, Venus::Path])

=metadata rmfiles

{
  since => '0.01',
}

=example-1 rmfiles

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/stars')->mkdir;

  $path->child('sirius')->mkfile;
  $path->child('canopus')->mkfile;
  $path->child('arcturus')->mkfile;
  $path->child('vega')->mkfile;
  $path->child('capella')->mkfile;

  my $rmfiles = $path->rmfiles;

  # [
  #   bless({ value => "t/data/stars/arcturus" }, "Venus::Path"),
  #   bless({ value => "t/data/stars/canopus" }, "Venus::Path"),
  #   bless({ value => "t/data/stars/capella" }, "Venus::Path"),
  #   bless({ value => "t/data/stars/sirius" }, "Venus::Path"),
  #   bless({ value => "t/data/stars/vega" }, "Venus::Path"),
  # ]

=cut

$test->for('example', 1, 'rmfiles', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result == 5;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr/t${fsds}data${fsds}stars${fsds}arcturus$/;

  ok $result->[1]->isa('Venus::Path');
  like $result->[1], qr/t${fsds}data${fsds}stars${fsds}canopus$/;

  ok $result->[2]->isa('Venus::Path');
  like $result->[2], qr/t${fsds}data${fsds}stars${fsds}capella$/;

  ok $result->[3]->isa('Venus::Path');
  like $result->[3], qr/t${fsds}data${fsds}stars${fsds}sirius$/;

  ok $result->[4]->isa('Venus::Path');
  like $result->[4], qr/t${fsds}data${fsds}stars${fsds}vega$/;

  rmdir 't/data/stars';
  $result
});

=method root

The root method performs a search up the file system heirarchy returns the
first path (i.e. absolute path) matching the file test specification and base
path expression provided. The file test specification is the same passed to
L</test>. If no path matches are found this method returns underfined.

=signature root

  root(string $spec, string $base) (maybe[Venus::Path])

=metadata root

{
  since => '2.32',
}

=example-1 root

  # given: synopsis;

  my $root = $path->root('d', 't');

  # bless({ value => "/path/to/t/../" }, "Venus::Path")

=cut

$test->for('example', 1, 'root', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Path');
  ok $result->child('t')->test('d');

  $result
});

=example-2 root

  # given: synopsis;

  my $root = $path->root('f', 't');

  # undef

=cut

$test->for('example', 2, 'root', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok !defined $result;

  !$result
});

=method seek

The seek method performs a search down the file system heirarchy returns the
first path (i.e. absolute path) matching the file test specification and base
path expression provided. The file test specification is the same passed to
L</test>. If no path matches are found this method returns underfined.

=signature seek

  seek(string $spec, string $base) (maybe[Venus::Path])

=metadata seek

{
  since => '2.32',
}

=example-1 seek

  # given: synopsis;

  $path = Venus::Path->new('t');

  my $seek = $path->seek('f', 'earth');

  # bless({ value => "/path/to/t/data/planets/earth" }, "Venus::Path")

=cut

$test->for('example', 1, 'seek', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Path');
  ok $result =~ m{t${fsds}data${fsds}planets${fsds}earth};

  $result
});

=example-2 seek

  # given: synopsis;

  $path = Venus::Path->new('t');

  my $seek = $path->seek('f', 'europa');

  # undef

=cut

$test->for('example', 2, 'seek', sub {
  my ($tryable) = @_;
  ok !(my $result = $tryable->result);
  ok !defined $result;

  !$result
});

=method sibling

The sibling method returns a path object representing the sibling path provided.

=signature sibling

  sibling(string $path) (Venus::Path)

=metadata sibling

{
  since => '0.01',
}

=example-1 sibling

  # given: synopsis;

  my $sibling = $path->sibling('galaxies');

  # bless({ value => "t/data/galaxies" }, "Venus::Path")

=cut

$test->for('example', 1, 'sibling', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Path');
  ok $result =~ m{t${fsds}data${fsds}galaxies$};

  $result
});

=method siblings

The siblings method returns all sibling files and directories for the current
path. This method can return a list of values in list-context.

=signature siblings

  siblings() (within[arrayref, Venus::Path])

=metadata siblings

{
  since => '0.01',
}

=example-1 siblings

  # given: synopsis;

  my $siblings = $path->siblings;

  # [
  #   bless({ value => "t/data/moon" }, "Venus::Path"),
  #   bless({ value => "t/data/sections" }, "Venus::Path"),
  #   bless({ value => "t/data/sun" }, "Venus::Path"),
  #   bless({ value => "t/data/texts" }, "Venus::Path"),
  # ]

=cut

$test->for('example', 1, 'siblings', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok @$result == 4;

  ok $result->[0]->isa('Venus::Path');
  like $result->[0], qr/t${fsds}data${fsds}moon$/;

  ok $result->[1]->isa('Venus::Path');
  like $result->[1], qr/t${fsds}data${fsds}sections$/;

  ok $result->[2]->isa('Venus::Path');
  like $result->[2], qr/t${fsds}data${fsds}sun$/;

  ok $result->[3]->isa('Venus::Path');
  like $result->[3], qr/t${fsds}data${fsds}texts$/;

  $result
});

=method test

The test method evaluates the current path against the stackable file test
operators provided.

=signature test

  test(string $expr) (boolean)

=metadata test

{
  since => '0.01',
}

=example-1 test

  # given: synopsis;

  my $test = $path->test;

  # -e $path

  # 1

=cut

$test->for('example', 1, 'test', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=example-2 test

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/sun');

  my $test = $path->test('efs');

  # -e -f -s $path

  # 1

=cut

$test->for('example', 2, 'test', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=method unlink

The unlink method removes the file and returns a path object representing the
removed file.

=signature unlink

  unlink() (Venus::Path)

=metadata unlink

{
  since => '0.01',
}

=example-1 unlink

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/asteroid')->mkfile;

  my $unlink = $path->unlink;

  # bless({ value => "t/data/asteroid" }, "Venus::Path")

=cut

$test->for('example', 1, 'unlink', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Path');
  ok $result =~ m{t${fsds}data${fsds}asteroid$};

  $result
});

=example-2 unlink

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('/path/to/xyz');

  my $unlink = $path->unlink;

  # Exception! (isa Venus::Path::Error) (see error_on_unlink)

=cut

$test->for('example', 2, 'unlink', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Path::Error');
  ok $error->isa('Venus::Error');

  $result
});

=method write

The write method write the data provided to the file.

=signature write

  write(string $data, string $encoding) (Venus::Path)

=metadata write

{
  since => '0.01',
}

=example-1 write

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('t/data/asteroid');

  my $write = $path->write('asteroid');

=cut

$test->for('example', 1, 'write', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result->isa('Venus::Path');
  ok $result =~ m{t${fsds}data${fsds}asteroid$};
  ok $result->read =~ m{asteroid};

  unlink $result;
  $result
});

=example-2 write

  package main;

  use Venus::Path;

  my $path = Venus::Path->new('/path/to/xyz');

  my $write = $path->write('nothing');

  # Exception! (isa Venus::Path::Error) (see error_on_write_open)

=cut

$test->for('example', 2, 'write', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->error(\my $error)->result;
  ok $error->isa('Venus::Path::Error');
  ok $error->isa('Venus::Error');

  $result
});

=error error_on_copy

This package may raise an C<on.copy> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_copy> method.

=cut

$test->for('error', 'error_on_copy');

=example-1 error_on_copy

  # given: synopsis;

  my $error = $path->error_on_copy({
    error => $!,
    path => '/nowhere',
    self => $path,
  });

  # ...

  # my $name = $error->name;

  # "on.copy"

  # my $render = $error->render;

  # "Can't copy \"t\/data\/planets\" to \"/nowhere\": $!"

=cut

$test->for('example', 1, 'error_on_copy', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.copy";
  my $render = $result->render;
  is $render, "Can't copy \"t\/data\/planets\" to \"/nowhere\": $!";

  $result
});

=error error_on_mkcall

This package may raise an C<on.mkcall> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_mkcall> method.

=cut

$test->for('error', 'error_on_mkcall');

=example-1 error_on_mkcall

  # given: synopsis;

  my $error = $path->error_on_mkcall({
    error => $!,
    path => '/nowhere',
  });

  # ...

  # my $name = $error->name;

  # "on.mkcall"

  # my $render = $error->render;

  # "Can't make system call to \"/nowhere\": $!"

=cut

$test->for('example', 1, 'error_on_mkcall', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.mkcall";
  my $render = $result->render;
  is $render, "Can't make system call to \"/nowhere\": exit code (0)";

  $result
});

=error error_on_mkdir

This package may raise an C<on.mkdir> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_mkdir> method.

=cut

$test->for('error', 'error_on_mkdir');

=example-1 error_on_mkdir

  # given: synopsis;

  my $error = $path->error_on_mkdir({
    error => $!,
    path => '/nowhere',
  });

  # ...

  # my $name = $error->name;

  # "on.mkdir"

  # my $render = $error->render;

  # "Can't make directory \"/nowhere\": $!"

=cut

$test->for('example', 1, 'error_on_mkdir', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.mkdir";
  my $render = $result->render;
  is $render, "Can't make directory \"/nowhere\": $!";

  $result
});

=error error_on_mkfile

This package may raise an C<on.mkfile> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_mkfile> method.

=cut

$test->for('error', 'error_on_mkfile');

=example-1 error_on_mkfile

  # given: synopsis;

  my $error = $path->error_on_mkfile({
    error => $!,
    path => '/nowhere',
  });

  # ...

  # my $name = $error->name;

  # "on.mkfile"

  # my $render = $error->render;

  # "Can't make file \"/nowhere\": $!"

=cut

$test->for('example', 1, 'error_on_mkfile', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.mkfile";
  my $render = $result->render;
  is $render, "Can't make file \"/nowhere\": $!";

  $result
});

=error error_on_move

This package may raise an C<on.move> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_move> method.

=cut

$test->for('error', 'error_on_move');

=example-1 error_on_move

  # given: synopsis;

  my $error = $path->error_on_move({
    error => $!,
    path => '/nowhere',
    self => $path,
  });

  # ...

  # my $name = $error->name;

  # "on.move"

  # my $render = $error->render;

  # "Can't move \"t\/data\/planets\" to \"/nowhere\": $!"

=cut

$test->for('example', 1, 'error_on_move', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.move";
  my $render = $result->render;
  is $render, "Can't move \"t\/data\/planets\" to \"/nowhere\": $!";

  $result
});

=error error_on_open

This package may raise an C<on.open> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_open> method.

=cut

$test->for('error', 'error_on_open');

=example-1 error_on_open

  # given: synopsis;

  my $error = $path->error_on_open({
    error => $!,
    path => '/nowhere',
  });

  # ...

  # my $name = $error->name;

  # "on.open"

  # my $render = $error->render;

  # "Can't open \"/nowhere\": $!"

=cut

$test->for('example', 1, 'error_on_open', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.open";
  my $render = $result->render;
  is $render, "Can't open \"/nowhere\": $!";

  $result
});

=error error_on_read

This package may raise an C<on.read> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_read> method.

=cut

$test->for('error', 'error_on_read');

=example-1 error_on_read

  # given: synopsis;

  my $error = $path->error_on_read({
    error => $!,
    path => '/nowhere',
  });

  # ...

  # my $name = $error->name;

  # "on.read"

  # my $render = $error->render;

  # "Can't read \"/nowhere\": $!"

=cut

$test->for('example', 1, 'error_on_read', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.read";
  my $render = $result->render;
  is $render, "Can't read \"/nowhere\": $!";

  $result
});

=error error_on_rmdir

This package may raise an C<on.rmdir> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_rmdir> method.

=cut

$test->for('error', 'error_on_rmdir');

=example-1 error_on_rmdir

  # given: synopsis;

  my $error = $path->error_on_rmdir({
    error => $!,
    path => '/nowhere',
  });

  # ...

  # my $name = $error->name;

  # "on.rmdir"

  # my $render = $error->render;

  # "Can't rmdir \"/nowhere\": $!"

=cut

$test->for('example', 1, 'error_on_rmdir', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.rmdir";
  my $render = $result->render;
  is $render, "Can't rmdir \"/nowhere\": $!";

  $result
});

=error error_on_write

This package may raise an C<on.write> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_write> method.

=cut

$test->for('error', 'error_on_write');

=example-1 error_on_write

  # given: synopsis;

  my $error = $path->error_on_write({
    error => $!,
    path => '/nowhere',
  });

  # ...

  # my $name = $error->name;

  # "on.write"

  # my $render = $error->render;

  # "Can't write \"/nowhere\": $!"

=cut

$test->for('example', 1, 'error_on_write', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.write";
  my $render = $result->render;
  is $render, "Can't write \"/nowhere\": $!";

  $result
});

=error error_on_unlink

This package may raise an C<on.unlink> error, as an instance of
C<Venus::Cli::Error>, via the C<error_on_unlink> method.

=cut

$test->for('error', 'error_on_unlink');

=example-1 error_on_unlink

  # given: synopsis;

  my $error = $path->error_on_unlink({
    error => $!,
    path => '/nowhere',
  });

  # ...

  # my $name = $error->name;

  # "on.unlink"

  # my $render = $error->render;

  # "Can't unlink \"/nowhere\": $!"

=cut

$test->for('example', 1, 'error_on_unlink', sub {
  my ($tryable) = @_;
  my $result = $tryable->result;
  isa_ok $result, 'Venus::Error';
  my $name = $result->name;
  is $name, "on.unlink";
  my $render = $result->render;
  is $render, "Can't unlink \"/nowhere\": $!";

  $result
});

=operator (.)

This package overloads the C<.> operator.

=cut

$test->for('operator', '(.)');

=example-1 (.)

  # given: synopsis;

  my $result = $path . '/earth';

  # "t/data/planets/earth"

=cut

$test->for('example', 1, '(.)', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq "t/data/planets/earth";

  $result
});

=operator (eq)

This package overloads the C<eq> operator.

=cut

$test->for('operator', '(eq)');

=example-1 (eq)

  # given: synopsis;

  my $result = $path eq 't/data/planets';

  # 1

=cut

$test->for('example', 1, '(eq)', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=operator (ne)

This package overloads the C<ne> operator.

=cut

$test->for('operator', '(ne)');

=example-1 (ne)

  # given: synopsis;

  my $result = $path ne 't/data/planets/';

  # 1

=cut

$test->for('example', 1, '(ne)', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=operator (qr)

This package overloads the C<qr> operator.

=cut

$test->for('operator', '(qr)');

=example-1 (qr)

  # given: synopsis;

  my $result = 't/data/planets' =~ $path;

  # 1

=cut

$test->for('example', 1, '(qr)', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result == 1;

  $result
});

=operator ("")

This package overloads the C<""> operator.

=cut

$test->for('operator', '("")');

=example-1 ("")

  # given: synopsis;

  my $result = "$path";

  # "t/data/planets"

=cut

$test->for('example', 1, '("")', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 't/data/planets';

  $result
});

=example-2 ("")

  # given: synopsis;

  my $mercury = $path->child('mercury');

  my $result = "$path, $path";

  # "t/data/planets, t/data/planets"

=cut

$test->for('example', 2, '("")', sub {
  my ($tryable) = @_;
  ok my $result = $tryable->result;
  ok $result eq 't/data/planets, t/data/planets';

  $result
});

=operator (~~)

This package overloads the C<~~> operator.

=cut

$test->for('operator', '(~~)');

=example-1 (~~)

  # given: synopsis;

  my $result = $path ~~ 't/data/planets';

  # 1

=cut

$test->for('example', 1, '(~~)', sub {
  1;
});

=partials

t/Venus.t: present: authors
t/Venus.t: present: license

=cut

$test->for('partials');

# END

$test->render('lib/Venus/Path.pod') if $ENV{VENUS_RENDER};

ok 1 and done_testing;