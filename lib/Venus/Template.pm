package Venus::Template;

use 5.018;

use strict;
use warnings;

use Venus::Class 'attr', 'base', 'with';

base 'Venus::Kind::Utility';

with 'Venus::Role::Valuable';
with 'Venus::Role::Buildable';
with 'Venus::Role::Accessible';
with 'Venus::Role::Explainable';

use overload (
  '""' => 'explain',
  'eq' => sub{$_[0]->render eq "$_[1]"},
  'ne' => sub{$_[0]->render ne "$_[1]"},
  'qr' => sub{qr/@{[quotemeta($_[0]->render)]}/},
  '~~' => 'explain',
  fallback => 1,
);

# ATTRIBUTES

attr 'markers';
attr 'variables';

# BUILDERS

sub build_self {
  my ($self, $data) = @_;

  $self->markers([qr/\{\{/, qr/\}\}/]) if !defined $self->markers;
  $self->variables({}) if !defined $self->variables;

  return $self;
}

# METHODS

sub assertion {
  my ($self) = @_;

  my $assertion = $self->SUPER::assertion;

  $assertion->match('string')->format(sub{
    (ref $self || $self)->new($_)
  });

  return $assertion;
}

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
  my ($self, $content, $variables) = @_;

  if (!defined $content) {
    $content = $self->get;
  }

  if (!defined $variables) {
    $variables = $self->variables;
  }
  else {
    $variables = $self->mappable($self->variables)->merge(
      $self->mappable($variables)->get
    );
  }

  $content =~ s/^\r?\n//;
  $content =~ s/\r?\n\ *$//;

  $content = $self->render_blocks($content, $variables);

  $content = $self->render_tokens($content, $variables);

  return $content;
}

sub render_blocks {
  my ($self, $content, $variables) = @_;

  my ($stag, $etag) = @{$self->markers};

  my $path = qr/[a-z_][\w.]*/;

  my $regexp = qr{
    $stag
    \s*
    (FOR|IF|IF\sNOT)
    \s+
    ($path)
    \s*
    $etag
    (.+)
    $stag
    \s*
    (END)
    \s+
    \2
    \s*
    $etag
  }xis;

  $variables = $self->mappable($variables);

  $content =~ s{
    $regexp
  }{
    my ($type, $path, $body) = ($1, $2, $3);
    if (lc($type) eq 'if') {
      $self->render_if(
        $body, $variables, !!scalar($variables->path($path)), $path
      );
    }
    elsif (lc($type) eq 'if not') {
      $self->render_if_not(
        $body, $variables, !!scalar($variables->path($path)), $path
      );
    }
    elsif (lc($type) eq 'for') {
      $self->render_foreach(
        $body, $self->mappable($variables->path($path))
      );
    }
  }gsex;

  return $content;
}

sub render_if {
  my ($self, $context, $variables, $boolean, $path) = @_;

  my $mappable = $self->mappable($variables);

  my ($stag, $etag) = @{$self->markers};

  $path = quotemeta $path;

  my $regexp = qr{
    $stag
    \s*
    ELSE
    \s+
    $path
    \s*
    $etag
  }xis;

  my ($a, $b) = split /$regexp/, $context;

  if ($boolean) {
    return $self->render($a, $mappable);
  }
  else {
    if ($b) {
      return $self->render($b, $mappable);
    }
    else {
      return '';
    }
  }
}

sub render_if_not {
  my ($self, $context, $variables, $boolean, $path) = @_;

  my $mappable = $self->mappable($variables);

  my ($stag, $etag) = @{$self->markers};

  $path = quotemeta $path;

  my $regexp = qr{
    $stag
    \s*
    ELSE
    \s+
    $path
    \s*
    $etag
  }xis;

  my ($a, $b) = split /$regexp/, $context;

  if (!$boolean) {
    return $self->render($a, $mappable);
  }
  else {
    if ($b) {
      return $self->render($b, $mappable);
    }
    else {
      return '';
    }
  }
}

sub render_foreach {
  my ($self, $context, $mappable) = @_;

  $mappable = $self->mappable($mappable);

  if (!$mappable->isa('Venus::Array')) {
    return '';
  }

  my @results = $self->mappable($mappable)->each(sub {
    my (@args) = @_;
    $self->render($context, $self->mappable($args[1])->do(
      'set', 'loop', {index => $args[0], place => $args[0]+1},
    ));
  });

  return join "\n", grep !!$_, @results;
}

sub render_tokens {
  my ($self, $content, $variables) = @_;

  my ($stag, $etag) = @{$self->markers};

  my $path = qr/[a-z_][\w.]*/;

  my $regexp = qr{
    $stag
    \s*
    ($path)
    \s*
    $etag
  }xi;

  $variables = $self->mappable($variables);

  $content =~ s{
    $regexp
  }{
    scalar($variables->path($1)) // ''
  }gsex;

  return $content;
}

1;
