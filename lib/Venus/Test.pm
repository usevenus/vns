package Venus::Test;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus 'fault';

use Venus::Class 'attr', 'base', 'with';

# INHERITS

base 'Venus::Kind';

# INTEGRATES

with 'Venus::Role::Buildable';
with 'Venus::Role::Encaseable';

# REQUIRES

require Test::More;

# STATE

our @EXPORT = ('false', 'test', 'true');

# CONFIG

our $CONFIG = {
  block => {
    abstract => {
      find => {
        list => undef,
        name => 'abstract'
      },
      render => {
        index => 2,
        section => undef
      },
      required => true,
    },
    attribute => {
      find => {
        list => 'attribute',
        name => undef
      },
      render => {
        index => 6,
        section => 'attributes'
      },
      required => false,
    },
    attributes => {
      find => {
        list => undef,
        name => 'attributes'
      },
      render => {
        index => 6,
        section => undef
      },
      required => false,
    },
    authors => {
      find => {
        list => undef,
        name => 'authors'
      },
      render => {
        index => 17,
        section => undef
      },
      required => false,
    },
    description => {
      find => {
        list => undef,
        name => 'description'
      },
      render => {
        index => 5,
        section => undef
      },
      required => true,
    },
    encoding => {
      find => {
        list => undef,
        name => 'encoding'
      },
      render => {
        index => 0,
        section => undef
      },
      required => false,
    },
    error => {
      find => {
        list => 'error',
        name => undef
      },
      render => {
        index => 14,
        section => 'errors'
      },
      required => false,
    },
    example => {
      find => {
        list => 'example',
        name => undef
      },
      render => {
        index => undef,
        section => undef
      },
      required => false,
    },
    feature => {
      find => {
        list => 'feature',
        name => undef
      },
      render => {
        index => 13,
        section => 'features'
      },
      required => false,
    },
    function => {
      find => {
        list => 'function',
        name => undef
      },
      render => {
        index => 10,
        section => 'functions'
      },
      required => false,
    },
    includes => {
      find => {
        list => undef,
        name => 'includes'
      },
      render => {
        index => undef,
        section => undef
      },
      required => false,
    },
    inherits => {
      find => {
        list => undef,
        name => 'inherits'
      },
      render => {
        index => 7,
        section => undef
      },
      required => false,
    },
    integrates => {
      find => {
        list => undef,
        name => 'integrates'
      },
      render => {
        index => 8,
        section => undef
      },
      required => false,
    },
    layout => {
      find => {
        list => undef,
        name => 'layout'
      },
      render => {
        index => undef,
        section => undef
      },
      required => false,
    },
    libraries => {
      find => {
        list => undef,
        name => 'libraries'
      },
      render => {
        index => 9,
        section => undef
      },
      required => false,
    },
    license => {
      find => {
        list => undef,
        name => 'license'
      },
      render => {
        index => 18,
        section => undef
      },
      required => false,
    },
    message => {
      find => {
        list => 'message',
        name => undef
      },
      render => {
        index => 12,
        section => 'messages'
      },
      required => false,
    },
    metadata => {
      find => {
        list => 'metadata',
        name => undef
      },
      render => {
        index => undef,
        section => undef
      },
      required => false,
    },
    method => {
      find => {
        list => 'method',
        name => undef
      },
      render => {
        index => 11,
        section => 'methods'
      },
      required => false,
    },
    name => {
      find => {
        list => undef,
        name => 'name'
      },
      render => {
        index => 1,
        section => undef
      },
      required => true,
    },
    operator => {
      find => {
        list => 'operator',
        name => undef
      },
      render => {
        index => 15,
        section => 'operators'
      },
      required => false,
    },
    partials => {
      find => {
        list => undef,
        name => 'partials'
      },
      render => {
        index => 16,
        section => undef
      },
      required => false,
    },
    project => {
      find => {
        list => undef,
        name => 'project'
      },
      render => {
        index => 19,
        section => undef
      },
      required => false,
    },
    raise => {
      find => {
        list => 'raise',
        name => undef
      },
      render => {
        index => undef,
        section => undef
      },
      required => false,
    },
    signature => {
      find => {
        list => 'signature',
        name => undef
      },
      render => {
        index => undef,
        section => undef
      },
      required => false,
    },
    synopsis => {
      find => {
        list => undef,
        name => 'synopsis'
      },
      render => {
        index => 4,
        section => undef
      },
      required => true,
    },
    tagline => {
      find => {
        list => undef,
        name => 'tagline'
      },
      render => {
        index => undef,
        section => undef
      },
      required => true,
    },
    version => {
      find => {
        list => undef,
        name => 'version'
      },
      render => {
        index => 3,
        section => undef
      },
      required => false,
    },
  },
};

# ATTRIBUTES

attr 'file';

# BUILDERS

sub build_arg {
  my ($self, $data) = @_;

  return {
    file => $data,
  };
}

sub build_self {
  my ($self, $data) = @_;

  return $self if !$self->file;

  for my $name (grep {$CONFIG->{block}->{$_}->{required}} keys %{$CONFIG->{block}}) {
    if (!$self->text->count({name => $name, list => undef})) {
      $self->error_on_new({file => $self->file, block => $name})->throw;
    }
  }

  return $self;
}

# FUNCTIONS

sub test {

  return Venus::Test->new($_[0]);
}

# METHODS

sub auto {
  my ($self, $name, @args) = @_;

  return if !$name;

  my $NAME = uc "venus_test_auto_${name}";

  return $ENV{$NAME} if !@args;

  return ($ENV{$NAME}) = @args;
}

sub diag {
  my ($self, @args) = @_;

  return $self->handler('diag', $self->explain(@args));
}

sub done {
  my ($self) = @_;

  $self->render if $self->auto('render') && !$self->encased('rendered');

  return $self->handler('done_testing');
}

sub eval {
  my ($self, $perl) = @_;

  local $@;

  my @result = CORE::eval(join("\n\n", "no warnings q(redefine);", $perl));

  my $dollarat = $@;

  die $dollarat if $dollarat;

  return wantarray ? (@result) : $result[0];
}

