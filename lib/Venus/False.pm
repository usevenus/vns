package Venus::False;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Scalar::Util ();

# STATE

state $false = Scalar::Util::dualvar(0, "0");

# OVERLOADS

use overload (
  '!' => sub{!$false},
  'bool' => sub{$false},
  fallback => 1,
);

# METHODS

sub new {
  return bless({});
}

sub value {
  return $false;
}

1;
