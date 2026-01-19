package Venus::Text::Tag;

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

  $data = (split(/^__END__/m, (split(/^__DATA__/m, $data))[1] || ''))[0] || '';

  $data =~ s/^\s+|\s+$//g;

  return $data;
}

sub stag {

  return '@@ ';
}

sub etag {

  return '@@ end';
}

1;