sub explain {
  my ($self, @args) = @_;

  return join ' ',
    map {s/^\s+|\s+$//gr} map {$self->more('explain', $_)} grep {defined} @args;
}

sub fail {
  my ($self, $bool,  @args) = @_;

  my $result = $self->handler('ok', !$bool, @args);

  return $result;
}

sub for {
  my ($self, $type, @args) = @_;

  my $code = ref $args[-1] eq 'CODE' ? pop @args : undef;

  my $name = join ' ', grep {!ref $_} $type, @args;

  $self->subtest($name, sub {$self->execute($type, @args, $code)});

  return $self;
}

sub gate {
  my ($self, $note, $code) = @_;

  my $test = $self->renew;

  $test->recase('gate', [$note, $code]);

  return $test;
}

sub handler {
  my ($self, $name, @args) = @_;

  my $found = 0;
  my $level = 0;

  while (my @caller = caller($level)) {
    $level++;
    $found++ && last if $caller[1] =~ qr{@{[quotemeta($self->file)]}$};
  }

  local $Test::Builder::Level = $found ? $level + 1 : $Test::Builder::Level + $level;

  my @return;

  if (wantarray) {
    @return = Test::More->can($name)->(@args);
  }
  else {
    $return[0] = Test::More->can($name)->(@args);
  }

  # whitelist methods
  state $test_more_functions = {
    BAIL_OUT => 'BAIL_OUT',
    done_testing => 'done_testing',
    plan => 'plan',
    skip => 'skip',
  };
  $self->BAIL_OUT
    if (!@return || (@return == 1 && !$return[0]))
    && $self->auto('bailout')
    && !$test_more_functions->{$name};

  return wantarray ? @return : defined(wantarray) ? $return[0] : ();
}

sub in {
  my ($self, $this, $that, @args) = @_;

  return $self->pass(Venus::in($this, $that), @args);
}

sub is {
  my ($self, $data, @args) = @_;

  my $result = $self->handler('is', scalar($data), @args);

  return $result;
}

sub is_arrayref {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_arrayref($data), @args);
}

sub is_blessed {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_blessed($data), @args);
}

sub is_boolean {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_boolean($data), @args);
}

sub is_coderef {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_coderef($data), @args);
}

sub is_dirhandle {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_dirhandle($data), @args);
}

sub is_enum {
  my ($self, $data, $items, @args) = @_;

  return $self->pass(Venus::is_enum($data, Venus::list($items)), @args);
}

sub is_error {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_error($data), @args);
}

sub is_false {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_false($data), @args);
}

sub is_fault {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_fault($data), @args);
}

sub is_filehandle {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_filehandle($data), @args);
}

sub is_float {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_float($data), @args);
}

sub is_glob {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_glob($data), @args);
}

sub is_hashref {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_hashref($data), @args);
}

sub is_number {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_number($data), @args);
}

sub is_object {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_object($data), @args);
}

sub is_package {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_package($data), @args);
}

sub is_reference {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_reference($data), @args);
}

sub is_regexp {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_regexp($data), @args);
}

sub is_scalarref {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_scalarref($data), @args);
}

sub is_string {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_string($data), @args);
}

sub is_true {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_true($data), @args);
}

sub is_undef {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_undef($data), @args);
}

sub is_value {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_value($data), @args);
}

sub is_yesno {
  my ($self, $data, @args) = @_;

  return $self->pass(Venus::is_yesno($data), @args);
}

sub isnt {
  my ($self, $data, @args) = @_;

  my $result = $self->handler('isnt', scalar($data), @args);

  return $result;
}

sub isnt_arrayref {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_arrayref($data), @args);
}

sub isnt_blessed {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_blessed($data), @args);
}

sub isnt_boolean {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_boolean($data), @args);
}

sub isnt_coderef {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_coderef($data), @args);
}

sub isnt_dirhandle {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_dirhandle($data), @args);
}

sub isnt_enum {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_enum($data), @args);
}

sub isnt_error {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_error($data), @args);
}

sub isnt_false {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_false($data), @args);
}

sub isnt_fault {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_fault($data), @args);
}

sub isnt_filehandle {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_filehandle($data), @args);
}

sub isnt_float {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_float($data), @args);
}

sub isnt_glob {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_glob($data), @args);
}

sub isnt_hashref {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_hashref($data), @args);
}

sub isnt_number {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_number($data), @args);
}

sub isnt_object {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_object($data), @args);
}

sub isnt_package {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_package($data), @args);
}

sub isnt_reference {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_reference($data), @args);
}

sub isnt_regexp {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_regexp($data), @args);
}

sub isnt_scalarref {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_scalarref($data), @args);
}

sub isnt_string {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_string($data), @args);
}

sub isnt_true {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_true($data), @args);
}

sub isnt_undef {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_undef($data), @args);
}

sub isnt_value {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_value($data), @args);
}

sub isnt_yesno {
  my ($self, $data, @args) = @_;

  return $self->fail(Venus::is_yesno($data), @args);
}

sub lfile {
  my ($self) = @_;

  my $lfile = $self->space->format('lfile', 'lib/%s');

  return $lfile;
}

sub like {
  my ($self, $this, $that, @args) = @_;

  $that = qr/$that/ if ref $that ne 'Regexp';

  my $result = $self->handler('like', $this, $that, @args);

  return $result;
}

sub mktemp_dir {
  my ($self) = @_;

  my $path = $self->path;

  return $path->mktemp_dir;
}

sub mktemp_file {
  my ($self) = @_;

  my $path = $self->path;

  return $path->mktemp_file;
}

sub note {
  my ($self, @args) = @_;

  $self->handler('diag', $self->explain(@args));

  return;
}

sub only_if {
  my ($self, $what, @args) = @_;

  local $_ = $self;

  return $self->gate(
    (join ' ', 'only_if', grep {!ref} $what), sub {$self->$what(@args) ? true : false}
  );
}

sub os {
  my ($self) = @_;

  my $os;

  require Venus::Os;

  $os = $self->encased('os');

  return $os if $os;

  $os = Venus::Os->new;

  return $self->recase('os', $os);
}

sub os_is_bsd {
  my ($self) = @_;

  return $self->os->is_bsd;
}

sub os_is_cyg {
  my ($self) = @_;

  return $self->os->is_cyg;
}

sub os_is_dos {
  my ($self) = @_;

  return $self->os->is_dos;
}

sub os_is_lin {
  my ($self) = @_;

  return $self->os->is_lin;
}

sub os_is_mac {
  my ($self) = @_;

  return $self->os->is_mac;
}

sub os_is_non {
  my ($self) = @_;

  return $self->os->is_non;
}

