package Venus::Path;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base', 'with';

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Valuable';
with 'Venus::Role::Buildable';
with 'Venus::Role::Accessible';
with 'Venus::Role::Explainable';

# OVERLOADS

use overload (
  '""' => 'explain',
  'eq' => sub{$_[0]->value eq "$_[1]"},
  'ne' => sub{$_[0]->value ne "$_[1]"},
  'qr' => sub{qr/@{[quotemeta($_[0]->value)]}/},
  '~~' => 'explain',
  fallback => 1,
);

# HOOKS

sub _exitcode {
  $? >> 8;
}

# METHODS

sub absolute {
  my ($self) = @_;

  require File::Spec;

  return $self->class->new(File::Spec->rel2abs($self->get));
}

sub basename {
  my ($self) = @_;

  require File::Basename;

  return File::Basename::basename($self->get);
}

sub child {
  my ($self, $path) = @_;

  require File::Spec;

  my @parts = File::Spec->splitdir($path);

  return $self->class->new(File::Spec->catfile($self->get, @parts));
}

sub chmod {
  my ($self, $mode) = @_;

  my $path = $self->get;

  CORE::chmod($mode, $path);

  return $self;
}

sub chown {
  my ($self, @args) = @_;

  my $path = $self->get;

  CORE::chown((map $_||-1, @args[0,1]), $path);

  return $self;
}

sub children {
  my ($self) = @_;

  require File::Spec;

  my @paths = map $self->glob($_), '.??*', '*';

  return wantarray ? (@paths) : \@paths;
}

sub copy {
  my ($self, $path) = @_;

  require File::Copy;

  File::Copy::copy("$self", "$path") or my $error = $!;
  if ($error) {
    $self->error_on_copy({error => $error, path => $path})
    ->input($self, $path)
    ->output($error)
    ->throw;
  }

  return $self;
}

sub default {
  require Cwd;

  return Cwd::getcwd();
}

sub directories {
  my ($self) = @_;

  my @paths = grep -d, $self->children;

  return wantarray ? (@paths) : \@paths;
}

sub exists {
  my ($self) = @_;

  return int!!-e $self->get;
}

sub explain {
  my ($self) = @_;

  return $self->get;
}

sub extension {
  my ($self, $value) = @_;

  my $basename = $self->basename;

  my ($filename, $suffix);

  if ($basename =~ /^(.+)\.([^.]+)$/) {
    $filename = $1;
    $suffix  = $2;
  } else {
    $filename = $basename;
    $suffix  = '';
  }

  return $suffix || undef if !$value;

  return $self->sibling(join '.', $filename, $value);
}

sub find {
  my ($self, $expr) = @_;

  $expr = '.*' if !$expr;

  $expr = qr/$expr/ if ref($expr) ne 'Regexp';

  my @paths;

  push @paths, grep {
    $_ =~ $expr
  } map {
    $_->is_directory ? $_->find($expr) : $_
  }
  $self->children;

  return wantarray ? (@paths) : \@paths;
}

sub files {
  my ($self) = @_;

  my @paths = grep -f, $self->children;

  return wantarray ? (@paths) : \@paths;
}

sub glob {
  my ($self, $expr) = @_;

  require File::Spec;

  $expr ||= '*';

  my @paths = map $self->class->new($_),
    CORE::glob +File::Spec->catfile($self->absolute, $expr);

  return wantarray ? (@paths) : \@paths;
}

sub is_absolute {
  my ($self) = @_;

  require File::Spec;

  return int!!(File::Spec->file_name_is_absolute($self->get));
}

sub is_directory {
  my ($self) = @_;

  my $path = $self->get;

  return int!!(-e $path && -d $path);
}

sub is_file {
  my ($self) = @_;

  my $path = $self->get;

  return int!!(-e $path && !-d $path);
}

sub is_relative {
  my ($self) = @_;

  return int!$self->is_absolute;
}

sub lines {
  my ($self, $separator, $binmode) = @_;

  $separator //= "\n";

  return [split /$separator/, $binmode ? $self->read($binmode) : $self->read];
}

sub lineage {
  my ($self) = @_;

  require File::Spec;

  my @parts = File::Spec->splitdir($self->get);

  my @paths = ((
    reverse map $self->class->new(File::Spec->catfile(@parts[0..$_])), 1..$#parts
    ), $self->class->new($parts[0]));

  return wantarray ? (@paths) : \@paths;
}

