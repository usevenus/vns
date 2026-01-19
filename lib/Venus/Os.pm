package Venus::Os;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base';

# INHERITS

base 'Venus::Kind::Utility';

use Encode ();

our %TYPES;

# BUILDERS

sub build_arg {
  my ($self) = @_;

  return {};
}

# HOOKS

sub _exitcode {
  $? >> 8;
}

sub _open {
  CORE::open(shift, shift, shift);
}

sub _osname {
  $TYPES{$^O} || $^O
}

sub _system {
  local $SIG{__WARN__} = sub {};
  CORE::system(@_) or return 0;
}

# METHODS

sub call {
  my ($self, $name, @args) = @_;

  return if !$name;

  require Venus::Path;

  my $which = $self->which($name);

  return if !$which;

  my $path = Venus::Path->new($which);

  my $expr = join ' ', @args;

  return $path->try('mkcall')->maybe->result($expr || ());
}

sub find {
  my ($self, $name, @paths) = @_;

  return if !$name;

  require File::Spec;

  return [$name] if File::Spec->splitdir($name) > 1;

  my $result = [grep -f, map File::Spec->catfile($_, $name), @paths];

  return wantarray ? @{$result} : $result;
}

sub is_bsd {

  return true if lc(_osname()) eq 'freebsd';
  return true if lc(_osname()) eq 'openbsd';

  return false;
}

sub is_cyg {

  return true if lc(_osname()) eq 'cygwin';
  return true if lc(_osname()) eq 'msys';

  return false;
}

sub is_dos {

  return true if is_win();

  return false;
}

sub is_lin {

  return true if lc(_osname()) eq 'linux';

  return false;
}

sub is_mac {

  return true if lc(_osname()) eq 'macos';
  return true if lc(_osname()) eq 'darwin';

  return false;
}

sub is_non {

  return false if is_bsd();
  return false if is_cyg();
  return false if is_dos();
  return false if is_lin();
  return false if is_mac();
  return false if is_sun();
  return false if is_vms();
  return false if is_win();

  return true;
}

sub is_sun {

  return true if lc(_osname()) eq 'solaris';
  return true if lc(_osname()) eq 'sunos';

  return false;
}

sub is_vms {

  return true if lc(_osname()) eq 'vms';

  return false;
}

sub is_win {

  return true if lc(_osname()) eq 'mswin32';
  return true if lc(_osname()) eq 'dos';
  return true if lc(_osname()) eq 'os2';

  return false;
}

sub name {
  my ($self) = @_;

  my $name = _osname();

  return $name;
}

sub paths {
  my ($self) = @_;

  require File::Spec;

  my %seen;

  my $result = [grep !$seen{$_}++, File::Spec->path];

  return wantarray ? @{$result} : $result;
}

sub quote {
  my ($self, $data) = @_;

  if (!defined $data) {
    return '';
  }
  elsif ($self->is_win) {
    return ($data =~ /^"/ && $data =~ /"$/)
      ? $data
      : ('"' . (($data =~ s/"/\\"/gr) || "") . '"');
  }
  else {
    return ($data =~ /^'/ && $data =~ /'$/)
      ? $data
      : ("'" . (($data =~ s/'/'\\''/gr) || "") . "'");
  }
}