sub os_is_sun {
  my ($self) = @_;

  return $self->os->is_sun;
}

sub os_is_vms {
  my ($self) = @_;

  return $self->os->is_vms;
}

sub os_is_win {
  my ($self) = @_;

  return $self->os->is_win;
}

sub os_isnt_bsd {
  my ($self) = @_;

  return $self->os->is_bsd ? false : true;
}

sub os_isnt_cyg {
  my ($self) = @_;

  return $self->os->is_cyg ? false : true;
}

sub os_isnt_dos {
  my ($self) = @_;

  return $self->os->is_dos ? false : true;
}

sub os_isnt_lin {
  my ($self) = @_;

  return $self->os->is_lin ? false : true;
}

sub os_isnt_mac {
  my ($self) = @_;

  return $self->os->is_mac ? false : true;
}

sub os_isnt_non {
  my ($self) = @_;

  return $self->os->is_non ? false : true;
}

sub os_isnt_sun {
  my ($self) = @_;

  return $self->os->is_sun ? false : true;
}

sub os_isnt_vms {
  my ($self) = @_;

  return $self->os->is_vms ? false : true;
}

sub os_isnt_win {
  my ($self) = @_;

  return $self->os->is_win ? false : true;
}

sub pass {
  my ($self, $bool,  @args) = @_;

  my $result = $self->handler('ok', $bool, @args);

  return $result;
}

sub patch {
  my ($self, $name, $code) = @_;

  my $space = $self->space;

  $space->patch($name, $code);

  my $patched = $space->{patched}->{$name};

  return $patched;
}

sub path {
  my ($self, $file) = @_;

  $file ||= $self->file;

  require Venus::Path;

  return Venus::Path->new($file);
}

sub pfile {
  my ($self) = @_;

  my $pfile = $self->space->format('pfile', 'lib/%s');

  return $pfile;
}

sub render {
  my ($self, $file) = @_;

  $file ||= $self->pfile;

  require Venus::Path;

  my $path = Venus::Path->new($file);

  $path->parent->mkdirs;

  my @layout = split /\r?\n/, join "\n\n", $self->collect('layout');

  my @output;

  for my $item (grep {length} @layout) {
    push @output, grep {length} $self->present(split /:\s*/, $item);
  }

  $path->write(join "\n", @output);

  $self->recase('rendered', true);

  return $path;
}

sub same {
  my ($self, $this, $that, @args) = @_;

  my $result = $self->handler('is_deeply', $this, $that, @args);

  return $result;
}

sub skip {
  my ($self, $note) = @_;

  return $self->handler('plan', 'skip_all', $note);
}

sub skip_if {
  my ($self, $what, @args) = @_;

  local $_ = $self;

  return $self->gate(
    (join ' ', 'skip_if', grep {!ref} $what), sub {$self->$what(@args) ? false : true}
  );
}

sub space {
  my ($self, $name) = @_;

  my $space;

  require Venus::Space;

  $space = Venus::Space->new($name) if $name;

  return $space if $name;

  $space = $self->encased('space');

  return $space if $space;

  $space = Venus::Space->new($self->collect('name'));

  return $self->recase('space', $space);
}

sub subtest {
  my ($self, $name, $code) = @_;

  my $gate = $self->encased('gate');

  my $callback = !$gate ? $code : sub {
    ($gate->[1] && $gate->[1]->()) ? $code->() : $self->skip($gate->[0]);
  };

  my $result = $self->handler('subtest', $name, $callback);

  $self->unpatch if $self->auto('unpatch');

  return $result;
}

sub text {
  my ($self) = @_;

  my $text;

  $text = $self->encased('text');

  return $text if $text;

  require Venus::Text::Pod;

  $text = Venus::Text::Pod->new($self->file);

  return $self->recase('text', $text);
}

sub tfile {
  my ($self) = @_;

  my $tfile = $self->space->format('tfile', 't/%s');

  return $tfile;
}

sub type {
  my ($self, $data, $expr, @args) = @_;

  require Venus::Type;

  my $type = Venus::Type->new;

  return $self->pass($type->check($expr)->eval($data), @args);
}

sub unlike {
  my ($self, $this, $that, @args) = @_;

  $that = qr/$that/ if ref $that ne 'Regexp';

  my $result = $self->handler('unlike', $this, $that, @args);

  return $result;
}

sub unpatch {
  my ($self, @args) = @_;

  my $space = $self->space;

  return $space->unpatch(@args);
}

# COMPATIBILITY

*data = *text; # deprecated since 4.15
*more = *handler; # deprecated since 4.15
*okay = *pass; # deprecated since 4.15

# ERRORS

