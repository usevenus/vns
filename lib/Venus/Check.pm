package Venus::Check;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Class 'attr', 'base', 'with';

use Venus::What;

# INHERITS

base 'Venus::Kind::Utility';

# INTEGRATES

with 'Venus::Role::Buildable';

# ATTRIBUTES

attr 'on_eval';

# BUILDERS

sub build_arg {
  my ($self, $data) = @_;

  return {
    on_eval => ref $data eq 'ARRAY' ? $data : [$data],
  };
}

sub build_args {
  my ($self, $data) = @_;

  $data->{on_eval} = [] if !$data->{on_eval};

  return $data;
}

# METHODS

sub any {
  my ($self) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    return $source->pass($value, {
      from => 'any',
    });
  };

  return $self;
}

sub accept {
  my ($self, $name, @args) = @_;

  if (!$name) {
    return $self;
  }
  if ($self->can($name)) {
    return $self->$name(@args);
  }
  else {
    return $self->identity($name, @args);
  }
}

sub array {
  my ($self, @code) = @_;

  return $self->arrayref(@code);
}

sub arrayref {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'array')) {
      return $source->pass($value, {
        from => 'arrayref',
      });
    }
    else {
      return $source->fail($value, {
        from => 'arrayref',
        expected => 'arrayref',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, @code;

  return $self;
}

sub attributes {
  my ($self, @pairs) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'object')) {
      return $source->pass($value, {
        from => 'attributes',
      });
    }
    else {
      return $source->fail($value, {
        from => 'attributes',
        expected => 'object',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if (@pairs % 2) {
      return $source->fail($value, {
        from => 'attributes',
        args => [@pairs],
        with => 'error_on_pairs',
      });
    }
    my $result = true;
    for (my $i = 0; $i < @pairs;) {
      my ($key, $data) = (map $pairs[$_], $i++, $i++);
      if (!$value->can($key)) {
        $result = $source->fail($value, {
          from => 'attributes',
          name => $key,
          with => 'error_on_missing',
        });
        last;
      }
      my ($match, @args) = (ref $data) ? (@{$data}) : ($data);
      my $check = $source->branch($key)->accept($match, @args);
      if (!$check->eval($value->$key)) {
        $result = $source->fail($value, {
          branch => $check->{'$branch'},
          %{$check->{'$result'}},
          from => 'attributes',
        });
        last;
      }
    }
    if (!$result) {
      return $result;
    }
    else {
      return $source->pass($value, {
        from => 'attributes',
      });
    }
  };

  return $self;
}

sub bool {
  my ($self, @code) = @_;

  return $self->boolean(@code);
}

sub boolean {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'boolean')) {
      return $source->pass($value, {
        from => 'boolean',
      });
    }
    else {
      return $source->fail($value, {
        from => 'boolean',
        expected => 'boolean',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, @code;

  return $self;
}

sub branch {
  my ($self, @args) = @_;

  my $source = $self->new;

  $source->{'$branch'} = [
    ($self->{'$branch'} ? @{$self->{'$branch'}} : ()), @args
  ];

  return $source;
}

sub clear {
  my ($self) = @_;

  @{$self->on_eval} = ();

  delete $self->{'$branch'};
  delete $self->{'$result'};

  return $self;
}

sub code {
  my ($self, @code) = @_;

  return $self->coderef(@code);
}

sub coded {
  my ($self, $data, $name) = @_;

  require Venus::What;

  return Venus::What->new($data)->coded($name) ? true : false;
}

sub coderef {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'code')) {
      return $source->pass($value, {
        from => 'coderef',
      });
    }
    else {
      return $source->fail($value, {
        from => 'coderef',
        expected => 'coderef',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, @code;

  return $self;
}

sub consumes {
  my ($self, $role) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'object')) {
      return $source->pass($value, {
        from => 'consumes',
      });
    }
    else {
      return $source->fail($value, {
        from => 'consumes',
        expected => 'object',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if ($value->can('DOES') && $value->DOES($role)) {
      return $source->pass($value, {
        from => 'consumes',
      });
    }
    else {
      return $source->fail($value, {
        from => 'consumes',
        role => $role,
        with => 'error_on_consumes',
      });
    }
  };

  return $self;
}

sub defined {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if (CORE::defined($value)) {
      return $source->pass($value, {
        from => 'defined',
      });
    }
    else {
      return $source->fail($value, {
        from => 'defined',
        with => 'error_on_defined',
      });
    }
  }, @code;

  return $self;
}

sub dirhandle {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'scalar') && ref $value eq 'GLOB' && do{no warnings 'io'; -d $value}) {
      return $source->pass($value, {
        from => 'dirhandle',
      });
    }
    else {
      return $source->fail($value, {
        from => 'dirhandle',
        expected => 'dirhandle',
        received => $source->what($value),
        with => 'error_on_dirhandle',
      });
    }
  }, @code;

  return $self;
}

