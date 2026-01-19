package Venus::True;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Scalar::Util ();

# STATE

state $true = Scalar::Util::dualvar(1, "1");

# OVERLOADS

use overload (
  '!' => sub{!$true},
  'bool' => sub{$true},
  fallback => 1,
);

# METHODS

sub new {
  return bless({});
}

sub value {
  return $true;
}

1;
