package Venus::Type;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Buildable';

# STATE

state $SIMPLE_TYPES = {
  any => 'any',
  array => 'array',
  arrayref => 'arrayref',
  bool => 'bool',
  boolean => 'boolean',
  code => 'code',
  coderef => 'coderef',
  defined => 'defined',
  dirhandle => 'dirhandle',
  filehandle => 'filehandle',
  float => 'float',
  glob => 'glob',
  hash => 'hash',
  hashref => 'hashref',
  identity => 'identity',
  number => 'number',
  object => 'object',
  package => 'package',
  reference => 'reference',
  regexp => 'regexp',
  scalar => 'scalar',
  scalarref => 'scalarref',
  string => 'string',
  undef => 'undef',
  value => 'value',
  yesno => 'yesno',
};

state $COMPLEX_TYPES = {
  attributes => 'attributes',
  consumes => 'consumes',
  either => 'either',
  hashkeys => 'hashkeys',
  includes => 'includes',
  inherits => 'inherits',
  integrates => 'integrates',
  maybe => 'maybe',
  routines => 'routines',
  tuple => 'tuple',
  within => 'within',
};

# METHODS

sub assert {
  my ($self, $expr) = @_;

  require Venus::Assert;

  return Venus::Assert->new->accept($self->offer($expr));
}

sub check {
  my ($self, $expr) = @_;

  require Venus::Check;

  return Venus::Check->new->accept($self->offer($expr));
}

sub clean {
  my ($self, $expr) = @_;

  return '' if !defined $expr;

  $expr =~ s/\n//g;
  $expr =~ s/^\s+|\s+$//g;

  return $expr;
}

sub coercion {
  my ($self, $expr) = @_;

  require Venus::Coercion;

  return Venus::Coercion->new->accept($self->offer($expr));
}

sub constraint {
  my ($self, $expr) = @_;

  require Venus::Constraint;

  return Venus::Constraint->new->accept($self->offer($expr));
}

sub expression {
  my ($self, $data) = @_;

  return ref $data eq 'ARRAY' ? $self->generate_expression($data) : $self->parse_expression($data);
}

sub parse_expression {
  my ($self, $expr) = @_;

  return $self->parser_parse_expression($self->clean($expr));
}

sub parse_signature {
  my ($self, $expr) = @_;

  $expr = $self->clean($expr);

  my $pattern = qr/^(\w+)\s*\((.*?)\)\s*\((.*?)\)$/;

  my ($name, $input_types, $output_types) = ($expr =~ $pattern);

  if ($name && $output_types) {
    return [
      $name,
      [$self->parse_signature_type_expression($input_types)],
      [$self->parse_signature_type_expression($output_types)],
    ];
  }

  return $self->error_on_signature_parse({signature => $expr})->input($self, $expr)->throw;
}

sub parse_signature_input {
  my ($self, $expr) = @_;

  my $parsed_signature = $self->parse_signature($expr);

  my $input = [map $$_[0], @{$parsed_signature->[1]}];

  return wantarray ? @{$input} : $input;
}

sub parse_signature_output {
  my ($self, $expr) = @_;

  my $parsed_signature = $self->parse_signature($expr);

  my $output = [map $$_[0], @{$parsed_signature->[2]}];

  return wantarray ? @{$output} : $output;
}

sub parse_signature_type_expression {
  my ($self, $expr) = @_;

  $expr = $self->clean($expr);

  my $type_expressions = [];

  my @parts = map $self->clean($_), split(/\s*,(?![^\[]*\])/, $expr);

  for my $part (@parts) {
    if ($part =~ /^(.+?)\s*([\*\$\@\%]\w+)$/) {
      push @{$type_expressions}, [$1, $2];
    }
    else {
      push @{$type_expressions}, [$part];
    }
  }

  return wantarray ? @{$type_expressions} : $type_expressions;
}

sub parser_complex_type {
  my ($self, $expr) = @_;

  return $$COMPLEX_TYPES{$expr};
}

sub parser_has_complex_type {
  my ($self, $expr) = @_;

  return $self->parser_complex_type($expr) ? true : false;
}

sub parser_has_simple_type {
  my ($self, $expr) = @_;

  return $self->parser_simple_type($expr) ? true : false;
}

sub parser_has_type {
  my ($self, $expr) = @_;

  return $self->parser_has_simple_type($expr) || $self->parser_has_complex_type($expr);
}

sub parser_parse_expression {
  my ($self, $expr) = @_;

  $expr =~ s/^\s+|\s+$//g;

  if ($expr =~ /^(\w+)\[(.+)\]$/ && $expr !~ /^\w+\[.+\]\s*[\|\+]\s*\w+\[.+\]$/) {
    my $type = $1;
    my $inner = $2;
    my @params = $self->parser_parse_parameters($inner);
    return [$type, @params];
  }

  if ($expr =~ /\|/ ? $expr =~ /^[^|]*\+[^|]*\|/ : $expr =~ /\+/) {
    my @parts = $self->parser_split_by_operator($expr, '\+');
    return ['includes', map { $self->parser_parse_expression($_) } @parts];
  }

  if ($expr =~ /\+/ ? $expr =~ /^[^+]*\|[^+]*\+/ : $expr =~ /\|/) {
    my @parts = $self->parser_split_by_operator($expr, '\|');
    return ['either', map { $self->parser_parse_expression($_) } @parts];
  }

  if ($expr =~ /^(\w+)\[(.+)\]$/) {
    my $type = $1;
    my $inner = $2;
    my @params = $self->parser_parse_parameters($inner);
    return [$type, @params];
  }

  if ($self->parser_has_simple_type($expr)) {
    return $expr;
  }

  if ($expr =~ /^[A-Z](?:(?:\w|::)*[a-zA-Z0-9])?$/) {
    return $expr;
  }

  my $unquoted = 0;

  $expr =~ s/^\"|\"$//g if !$unquoted++ && $expr =~ /^\".*\"$/;
  $expr =~ s/^\'|\'$//g if !$unquoted++ && $expr =~ /^\'.*\'$/;

  return $expr;
}