sub read {
  my ($self, $from) = @_;

  no warnings 'io';

  my $fh;
  my $is_handle = ref($from) eq 'GLOB' || UNIVERSAL::isa($from, 'IO::Handle');
  my $error;

  if ($is_handle) {
    $fh = $from;
    binmode($fh, ':raw') or $error = $!;
    if ($error) {
      $self->error_on_read_binmode({from => $from, error => $error, binmode => ':raw'})
      ->input($self, $from)
      ->output($error)
      ->throw;
    }
    seek($fh, 0, 0) or $error = $!;
    if ($error) {
      $self->error_on_read_seek({filehandle => $fh, error => $error})
      ->input($self, $from)
      ->output($error)
      ->throw;
    }
  }
  else {
    if (!defined $from || $from eq '-' || $from eq 'STDIN') {
      if (!defined(fileno(STDIN))) {
        _open(\*STDIN, '<&', 0) or $error = $!;
        if ($error) {
          $self->error_on_read_open_stdin({error => $error})
          ->input($self, $from)
          ->output($error)
          ->throw;
        }
      }
      $fh = *STDIN;
      binmode($fh, ':raw') or $error = $!;
      if ($error) {
        $self->error_on_read_binmode({from => 'STDIN', error => $error, binmode => ':raw'})
        ->input($self, $from)
        ->output($error)
        ->throw;
      }
    }
    else {
      _open($fh, '<:raw', $from) or $error = $!;
      if ($error) {
        $self->error_on_read_open_file({error => $error, file => $from})
        ->input($self, $from)
        ->output($error)
        ->throw;
      }
    }
  }

  read($fh, my $bom, 4);
  my $encoding;
  my $offset = 0;

  if ($bom =~ /^\xEF\xBB\xBF/) {
    $encoding = 'UTF-8';
    $offset = 3;
  }
  elsif ($bom =~ /^\xFF\xFE\x00\x00/) {
    $encoding = 'UTF-32LE';
    $offset = 4;
  }
  elsif ($bom =~ /^\x00\x00\xFE\xFF/) {
    $encoding = 'UTF-32BE';
    $offset = 4;
  }
  elsif ($bom =~ /^\xFF\xFE/) {
    $encoding = 'UTF-16LE';
    $offset = 2;
  }
  elsif ($bom =~ /^\xFE\xFF/) {
    $encoding = 'UTF-16BE';
    $offset = 2;
  }
  else {
    $encoding = 'UTF-8';
    seek($fh, 0, 0) or $error = $!;
    if ($error) {
      $self->error_on_read_seek_reset({error => $error})
      ->input($self, $from)
      ->output($error)
      ->throw;
    }
  }

  if ($offset > 0) {
    seek($fh, $offset, 0) or $error = $!;
    if ($error) {
      $self->error_on_read_seek({error => $error})
      ->input($self, $from)
      ->output($error)
      ->throw;
    }
  }

  my $raw_content = '';

  while (read($fh, my $chunk, 8192)) {
    $raw_content .= $chunk;
  }

  local $@;

  my $data = eval {
    Encode::decode($encoding, $raw_content, Encode::FB_CROAK);
  };
  if ($@) {
    $data = Encode::decode('ISO-8859-1', $raw_content);
  }

  close $fh if !$is_handle && fileno($fh) != fileno(STDIN);

  $data =~ s/\r\n?/\n/g;

  return $data;
}

sub syscall {
  my ($self, @args) = @_;

  (_system(@args) == 0) or do {
    my $error = $!;
    $self->error_on_system_call({args => [@args], error => $error || _exitcode(), exit_code => _exitcode()})
      ->input($self, @args)
      ->output($error)
      ->throw;
  };

  return $self;
}

sub type {
  my ($self) = @_;

  my @types = qw(
    is_lin
    is_mac
    is_win
    is_bsd
    is_cyg
    is_sun
    is_vms
  );

  my $result = [grep $self->$_, @types];

  return $result->[0] || 'is_non';
}

sub where {
  my ($self, $name) = @_;

  my $result = $self->find($name, $self->paths);

  return wantarray ? @{$result} : $result;
}

sub which {
  my ($self, $name) = @_;

  my $result = $self->where($name);

  return $result->[0];
}

