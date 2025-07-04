package Venus::Space;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'base';

# INHERITS

base 'Venus::Name';

# STATE

state $SERIAL = 0;

# BUILDERS

sub build_self {
  my ($self, $data) = @_;

  $self->{value} = $self->package if !$self->lookslike_a_pragma;

  return $self;
}

# METHODS

sub all {
  my ($self, $name, @args) = @_;

  my $result = [];
  my $class = $self->class;

  for my $package ($self->package, @{$self->inherits}) {
    push @$result, [$package, $class->new($package)->$name(@args)];
  }

  return $result;
}

sub append {
  my ($self, @args) = @_;

  my $class = $self->class;

  my $path = join '/',
    $self->path, map $class->new($_)->path, @args;

  return $class->new($path);
}

sub array {
  my ($self, $name, @data) = @_;

  no strict 'refs';

  my $class = $self->package;

  no warnings 'once';

  @{"${class}::${name}"} = @data if @data;

  return [@{"${class}::${name}"}];
}

sub arrays {
  my ($self) = @_;

  no strict 'refs';

  my $class = $self->package;

  my $arrays = [
    sort grep !!@{"${class}::$_"},
    grep /^[_a-zA-Z]\w*$/, keys %{"${class}::"}
  ];

  return $arrays;
}

sub attributes {
  my ($self) = @_;

  return $self->meta->local('attrs');
}

sub authority {
  my ($self) = @_;

  return $self->scalar('AUTHORITY');
}

sub basename {
  my ($self) = @_;

  return $self->parse->[-1];
}

sub blessed {
  my ($self, $data) = @_;

  $data //= {};

  my $class = $self->load;

  return CORE::bless($data, $class);
}

sub build {
  my ($self, @args) = @_;

  my $class = $self->load;

  return $self->call('new', $class, @args);
}

sub call {
  my ($self, $func, @args) = @_;

  my $class = $self->load;

  unless ($func) {
    $self->error_on_call_undefined({package => $class, routine => $func})
      ->input($self, $func, @args)
      ->throw;
  }

  my $next = $class->can($func);

  unless ($next) {
    if ($class->can('AUTOLOAD')) {
      $next = sub { no strict 'refs'; &{"${class}::${func}"}(@args) };
    }
  }

  unless ($next) {
    $self->error_on_call_missing({package => $class, routine => $func})
      ->input($self, $func, @args)
      ->throw;
  }

  @_ = @args; goto $next;
}

sub chain {
  my ($self, @steps) = @_;

  my $result = $self;

  for my $step (@steps) {
    my ($name, @args) = (ref($step) eq 'ARRAY') ? @$step : ($step);

    $result = $result->$name(@args);
  }

  return $result;
}

sub child {
  my ($self, @args) = @_;

  return $self->append(@args);
}

