package Venus::String;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base';

# INHERITS

base 'Venus::Kind::Value';

# OVERLOADS

use overload (
  'eq' => sub{$_[0]->value eq "$_[1]"},
  'ne' => sub{$_[0]->value ne "$_[1]"},
  'qr' => sub{qr/@{[quotemeta($_[0]->value)]}/},
  fallback => 1,
);

# METHODS

sub append {
  my ($self, @args) = @_;

  return $self->append_with(' ', @args);
}

sub append_with {
  my ($self, $delimiter, @args) = @_;

  my $data = $self->get;

  return CORE::join($delimiter // '', $data, @args);
}

sub camelcase {
  my ($self) = @_;

  my $data = $self->get;

  my $result = CORE::ucfirst(CORE::lc($data));

  $result =~ s/[^a-zA-Z0-9]+([a-z])/\U$1/g;
  $result =~ s/[^a-zA-Z0-9]+//g;

  return CORE::lcfirst($result);
}

sub chomp {
  my ($self) = @_;

  my $data = $self->get;

  CORE::chomp($data);

  return $data;
}

sub chop {
  my ($self) = @_;

  my $data = $self->get;

  CORE::chop($data);

  return $data;
}

sub comparer {
  my ($self) = @_;

  my $data = $self->get;

  require Scalar::Util;

  return Scalar::Util::looks_like_number($data) ? 'numified' : 'stringified';
}

sub concat {
  my ($self, @args) = @_;

  my $data = $self->get;

  return CORE::join('', $data, @args);
}

sub contains {
  my ($self, $pattern) = @_;

  my $data = $self->get;

  return 0 unless CORE::defined($pattern);

  my $regexp = UNIVERSAL::isa($pattern, 'Regexp');

  return CORE::index($data, $pattern) < 0 ? 0 : 1 if !$regexp;

  return ($data =~ $pattern) ? true : false;
}

sub default {
  return '';
}

sub format {
  my ($self, @args) = @_;

  my $data = $self->get;

  return CORE::sprintf($data, @args);
}

sub hex {
  my ($self) = @_;

  my $data = $self->get;

  return CORE::hex($data);
}

sub index {
  my ($self, $substr, $start) = @_;

  my $data = $self->get;

  return CORE::index($data, $substr) if not(CORE::defined($start));
  return CORE::index($data, $substr, $start);
}

sub kebabcase {
  my ($self) = @_;

  my $data = $self->get;
  my $re = qr/[\W_]+/;

  $data =~ s/$re/-/g;
  $data =~ s/^$re|$re$//g;

  return $data;
}

sub lc {
  my ($self) = @_;

  my $data = $self->get;

  return CORE::lc($data);
}

sub lcfirst {
  my ($self) = @_;

  my $data = $self->get;

  return CORE::lcfirst($data);
}

sub length {
  my ($self) = @_;

  my $data = $self->get;

  return CORE::length($data);
}

sub lines {
  my ($self) = @_;

  my $data = $self->get;

  return [CORE::split(/[\n\r]+/, $data)];
}

sub lowercase {
  my ($self) = @_;

  my $data = $self->get;

  return CORE::lc($data);
}

sub numified {
  my ($self) = @_;

  my $data = $self->get;

  return $self->comparer eq 'numified' ? (0 + $data) : $self->SUPER::numified();
}

sub pascalcase {
  my ($self) = @_;

  my $data = $self->get;

  my $result = CORE::ucfirst(CORE::lc($data));

  $result =~ s/[^a-zA-Z0-9]+([a-z])/\U$1/g;
  $result =~ s/[^a-zA-Z0-9]+//g;

  return $result;
}

sub prepend {
  my ($self, @args) = @_;

  return $self->prepend_with(' ', @args);
}

sub prepend_with {
  my ($self, $delimiter, @args) = @_;

  my $data = $self->get;

  return CORE::join($delimiter // '', @args, $data);
}

sub repeat {
  my ($self, $count, $delimiter) = @_;

  my $data = $self->get;

  return CORE::join($delimiter // '', CORE::map $data, 1..($count || 1));
}

sub render {
  my ($self, $tokens) = @_;

  my $data = $self->get;

  $tokens ||= {};

  while (my($key, $value) = each(%$tokens)) {
    my $token = quotemeta $key;
    $data =~ s/\{\{\s*$token\s*\}\}/$value/g;
  }

  return $data;
}

sub replace {
  my ($self, $regexp, $replace, $flags) = @_;

  require Venus::Regexp;

  return Venus::Regexp->new($regexp)->replace($self->get, $replace, $flags);
}

sub reverse {
  my ($self) = @_;

  my $data = $self->get;

  return scalar(CORE::reverse($data));
}

sub rindex {
  my ($self, $substr, $start) = @_;

  my $data = $self->get;

  return CORE::rindex($data, $substr) if not(CORE::defined($start));
  return CORE::rindex($data, $substr, $start);
}

sub search {
  my ($self, $regexp) = @_;

  require Venus::Regexp;

  return Venus::Regexp->new($regexp)->search($self->get);
}

sub snakecase {
  my ($self) = @_;

  my $data = $self->get;
  my $re = qr/[\W_]+/;

  $data =~ s/$re/_/g;
  $data =~ s/^$re|$re$//g;

  return $data;
}

sub split {
  my ($self, $pattern, $limit) = @_;

  my $data = $self->get;

  $pattern //= '';

  my $regexp = UNIVERSAL::isa($pattern, 'Regexp');

  $pattern = quotemeta($pattern) if $pattern and !$regexp;

  return [CORE::split(/$pattern/, $data)] if !CORE::defined($limit);
  return [CORE::split(/$pattern/, $data, $limit)];
}

sub strip {
  my ($self) = @_;

  my $data = $self->get;

  $data =~ s/\s{2,}/ /g;

  return $data;
}

sub substr {
  my ($self, $offset, $length, $replace) = @_;

  my $data = $self->get;

  if (CORE::defined($replace)) {
    my $result = CORE::substr($data, $offset // 0, $length // 0, $replace);
    return wantarray ? ($result, $data) : $data;
  }
  else {
    my $result = CORE::substr($data, $offset // 0, $length // 0);
    return wantarray ? ($result, $data) : $result;
  }
}

sub template {
  my ($self, $code, @args) = @_;

  require Venus::Template;

  my $template = Venus::Template->new($self->get);

  return $code ? $template->$code(@args) : $template;
}

sub titlecase {
  my ($self) = @_;

  my $data = $self->get;

  $data =~ s/\b(\w)/\U$1/g;

  return $data;
}

sub trim {
  my ($self) = @_;

  my $data = $self->get;

  $data =~ s/^\s+|\s+$//g;

  return $data;
}

sub uc {
  my ($self) = @_;

  my $data = $self->get;

  return CORE::uc($data);
}

sub ucfirst {
  my ($self) = @_;

  my $data = $self->get;

  return CORE::ucfirst($data);
}

sub uppercase {
  my ($self) = @_;

  my $data = $self->get;

  return CORE::uc($data);
}

sub wrap {
  my ($self, $length, $indent) = @_;

  $length ||= 80;

  $indent ||= 0;

  my $space = ' ' x $indent;

  my $total_length = $length - CORE::length($space);

  my @lines;

  my @input_lines = split /\n/, $self->get;

  for my $input_line (@input_lines) {
    if ($input_line eq '') {
      push @lines, $input_line;
      next;
    }

    my ($saved_space) = ($input_line =~ /^(\s*)/);

    $saved_space ||= '';

    my @parts = split /\s+/, $input_line;

    my $line = '';

    for my $part (@parts) {
      if (CORE::length($line) + CORE::length($part) + 1 > $total_length) {
        push @lines, $space . $saved_space . $line;
        $line = $part;
      }
      else {
        $line .= $line ? " $part" : $part;
      }
    }

    push @lines, $space . $saved_space . $line if $line;
  }

  return wantarray ? (@lines) : join "\n", @lines;
}

sub words {
  my ($self) = @_;

  my $data = $self->get;

  return [CORE::split(/\s+/, $data)];
}

1;
