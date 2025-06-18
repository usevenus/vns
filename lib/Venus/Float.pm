package Venus::Float;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base';

# INHERITS

base 'Venus::Number';

# METHODS

sub default {
  return '0.0';
}

1;