sub parser_split_by_operator {
  my ($self, $expr, $operator) = @_;

  my @parts;
  my $depth = 0;
  my $current_part = '';

  for my $char (split //, $expr) {
    if ($char eq '[') {
      $depth++;
    }
    elsif ($char eq ']') {
      $depth--;
    }
    elsif ($char =~ /$operator/ && $depth == 0) {
      $current_part =~ s/^\s+|\s+$//g;
      push @parts, $current_part;
      $current_part = '';
      next;
    }
    $current_part .= $char;
  }

  $current_part =~ s/^\s+|\s+$//g;
  push @parts, $current_part if $current_part;

  return @parts;
}

sub parser_parse_parameters {
  my ($self, $param_str) = @_;

  $param_str =~ s/^\s+|\s+$//g;

  my @params;
  my $depth = 0;
  my $current_param = '';

  for my $char (split //, $param_str) {
    if ($char eq '[') {
      $depth++;
    }
    elsif ($char eq ']') {
      $depth--;
    }
    elsif ($char eq ',' && $depth == 0) {
      $current_param =~ s/^\s+|\s+$//g;
      push @params, $self->parser_parse_expression($current_param);
      $current_param = '';
      next;
    }
    $current_param .= $char;
  }

  $current_param =~ s/^\s+|\s+$//g;
  push @params, $self->parser_parse_expression($current_param)
    if $current_param;

  return @params;
}

sub parser_simple_type {
  my ($self, $expr) = @_;

  return $$SIMPLE_TYPES{$expr};
}

sub parser_type {
  my ($self, $expr) = @_;

  return $self->parser_simple_type($expr) || $self->parser_complex_type($expr);
}

sub generate_expression {
  my ($self, $data) = @_;

  if (!defined $data) {
    return "";
  }

  if (ref $data eq 'HASH' && keys %{$data} == 0) {
    return "";
  }

  if (ref $data eq 'HASH' && keys %{$data} == 1 && values %{$data} == 1 && ref((values %{$data})[0]) eq 'HASH') {
    return $self->generate_expression([(keys %{$data}), (values %{$data})]);
  }

  if (ref $data eq 'HASH') {
    return join ', ', map +($self->generate_expression($_), $self->generate_expression($data->{$_})), sort keys %{$data};
  }

  if (ref $data eq 'ARRAY' && defined $data->[0] && $data->[0] eq 'either') {
    return join ' | ', map $self->generate_expression($_), @{$data}[1..$#$data];
  }

  if (ref $data eq 'ARRAY' && defined $data->[0] && $data->[0] eq 'includes') {
    return join ' + ', map $self->generate_expression($_), @{$data}[1..$#$data];
  }

  if (ref $data eq 'ARRAY' && scalar(@{$data}) >= 2) {
    return join '', $data->[0], '[', (join ', ', map $self->generate_expression($_), @{$data}[1..$#$data]), ']';
  }

  if (ref $data eq 'ARRAY' && scalar(@{$data}) <= 1) {
    return $self->generate_expression($data->[0]);
  }

  if ($data =~ /\"|\s/) {
    $data =~ s/(?<!\\)\"/\\"/g;
    $data = "\"$data\"";
  }

  return $data;
}

sub generate_signature {
  my ($self, $data) = @_;

  return sprintf '%s(%s) (%s)', $data->[0],
    $self->generate_signature_input($data->[1]),
    $self->generate_signature_input($data->[2]);
}

sub generate_signature_input {
  my ($self, $data) = @_;

  return join ', ', map +(join ' ', @{$_}), @{$data};
}

sub generate_signature_output {
  my ($self, $data) = @_;

  return join ', ', map +(join ' ', @{$_}), @{$data};
}

sub offer {
  my ($self, $expr) = @_;

  my $data = $self->expression($expr) || [];

  $data = [$data] if ref $data ne 'ARRAY';

  return wantarray ? @{$data} : $data;
}

sub signature {
  my ($self, $data) = @_;

  return ref $data eq 'ARRAY' ? $self->generate_signature($data) : $self->parse_signature($data);
}

sub unpack {
  my ($self, $args, $data) = @_;

  require Venus::Unpack;

  my $upto = $#$args > $#$data ? $#$args : $#$data;

  return Venus::Unpack->new(args => $args)->use(0..$upto)->types(@{$data});
}

sub unpack_signature_input {
  my ($self, $expr, $args) = @_;

  my $data = $self->parse_signature_input($expr);

  return $self->unpack($args, $data);
}

sub unpack_signature_output {
  my ($self, $expr, $args) = @_;

  my $data = $self->parse_signature_output($expr);

  return $self->unpack($args, $data);
}

# ERRORS

sub error_on_signature_parse {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t parse signature "{{signature}}"';

  $error->name('on.signature.parse');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

1;