sub either {
  my ($self, @data) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    my $returns;
    my @errors;
    my @results;
    for (my $i = 0; $i < @data; $i++) {
      my ($match, @args) = (ref $data[$i]) ? (@{$data[$i]}) : ($data[$i]);
      my $check = $source->branch->do('accept', $match, @args);
      if ($check->eval($value)) {
        $returns = $source->pass($value, {
          from => 'either',
          ($check->{'$branch'} ? (branch => $check->{'$branch'}) : ()),
          %{$check->{'$result'}},
        });
        push @results, $source->{'$result'};
        last;
      }
      else {
        $returns = $source->fail($value, {
          from => 'either',
          ($check->{'$branch'} ? (branch => $check->{'$branch'}) : ()),
          %{$check->{'$result'}},
        });
        push @results, $source->{'$result'};
        push @errors, $source->catch('result')->render;
      }
    }
    if ($returns) {
      return $returns;
    }
    else {
      return $self->fail($value, {
        from => 'either',
        with => 'error_on_either',
        results => [@results],
        errors => [@errors],
      });
    }
  };

  return $self;
}

sub enum {
  my ($self, @data) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if (CORE::defined($value)) {
      return $source->pass($value, {
        from => 'enum',
      });
    }
    else {
      return $source->fail($value, {
        from => 'enum',
        with => 'error_on_defined',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    my $result;
    for my $item (@data) {
      if ($value eq $item) {
        $result = $source->pass($value, {
          from => 'enum',
        });
        last;
      }
      else {
        $result = $source->fail($value, {
          from => 'enum',
          with => 'error_on_enum',
          enum => [@data],
        });
      }
    }
    return $result;
  };

  return $self;
}

sub eval {
  my ($self, $data) = @_;

  delete $self->{'$result'};

  my $result = false;

  for my $callback (@{$self->on_eval}) {
    local $_ = $data;
    $result = $self->$callback($data) ? true : false;
    last if !$result;
  }

  return $result;
}

sub evaled {
  my ($self) = @_;

  my $passed = $self->passed;
  my $failed = $self->failed;

  return !$passed && !$failed ? false : true;
}

sub evaler {
  my ($self, @args) = @_;

  return $self->defer('eval', @args);
}

sub fail {
  my ($self, $data, $meta) = @_;

  my $from = $meta->{from} || 'callback';
  my $with = $meta->{with};
  my $okay = false;

  $self->{'$result'} = {
    %$meta,
    data => $data,
    from => $from,
    okay => $okay,
    with => $with,
  };

  return $okay;
}

sub failed {
  my ($self) = @_;

  my $result = $self->{'$result'};

  return $result ? ($result->{okay} ? false : true) : false;
}

sub filehandle {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'scalar') && ref $value eq 'GLOB' && defined(fileno($value)) && !-d $value) {
      return $source->pass($value, {
        from => 'filehandle',
      });
    }
    else {
      return $source->fail($value, {
        from => 'filehandle',
        expected => 'filehandle',
        received => $source->what($value),
        with => 'error_on_filehandle',
      });
    }
  }, @code;

  return $self;
}

sub float {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'float')) {
      return $source->pass($value, {
        from => 'float',
      });
    }
    else {
      return $source->fail($value, {
        from => 'float',
        expected => 'float',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, @code;

  return $self;
}

sub glob {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'scalar') && ref $value eq 'GLOB') {
      return $source->pass($value, {
        from => 'glob',
      });
    }
    else {
      return $source->fail($value, {
        from => 'glob',
        expected => 'typeglob',
        received => $source->what($value),
        with => 'error_on_typeglob',
      });
    }
  }, @code;

  return $self;
}

