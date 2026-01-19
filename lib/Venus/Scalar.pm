package Venus::Scalar;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base';

# INHERITS

base 'Venus::Kind::Value';

# OVERLOADS

use overload (
  '${}' => sub{$_[0]->value},
  '*{}' => sub{$_[0]->value},
  fallback => 1,
);

# METHODS

sub default {
  return \'';
}

1;
