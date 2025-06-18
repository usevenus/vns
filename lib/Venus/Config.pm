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

  for my $line (grep !/^\s*$/, grep !/^\s*#/, split /\n/, $lines // '') {
    if ($line =~ /^\s*([\w\.]+)\s*=\s*(?:"([^"]+)"|'([^']+)'|([^\s#]+))\s*$/) {
      my ($key, $val) = ($1, $2 // $3 // $4);
      $data->{$key} = $val;
    }
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

    next if !defined $value;

    $value = qq("$value") if $value =~ /\s/;

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