sub hash {
  my ($self, @code) = @_;

  return $self->hashref(@code);
}

sub hashkeys {
  my ($self, @pairs) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if (CORE::defined($value)) {
      return $source->pass($value, {
        from => 'hashkeys',
      });
    }
    else {
      return $source->fail($value, {
        from => 'hashkeys',
        with => 'error_on_defined',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if (UNIVERSAL::isa($value, 'HASH')) {
      return $source->pass($value, {
        from => 'hashkeys',
      });
    }
    else {
      return $source->fail($value, {
        from => 'hashkeys',
        with => 'error_on_hashref',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if ((CORE::keys %{$value}) > 0) {
      return $source->pass($value, {
        from => 'hashkeys',
      });
    }
    else {
      return $source->fail($value, {
        from => 'hashkeys',
        with => 'error_on_hashref_empty',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if (@pairs % 2) {
      return $source->fail($value, {
        from => 'hashkeys',
        args => [@pairs],
        with => 'error_on_pairs',
      });
    }
    my $result = true;
    for (my $i = 0; $i < @pairs;) {
      my ($key, $data) = (map $pairs[$_], $i++, $i++);
      if (!exists $value->{$key}) {
        $result = $source->fail($value, {
          from => 'hashkeys',
          name => $key,
          with => 'error_on_missing',
        });
        last;
      }
      my ($match, @args) = (ref $data) ? (@{$data}) : ($data);
      my $check = $source->branch($key)->accept($match, @args);
      if (!$check->eval($value->{$key})) {
        $result = $source->fail($value, {
          branch => $check->{'$branch'},
          %{$check->{'$result'}},
          from => 'hashkeys',
        });
        last;
      }
    }
    if (!$result) {
      return $result;
    }
    else {
      return $source->pass($value, {
        from => 'hashkeys',
      });
    }
  };

  return $self;
}

sub hashref {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'hash')) {
      return $source->pass($value, {
        from => 'hashref',
      });
    }
    else {
      return $source->fail($value, {
        from => 'hashref',
        expected => 'hashref',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, @code;

  return $self;
}

sub includes {
  my ($self, @data) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    my $returns;
    my @errors;
    my @results;
    for (my $i = 0; $i < @data; $i++) {
      my ($match, @args) = (ref $data[$i]) ? (@{$data[$i]}) : ($data[$i]);
      my $check = $source->branch->do('accept', $match, @args);
      if ($check->eval($value)) {
        $returns = $source->pass($value, {
          from => 'either',
          ($check->{'$branch'} ? (branch => $check->{'$branch'}) : ()),
          %{$check->{'$result'}},
        });
        push @results, $source->{'$result'};
      }
      else {
        $returns = $source->fail($value, {
          from => 'either',
          ($check->{'$branch'} ? (branch => $check->{'$branch'}) : ()),
          %{$check->{'$result'}},
        });
        push @results, $source->{'$result'};
        push @errors, $source->catch('result')->render;
        last;
      }
    }
    if (@errors) {
      return $self->fail($value, {
        from => 'includes',
        with => 'error_on_includes',
        results => [@results],
        errors => [@errors],
      });
    }
    else {
      return $returns;
    }
  };

  return $self;
}

sub identity {
  my ($self, $name) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'object')) {
      return $source->pass($value, {
        from => 'identity',
      });
    }
    else {
      return $source->fail($value, {
        from => 'identity',
        expected => 'object',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if ($value->isa($name)) {
      return $source->pass($value, {
        from => 'identity',
      });
    }
    else {
      return $source->fail($value, {
        from => 'identity',
        with => 'error_on_identity',
        name => $name,
      });
    }
  };

  return $self;
}

sub inherits {
  my ($self, $name) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'object')) {
      return $source->pass($value, {
        from => 'inherits',
      });
    }
    else {
      return $source->fail($value, {
        from => 'inherits',
        expected => 'object',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if ($value->isa($name)) {
      return $source->pass($value, {
        from => 'inherits',
      });
    }
    else {
      return $source->fail($value, {
        from => 'inherits',
        with => 'error_on_inherits',
        name => $name,
      });
    }
  };

  return $self;
}

sub integrates {
  my ($self, $role) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'object')) {
      return $source->pass($value, {
        from => 'integrates',
      });
    }
    else {
      return $source->fail($value, {
        from => 'integrates',
        expected => 'object',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if ($value->can('DOES') && $value->DOES($role)) {
      return $source->pass($value, {
        from => 'integrates',
      });
    }
    else {
      return $source->fail($value, {
        from => 'integrates',
        role => $role,
        with => 'error_on_consumes',
      });
    }
  };

  return $self;
}

sub maybe {
  my ($self, $match, @args) = @_;

  $self->either('undef', ($match ? [$match, @args] : ()));

  return $self;
}

sub number {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'number')) {
      return $source->pass($value, {
        from => 'number',
      });
    }
    else {
      return $source->fail($value, {
        from => 'number',
        expected => 'number',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, @code;

  return $self;
}

sub object {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'object')) {
      return $source->pass($value, {
        from => 'object',
      });
    }
    else {
      return $source->fail($value, {
        from => 'object',
        expected => 'object',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, @code;

  return $self;
}

sub package {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'string')) {
      return $source->pass($value, {
        from => 'package',
      });
    }
    else {
      return $source->fail($value, {
        from => 'package',
        expected => 'string',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if ($value =~ /^[A-Z](?:(?:\w|::)*[a-zA-Z0-9])?$/) {
      return $source->pass($value, {
        from => 'package',
      });
    }
    else {
      return $source->fail($value, {
        from => 'package',
        with => 'error_on_package',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    require Venus::Space;
    if (Venus::Space->new($value)->loaded) {
      return $source->pass($value, {
        from => 'package',
      });
    }
    else {
      return $source->fail($value, {
        from => 'package',
        with => 'error_on_package_loaded',
      });
    }
  }, @code;

  return $self;
}

sub pass {
  my ($self, $data, $meta) = @_;

  my $from = $meta->{from} || 'callback';
  my $with = $meta->{with};
  my $okay = true;

  $self->{'$result'} = {
    %$meta,
    data => $data,
    from => $from,
    okay => $okay,
    with => $with,
  };

  return $okay;
}

sub passed {
  my ($self) = @_;

  my $result = $self->{'$result'};

  return $result ? ($result->{okay} ? true : false) : false;
}

sub reference {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if (CORE::defined($value)) {
      return $source->pass($value, {
        from => 'reference',
      });
    }
    else {
      return $source->fail($value, {
        from => 'reference',
        with => 'error_on_defined',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if (ref($value)) {
      return $source->pass($value, {
        from => 'reference',
      });
    }
    else {
      return $source->fail($value, {
        from => 'reference',
        with => 'error_on_reference',
      });
    }
  }, @code;

  return $self;
}

sub regexp {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'regexp')) {
      return $source->pass($value, {
        from => 'regexp',
      });
    }
    else {
      return $source->fail($value, {
        from => 'regexp',
        expected => 'regexp',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, @code;

  return $self;
}

sub result {
  my ($self, @data) = @_;

  my $eval = $self->eval(@data) if @data;

  my $result = $self->{'$result'};

  return undef if !defined $result;

  my $data = $result->{data};
  my $okay = (delete $result->{okay}) || $eval;
  my $with = (delete $result->{with}) || 'error_on_unknown';

  $result->{at} = $result->{'branch'}
    ? join('.', '', @{$result->{'branch'}}) || '.' : '.';

  return $okay ? $data : $self->$with($result)->capture(@data)->throw;
}

sub routines {
  my ($self, @data) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'object')) {
      return $source->pass($value, {
        from => 'routines',
      });
    }
    else {
      return $source->fail($value, {
        from => 'routines',
        expected => 'object',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    my $result;
    for my $item (@data) {
      if ($value->can($item)) {
        $result = $source->pass($value, {
          from => 'routines',
        });
      }
      else {
        $result = $source->fail($value, {
          from => 'routines',
          name => $item,
          with => 'error_on_missing',
        });
        last;
      }
    }
    return $result;
  };

  return $self;
}

sub scalar {
  my ($self, @code) = @_;

  return $self->scalarref(@code);
}

sub scalarref {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'scalar')) {
      return $source->pass($value, {
        from => 'scalarref',
      });
    }
    else {
      return $source->fail($value, {
        from => 'scalarref',
        expected => 'scalarref',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, @code;

  return $self;
}

sub string {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'string')) {
      return $source->pass($value, {
        from => 'string',
      });
    }
    else {
      return $source->fail($value, {
        from => 'string',
        expected => 'string',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, @code;

  return $self;
}

sub tuple {
  my ($self, @data) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if (CORE::defined($value)) {
      return $source->pass($value, {
        from => 'tuple',
      });
    }
    else {
      return $source->fail($value, {
        from => 'tuple',
        with => 'error_on_defined',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if (UNIVERSAL::isa($value, 'ARRAY')) {
      return $source->pass($value, {
        from => 'tuple',
      });
    }
    else {
      return $source->fail($value, {
        from => 'tuple',
        with => 'error_on_arrayref',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if (@data == @{$value}) {
      return $source->pass($value, {
        from => 'tuple',
      });
    }
    else {
      return $source->fail($value, {
        from => 'tuple',
        with => 'error_on_arrayref_count',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    my $result = true;
    for (my $i = 0; $i < @data; $i++) {
      my ($match, @args) = (ref $data[$i]) ? (@{$data[$i]}) : ($data[$i]);
      my $check = $source->branch($i)->accept($match, @args);
      if (!$check->eval($value->[$i])) {
        $result = $source->fail($value, {
          branch => $check->{'$branch'},
          %{$check->{'$result'}},
          from => 'tuple',
        });
        last;
      }
    }
    if (!$result) {
      return $result;
    }
    else {
      return $self->pass($value, {
        from => 'tuple',
      });
    }
  };

  return $self;
}

sub what {
  my ($self, $value) = @_;

  my $aliases = {
    array => 'arrayref',
    code => 'coderef',
    hash => 'hashref',
    regexp => 'regexpref',
    scalar => 'scalarref',
  };

  my $identity = lc(Venus::What->new(value => $value)->identify);

  return $aliases->{$identity} || $identity;
}

sub undef {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if ($source->coded($value, 'undef')) {
      return $source->pass($value, {
        from => 'undef',
      });
    }
    else {
      return $source->fail($value, {
        from => 'undef',
        expected => 'undef',
        received => $source->what($value),
        with => 'error_on_coded',
      });
    }
  }, @code;

  return $self;
}

sub value {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if (CORE::defined($value)) {
      return $source->pass($value, {
        from => 'value',
      });
    }
    else {
      return $source->fail($value, {
        from => 'value',
        with => 'error_on_defined',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if (!CORE::ref($value)) {
      return $source->pass($value, {
        from => 'value',
      });
    }
    else {
      return $source->fail($value, {
        from => 'value',
        with => 'error_on_value',
      });
    }
  }, @code;

  return $self;
}

sub within {
  my ($self, $type, @next) = @_;

  if (!$type) {
    return $self;
  }

  my $where = $self->new;

  if (lc($type) eq 'hash' || lc($type) eq 'hashref') {
    push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if (CORE::defined($value)) {
      return $source->pass($value, {
        from => 'within',
      });
    }
    else {
      return $source->fail($value, {
        from => 'within',
        with => 'error_on_defined',
      });
    }
    }, sub {
      my ($source, $value) = @_;
      if (UNIVERSAL::isa($value, 'HASH')) {
        return $source->pass($value, {
          from => 'within',
        });
      }
      else {
        return $source->fail($value, {
          from => 'within',
          with => 'error_on_hashref',
        });
      }
    }, sub {
      my ($source, $value) = @_;
      if ((CORE::keys %{$value}) > 0) {
        return $source->pass($value, {
          from => 'within',
        });
      }
      else {
        return $source->fail($value, {
          from => 'within',
          with => 'error_on_hashref_empty',
        });
      }
    }, sub {
      my ($source, $value) = @_;
      my $result = true;
      for my $key (CORE::keys %{$value}) {
        my $check = $where->branch($key);
        $check->on_eval($where->on_eval);
        if (!$check->eval($value->{$key})) {
          $result = $source->fail($value, {
            branch => $check->{'$branch'},
            %{$check->{'$result'}},
            from => 'within',
          });
          last;
        }
      }
      if (!$result) {
        return $result;
      }
      else {
        return $self->pass($value, {
          from => 'within',
        });
      }
    };
  }
  elsif (lc($type) eq 'array' || lc($type) eq 'arrayref') {
    push @{$self->on_eval}, sub {
      my ($source, $value) = @_;
      if (CORE::defined($value)) {
        return $source->pass($value, {
          from => 'within',
        });
      }
      else {
        return $source->fail($value, {
          from => 'within',
          with => 'error_on_defined',
        });
      }
    }, sub {
      my ($source, $value) = @_;
      if (UNIVERSAL::isa($value, 'ARRAY')) {
        return $source->pass($value, {
          from => 'within',
        });
      }
      else {
        return $source->fail($value, {
          from => 'within',
          with => 'error_on_arrayref',
        });
      }
    }, sub {
      my ($source, $value) = @_;
      if (@{$value} > 0) {
        return $source->pass($value, {
          from => 'within',
        });
      }
      else {
        return $source->fail($value, {
          from => 'within',
          with => 'error_on_arrayref_count',
        });
      }
    }, sub {
      my ($source, $value) = @_;
      my $result = true;
      my $key = 0;
      for my $item (@{$value}) {
        my $check = $where->branch($key++);
        $check->on_eval($where->on_eval);
        if (!$check->eval($item)) {
          $result = $source->fail($value, {
            branch => $check->{'$branch'},
            %{$check->{'$result'}},
            from => 'within',
          });
          last;
        }
      }
      if (!$result) {
        return $result;
      }
      else {
        return $self->pass($value, {
          from => 'within',
        });
      }
    };
  }
  else {
    require Venus::Meta;
    require Venus::Space;
    my $meta = Venus::Meta->new(
      name => Venus::Space->new($type)->do('tryload')->package,
    );
    if ($type && !ref $type && $meta->role('Venus::Role::Mappable')) {
      push @{$self->on_eval}, sub {
        my ($source, $value) = @_;
        if (CORE::defined($value)) {
          return $source->pass($value, {
            from => 'within',
          });
        }
        else {
          return $source->fail($value, {
            from => 'within',
            with => 'error_on_defined',
          });
        }
      }, sub {
        my ($source, $value) = @_;
        if (UNIVERSAL::isa($value, $type)) {
          return $source->pass($value, {
            from => 'within',
          });
        }
        else {
          return $source->fail($value, {
            from => 'within',
            expected => $type,
            received => $source->what($value),
            with => 'error_on_mappable_isa',
          });
        }
      }, sub {
        my ($source, $value) = @_;
        if ($value->count) {
          return $source->pass($value, {
            from => 'within',
          });
        }
        else {
          return $source->fail($value, {
            from => 'within',
            with => 'error_on_mappable_empty',
          });
        }
      }, sub {
        my ($source, $value) = @_;
        my $result = true;
        for my $key (@{$value->keys}) {
          my $check = $where->branch($key);
          $check->on_eval($where->on_eval);
          if (!$check->eval($value->get($key))) {
            $result = $source->fail($value, {
              branch => $check->{'$branch'},
              %{$check->{'$result'}},
              from => 'within',
            });
            last;
          }
        }
        if (!$result) {
          return $result;
        }
        else {
          return $self->pass($value, {
            from => 'within',
          });
        }
      };
    }
    else {
      return $self->error({
        throw => 'error_on_within',
        type => $type,
        args => [@next]
      });
    }
  }

  $where->accept(map +(ref($_) ? @$_ : $_), $next[0]) if @next;

  return $where;
}

sub yesno {
  my ($self, @code) = @_;

  push @{$self->on_eval}, sub {
    my ($source, $value) = @_;
    if (CORE::defined($value)) {
      return $source->pass($value, {
        from => 'yesno',
      });
    }
    else {
      return $source->fail($value, {
        from => 'yesno',
        with => 'error_on_defined',
      });
    }
  }, sub {
    my ($source, $value) = @_;
    if ($value =~ /^(?:1|y(?:es)?|0|n(?:o)?)$/i) {
      return $source->pass($value, {
        from => 'yesno',
      });
    }
    else {
      return $source->fail($value, {
        from => 'yesno',
        with => 'error_on_yesno',
      });
    }
  }, @code;

  return $self;
}

# ERRORS

sub error_on_arrayref {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'value provided is not an arrayref or arrayref derived',
    'at {{at}}';

  $error->name('on.arrayref');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_arrayref_count {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'incorrect item count in arrayref or arrayref derived object',
    'at {{at}}';

  $error->name('on.arrayref.count');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_coded {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'expected {{expected}}',
    'received {{received}}',
    'at {{at}}';

  $error->name('on.coded');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_consumes {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'object does not consume the role "{{role}}"',
    'at {{at}}';

  $error->name('on.consumes');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_defined {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'value provided is undefined',
    'at {{at}}';

  $error->name('on.defined');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_dirhandle {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'value provided is not a dirhandle (or is not open)',
    'at {{at}}';

  $error->name('on.dirhandle');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_either {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join "\n\n",
    'Failed checking either-or condition:',
    @{$data->{errors}};

  $error->name('on.either');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_enum {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'received {{data}}',
    'valid options are {{options}}',
    'at {{at}}';

  $error->stash(options => (join ', ', @{$data->{enum}}));
  $error->name('on.enum');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_filehandle {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'value provided is not a filehandle (or is not open)',
    'at {{at}}';

  $error->name('on.filehandle');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_hashref {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'value provided is not a hashref or hashref derived',
    'at {{at}}';

  $error->name('on.hashref');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_hashref_empty {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'no items found in hashref or hashref derived object',
    'at {{at}}';

  $error->name('on.hashref.empty');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_includes {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join "\n\n",
    'Failed checking union-includes condition:',
    @{$data->{errors}};

  $error->name('on.includes');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_identity {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'object is not a {{name}} or derived object',
    'at {{at}}';

  $error->name('on.identity');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_inherits {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'object is not a {{name}} derived object',
    'at {{at}}';

  $error->name('on.inherits');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_isa {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'expected instance (or subclass) of {{expected}}',
    'received {{received}}',
    'at {{at}}';

  $error->name('on.isa');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_mappable_isa {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'expected instance (or subclass) of {{expected}}',
    'received {{received}}',
    'at {{at}}';

  $error->name('on.mappable.isa');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_mappable_empty {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'no items found in mappable object',
    'at {{at}}';

  $error->name('on.mappable.empty');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_missing {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    '"{{name}}" is missing',
    'at {{at}}';

  $error->name('on.missing');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_package {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    '"{{data}}" is not a valid package name',
    'at {{at}}';

  $error->name('on.package');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_package_loaded {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    '"{{data}}" is not loaded',
    'at {{at}}';

  $error->name('on.package.loaded');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_pairs {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'imblanced key/value pairs provided',
    'at {{at}}';

  $error->name('on.pairs');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_reference {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'value provided is not a reference',
    'at {{at}}';

  $error->name('on.reference');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_typeglob {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'value provided is not a typeglob',
    'at {{at}}';

  $error->name('on.typeglob');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_value {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'value provided is a reference',
    'at {{at}}';

  $error->name('on.value');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_within {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Invalid type "{{type}}" provided to the "within" method';

  $error->name('on.within');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_unknown {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = 'Failed performing check for unknown reason';

  $error->name('on.unknown');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

sub error_on_yesno {
  my ($self, $data) = @_;

  my $error = $self->error->sysinfo;

  my $message = join ', ',
    'Failed checking {{from}}',
    'value provided is not a recognized "yes" or "no" value',
    'at {{at}}';

  $error->name('on.yesno');
  $error->message($message);
  $error->offset(1);
  $error->stash($data);
  $error->reset;

  return $error;
}

1;