sub open {
  my ($self, @args) = @_;

  my $path = $self->get;

  require IO::File;

  my $handle = IO::File->new;

  $handle->open($path, @args) or my $error = $!;
  if ($error) {
    $self->error_on_open({path => $path, error => $error})
    ->input($self, @args)
    ->output($error)
    ->throw;
  }

  return $handle;
}

sub mkcall {
  my ($self, @args) = @_;

  require File::Spec;

  my $path = File::Spec->catfile(File::Spec->splitdir($self->get));

  my $result;

  require Venus::Os;

  my $args = join ' ', map Venus::Os->quote($_), grep defined, @args;

  (defined($result = ($args ? qx($path $args) : qx($path)))) or my $error = $!;
  if ($error) {
    $self->error_on_mkcall({error => $error, exit_code => _exitcode(), path => $path})
      ->input($self, @args)
      ->output($error)
      ->throw;
  }

  chomp $result;

  return wantarray ? ($result, _exitcode()) : $result;
}

sub mkdir {
  my ($self, $mode) = @_;

  my $path = $self->get;

  ($mode ? CORE::mkdir($path, $mode) : CORE::mkdir($path)) or my $error = $!;
  if ($error) {
    $self->error_on_mkdir({error => $error, path => $path})
      ->input($self, $mode)
      ->output($error)
      ->throw;
  }

  return $self;
}

sub mkdirs {
  my ($self, $mode) = @_;

  my @paths;

  for my $path (
    grep !!$_, reverse($self->parents), ($self->is_file ? () : $self)
  )
  {
    if ($path->exists) {
      next;
    }
    else {
      push @paths, $path->mkdir($mode);
    }
  }

  return wantarray ? (@paths) : \@paths;
}

sub mktemp_dir {
  my ($self) = @_;

  require File::Temp;

  return $self->class->new(File::Temp::tempdir());
}

sub mktemp_file {
  my ($self) = @_;

  require File::Temp;

  return $self->class->new((File::Temp::tempfile())[1]);
}

sub mkfile {
  my ($self) = @_;

  my $path = $self->get;

  return $self if $self->exists;

  $self->open('>');

  CORE::utime(undef, undef, $path) or my $error = $!;
  if ($error) {
    $self->error_on_mkfile({path => $path, error => $error})
      ->input($self)
      ->output($error)
      ->throw;
  }

  return $self;
}

sub move {
  my ($self, $path) = @_;

  require File::Copy;

  File::Copy::move("$self", "$path") or my $error = $!;
  if ($error) {
    $self->error_on_move({path => $path, error => $error})
      ->input($self, $path)
      ->output($error)
      ->throw;
  }

  return $self->class->new($path)->absolute;
}

sub name {
  my ($self) = @_;

  return $self->absolute->get;
}

