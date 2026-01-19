package Venus::Text::Pod;

use 5.018;

use strict;
use warnings;

# VENUS

use Venus::Class 'base';

# IMPORTS

use Venus::Path;

# INHERITS

base 'Venus::Text';

# METHODS

sub data {
  my ($self) = @_;

  my $file = $self->file;

  my $data = Venus::Path->new($file)->read;

  return $data;
}

sub stag {

  return '=';
}

sub etag {

  return '=cut';
}

1;