sub write {
  my ($self, $into, $data, $encoding) = @_;

  no warnings 'io';

  $encoding ||= Encode::is_utf8($data) ? 'UTF-8' : 'ISO-8859-1';

  my $fh;
  my $is_handle = ref($into) eq 'GLOB' || UNIVERSAL::isa($into, 'IO::Handle');
  my $error;

  if ($is_handle) {
    $fh = $into;
  }
  else {
    if (!defined $into || $into eq '-' || $into eq 'STDOUT') {
      if (!defined(fileno(STDOUT))) {
        _open(\*STDOUT, '>&', 1) or $error = $!;
        if ($error) {
          $self->error_on_write_open_stdout({error => $error})
          ->input($self, $into, $data, $encoding)
          ->output($error)
          ->throw;
        }
      }
      $fh = \*STDOUT; select($fh); $| = 1;
    }
    elsif ($into eq 'STDERR') {
      if (!defined(fileno(STDERR))) {
        _open(\*STDERR, '>&', 2) or $error = $!;
        if ($error) {
          $self->error_on_write_open_stderr({error => $error})
          ->input($self, $into, $data, $encoding)
          ->output($error)
          ->throw;
        }
      }
      $fh = \*STDERR; select($fh); $| = 1;
    }
    else {
      _open($fh, '>:raw', $into) or $error = $!;
      if ($error) {
        $self->error_on_write_open_file({error => $error, file => $into})
        ->input($self, $into, $data, $encoding)
        ->output($error)
        ->throw;
      }
    }
  }

  if (fileno($fh) == fileno(STDOUT) || fileno($fh) == fileno(STDERR)) {
    binmode($fh, ":raw") or $error = $!;
    if ($error) {
      $self->error_on_write_binmode({from => 'STOUT', error => $error, binmode => ':raw'})
      ->input($self, $into, $data, $encoding)
      ->output($error)
      ->throw;
    }
  }
  else {
    binmode($fh, ':raw') or $error = $!;
    if ($error) {
      $self->error_on_write_binmode({from => $fh, error => $error, binmode => ':raw'})
      ->input($self, $into, $data, $encoding)
      ->output($error)
      ->throw;
    }

    if ($encoding eq 'UTF-8') {
      print $fh "\xEF\xBB\xBF";
    }
    elsif ($encoding eq 'UTF-16LE') {
      print $fh "\xFF\xFE";
    }
    elsif ($encoding eq 'UTF-16BE') {
      print $fh "\xFE\xFF";
    }
    elsif ($encoding eq 'UTF-32LE') {
      print $fh "\xFF\xFE\x00\x00";
    }
    elsif ($encoding eq 'UTF-32BE') {
      print $fh "\x00\x00\xFE\xFF";
    }
  }

  $data = "" if !defined $data;

  if ($self->is_vms || $self->is_win) {
    $data =~ s/(?<!\r)\n/\r\n/g;
  }

  if (fileno($fh) == fileno(STDOUT) || fileno($fh) == fileno(STDERR)) {
    my $encoded_content = Encode::is_utf8($data)
      ? "$data"
      : Encode::encode('UTF-8', $data, Encode::FB_CROAK);
    print $fh $encoded_content;
  }
  else {
    my $encoded_content = Encode::encode($encoding, $data, Encode::FB_CROAK);
    my $chunk_size = 8192;
    my $offset = 0;
    my $length = length($encoded_content);

    while ($offset < $length) {
      my $chunk = substr($encoded_content, $offset, $chunk_size);
      print $fh $chunk;
      $offset += $chunk_size;
    }
  }

  close $fh
    if !$is_handle
    && (fileno($fh) != fileno(STDOUT) && fileno($fh) != fileno(STDERR));

  return $self;
}

# ERRORS

sub error_on_read_binmode {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t binmode on read: {{error}}';

  $error->name('on.read.binmode');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_read_open_file {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t open "{{file}}" for reading: {{error}}';

  $error->name('on.read.open.file');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_read_open_stdin {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t open STDIN for reading: {{error}}';

  $error->name('on.read.open.stdin');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_read_seek {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t seek in filehandle: {{error}}';

  $error->name('on.read.seek');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_read_seek_reset {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t reset seek in filehandle: {{error}}';

  $error->name('on.read.seek.reset');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_system_call {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t make system call "{{command}}": {{error}}';

  $data->{command} = join ' ', @{$data->{args}};

  $error->name('on.system.call');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_write_binmode {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t binmode on write: {{error}}';

  $error->name('on.write.binmode');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_write_open_file {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t open "{{file}}" for writing: {{error}}';

  $error->name('on.write.open.file');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_write_open_stderr {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t open STDERR for writing: {{error}}';

  $error->name('on.write.open.stderr');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_write_open_stdout {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t open STDOUT for writing: {{error}}';

  $error->name('on.write.open.stdout');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

1;