sub parent {
  my ($self) = @_;

  require File::Spec;

  my @parts = File::Spec->splitdir($self->get);

  my $path = File::Spec->catfile(@parts[0..$#parts-1]);

  return defined $path ? $self->class->new($path) : undef;
}

sub parents {
  my ($self) = @_;

  my @paths = $self->lineage;

  @paths = @paths[1..$#paths] if @paths;

  return wantarray ? (@paths) : \@paths;
}

sub parts {
  my ($self) = @_;

  require File::Spec;

  return [File::Spec->splitdir($self->get)];
}

sub read {
  my ($self) = @_;

  my $path = $self->get;

  require Venus::Os;

  my ($catch, $data) = Venus::Os->new->catch('read', $path);

  if ($catch && $catch->isa('Venus::Os::Error') && $catch->of('on.read')) {
    $self->error_on_read({path => $path, error => $catch->stash('error')})
      ->input($self)
      ->output($catch->stash('error'))
      ->set('cause', $catch)
      ->throw;
  }
  elsif ($catch) {
    die $catch;
  }

  return $data;
}

sub relative {
  my ($self, $path) = @_;

  require File::Spec;

  $path ||= $self->default;

  return $self->class->new(File::Spec->abs2rel($self->get, $path));
}

sub rename {
  my ($self, $path) = @_;

  $path = $self->class->new($path);

  $path = $self->sibling("$path") if $path->is_relative;

  return $self->move($path);
}

sub rmdir {
  my ($self) = @_;

  my $path = $self->get;

  CORE::rmdir($path) or my $error = $!;
  if ($error) {
    $self->error_on_rmdir({path => $path, error => $error})
    ->input($self)
    ->output($error)
    ->throw;
  }

  return $self;
}

sub rmdirs {
  my ($self) = @_;

  my @paths;

  for my $path ($self->children) {
    if ($path->is_file) {
      push @paths, $path->unlink;
    }
    else {
      push @paths, $path->rmdirs;
    }
  }

  push @paths, $self->rmdir;

  return wantarray ? (@paths) : \@paths;
}

sub rmfiles {
  my ($self) = @_;

  my @paths;

  for my $path ($self->children) {
    if ($path->is_file) {
      push @paths, $path->unlink;
    }
    else {
      push @paths, $path->rmfiles;
    }
  }

  return wantarray ? (@paths) : \@paths;
}

sub root {
  my ($self, $spec, $base) = @_;

  my @paths;

  for my $path ($self->absolute->lineage) {
    if ($path->child($base)->test($spec)) {
      push @paths, $path;
      last;
    }
  }

  return @paths ? (-f $paths[0] ? $paths[0]->parent : $paths[0]) : undef;
}

sub seek {
  my ($self, $spec, $base) = @_;

  if ((my $path = $self->child($base))->test($spec)) {
    return $path;
  }
  else {
    for my $path ($self->directories) {
      my $sought = $path->seek($spec, $base);
      return $sought if $sought;
    }
    return undef;
  }
}

sub sibling {
  my ($self, $path) = @_;

  require File::Basename;
  require File::Spec;

  return $self->class->new(File::Spec->catfile(
    File::Basename::dirname($self->get), $path));
}

sub siblings {
  my ($self) = @_;

  my @paths = map $self->parent->glob($_), '.??*', '*';

  my %seen = ($self->absolute, 1);

  @paths = grep !$seen{$_}++, @paths;

  return wantarray ? (@paths) : \@paths;
}

sub test {
  my ($self, $spec) = @_;

  return eval(
    join(' ', map("-$_", grep(/^[a-zA-Z]$/, split(//, $spec || 'e'))), '$self')
  );
}

sub unlink {
  my ($self) = @_;

  my $path = $self->get;

  CORE::unlink($path) or my $error = $!;
  if ($error) {
    $self->error_on_unlink({path => $path, error => $error})
    ->input($self)
    ->output($error)
    ->throw;
  }

  return $self;
}

sub write {
  my ($self, $data) = @_;

  my $path = $self->get;

  require Venus::Os;

  my $catch = Venus::Os->new->catch('write', $path, $data);

  if ($catch && $catch->isa('Venus::Os::Error') && $catch->of('on.write')) {
    $self->error_on_write({path => $path, error => $catch->stash('error')})
      ->input($self, $data)
      ->output($catch->stash('error'))
      ->set('cause', $catch)
      ->throw;
  }
  elsif ($catch) {
    die $catch;
  }

  return $self;
}

# ERRORS

sub error_on_copy {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t copy "{{self}}" to "{{path}}": {{error}}';

  $error->name('on.copy');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_mkcall {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = ("Can't make system call to \"{{path}}\": "
    . ($data->{error} ? "@{[$data->{error}]}" : sprintf("exit code (%s)", $data->{exit_code} || 0)));

  $error->name('on.mkcall');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_mkdir {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t make directory "{{path}}": {{error}}';

  $error->name('on.mkdir');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_mkfile {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t make file "{{path}}": {{error}}';

  $error->name('on.mkfile');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_move {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t move "{{self}}" to "{{path}}": {{error}}';

  $error->name('on.move');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_open {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t open "{{path}}": {{error}}';

  $error->name('on.open');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_read {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t read "{{path}}": {{error}}';

  $error->name('on.read');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_rmdir {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t rmdir "{{path}}": {{error}}';

  $error->name('on.rmdir');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_write {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t write "{{path}}": {{error}}';

  $error->name('on.write');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_unlink {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t unlink "{{path}}": {{error}}';

  $error->name('on.unlink');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

1;
