package Venus::Config;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Buildable';
with 'Venus::Role::Valuable';

use Scalar::Util ();

# STATE

state $reader = {
  env => 'read_env_file',
  js => 'read_json_file',
  json => 'read_json_file',
  perl => 'read_perl_file',
  pl => 'read_perl_file',
  yaml => 'read_yaml_file',
  yml => 'read_yaml_file',
};

state $writer = {
  env => 'write_env_file',
  js => 'write_json_file',
  json => 'write_json_file',
  perl => 'write_perl_file',
  pl => 'write_perl_file',
  yaml => 'write_yaml_file',
  yml => 'write_yaml_file',
};

# BUILDERS

sub build_args {
  my ($self, $data) = @_;

  if (keys %$data == 1 && exists $data->{value}) {
    return $data;
  }
  return {
    value => $data
  };
}

# METHODS

sub edit_file {
  my ($self, $file, $code) = @_;

  $self = $self->read_file($file);

  $self->value($self->$code($self->value));

  return $self->write_file($file);
}

sub read_env {
  my ($self, $lines) = @_;

  my $data = {};

  my $content = $lines // '';
  my $length = length($content);
  my $pos = 0;

  while ($pos < $length) {
    # Skip whitespace and newlines
    if (substr($content, $pos, 1) =~ /[\s\n]/) {
      $pos++;
      next;
    }

    # Skip comments (lines starting with #)
    if (substr($content, $pos, 1) eq '#') {
      while ($pos < $length && substr($content, $pos, 1) ne "\n") {
        $pos++;
      }
      next;
    }

    # Parse key (alphanumeric, underscore, and dot)
    my $key = '';
    while ($pos < $length && substr($content, $pos, 1) =~ /[\w\.]/) {
      $key .= substr($content, $pos, 1);
      $pos++;
    }

    # Skip if no key found
    next if !length($key);

    # Skip whitespace before =
    while ($pos < $length && substr($content, $pos, 1) =~ /[ \t]/) {
      $pos++;
    }

    # Expect =
    if ($pos >= $length || substr($content, $pos, 1) ne '=') {
      # Skip to end of line if no =
      while ($pos < $length && substr($content, $pos, 1) ne "\n") {
        $pos++;
      }
      next;
    }
    $pos++; # Skip =

    # Skip whitespace after =
    while ($pos < $length && substr($content, $pos, 1) =~ /[ \t]/) {
      $pos++;
    }

    # Parse value
    my $value = '';
    my $char = substr($content, $pos, 1);

    if ($char eq '"') {
      # Double-quoted value (can be multiline)
      $pos++; # Skip opening quote
      while ($pos < $length) {
        $char = substr($content, $pos, 1);
        if ($char eq '\\' && $pos + 1 < $length) {
          # Handle escape sequences
          my $next = substr($content, $pos + 1, 1);
          if ($next eq 'n') {
            $value .= "\n";
            $pos += 2;
          }
          elsif ($next eq 't') {
            $value .= "\t";
            $pos += 2;
          }
          elsif ($next eq '"') {
            $value .= '"';
            $pos += 2;
          }
          elsif ($next eq '\\') {
            $value .= '\\';
            $pos += 2;
          }
          else {
            $value .= $char;
            $pos++;
          }
        }
        elsif ($char eq '"') {
          $pos++; # Skip closing quote
          last;
        }
        else {
          $value .= $char;
          $pos++;
        }
      }
    }
    elsif ($char eq "'") {
      # Single-quoted value (can be multiline, no escape processing)
      $pos++; # Skip opening quote
      while ($pos < $length) {
        $char = substr($content, $pos, 1);
        if ($char eq "'") {
          $pos++; # Skip closing quote
          last;
        }
        else {
          $value .= $char;
          $pos++;
        }
      }
    }
    else {
      # Unquoted value (single line, until whitespace or comment)
      while ($pos < $length) {
        $char = substr($content, $pos, 1);
        last if $char =~ /[\s#\n]/;
        $value .= $char;
        $pos++;
      }
    }

    $data->{$key} = $value;
  }

  return $self->class->new($data);
}

sub read_env_file {
  my ($self, $file) = @_;

  return $self->read_env(Venus::Path->new($file)->read);
}

sub read_file {
  my ($self, $file) = @_;

  if (!$file) {
    return $self->class->new;
  }
  elsif (my $method = $reader->{(split/\./, $file)[-1]}) {
    return $self->$method($file);
  }
  else {
    return $self->class->new;
  }
}

sub read_json {
  my ($self, $data) = @_;

  require Venus::Json;

  return $self->class->new(Venus::Json->new->decode($data));
}

sub read_json_file {
  my ($self, $file) = @_;

  require Venus::Path;

  return $self->read_json(Venus::Path->new($file)->read);
}

sub read_perl {
  my ($self, $data) = @_;

  require Venus::Dump;

  return $self->class->new(Venus::Dump->new->decode($data));
}

sub read_perl_file {
  my ($self, $file) = @_;

  require Venus::Path;

  return $self->read_perl(Venus::Path->new($file)->read);
}

sub read_yaml {
  my ($self, $data) = @_;

  require Venus::Yaml;

  return $self->class->new(Venus::Yaml->new->decode($data));
}

sub read_yaml_file {
  my ($self, $file) = @_;

  require Venus::Path;

  return $self->read_yaml(Venus::Path->new($file)->read);
}

sub write_env {
  my ($self) = @_;

  my @data;

  for my $key (sort keys %{$self->value}) {
    my $value = $self->value->{$key};

    next if !defined $value || ref $value;

    # Check if value needs quoting (contains whitespace, newlines, or special chars)
    my $needs_quotes = $value =~ /[\s\n\t"'#\\]/;

    if ($needs_quotes) {
      # Escape special characters for double-quoted values
      $value =~ s/\\/\\\\/g;
      $value =~ s/"/\\"/g;
      $value =~ s/\n/\\n/g;
      $value =~ s/\t/\\t/g;
      $value = qq("$value");
    }

    push @data, "$key=$value";
  }

  return join "\n", @data;
}

sub write_env_file {
  my ($self, $file) = @_;

  Venus::Path->new($file)->write($self->write_env);

  return $self;
}

sub write_file {
  my ($self, $file) = @_;

  if (!$file) {
    return $self->class->new;
  }
  elsif (my $method = $writer->{(split/\./, $file)[-1]}) {
    return $self->do($method, $file);
  }
  else {
    return $self->class->new;
  }
}

sub write_json {
  my ($self) = @_;

  require Venus::Json;

  return Venus::Json->new($self->value)->encode;
}

sub write_json_file {
  my ($self, $file) = @_;

  require Venus::Path;

  Venus::Path->new($file)->write($self->write_json);

  return $self;
}

sub write_perl {
  my ($self) = @_;

  require Venus::Dump;

  return Venus::Dump->new($self->value)->encode;
}

sub write_perl_file {
  my ($self, $file) = @_;

  require Venus::Path;

  Venus::Path->new($file)->write($self->write_perl);

  return $self;
}

sub write_yaml {
  my ($self) = @_;

  require Venus::Yaml;

  return Venus::Yaml->new($self->value)->encode;
}

sub write_yaml_file {
  my ($self, $file) = @_;

  require Venus::Path;

  Venus::Path->new($file)->write($self->write_yaml);

  return $self;
}

1;
