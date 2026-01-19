package Venus::Template;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Valuable';
with 'Venus::Role::Buildable';
with 'Venus::Role::Accessible';
with 'Venus::Role::Explainable';

# STATE

state $TOKEN_PATH_NOTATION = qr/[a-z_][\w.]*/;
state $TOKEN_TAG_OPEN = qr/\{\{/;
state $TOKEN_TAG_CLOSE = qr/\}\}/;

# OVERLOADS

use overload (
  '""' => 'explain',
  'eq' => sub{$_[0]->render eq "$_[1]"},
  'ne' => sub{$_[0]->render ne "$_[1]"},
  'qr' => sub{qr/@{[quotemeta($_[0]->render)]}/},
  '~~' => 'explain',
  fallback => 1,
);

# ATTRIBUTES

attr 'context';

# BUILDERS

sub build_data {
  my ($self, $data, $args) = @_;

  $data->{context} = $data->{context} ? ({%{$data->{context}}, %{$args}}) : $args;

  $data->{value} ||= '';

  return $data;
}

# METHODS

sub default {

  return '';
}

sub explain {
  my ($self) = @_;

  return $self->render;
}

sub mappable {
  my ($self, $data) = @_;

  require Scalar::Util;
  require Venus::Array;
  require Venus::Hash;

  if (!$data) {
    return Venus::Hash->new;
  }
  if (!Scalar::Util::blessed($data) && ref($data) eq 'ARRAY') {
    return Venus::Array->new($data);
  }
  if (!Scalar::Util::blessed($data) && ref($data) eq 'HASH') {
    return Venus::Hash->new($data);
  }
  if (!Scalar::Util::blessed($data) || (Scalar::Util::blessed($data)
      && !($data->isa('Venus::Array') || $data->isa('Venus::Hash'))))
  {
    return Venus::Hash->new;
  }
  else {
    return $data;
  }
}

sub render {
  my ($self, $content, $context, $parent_loops) = @_;

  if (!defined $content) {
    $content = $self->get;
  }

  if (!defined $context) {
    $context = $self->context;
  }
  else {
    $context = $self->mappable($self->context)->merge(
      $self->mappable($context)->get
    );
  }

  $content =~ s/^\r?\n//;
  $content =~ s/\r?\n\ *$//;

  $parent_loops ||= [];

  $content = $self->render_blocks($content, $context, $parent_loops);

  $content = $self->render_tokens($content, $context);

  return $content;
}

sub render_blocks {
  my ($self, $content, $context, $parent_loops) = @_;

  my $token_tag_open = $TOKEN_TAG_OPEN;

  my $token_tag_close = $TOKEN_TAG_CLOSE;

  my $path = $TOKEN_PATH_NOTATION;

  my $regexp = qr{
    (?<!\\)
    (?<!\\\{)
    $token_tag_open
    \s*
    (FOR|IF|IF\sNOT)
    \s+
    ($path)
    \s*
    $token_tag_close
    (?!\})
    (.+?)
    (?<!\\)
    (?<!\\\{)
    $token_tag_open
    \s*
    (END)
    \s+
    \2
    \s*
    $token_tag_close
    (?!\})
  }xis;

  $parent_loops ||= [];

  $context = $self->mappable($context);

  $content =~ s{
    $regexp
  }{
    my ($type, $path, $block) = ($1, $2, $3);
    if (lc($type) eq 'if') {
      $self->render_if(
        $block, $context, !!scalar($context->path($path)), $path, $parent_loops,
      );
    }
    elsif (lc($type) eq 'if not') {
      $self->render_if_not(
        $block, $context, !!scalar($context->path($path)), $path, $parent_loops,
      );
    }
    elsif (lc($type) eq 'for') {
      $self->render_foreach(
        $block, $self->mappable($context->path($path)), $parent_loops,
      );
    }
  }gsex;

  $content =~ s/\\(\{\{|\}\})/$1/g;

  return $content;
}

sub render_if {
  my ($self, $content, $context, $boolean, $path, $parent_loops) = @_;

  my $mappable = $self->mappable($context);

  my $token_tag_open = $TOKEN_TAG_OPEN;

  my $token_tag_close = $TOKEN_TAG_CLOSE;

  $path = quotemeta $path;

  my $regexp = qr{
    $token_tag_open
    \s*
    ELSE
    \s+
    $path
    \s*
    $token_tag_close
  }xis;

  $parent_loops ||= [];

  my ($a, $b) = split /$regexp/, $content;

  if ($boolean) {
    return $self->render($a, $mappable, $parent_loops);
  }
  else {
    if ($b) {
      return $self->render($b, $mappable, $parent_loops);
    }
    else {
      return '';
    }
  }
}

sub render_if_not {
  my ($self, $content, $context, $boolean, $path, $parent_loops) = @_;

  my $mappable = $self->mappable($context);

  my $token_tag_open = $TOKEN_TAG_OPEN;

  my $token_tag_close = $TOKEN_TAG_CLOSE;

  $path = quotemeta $path;

  my $regexp = qr{
    $token_tag_open
    \s*
    ELSE
    \s+
    $path
    \s*
    $token_tag_close
  }xis;

  $parent_loops ||= [];

  my ($a, $b) = split /$regexp/, $content;

  if (!$boolean) {
    return $self->render($a, $mappable, $parent_loops);
  }
  else {
    if ($b) {
      return $self->render($b, $mappable, $parent_loops);
    }
    else {
      return '';
    }
  }
}

sub render_foreach {
  my ($self, $content, $context, $parent_loops) = @_;

  $context = $self->mappable($context);

  if (!$context->isa('Venus::Array')) {
    return '';
  }

  $parent_loops ||= [];

  my @results = $self->mappable($context)->each(sub {
    my (@args) = @_;

    my $value = $args[1];

    my $loop = {
      index => $args[0],
      item => $value,
      level => {},
      parent => $parent_loops->[0],
      place => $args[0]+1,
    };

    my $iteration_parent_loops = [$loop, @{$parent_loops}];

    $loop->{level}->{$_} = $iteration_parent_loops->[$_]
      for map {$#{$iteration_parent_loops} - $_} 0..$#{$iteration_parent_loops};

    $value = ref($value) ? $value : {};

    $self->render($content, $self->mappable($value)->do('set', 'loop', $loop), $iteration_parent_loops);
  });

  return join "\n", grep !!$_, @results;
}

sub render_tokens {
  my ($self, $content, $context) = @_;

  my $token_tag_open = $TOKEN_TAG_OPEN;

  my $token_tag_close = $TOKEN_TAG_CLOSE;

  my $path = $TOKEN_PATH_NOTATION;

  my $regexp = qr{
    (?<!\\)
    (?<!\\\{)
    $token_tag_open
    \s*
    ($path)
    \s*
    $token_tag_close
    (?!\})
  }xi;

  $context = $self->mappable($context);

  $content =~ s{
    $regexp
  }{
    scalar($context->path($1)) // ''
  }gsex;

  $content =~ s/\\(\{\{|\}\})/$1/g;

  return $content;
}

1;