sub error_on_missing {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Can\'t locate object method "{{method}}" via package "{{class}}"';

  $error->name('on.missing');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_new {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Test file "{{file}}" missing {{block}} block';

  $error->name('on.new');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

# AUTOLOAD

sub AUTOLOAD {
  my ($self, @args) = @_;

  our $AUTOLOAD;
  my $method = $AUTOLOAD =~ s/.*:://r;

  # Handle collect method
  if ($method eq 'collect' && @args) {
    my ($name) = shift @args;
    $method = "collect_data_for_${name}";
    return $self->$method(@args) if $self->can($method);
  }

  # Handle collect_data_for_* methods using config
  if (my ($block) = $method =~ /^collect_data_for_(\w+)$/) {
    if ($method eq 'collect_data_for_layout') {
      my ($find) = $self->data->find(undef, 'layout');

      my $data = $find ? $find->{data} : [
        'encoding',
        'name',
        'abstract',
        'version',
        'synopsis',
        'description',
        'attributes: attribute',
        'inherits',
        'integrates',
        'libraries',
        'functions: function',
        'methods: method',
        'messages: message',
        'features: feature',
        'errors: error',
        'operators: operator',
        'partials',
        'authors',
        'license',
        'project',
      ];

      return wantarray ? (@{$data}) : $data;
    }
    elsif ($method eq 'collect_data_for_version') {
      my ($find) = $self->data->find(undef, 'version');

      my $data = $find ? $find->{data} : [];

      require Venus::Space;

      if (!@{$data} && (my ($name) = $self->collect('name'))) {
        @{$data} = (Venus::Space->new($name)->version) || ();
      }

      return wantarray ? (@{$data}) : $data;
    }
    elsif (my $config = $CONFIG->{block}{$block}) {
      my $find_spec = $config->{find};
      my ($list, $name) = @{$find_spec}{qw(list name)};

      if ($block eq 'example' && @args == 2) {
        my ($number, $arg_name) = @args;
        my ($find) = $self->text->find("example-$number", $arg_name);
        my $data = $find ? $find->{data} : [];
        return wantarray ? (@{$data}) : $data;
      }

      my ($find) = defined($list)
        ? $self->text->find($list, @args ? $args[0] : undef)
        : $self->text->find(undef, $name);

      my $data = $find ? $find->{data} : [];

      # special-case: encoding
      if ($block eq 'encoding') {
        @{$data} = (map {map uc, split /\r?\n+/} @{$data});
      }

      # special-case: includes
      if ($block eq 'includes') {
        @{$data} = grep !/^#/, grep /\w/, map {split/\n/} @{$data};
      }

      return wantarray ? (@{$data}) : $data;
    }
  }

  # Handle execute method
  if ($method eq 'execute' && @args) {
    my ($name) = shift @args;
    $method = "execute_test_for_${name}";
    return $self->$method(@args) if $self->can($method);
  }

  # Handle execute_test_for_* methods using config
  if (my ($block) = $method =~ /^execute_test_for_(\w+)$/) {
    if ($method eq 'execute_test_for_attributes') {
      my ($code) = @args;
      my $data = $self->collect('attributes');
      my $result = $self->perform('attributes', $data);
      $result = $code->($data) if $code;
      $self->pass($result, '=attributes');
      my ($package) = $self->collect('name');
      for my $line (@{$data}) {
        next if !$line;
        my ($name, $is, $pre, $isa, $def) = map { split /,\s*/ } split /:\s*/,
          $line, 2;
        $self->pass($package->can($name), "$package has $name");
        $self->pass((($is eq 'ro' || $is eq 'rw')
            && ($pre eq 'opt' || $pre eq 'req')
            && $isa), $line);
      }
      return $result;
    }
    elsif ($method eq 'execute_test_for_example') {
      my ($number, $name, $code) = @args;
      my $data = $self->collect('example', $number, $name);
      my $text = join "\n\n", @{$data};
      my @includes;
      if ($text =~ /.*#\s*given:\s*synopsis/m) {
        my $line = $&;
        if ($line !~ /#.*#\s*given:\s*synopsis/) {
          push @includes, $self->collect('synopsis');
        }
      }
      for my $given ($text =~ /.*#\s*given:\s*example-((?:\d+)\s+(?:[\-\w]+))/gm) {
        my $line = $&;
        if ($line !~ /#.*#\s*given:\s*example-(?:\d+)\s+(?:[\-\w]+)/) {
          my ($number, $name) = split /\s+/, $given, 2;
          push @includes, $self->collect('example', $number, $name);
        }
      }
      $text =~ s/.*#\s*given:\s*.*\n\n*//g;
      $text = join "\n\n", @includes, $text;
      my $result = $self->perform('example', $number, $name, $data);
      $self->pass($result, "=example-$number $name");
      $result = $code->($self->try('eval', $text)) if $code;
      $self->pass($result, "=example-$number $name returns ok") if $code;
      if ($self->auto('scrub')) {
        state $name = $self->text->string(undef, 'name');
        for my $package ($text =~ /package\W+([\w:]+)/g) {
          next if $package eq 'main';
          next if $package eq __PACKAGE__;
          next if $package eq $name;
          $self->space($package)->scrub;
        }
      }
      return $result;
    }
    elsif ($method eq 'execute_test_for_raise') {
      my ($site, $class, $name, $code) = @args;
      my $data = do {
        my ($find) = $self->text->find($block, "$site $class $name");
        $find ? $find->{data} : [];
      };
      my $text = join "\n\n", @{$data};
      my @includes;
      if ($text =~ /.*#\s*given:\s*synopsis/m) {
        my $line = $&;
        if ($line !~ /#.*#\s*given:\s*synopsis/) {
          push @includes, $self->collect('synopsis');
        }
      }
      for my $given ($text =~ /.*#\s*given:\s*example-((?:\d+)\s+(?:[\-\w]+))/gm) {
        my $line = $&;
        if ($line !~ /#.*#\s*given:\s*example-(?:\d+)\s+(?:[\-\w]+)/) {
          my ($number, $name) = split /\s+/, $given, 2;
          push @includes, $self->collect('example', $number, $name);
        }
      }
      $text =~ s/.*#\s*given:\s*.*\n\n*//g;
      $text = join "\n\n", @includes, $text;
      my $handle = join ' ', grep defined, $site, $class, $name;
      my $result = $self->perform('raise', $handle, $data);
      $self->pass($result, "=$handle");
      $result = $code->($self->try('eval', $text)) if $code;
      $self->pass($result, "=error $site $class $name returns ok") if $code;
      if ($self->auto('scrub')) {
        state $name = $self->text->string(undef, 'name');
        for my $package ($text =~ /package\W+([\w:]+)/g) {
          next if $package eq 'main';
          next if $package eq __PACKAGE__;
          next if $package eq $name;
          $self->space($package)->scrub;
        }
      }
      return $result;
    }
    elsif ($method eq 'execute_test_for_synopsis') {
      my ($code) = @args;
      my $data = $self->collect('synopsis');
      my $text = join "\n\n", @{$data};
      my @includes;
      for my $given ($text =~ /.*#\s*given:\s*example-((?:\d+)\s+(?:[\-\w]+))/gm) {
        my $line = $&;
        if ($line !~ /#.*#\s*given:\s*example-(?:\d+)\s+(?:[\-\w]+)/) {
          my ($number, $name) = split /\s+/, $given, 2;
          push @includes, $self->collect('example', $number, $name);
        }
      }
      $text =~ s/.*#\s*given:\s*.*\n\n*//g;
      $text = join "\n\n", @includes, $text;
      my $result = $self->perform('synopsis', $data);
      $self->pass($result, "=synopsis");
      $result = $code->($self->try('eval', $text)) if $code;
      $self->pass($result, "=synopsis returns ok") if $code;
      if ($self->auto('scrub')) {
        state $name = $self->text->string(undef, 'name');
        for my $package ($text =~ /package\W+([\w:]+)/g) {
          next if $package eq 'main';
          next if $package eq __PACKAGE__;
          next if $package eq $name;
          $self->space($package)->scrub;
        }
      }
      return $result;
    }
    elsif ($method eq 'execute_test_for_name') {
      my ($code) = @args;
      my ($text) = $self->collect_data_for_name;
      my $result = length($text) ? true : false;
      $self->pass($result, '=name content');
      $self->pass(scalar(eval("require $text")), "require $text");
      return $result;
    }
    elsif (my $config = $CONFIG->{block}{$block}) {
      my $find_spec = $config->{find};
      my ($list, $name) = @{$find_spec}{qw(list name)};

      my $code = ref($args[-1]) eq 'CODE' ? pop(@args) : undef;
      my $collect = "collect_data_for_$block";
      my $data = $self->$collect(@args);
      my $perform = "perform_test_for_$block";

      my $result = $code
        ? $code->(defined $list ? ($block, $data) : $data)
        : $self->$perform(defined $list ? ($block, $data) : $data);

      $self->pass($result, "=$block");

      return $result;
    }
  }

  # Handle perform method
  if ($method eq 'perform' && @args) {
    my ($name) = shift @args;
    $method = "perform_test_for_${name}";
    return $self->$method(@args) if $self->can($method);
  }

  # Handle perform_test_for_* methods using config
  if (my ($block) = $method =~ /^perform_test_for_(\w+)$/) {
    if ($method eq 'perform_test_for_example') {
      my ($number, $name, $data) = @args;
      my $result = length(join "\n", @{$data}) ? true : false;
      $self->pass($result, "=example-$number $name content");
      return $result;
    }
    elsif ($method eq 'perform_test_for_name') {
      my ($data) = @args;
      my $text = join "\n", @{$data};
      my $result = length($text) ? true : false;
      $self->pass($result, '=name content');
      $self->pass(scalar(eval("require $text")), $self->explain('require', $text));
      return $result;
    }
    elsif (my $config = $CONFIG->{block}{$block}) {
      my $find_spec = $config->{find};
      my $list = $find_spec->{list};
      my ($name, $data) = defined $list ? @args : (undef, $args[0]);
      my $result = length(join "\n", @{$data}) ? true : false;
      $self->pass($result, defined $list ? "=$block $name content" : "=$block content");
      return $result;
    }
  }

  # Handle present method
  if ($method eq 'present' && @args) {
    my ($name) = shift @args;
    $method = "present_data_for_${name}";
    return $self->$method(@args) if $self->can($method);
  }

  # Handle present_data_for_* methods using config
  if (my ($block) = $method =~ /^present_data_for_(\w+)$/) {
    # special-case: present_data_for_abstract
    if ($method eq 'present_data_for_abstract') {
      my @data = $self->collect('abstract');
      return @data ? ($self->present_data_for_head1('abstract', @data)) : ();
    }
    # special-case: present_data_for_attribute
    elsif ($method eq 'present_data_for_attribute') {
      my ($name) = @args;
      return $self->present_data_for_attribute_type2($name);
    }
    # special-case: present_data_for_attribute_type1
    elsif ($method eq 'present_data_for_attribute_type1') {
      my ($name, $is, $pre, $isa, $def) = @args;
      my @output;
      $is = $is eq 'ro' ? 'read-only' : 'read-write';
      $pre = $pre eq 'req' ? 'required' : 'optional';
      push @output, "  $name($isa)\n";
      push @output, "This attribute is $is, accepts C<($isa)> values, ". (
        $def ? "is $pre, and defaults to $def." : "and is $pre."
      );
      return ($self->present_data_for_head2($name, @output));
    }
    # special-case: present_data_for_attribute_type2
    elsif ($method eq 'present_data_for_attribute_type2') {
      my ($name) = @args;
      my @output;
      my ($metadata) = $self->collect('metadata', $name);
      my ($signature) = $self->collect('signature', $name);
      push @output, ($signature, '') if $signature;
      my @data = $self->collect('attribute', $name);
      return () if !@data;
      push @output, join "\n\n", @data;
      if ($metadata) {
        local $@;
        my $perlcode = do{no warnings; eval $metadata};
        if ($metadata = ($perlcode && ref $perlcode) ? $perlcode : $metadata) {
          if (ref $metadata ne 'HASH') {
            my @debug_data = (map {split /:\s*/} split /\n+/, $metadata);
            $metadata = {map {split /:\s*/} split /\n+/, $metadata};
          }
          my @lifespan;
          if (my $introduced = $metadata->{introduced}) {
            push @lifespan, "I<Introduced C<$introduced>>";
          }
          if (my $deprecated = $metadata->{deprecated}) {
            push @lifespan, "I<Deprecated C<$deprecated>>";
          }
          if (my $since = $metadata->{since}) {
            @lifespan = ("I<Since C<$since>>");
          }
          push @output, "", join(", ", @lifespan) if @lifespan;
        }
      }
      my @results = $self->data->search({name => $name});
      for my $i (1..(int grep {($$_{list} || '') =~ /^example-\d+/} @results)) {
        push @output, join "\n\n", $self->present('example', $i, $name);
      }
      pop @output if $output[-1] eq '';
      return ($self->present_data_for_head2($name, @output));
    }
    # special-case: present_data_for_attributes
    elsif ($method eq 'present_data_for_attributes') {
      my $method = $self->data->count({list => undef, name => 'attributes'})
        ? 'attributes_type1'
        : 'attributes_type2';
      return $self->present($method, @args);
    }
    # special-case: present_data_for_attributes_type1
    elsif ($method eq 'present_data_for_attributes_type1') {
      my @output;
      my @data = $self->collect('attributes');
      return () if !@data;
      for my $line (split /\r?\n/, join "\n", @data) {
        push @output, $self->present('attribute_type1', (
          map {split /,\s*/} split /:\s*/, $line, 2
        ));
      }
      return () if !@output;
      if (@output) {
        unshift @output,
          $self->present_data_for_head1('attributes',
            $self->text->string('header', 'attributes') ||
          'This package has the following attributes:');
      }
      return join "\n", @output;
    }
    # special-case: present_data_for_attributes_type2
    elsif ($method eq 'present_data_for_attributes_type2') {
      my @output;
      for my $list ($self->data->search({list => 'attribute'})) {
        push @output, $self->present('attribute_type2', $list->{name});
      }
      if (@output) {
        unshift @output,
          $self->present_data_for_head1('attributes',
            $self->text->string('header', 'attributes') ||
          'This package has the following attributes:');
      }
      return join "\n", @output;
    }
    # special-case: present_data_for_authors
    elsif ($method eq 'present_data_for_authors') {
      my @data = $self->collect('authors');
      return @data ? ($self->present_data_for_head1('authors', join "\n\n", @data)) : ();
    }
    # special-case: present_data_for_description
    elsif ($method eq 'present_data_for_description') {
      my @data = $self->collect('description');
      return @data ? ($self->present_data_for_head1('description', join "\n\n", @data)) : ();
    }
    # special-case: present_data_for_encoding
    elsif ($method eq 'present_data_for_encoding') {
      my ($name) = $self->collect('encoding');
      return () if !$name;
      return join("\n", "", "=encoding \U$name", "", "=cut");
    }
    # special-case: present_data_for_error
    elsif ($method eq 'present_data_for_error') {
      my ($name) = @args;
      my @output;
      my @data = $self->collect('error', $name);
      return () if !@data;
      my @results = $self->data->search({name => $name});
      for my $i (1..(int grep {($$_{list} || '') =~ /^example-\d+/} @results)) {
        push @output, "B<example $i>", $self->collect('example', $i, $name);
      }
      return (
        $self->present_data_for_over($self->present_data_for_item(
          "error: C<$name>",
          join "\n\n", @data, @output
        ))
      );
    }
    # special-case: present_data_for_errors
    elsif ($method eq 'present_data_for_errors') {
      my @output;
      my $type = 'error';
      for my $name (
        sort map $$_{name},
          $self->data->search({list => $type})
      )
      {
        push @output, $self->present($type, $name);
      }
      if (@output) {
        unshift @output,
          $self->present_data_for_head1('errors',
            $self->text->string('header', 'errors') ||
          'This package may raise the following errors:');
      }
      return join "\n", @output;
    }
    # special-case: present_data_for_example
    elsif ($method eq 'present_data_for_example') {
      my ($number, $name) = @args;
      my @data = $self->collect('example', $number, $name);
      return @data
        ? (
        $self->present_data_for_over($self->present_data_for_item(
          "$name example $number", join "\n\n", @data)))
        : ();
    }
    # special-case: present_data_for_feature
    elsif ($method eq 'present_data_for_feature') {
      my ($name) = @args;
      my @output;
      my ($metadata) = $self->collect('metadata', $name);
      my ($signature) = $self->collect('signature', $name);
      push @output, ($signature, '') if $signature;
      my @data = $self->collect('feature', $name);
      return () if !@data;
      push @output, join "\n\n", @data;
      if ($metadata) {
        local $@;
        my $perlcode = do{no warnings; eval $metadata};
        if ($metadata = ($perlcode && ref $perlcode) ? $perlcode : $metadata) {
          if (ref $metadata ne 'HASH') {
            $metadata = {map {split /:\s*/} split /\n+/, $metadata};
          }
          my @lifespan;
          if (my $introduced = $metadata->{introduced}) {
            push @lifespan, "I<Introduced C<$introduced>>";
          }
          if (my $deprecated = $metadata->{deprecated}) {
            push @lifespan, "I<Deprecated C<$deprecated>>";
          }
          if (my $since = $metadata->{since}) {
            @lifespan = ("I<Since C<$since>>");
          }
          push @output, "", join(", ", @lifespan) if @lifespan;
        }
      }
      my @results = $self->data->search({name => $name});
      for my $i (1..(int grep {($$_{list} || '') =~ /^example-\d+/} @results)) {
        push @output, "B<example $i>", $self->collect('example', $i, $name);
      }
      pop @output if $output[-1] eq '';
      return (
        $self->present_data_for_over($self->present_data_for_item(
          $name, join "\n\n", grep {length} @output))
      );
    }
    # special-case: present_data_for_features
    elsif ($method eq 'present_data_for_features') {
      my @output;
      my $type = 'feature';
      for my $name (
        sort map $$_{name},
          $self->data->search({list => $type})
      )
      {
        push @output, $self->present($type, $name);
      }
      if (@output) {
        unshift @output,
          $self->present_data_for_head1('features',
            $self->text->string('header', 'features') ||
          'This package provides the following features:');
      }
      return join "\n", @output;
    }
    # special-case: present_data_for_function
    elsif ($method eq 'present_data_for_function') {
      my ($name) = @args;
      my @output;
      my ($metadata) = $self->collect('metadata', $name);
      my ($signature) = $self->collect('signature', $name);
      push @output, ($signature, '') if $signature;
      my @data = $self->collect('function', $name);
      return () if !@data;
      push @output, join "\n\n", @data;
      if ($metadata) {
        local $@;
        my $perlcode = do{no warnings; eval $metadata};
        if ($metadata = ($perlcode && ref $perlcode) ? $perlcode : $metadata) {
          if (ref $metadata ne 'HASH') {
            $metadata = {map {split /:\s*/} split /\n+/, $metadata};
          }
          my @lifespan;
          if (my $introduced = $metadata->{introduced}) {
            push @lifespan, "I<Introduced C<$introduced>>";
          }
          if (my $deprecated = $metadata->{deprecated}) {
            push @lifespan, "I<Deprecated C<$deprecated>>";
          }
          if (my $since = $metadata->{since}) {
            @lifespan = ("I<Since C<$since>>");
          }
          push @output, "", join(", ", @lifespan) if @lifespan;
        }
      }
      my @results = $self->data->search({name => $name});
      for my $i (1..(int grep {($$_{list} || '') =~ /^example-\d+/} @results)) {
        push @output, $self->present('example', $i, $name);
      }
      pop @output if $output[-1] eq '';
      return ($self->present_data_for_head2($name, @output));
    }
    # special-case: present_data_for_functions
    elsif ($method eq 'present_data_for_functions') {
      my @output;
      my $type = 'function';
      for my $name (
        sort map /:\s*(\w+)$/,
        grep /^$type/,
        split /\r?\n/,
        join "\n\n", $self->collect('includes')
      )
      {
        push @output, $self->present($type, $name);
      }
      if (@output) {
        unshift @output,
          $self->present_data_for_head1('functions',
            $self->text->string('header', 'functions') ||
          'This package provides the following functions:');
      }
      return join "\n", @output;
    }
    # special-case: present_data_for_head1
    elsif ($method eq 'present_data_for_head1') {
      my ($name, @data) = @args;
      return join("\n", "", "=head1 \U$name", "", grep(defined, @data), "", "=cut");
    }
    # special-case: present_data_for_head2
    elsif ($method eq 'present_data_for_head2') {
      my ($name, @data) = @args;
      return join("\n", "", "=head2 \L$name", "", grep(defined, @data), "", "=cut");
    }
    # special-case: present_data_for_includes
    elsif ($method eq 'present_data_for_includes') {
      return ();
    }
    # special-case: present_data_for_inherits
    elsif ($method eq 'present_data_for_inherits') {
      my @output = map +($self->present_data_for_link($_), ""), grep defined,
        split /\r?\n/, join "\n\n", $self->collect('inherits');
      return () if !@output;
      pop @output;
      return $self->present_data_for_head1('inherits',
        $self->text->string('header', 'inherits') ||
        "This package inherits behaviors from:",
        "",
        @output,
      );
    }
    # special-case: present_data_for_integrates
    elsif ($method eq 'present_data_for_integrates') {
      my @output = map +($self->present_data_for_link($_), ""), grep defined,
        split /\r?\n/, join "\n\n", $self->collect('integrates');
      return () if !@output;
      pop @output;
      return $self->present_data_for_head1('integrates',
        $self->text->string('header', 'integrates') ||
        "This package integrates behaviors from:",
        "",
        @output,
      );
    }
    # special-case: present_data_for_item
    elsif ($method eq 'present_data_for_item') {
      my ($name, $data) = @args;
      return ("=item $name\n", "$data\n");
    }
    # special-case: present_data_for_layout
    elsif ($method eq 'present_data_for_layout') {
      return ();
    }
    # special-case: present_data_for_libraries
    elsif ($method eq 'present_data_for_libraries') {
      my @output = map +($self->present_data_for_link($_), ""), grep defined,
        split /\r?\n/, join "\n\n", $self->collect('libraries');
      return '' if !@output;
      pop @output;
      return $self->present_data_for_head1('libraries',
        $self->text->string('header', 'libraries') ||
        "This package uses type constraints from:",
        "",
        @output,
      );
    }
    # special-case: present_data_for_license
    elsif ($method eq 'present_data_for_license') {
      my @data = $self->collect('license');
      return @data
        ? ($self->present_data_for_head1('license', join "\n\n", @data))
        : ();
    }
    # special-case: present_data_for_link
    elsif ($method eq 'present_data_for_link') {
      return ("L<@{[join('|', @args)]}>");
    }
    # special-case: present_data_for_message
    elsif ($method eq 'present_data_for_message') {
      my ($name) = @args;
      my @output;
      my ($signature) = $self->collect('signature', $name);
      push @output, ($signature, '') if $signature;
      my @data = $self->collect('message', $name);
      return () if !@data;
      my @results = $self->data->search({name => $name});
      for my $i (1..(int grep {($$_{list} || '') =~ /^example-\d+/} @results)) {
        push @output, "B<example $i>", join "\n\n",
          $self->collect('example', $i, $name);
      }
      return (
        $self->present_data_for_over($self->present_data_for_item(
          $name, join "\n\n", @data, @output))
      );
    }
    # special-case: present_data_for_messages
    elsif ($method eq 'present_data_for_messages') {
      my @output;
      my $type = 'message';
      for my $name (
        sort map /:\s*(\w+)$/,
        grep /^$type/,
        split /\r?\n/,
        join "\n\n", $self->collect('includes')
      )
      {
        push @output, $self->present($type, $name);
      }
      if (@output) {
        unshift @output,
          $self->present_data_for_head1('messages',
            $self->text->string('header', 'messages') ||
          'This package provides the following messages:');
      }
      return join "\n", @output;
    }
    # special-case: present_data_for_metadata
    elsif ($method eq 'present_data_for_metadata') {
      return ();
    }
    # special-case: present_data_for_method
    elsif ($method eq 'present_data_for_method') {
      my ($name) = @args;
      my @output;
      my ($metadata) = $self->collect('metadata', $name);
      my ($signature) = $self->collect('signature', $name);
      push @output, ($signature, '') if $signature;
      my @data = $self->collect('method', $name);
      return () if !@data;
      push @output, join "\n\n", @data;
      if ($metadata) {
        local $@;
        my $perlcode = do{no warnings; eval $metadata};
        if ($metadata = ($perlcode && ref $perlcode) ? $perlcode : $metadata) {
          if (ref $metadata ne 'HASH') {
            $metadata = {map {split /:\s*/} split /\n+/, $metadata};
          }
          my @lifespan;
          if (my $introduced = $metadata->{introduced}) {
            push @lifespan, "I<Introduced C<$introduced>>";
          }
          if (my $deprecated = $metadata->{deprecated}) {
            push @lifespan, "I<Deprecated C<$deprecated>>";
          }
          if (my $since = $metadata->{since}) {
            @lifespan = ("I<Since C<$since>>");
          }
          push @output, "", join(", ", @lifespan) if @lifespan;
        }
      }
      my @results = $self->data->search({name => $name});
      for my $i (1..(int grep {($$_{list} || '') =~ /^example-\d+/} @results)) {
        push @output, $self->present('example', $i, $name);
      }
      my @raises = $self->data->search({list => 'raise'});
      for my $raise (grep {$$_{name} =~ /^$name\s/} @raises) {
        my ($sub, $package, $id) = $raise->{name}
          =~ /(\w+)\s+([:\w]*)\s+([\w\.]+)/;
        next unless $sub && $package;
        push @output,
          $self->present_data_for_over(
            $self->present_data_for_item(
              join(" ", "B<may raise> L<$package>", ($id ? "C<$id>" : ())), join("\n\n", @{$raise->{data}})
            ),
          );
      }
      pop @output if $output[-1] eq '';
      return ($self->present_data_for_head2($name, @output));
    }
    # special-case: present_data_for_methods
    elsif ($method eq 'present_data_for_methods') {
      my @output;
      my $type = 'method';
      for my $name (
        sort map /:\s*(\w+)$/,
        grep /^$type/,
        split /\r?\n/,
        join "\n\n", $self->collect('includes')
      )
      {
        push @output, $self->present($type, $name);
      }
      if (@output) {
        unshift @output,
          $self->present_data_for_head1('methods',
            $self->text->string('header', 'methods') ||
          'This package provides the following methods:');
      }
      return join "\n", @output;
    }
    # special-case: present_data_for_name
    elsif ($method eq 'present_data_for_name') {
      my $name = join ' - ', map $self->collect($_), 'name', 'tagline';
      return $name ? ($self->present_data_for_head1('name', $name)) : ();
    }
    # special-case: present_data_for_operator
    elsif ($method eq 'present_data_for_operator') {
      my ($name) = @args;
      my @output;
      my @data = $self->collect('operator', $name);
      return () if !@data;
      my @results = $self->data->search({name => $name});
      for my $i (1..(int grep {($$_{list} || '') =~ /^example-\d+/} @results)) {
        push @output, "B<example $i>", join "\n\n",
          $self->collect('example', $i, $name);
      }
      return (
        $self->present_data_for_over($self->present_data_for_item(
          "operation: C<$name>",
          join "\n\n", @data, @output
        ))
      );
    }
    # special-case: present_data_for_operators
    elsif ($method eq 'present_data_for_operators') {
      my @output;
      my $type = 'operator';
      for my $name (
        sort map $$_{name},
          $self->data->search({list => $type})
      )
      {
        push @output, $self->present($type, $name);
      }
      if (@output) {
        unshift @output,
          $self->present_data_for_head1('operators',
            $self->text->string('header', 'operators') ||
          'This package overloads the following operators:');
      }
      return join "\n", @output;
    }
    # special-case: present_data_for_over
    elsif ($method eq 'present_data_for_over') {
      return join("\n", "", "=over 4", "", grep(defined, @args), "=back");
    }
    # special-case: present_data_for_partial
    elsif ($method eq 'present_data_for_partial') {
      my ($data) = @args;
      my ($file, $method, @args) = @{$data};
      $method = 'present' if lc($method) eq 'pdml';
      my $test = $self->new($file);
      my @output;
      $self->pass((-f $file && (@output = ($test->$method(@args)))),
        "$file: $method: @args");
      return join "\n", @output;
    }
    # special-case: present_data_for_partials
    elsif ($method eq 'present_data_for_partials') {
      my @output;
      push @output, $self->present('partial', $_)
        for map [split /\:\s*/], grep /\w/, grep !/^#/, split /\r?\n/, join "\n\n",
          $self->collect('partials');
      return join "\n", @output;
    }
    # special-case: present_data_for_project
    elsif ($method eq 'present_data_for_project') {
      my @data = $self->collect('project');
      return @data ? ($self->present_data_for_head1('project', join "\n\n", @data)) : ();
    }
    # special-case: present_data_for_signature
    elsif ($method eq 'present_data_for_signature') {
      return ();
    }
    # special-case: present_data_for_synopsis
    elsif ($method eq 'present_data_for_synopsis') {
      my @data = $self->collect('synopsis');
      return @data
        ? ($self->present_data_for_head1('synopsis', join "\n\n", @data))
        : ();
    }
    # special-case: present_data_for_tagline
    elsif ($method eq 'present_data_for_tagline') {
      my @data = $self->collect('tagline');
      return @data
        ? ($self->present_data_for_head1('tagline', join "\n\n", @data))
        : ();
    }
    # special-case: present_data_for_version
    elsif ($method eq 'present_data_for_version') {
      my @data = $self->collect('version');
      return @data
        ? ($self->present_data_for_head1('version', join "\n\n", @data))
        : ();
    }
    else {
      my ($name) = @args;
      my @output;
      for my $item (
        sort map $$_{name},
          $self->data->search({list => $name})
      )
      {
        my @iteration;
        my ($metadata) = $self->collect('metadata', $item);
        my ($signature) = $self->collect('signature', $item);
        push @iteration, ($signature, '') if $signature;
        my @data = do {
          my ($find) = $self->text->find($name, $item); @{$find ? $find->{data} : []};
        };
        next if !@data;
        push @iteration, join "\n\n", @data;
        if ($metadata) {
          local $@;
          my $perlcode = do{no warnings; eval $metadata};
          if ($metadata = ($perlcode && ref $perlcode) ? $perlcode : $metadata) {
            if (ref $metadata ne 'HASH') {
              $metadata = {map {split /:\s*/} split /\n+/, $metadata};
            }
            my @lifespan;
            if (my $introduced = $metadata->{introduced}) {
              push @lifespan, "I<Introduced C<$introduced>>";
            }
            if (my $deprecated = $metadata->{deprecated}) {
              push @lifespan, "I<Deprecated C<$deprecated>>";
            }
            if (my $since = $metadata->{since}) {
              @lifespan = ("I<Since C<$since>>");
            }
            push @output, "", join(", ", @lifespan) if @lifespan;
          }
        }
        my @results = $self->data->search({name => $item});
        for my $i (1..(int grep {($$_{list} || '') =~ /^example-\d+/} @results)) {
          push @iteration, "B<example $i>", $self->collect('example', $i, $item);
        }
        pop @iteration if @output && $output[-1] eq '';
        push @output, (
          $self->present_data_for_over($self->present_data_for_item(
            $item, join "\n\n", @iteration))
        );
      }
      if (@output) {
        unshift @output,
          $self->present_data_for_head1($block,
            $self->text->string('header', $block) ||
          $self->text->string(undef, $block));
      }
      return join "\n", @output;
    }
  }

  # handle deprecated "okay_can"
  if ($method eq 'okay_can') {
    my $result = $self->handler('can_ok', @args);

    return $result;
  }

  # handle deprecated "okay_isa"
  if ($method eq 'okay_isa') {
    my $result = $self->handler('isa_ok', @args);

    return $result;
  }

  # hidden but accessible Test::More functions
  state $test_more_functions = {
    BAIL_OUT => 'BAIL_OUT',
    can_ok => 'can_ok',
    cmp_ok => 'cmp_ok',
    done_testing => 'done_testing',
    eq_array => 'eq_array',
    eq_hash => 'eq_hash',
    eq_set => 'eq_set',
    is_deeply => 'is_deeply',
    isa_ok => 'isa_ok',
    new_ok => 'new_ok',
    ok => 'ok',
    plan => 'plan',
    require_ok => 'require_ok',
    skip => 'skip',
    use_ok => 'use_ok',
  };
  if ($test_more_functions->{$method}) {
    return $self->handler($method, @args);
  }

  # method not found
  my $class = ref($self) || $self;
  return $self->error_on_missing({class => $class, method => $method})->throw;
}

1;
