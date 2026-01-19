package Venus::Text;

use 5.018;

use strict;
use warnings;

# Venus

use Venus::Class 'attr', 'base', 'with';

# IMPORTS

use Venus::Path;

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Buildable';

# ATTRIBUTES

attr 'file';
attr 'stag';
attr 'etag';

# BUILDERS

sub build_arg {
  my ($self, $data) = @_;

  return {
    file => $data,
  };
}

# METHODS

sub count {
  my ($self, $data) = @_;

  my @result = ($self->search($data));

  return scalar @result;
}

sub data {
  my ($self) = @_;

  my $file = $self->file;

  my $data = Venus::Path->new($file)->read;

  return $data;
}

sub explode {
  my ($self) = @_;

  my $data = $self->data;
  my $stag = $self->stag;
  my $etag = $self->etag;

  my @chunks = split /^(?:\@$stag|$stag)\s*(.+?)\s*\r?\n/m, ($data . "\n");

  shift @chunks;

  my $items = [];

  while (my ($meta, $data) = splice @chunks, 0, 2) {
    next unless $meta && $data;
    next unless $meta ne $etag;

    my @info = split /\s/, $meta, 2;
    my ($list, $name) = @info == 2 ? @info : (undef, @info);

    $data =~ s/(\r?\n)\+$stag/$1$stag/g; # auto-escape nested syntax
    $data = [split /\r?\n\r?\n/, $data];

    my $item = {name => $name, data => $data, index => @$items + 1, list => $list};

    push @$items, $item;
  }

  return $items;
}

sub find {
  my ($self, $list, $name) = @_;

  return $self->search({list => $list, name => $name});
}

sub search {
  my ($self, $data) = @_;

  $data //= {};

  my $exploded = $self->explode;

  return wantarray ? (@$exploded) : $exploded if !keys %$data;

  my @result;

  my $sought = {map +($_, 1), keys %$data};

  for my $item (sort {$a->{index} <=> $b->{index}} @$exploded) {
    my $found = {};

    my $text;
    if ($text = $data->{data}) {
      $text = ref($text) eq 'Regexp' ? $text : qr/^@{[quotemeta($text)]}$/;
      $found->{data} = 1 if "@{$item->{data}}" =~ $text;
    }

    my $index;
    if ($index = $data->{index}) {
      $index = ref($index) eq 'Regexp' ? $index : qr/^@{[quotemeta($index)]}$/;
      $found->{index} = 1 if $item->{index} =~ $index;
    }

    my $list;
    if ($list = $data->{list}) {
      $list = (ref($list) eq 'Regexp' ? $list : qr/^@{[quotemeta($list)]}$/);
      $found->{list} = 1 if defined $item->{list} && $item->{list} =~ $list;
    }
    else {
      $found->{list} = 1 if (exists $data->{list} && !defined $data->{list})
        && !defined $item->{list};
    }

    my $name;
    if ($name = $data->{name}) {
      $name = ref($name) eq 'Regexp' ? $name : qr/^@{[quotemeta($name)]}$/;
      $found->{name} = 1 if $item->{name} =~ $name;
    }

    if (not(grep(not(defined($found->{$_})), keys(%$sought)))) {
      push @result, $item;
    }
  }

  return wantarray ? (@result) : \@result;
}

sub string {
  my ($self, $list, $name) = @_;

  my @result;

  for my $item ($self->find($list, $name)) {
    push @result, join "\n\n", @{$item->{data}};
  }

  return wantarray ? (@result) : join "\n", @result;
}

1;