sub children {
  my ($self) = @_;

  my %list;
  my $path;
  my $type;

  $path = quotemeta $self->path;
  $type = 'pm';

  my $regexp = qr/$path\/[^\/]+\.$type/;

  for my $item (keys %INC) {
    $list{$item}++ if $item =~ /$regexp$/;
  }

  my %seen;

  for my $dir (@INC) {
    next if $seen{$dir}++;

    my $re = quotemeta $dir;
    map { s/^$re\///; $list{$_}++ }
    grep !$list{$_}, glob "$dir/@{[$self->path]}/*.$type";
  }

  my $class = $self->class;

  return [
    map $class->new($_),
    map {s/(.*)\.$type$/$1/r}
    sort keys %list
  ];
}

sub cop {
  my ($self, $func, @args) = @_;

  my $class = $self->load;

  if (!$func) {
    $self->error_on_cop_undefined({package => $class, routine => $func})
      ->input($self, $func, @args)
      ->throw;
  }

  my $next = $class->can($func);

  unless ($next) {
    $self->error_on_cop_missing({package => $class, routine => $func})
      ->input($self, $func, @args)
      ->throw;
  }

  return sub { $next->(@args ? (@args, @_) : @_) };
}

sub data {
  my ($self) = @_;

  no strict 'refs';

  my $class = $self->package;

  local $.;

  my $handle = \*{"${class}::DATA"};

  return '' if !fileno $handle;

  seek $handle, 0, 0;

  my $data = join '', <$handle>;

  $data =~ s/^.*\n__DATA__\r?\n/\n/s;
  $data =~ s/\n__END__\r?\n.*$/\n/s;

  return $data;
}

sub eval {
  my ($self, @args) = @_;

  local $@;

  my $result = eval join ' ', map "$_", "package @{[$self->package]};", @args;

  if (my $error = $@) {
    $self->error_on_eval({package => $self->package, error => $error})
      ->input($self, @args)
      ->output($error)
      ->throw;
  }

  return $result;
}

sub explain {
  my ($self) = @_;

  return $self->package;
}

sub hash {
  my ($self, $name, @data) = @_;

  no strict 'refs';

  my $class = $self->package;

  no warnings 'once';

  %{"${class}::${name}"} = (@data) if @data;

  return {%{"${class}::${name}"}};
}

sub hashes {
  my ($self) = @_;

  no strict 'refs';

  my $class = $self->package;

  return [
    sort grep !!%{"${class}::$_"},
    grep /^[_a-zA-Z]\w*$/, keys %{"${class}::"}
  ];
}

sub id {
  my ($self) = @_;

  return $self->label;
}

sub init {
  my ($self) = @_;

  $self->tryload;

  $self->eval('sub import') if !$self->loaded;

  return $self->package;
}

sub inherits {
  my ($self) = @_;

  return $self->array('ISA');
}

sub included {
  my ($self) = @_;

  return $INC{$self->format('path', '%s.pm')};
}

sub inject {
  my ($self, $name, $coderef) = @_;

  no strict 'refs';
  no warnings 'redefine';

  my $class = $self->package;

  return *{"${class}::${name}"} = $coderef || sub{$class};
}

sub integrates {
  my ($self) = @_;

  my $roles = $self->meta->roles;

  return $roles || [];
}

sub lfile {
  my ($self) = @_;

  return $self->format('path', '%s.pm');
}

sub load {
  my ($self) = @_;

  my $class = $self->package;

  return $class if $class eq 'main' || $self->loaded;

  my $error = do{local $@; eval "require $class"; $@};

  if ($error) {
    $self->error_on_load({error => $error || 'cause unknown', package => $class})
      ->input($self)
      ->output($error)
      ->throw;
  }

  return $class;
}

sub loaded {
  my ($self) = @_;

  return ($self->included || @{$self->routines}) ? true : false;
}

sub locate {
  my ($self) = @_;

  my $found = '';

  my $file = $self->format('path', '%s.pm');

  for my $path (@INC) {
    do { $found = "$path/$file"; last } if -f "$path/$file";
  }

  return $found;
}

sub meta {
  my ($self) = @_;

  require Venus::Meta;

  return Venus::Meta->new(name => $self->package);
}

sub mock {
  my ($self) = @_;

  my $name = sprintf '%s::Mock::%04d::%s', $self->class, ++$SERIAL, $self->package;

  my $space = $self->class->new($name);

  $space->do('init')->array('ISA', $self->package) if !$space->loaded;

  return $space;
}

sub name {
  my ($self) = @_;

  return $self->package;
}

sub parent {
  my ($self) = @_;

  my @parts = @{$self->parse};

  pop @parts if @parts > 1;

  my $class = $self->class;

  return $class->new(join '/', @parts);
}

sub parse {
  my ($self) = @_;

  return [
    map ucfirst,
    map join('', map(ucfirst, split /[-_]/)),
    split /[^-_a-zA-Z0-9.]+/,
    $self->path
  ];
}

sub parts {
  my ($self) = @_;

  return $self->parse;
}

sub patch {
  my ($self, $name, $code) = @_;

  my $patched = $self->{'$patched'} ||= {};

  my $orig = $self->swap($name, $code);

  $patched->{$name} = $orig;

  return $self;
}

sub patched {
  my ($self, $name) = @_;

  my $patched = $self->{'$patched'};

  return false if !$patched;

  return $name ? ($patched->{$name} ? true : false) : true;
}

sub pfile {
  my ($self) = @_;

  return $self->format('path', '%s.pod');
}

sub prepend {
  my ($self, @args) = @_;

  my $class = $self->class;

  my $path = join '/',
    (map $class->new($_)->path, @args), $self->path;

  return $class->new($path);
}

sub purge {
  my ($self) = @_;

  return $self if $self->unloaded;

  my $package = $self->package;

  no strict 'refs';

  for my $name (grep !/\A[^:]+::\z/, keys %{"${package}::"}) {
    undef *{"${package}::${name}"}; delete ${"${package}::"}{$name};
  }

  delete $INC{$self->format('path', '%s.pm')};

  return $self;
}

sub rebase {
  my ($self, @args) = @_;

  my $class = $self->class;

  my $path = join '/', map $class->new($_)->path, @args;

  return $class->new($self->basename)->prepend($path);
}

sub reload {
  my ($self) = @_;

  $self->unload;

  return $self->load;
}

sub require {
  my ($self, $target) = @_;

  $target = "'$target'" if -f $target;

  return $self->eval("require $target");
}

sub root {
  my ($self) = @_;

  return $self->parse->[0];
}

sub routine {
  my ($self, $name, $code) = @_;

  no strict 'refs';

  my $class = $self->package;

  no warnings 'redefine';

  *{"${class}::${name}"} = $code if $code;

  return *{"${class}::${name}"}{"CODE"};
}

sub routines {
  my ($self) = @_;

  no strict 'refs';

  my $class = $self->package;

  return [
    sort grep *{"${class}::$_"}{"CODE"},
    grep /^[_a-zA-Z]\w*$/, keys %{"${class}::"}
  ];
}

sub scalar {
  my ($self, $name, @data) = @_;

  no strict 'refs';

  my $class = $self->package;

  no warnings 'once';

  ${"${class}::${name}"} = $data[0] if @data;

  return ${"${class}::${name}"};
}

sub scalars {
  my ($self) = @_;

  no strict 'refs';

  my $class = $self->package;

  return [
    sort grep defined ${"${class}::$_"},
    grep /^[_a-zA-Z]\w*$/, keys %{"${class}::"}
  ];
}

sub sibling {
  my ($self, @args) = @_;

  return $self->parent->append(@args);
}

sub siblings {
  my ($self) = @_;

  my %list;
  my $path;
  my $type;

  $path = quotemeta $self->parent->path;
  $type = 'pm';

  my $regexp = qr/$path\/[^\/]+\.$type/;

  for my $item (keys %INC) {
    $list{$item}++ if $item =~ /$regexp$/;
  }

  my %seen;

  for my $dir (@INC) {
    next if $seen{$dir}++;

    my $re = quotemeta $dir;
    map { s/^$re\///; $list{$_}++ }
    grep !$list{$_}, glob "$dir/@{[$self->path]}/*.$type";
  }

  my $class = $self->class;

  return [
    map $class->new($_),
    map {s/(.*)\.$type$/$1/r}
    sort keys %list
  ];
}

sub splice {
  my ($self, $offset, $length, @list) = @_;

  my $class = $self->class;
  my $parts = $self->parts;

  if (@list) {
    CORE::splice(@{$parts}, $offset, $length, @list);
  }
  elsif (defined $length) {
    CORE::splice(@{$parts}, $offset, $length);
  }
  elsif (defined $offset) {
    CORE::splice(@{$parts}, $offset);
  }

  return $class->new(join '/', @$parts);
}

sub swap {
  my ($self, $name, $code) = @_;

  my $orig = (my $package = $self->package)->can($name);

  return $orig if !$code;

  if (!$orig) {
    $self->error_on_swap({package => $package, routine => $name})->throw;
  }

  $self->routine($name, sub {$code->($orig, @_)});

  return $orig;
}

sub tfile {
  my ($self) = @_;

  return $self->format('label', '%s.t');
}

sub tryload {
  my ($self) = @_;

  return do { local $@; eval { $self->load }; int!$@ };
}

sub use {
  my ($self, $target, @params) = @_;

  my $version;

  ($target, $version) = @$target if ref $target eq 'ARRAY';

  $self->require($target);

  require Scalar::Util;

  my @statement = (
    'no strict "subs";',
    (
      Scalar::Util::looks_like_number($version)
        ? "${target}->VERSION($version);" : ()
    ),
    'sub{ my ($target, @params) = @_; $target->import(@params)}'
  );

  $self->eval(join("\n", @statement))->($target, @params);

  return $self;
}

sub variables {
  my ($self) = @_;

  return [map [$_, [sort @{$self->$_}]], qw(arrays hashes scalars)];
}

sub version {
  my ($self) = @_;

  return $self->scalar('VERSION');
}

sub unload {
  my ($self) = @_;

  return $self if $self->unloaded;

  my $package = $self->package;

  no strict 'refs';

  for my $name (grep !/\A[^:]+::\z/, keys %{"${package}::"}) {
    undef *{"${package}::${name}"};
  }

  delete $INC{$self->format('path', '%s.pm')};

  return $self;
}

sub unloaded {
  my ($self) = @_;

  return $self->loaded ? false : true;
}

sub unpatch {
  my ($self, @names) = @_;

  my $patched = $self->{'$patched'} ||= {};

  @names = keys %{$patched} if !@names;

  for my $name (@names) {
    my $orig = delete $patched->{$name} or next;
    $self->routine($name, $orig);
  }

  delete $self->{'$patched'} if !keys %{$patched};

  return $self;
}

sub visible {
  my ($self) = @_;

  no strict 'refs';

  my $package = $self->package;

  return (grep !/\A[^:]+::\z/, keys %{"${package}::"}) ? true : false;
}

# ERRORS

sub error_on_call_missing {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Unable to locate class method "{{routine}}" via package "{{package}}"';

  $error->name('on.call.missing');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_call_undefined {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ' ', 'Attempt to call undefined class method',
    'in package "{{package}}"';

  $error->name('on.call.undefined');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_cop_missing {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ' ', 'Unable to locate object method "{{routine}}"',
    'via package "{{package}}"';

  $error->name('on.cop.missing');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_cop_undefined {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ' ', 'Attempt to cop undefined object method',
    'from package "{{package}}"';

  $error->name('on.cop.undefined');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_eval {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = $data->{error};

  $error->name('on.eval');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_load {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Error attempting to load {{package}}: "{{error}}"';

  $error->name('on.load');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_swap {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Attempt to swap undefined subroutine in package "{{package}}"';

  $error->name('on.swap');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

1;
