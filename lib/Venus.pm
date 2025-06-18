package Venus;

use 5.018;

use strict;
use warnings;

# VERSION

our $VERSION = '5.00';

# AUTHORITY

our $AUTHORITY = 'cpan:AWNCORP';

# FILES

our $FILES = {
  'lib/Venus.pm' => {
    help => 'lib/Venus.pod',
    main => 1,
    name => 'Venus',
    test => 't/Venus.t',
    type => 'dsl',
  },
  'lib/Venus/Args.pm' => {
    help => 'lib/Venus/Args.pod',
    name => 'Venus::Args',
    test => 't/Venus_Args.t',
    type => 'class',
  },
  'lib/Venus/Array.pm' => {
    help => 'lib/Venus/Array.pod',
    name => 'Venus::Array',
    test => 't/Venus_Array.t',
    type => 'class',
  },
  'lib/Venus/Assert.pm' => {
    help => 'lib/Venus/Assert.pod',
    name => 'Venus::Assert',
    test => 't/Venus_Assert.t',
    type => 'class',
  },
  'lib/Venus/Atom.pm' => {
    help => 'lib/Venus/Atom.pod',
    name => 'Venus::Atom',
    test => 't/Venus_Atom.t',
    type => 'class',
  },
  'lib/Venus/Boolean.pm' => {
    help => 'lib/Venus/Boolean.pod',
    name => 'Venus::Boolean',
    test => 't/Venus_Boolean.t',
    type => 'class',
  },
  'lib/Venus/Box.pm' => {
    help => 'lib/Venus/Box.pod',
    name => 'Venus::Box',
    test => 't/Venus_Box.t',
    type => 'class',
  },
  'lib/Venus/Check.pm' => {
    help => 'lib/Venus/Check.pod',
    name => 'Venus::Check',
    test => 't/Venus_Check.t',
    type => 'class',
  },
  'lib/Venus/Class.pm' => {
    help => 'lib/Venus/Class.pod',
    name => 'Venus::Class',
    test => 't/Venus_Class.t',
    type => 'dsl',
  },
  'lib/Venus/Cli.pm' => {
    help => 'lib/Venus/Cli.pod',
    name => 'Venus::Cli',
    test => 't/Venus_Cli.t',
    type => 'class',
  },
  'lib/Venus/Code.pm' => {
    help => 'lib/Venus/Code.pod',
    name => 'Venus::Code',
    test => 't/Venus_Code.t',
    type => 'class',
  },
  'lib/Venus/Coercion.pm' => {
    help => 'lib/Venus/Coercion.pod',
    name => 'Venus::Coercion',
    test => 't/Venus_Coercion.t',
    type => 'class',
  },
  'lib/Venus/Config.pm' => {
    help => 'lib/Venus/Config.pod',
    name => 'Venus::Config',
    test => 't/Venus_Config.t',
    type => 'class',
  },
  'lib/Venus/Constraint.pm' => {
    help => 'lib/Venus/Constraint.pod',
    name => 'Venus::Constraint',
    test => 't/Venus_Constraint.t',
    type => 'class',
  },
  'lib/Venus/Core.pm' => {
    help => 'lib/Venus/Core.pod',
    name => 'Venus::Core',
    test => 't/Venus_Core.t',
    type => 'core',
  },
  'lib/Venus/Core/Class.pm' => {
    help => 'lib/Venus/Core/Class.pod',
    name => 'Venus::Core::Class',
    test => 't/Venus_Core_Class.t',
    type => 'core',
  },
  'lib/Venus/Core/Mixin.pm' => {
    help => 'lib/Venus/Core/Mixin.pod',
    name => 'Venus::Core::Mixin',
    test => 't/Venus_Core_Mixin.t',
    type => 'core',
  },
  'lib/Venus/Core/Role.pm' => {
    help => 'lib/Venus/Core/Role.pod',
    name => 'Venus::Core::Role',
    test => 't/Venus_Core_Role.t',
    type => 'core',
  },
  'lib/Venus/Data.pm' => {
    help => 'lib/Venus/Data.pod',
    name => 'Venus::Data',
    test => 't/Venus_Data.t',
    type => 'class',
  },
  'lib/Venus/Date.pm' => {
    help => 'lib/Venus/Date.pod',
    name => 'Venus::Date',
    test => 't/Venus_Date.t',
    type => 'class',
  },
  'lib/Venus/Dump.pm' => {
    help => 'lib/Venus/Dump.pod',
    name => 'Venus::Dump',
    test => 't/Venus_Dump.t',
    type => 'class',
  },
  'lib/Venus/Enum.pm' => {
    help => 'lib/Venus/Enum.pod',
    name => 'Venus::Enum',
    test => 't/Venus_Enum.t',
    type => 'class',
  },
  'lib/Venus/Error.pm' => {
    help => 'lib/Venus/Error.pod',
    name => 'Venus::Error',
    test => 't/Venus_Error.t',
    type => 'class',
  },
  'lib/Venus/Factory.pm' => {
    help => 'lib/Venus/Factory.pod',
    name => 'Venus::Factory',
    test => 't/Venus_Factory.t',
    type => 'class',
  },
  'lib/Venus/False.pm' => {
    help => 'lib/Venus/False.pod',
    name => 'Venus::False',
    test => 't/Venus_False.t',
    type => 'class',
  },
  'lib/Venus/Fault.pm' => {
    help => 'lib/Venus/Fault.pod',
    name => 'Venus::Fault',
    test => 't/Venus_Fault.t',
    type => 'class',
  },
  'lib/Venus/Float.pm' => {
    help => 'lib/Venus/Float.pod',
    name => 'Venus::Float',
    test => 't/Venus_Float.t',
    type => 'class',
  },
  'lib/Venus/Future.pm' => {
    help => 'lib/Venus/Future.pod',
    name => 'Venus::Future',
    test => 't/Venus_Future.t',
    type => 'class',
  },
  'lib/Venus/Gather.pm' => {
    help => 'lib/Venus/Gather.pod',
    name => 'Venus::Gather',
    test => 't/Venus_Gather.t',
    type => 'class',
  },
  'lib/Venus/Hash.pm' => {
    help => 'lib/Venus/Hash.pod',
    name => 'Venus::Hash',
    test => 't/Venus_Hash.t',
    type => 'class',
  },
  'lib/Venus/Json.pm' => {
    help => 'lib/Venus/Json.pod',
    name => 'Venus::Json',
    test => 't/Venus_Json.t',
    type => 'class',
  },
  'lib/Venus/Kind.pm' => {
    help => 'lib/Venus/Kind.pod',
    name => 'Venus::Kind',
    test => 't/Venus_Kind.t',
    type => 'kind',
  },
  'lib/Venus/Kind/Utility.pm' => {
    help => 'lib/Venus/Kind/Utility.pod',
    name => 'Venus::Kind::Utility',
    test => 't/Venus_Kind_Utility.t',
    type => 'kind',
  },
  'lib/Venus/Kind/Value.pm' => {
    help => 'lib/Venus/Kind/Value.pod',
    name => 'Venus::Kind::Value',
    test => 't/Venus_Kind_Value.t',
    type => 'kind',
  },
  'lib/Venus/Log.pm' => {
    help => 'lib/Venus/Log.pod',
    name => 'Venus::Log',
    test => 't/Venus_Log.t',
    type => 'class',
  },
  'lib/Venus/Match.pm' => {
    help => 'lib/Venus/Match.pod',
    name => 'Venus::Match',
    test => 't/Venus_Match.t',
    type => 'class',
  },
  'lib/Venus/Map.pm' => {
    help => 'lib/Venus/Map.pod',
    name => 'Venus::Map',
    test => 't/Venus_Map.t',
    type => 'class',
  },
  'lib/Venus/Meta.pm' => {
    help => 'lib/Venus/Meta.pod',
    name => 'Venus::Meta',
    test => 't/Venus_Meta.t',
    type => 'class',
  },
  'lib/Venus/Mixin.pm' => {
    help => 'lib/Venus/Mixin.pod',
    name => 'Venus::Mixin',
    test => 't/Venus_Mixin.t',
    type => 'dsl',
  },
  'lib/Venus/Name.pm' => {
    help => 'lib/Venus/Name.pod',
    name => 'Venus::Name',
    test => 't/Venus_Name.t',
    type => 'class',
  },
  'lib/Venus/Number.pm' => {
    help => 'lib/Venus/Number.pod',
    name => 'Venus::Number',
    test => 't/Venus_Number.t',
    type => 'class',
  },
  'lib/Venus/Opts.pm' => {
    help => 'lib/Venus/Opts.pod',
    name => 'Venus::Opts',
    test => 't/Venus_Opts.t',
    type => 'class',
  },
  'lib/Venus/Os.pm' => {
    help => 'lib/Venus/Os.pod',
    name => 'Venus::Os',
    test => 't/Venus_Os.t',
    type => 'class',
  },
  'lib/Venus/Path.pm' => {
    help => 'lib/Venus/Path.pod',
    name => 'Venus::Path',
    test => 't/Venus_Path.t',
    type => 'class',
  },
  'lib/Venus/Process.pm' => {
    help => 'lib/Venus/Process.pod',
    name => 'Venus::Process',
    test => 't/Venus_Process.t',
    type => 'class',
  },
  'lib/Venus/Prototype.pm' => {
    help => 'lib/Venus/Prototype.pod',
    name => 'Venus::Prototype',
    test => 't/Venus_Prototype.t',
    type => 'class',
  },
  'lib/Venus/Random.pm' => {
    help => 'lib/Venus/Random.pod',
    name => 'Venus::Random',
    test => 't/Venus_Random.t',
    type => 'class',
  },
  'lib/Venus/Range.pm' => {
    help => 'lib/Venus/Range.pod',
    name => 'Venus::Range',
    test => 't/Venus_Range.t',
    type => 'class',
  },
  'lib/Venus/Regexp.pm' => {
    help => 'lib/Venus/Regexp.pod',
    name => 'Venus::Regexp',
    test => 't/Venus_Regexp.t',
    type => 'class',
  },
  'lib/Venus/Replace.pm' => {
    help => 'lib/Venus/Replace.pod',
    name => 'Venus::Replace',
    test => 't/Venus_Replace.t',
    type => 'class',
  },
  'lib/Venus/Result.pm' => {
    help => 'lib/Venus/Result.pod',
    name => 'Venus::Result',
    test => 't/Venus_Result.t',
    type => 'class',
  },
  'lib/Venus/Role.pm' => {
    help => 'lib/Venus/Role.pod',
    name => 'Venus::Role',
    test => 't/Venus_Role.t',
    type => 'dsl',
  },
  'lib/Venus/Role/Accessible.pm' => {
    help => 'lib/Venus/Role/Accessible.pod',
    name => 'Venus::Role::Accessible',
    test => 't/Venus_Role_Accessible.t',
    type => 'role',
  },
  'lib/Venus/Role/Boxable.pm' => {
    help => 'lib/Venus/Role/Boxable.pod',
    name => 'Venus::Role::Boxable',
    test => 't/Venus_Role_Boxable.t',
    type => 'role',
  },
  'lib/Venus/Role/Buildable.pm' => {
    help => 'lib/Venus/Role/Buildable.pod',
    name => 'Venus::Role::Buildable',
    test => 't/Venus_Role_Buildable.t',
    type => 'role',
  },
  'lib/Venus/Role/Catchable.pm' => {
    help => 'lib/Venus/Role/Catchable.pod',
    name => 'Venus::Role::Catchable',
    test => 't/Venus_Role_Catchable.t',
    type => 'role',
  },
  'lib/Venus/Role/Coercible.pm' => {
    help => 'lib/Venus/Role/Coercible.pod',
    name => 'Venus::Role::Coercible',
    test => 't/Venus_Role_Coercible.t',
    type => 'role',
  },
  'lib/Venus/Role/Comparable.pm' => {
    help => 'lib/Venus/Role/Comparable.pod',
    name => 'Venus::Role::Comparable',
    test => 't/Venus_Role_Comparable.t',
    type => 'role',
  },
  'lib/Venus/Role/Defaultable.pm' => {
    help => 'lib/Venus/Role/Defaultable.pod',
    name => 'Venus::Role::Defaultable',
    test => 't/Venus_Role_Defaultable.t',
    type => 'role',
  },
  'lib/Venus/Role/Deferrable.pm' => {
    help => 'lib/Venus/Role/Deferrable.pod',
    name => 'Venus::Role::Deferrable',
    test => 't/Venus_Role_Deferrable.t',
    type => 'role',
  },
  'lib/Venus/Role/Digestable.pm' => {
    help => 'lib/Venus/Role/Digestable.pod',
    name => 'Venus::Role::Digestable',
    test => 't/Venus_Role_Digestable.t',
    type => 'role',
  },
  'lib/Venus/Role/Doable.pm' => {
    help => 'lib/Venus/Role/Doable.pod',
    name => 'Venus::Role::Doable',
    test => 't/Venus_Role_Doable.t',
    type => 'role',
  },
  'lib/Venus/Role/Dumpable.pm' => {
    help => 'lib/Venus/Role/Dumpable.pod',
    name => 'Venus::Role::Dumpable',
    test => 't/Venus_Role_Dumpable.t',
    type => 'role',
  },
  'lib/Venus/Role/Encaseable.pm' => {
    help => 'lib/Venus/Role/Encaseable.pod',
    name => 'Venus::Role::Encaseable',
    test => 't/Venus_Role_Encaseable.t',
    type => 'role',
  },
  'lib/Venus/Role/Explainable.pm' => {
    help => 'lib/Venus/Role/Explainable.pod',
    name => 'Venus::Role::Explainable',
    test => 't/Venus_Role_Explainable.t',
    type => 'role',
  },
  'lib/Venus/Role/Fromable.pm' => {
    help => 'lib/Venus/Role/Fromable.pod',
    name => 'Venus::Role::Fromable',
    test => 't/Venus_Role_Fromable.t',
    type => 'role',
  },
  'lib/Venus/Role/Mappable.pm' => {
    help => 'lib/Venus/Role/Mappable.pod',
    name => 'Venus::Role::Mappable',
    test => 't/Venus_Role_Mappable.t',
    type => 'role',
  },
  'lib/Venus/Role/Matchable.pm' => {
    help => 'lib/Venus/Role/Matchable.pod',
    name => 'Venus::Role::Matchable',
    test => 't/Venus_Role_Matchable.t',
    type => 'role',
  },
  'lib/Venus/Role/Mockable.pm' => {
    help => 'lib/Venus/Role/Mockable.pod',
    name => 'Venus::Role::Mockable',
    test => 't/Venus_Role_Mockable.t',
    type => 'role',
  },
  'lib/Venus/Role/Optional.pm' => {
    help => 'lib/Venus/Role/Optional.pod',
    name => 'Venus::Role::Optional',
    test => 't/Venus_Role_Optional.t',
    type => 'role',
  },
  'lib/Venus/Role/Patchable.pm' => {
    help => 'lib/Venus/Role/Patchable.pod',
    name => 'Venus::Role::Patchable',
    test => 't/Venus_Role_Patchable.t',
    type => 'role',
  },
  'lib/Venus/Role/Pluggable.pm' => {
    help => 'lib/Venus/Role/Pluggable.pod',
    name => 'Venus::Role::Pluggable',
    test => 't/Venus_Role_Pluggable.t',
    type => 'role',
  },
  'lib/Venus/Role/Printable.pm' => {
    help => 'lib/Venus/Role/Printable.pod',
    name => 'Venus::Role::Printable',
    test => 't/Venus_Role_Printable.t',
    type => 'role',
  },
  'lib/Venus/Role/Proxyable.pm' => {
    help => 'lib/Venus/Role/Proxyable.pod',
    name => 'Venus::Role::Proxyable',
    test => 't/Venus_Role_Proxyable.t',
    type => 'role',
  },
  'lib/Venus/Role/Reflectable.pm' => {
    help => 'lib/Venus/Role/Reflectable.pod',
    name => 'Venus::Role::Reflectable',
    test => 't/Venus_Role_Reflectable.t',
    type => 'role',
  },
  'lib/Venus/Role/Rejectable.pm' => {
    help => 'lib/Venus/Role/Rejectable.pod',
    name => 'Venus::Role::Rejectable',
    test => 't/Venus_Role_Rejectable.t',
    type => 'role',
  },
  'lib/Venus/Role/Resultable.pm' => {
    help => 'lib/Venus/Role/Resultable.pod',
    name => 'Venus::Role::Resultable',
    test => 't/Venus_Role_Resultable.t',
    type => 'role',
  },
  'lib/Venus/Role/Serializable.pm' => {
    help => 'lib/Venus/Role/Serializable.pod',
    name => 'Venus::Role::Serializable',
    test => 't/Venus_Role_Serializable.t',
    type => 'role',
  },
  'lib/Venus/Role/Stashable.pm' => {
    help => 'lib/Venus/Role/Stashable.pod',
    name => 'Venus::Role::Stashable',
    test => 't/Venus_Role_Stashable.t',
    type => 'role',
  },
  'lib/Venus/Role/Subscribable.pm' => {
    help => 'lib/Venus/Role/Subscribable.pod',
    name => 'Venus::Role::Subscribable',
    test => 't/Venus_Role_Subscribable.t',
    type => 'role',
  },
  'lib/Venus/Role/Superable.pm' => {
    help => 'lib/Venus/Role/Superable.pod',
    name => 'Venus::Role::Superable',
    test => 't/Venus_Role_Superable.t',
    type => 'role',
  },
  'lib/Venus/Role/Testable.pm' => {
    help => 'lib/Venus/Role/Testable.pod',
    name => 'Venus::Role::Testable',
    test => 't/Venus_Role_Testable.t',
    type => 'role',
  },
  'lib/Venus/Role/Throwable.pm' => {
    help => 'lib/Venus/Role/Throwable.pod',
    name => 'Venus::Role::Throwable',
    test => 't/Venus_Role_Throwable.t',
    type => 'role',
  },
  'lib/Venus/Role/Tryable.pm' => {
    help => 'lib/Venus/Role/Tryable.pod',
    name => 'Venus::Role::Tryable',
    test => 't/Venus_Role_Tryable.t',
    type => 'role',
  },
  'lib/Venus/Role/Unacceptable.pm' => {
    help => 'lib/Venus/Role/Unacceptable.pod',
    name => 'Venus::Role::Unacceptable',
    test => 't/Venus_Role_Unacceptable.t',
    type => 'role',
  },
  'lib/Venus/Role/Unpackable.pm' => {
    help => 'lib/Venus/Role/Unpackable.pod',
    name => 'Venus::Role::Unpackable',
    test => 't/Venus_Role_Unpackable.t',
    type => 'role',
  },
  'lib/Venus/Role/Valuable.pm' => {
    help => 'lib/Venus/Role/Valuable.pod',
    name => 'Venus::Role::Valuable',
    test => 't/Venus_Role_Valuable.t',
    type => 'role',
  },
  'lib/Venus/Run.pm' => {
    help => 'lib/Venus/Run.pod',
    name => 'Venus::Run',
    test => 't/Venus_Run.t',
    type => 'class',
  },
  'lib/Venus/Scalar.pm' => {
    help => 'lib/Venus/Scalar.pod',
    name => 'Venus::Scalar',
    test => 't/Venus_Scalar.t',
    type => 'class',
  },
  'lib/Venus/Schema.pm' => {
    help => 'lib/Venus/Schema.pod',
    name => 'Venus::Schema',
    test => 't/Venus_Schema.t',
    type => 'class',
  },
  'lib/Venus/Sealed.pm' => {
    help => 'lib/Venus/Sealed.pod',
    name => 'Venus::Sealed',
    test => 't/Venus_Sealed.t',
    type => 'class',
  },
  'lib/Venus/Search.pm' => {
    help => 'lib/Venus/Search.pod',
    name => 'Venus::Search',
    test => 't/Venus_Search.t',
    type => 'class',
  },
  'lib/Venus/Set.pm' => {
    help => 'lib/Venus/Set.pod',
    name => 'Venus::Set',
    test => 't/Venus_Set.t',
    type => 'class',
  },
  'lib/Venus/Space.pm' => {
    help => 'lib/Venus/Space.pod',
    name => 'Venus::Space',
    test => 't/Venus_Space.t',
    type => 'class',
  },
  'lib/Venus/String.pm' => {
    help => 'lib/Venus/String.pod',
    name => 'Venus::String',
    test => 't/Venus_String.t',
    type => 'class',
  },
  'lib/Venus/Task.pm' => {
    help => 'lib/Venus/Task.pod',
    name => 'Venus::Task',
    test => 't/Venus_Task.t',
    type => 'class',
  },
  'lib/Venus/Task/Venus.pm' => {
    help => 'lib/Venus/Task/Venus.pod',
    name => 'Venus::Task::Venus',
    test => 't/Venus_Task_Venus.t',
    type => 'class',
  },
  'lib/Venus/Task/Venus/Gen.pm' => {
    help => 'lib/Venus/Task/Venus/Gen.pod',
    name => 'Venus::Task::Venus::Gen',
    test => 't/Venus_Task_Venus_Gen.t',
    type => 'class',
  },
  'lib/Venus/Task/Venus/Get.pm' => {
    help => 'lib/Venus/Task/Venus/Get.pod',
    name => 'Venus::Task::Venus::Get',
    test => 't/Venus_Task_Venus_Get.t',
    type => 'class',
  },
  'lib/Venus/Task/Venus/New.pm' => {
    help => 'lib/Venus/Task/Venus/New.pod',
    name => 'Venus::Task::Venus::New',
    test => 't/Venus_Task_Venus_New.t',
    type => 'class',
  },
  'lib/Venus/Task/Venus/Run.pm' => {
    help => 'lib/Venus/Task/Venus/Run.pod',
    name => 'Venus::Task::Venus::Run',
    test => 't/Venus_Task_Venus_Run.t',
    type => 'class',
  },
  'lib/Venus/Task/Venus/Set.pm' => {
    help => 'lib/Venus/Task/Venus/Set.pod',
    name => 'Venus::Task::Venus::Set',
    test => 't/Venus_Task_Venus_Set.t',
    type => 'class',
  },
  'lib/Venus/Template.pm' => {
    help => 'lib/Venus/Template.pod',
    name => 'Venus::Template',
    test => 't/Venus_Template.t',
    type => 'class',
  },
  'lib/Venus/Test.pm' => {
    help => 'lib/Venus/Test.pod',
    name => 'Venus::Test',
    test => 't/Venus_Test.t',
    type => 'class',
  },
  'lib/Venus/Throw.pm' => {
    help => 'lib/Venus/Throw.pod',
    name => 'Venus::Throw',
    test => 't/Venus_Throw.t',
    type => 'class',
  },
  'lib/Venus/True.pm' => {
    help => 'lib/Venus/True.pod',
    name => 'Venus::True',
    test => 't/Venus_True.t',
    type => 'class',
  },
  'lib/Venus/Try.pm' => {
    help => 'lib/Venus/Try.pod',
    name => 'Venus::Try',
    test => 't/Venus_Try.t',
    type => 'class',
  },
  'lib/Venus/Type.pm' => {
    help => 'lib/Venus/Type.pod',
    name => 'Venus::Type',
    test => 't/Venus_Type.t',
    type => 'class',
  },
  'lib/Venus/Undef.pm' => {
    help => 'lib/Venus/Undef.pod',
    name => 'Venus::Undef',
    test => 't/Venus_Undef.t',
    type => 'class',
  },
  'lib/Venus/Unpack.pm' => {
    help => 'lib/Venus/Unpack.pod',
    name => 'Venus::Unpack',
    test => 't/Venus_Unpack.t',
    type => 'class',
  },
  'lib/Venus/Validate.pm' => {
    help => 'lib/Venus/Validate.pod',
    name => 'Venus::Validate',
    test => 't/Venus_Validate.t',
    type => 'class',
  },
  'lib/Venus/Vars.pm' => {
    help => 'lib/Venus/Vars.pod',
    name => 'Venus::Vars',
    test => 't/Venus_Vars.t',
    type => 'class',
  },
  'lib/Venus/What.pm' => {
    help => 'lib/Venus/What.pod',
    name => 'Venus::What',
    test => 't/Venus_What.t',
    type => 'class',
  },
  'lib/Venus/Yaml.pm' => {
    help => 'lib/Venus/Yaml.pod',
    name => 'Venus::Yaml',
    test => 't/Venus_Yaml.t',
    type => 'class',
  },
};

# IMPORTS

sub import {
  my ($self, @args) = @_;

  my $target = caller;

  no strict 'refs';

  my %exports = (
    all => 1,
    any => 1,
    args => 1,
    array => 1,
    arrayref => 1,
    assert => 1,
    async => 1,
    atom => 1,
    await => 1,
    bool => 1,
    box => 1,
    call => 1,
    cast => 1,
    catch => 1,
    caught => 1,
    chain => 1,
    check => 1,
    clargs => 1,
    cli => 1,
    clone => 1,
    code => 1,
    concat => 1,
    config => 1,
    cop => 1,
    data => 1,
    date => 1,
    docs => 1,
    enum => 1,
    error => 1,
    factory => 1,
    false => 1,
    fault => 1,
    flat => 1,
    float => 1,
    future => 1,
    gather => 1,
    gets => 1,
    hash => 1,
    hashref => 1,
    in => 1,
    is => 1,
    is_arrayref => 1,
    is_blessed => 1,
    is_bool => 1,
    is_boolean => 1,
    is_coderef => 1,
    is_dirhandle => 1,
    is_enum => 1,
    is_error => 1,
    is_false => 1,
    is_fault => 1,
    is_filehandle => 1,
    is_float => 1,
    is_glob => 1,
    is_hashref => 1,
    is_number => 1,
    is_object => 1,
    is_package => 1,
    is_reference => 1,
    is_regexp => 1,
    is_scalarref => 1,
    is_string => 1,
    is_true => 1,
    is_undef => 1,
    is_value => 1,
    is_yesno => 1,
    json => 1,
    list => 1,
    load => 1,
    log => 1,
    make => 1,
    map => 1,
    match => 1,
    merge => 1,
    merge_flat => 1,
    merge_flat_mutate => 1,
    merge_join => 1,
    merge_join_mutate => 1,
    merge_keep => 1,
    merge_keep_mutate => 1,
    merge_swap => 1,
    merge_swap_mutate => 1,
    merge_take => 1,
    merge_take_mutate => 1,
    meta => 1,
    name => 1,
    number => 1,
    opts => 1,
    pairs => 1,
    path => 1,
    perl => 1,
    process => 1,
    proto => 1,
    puts => 1,
    raise => 1,
    random => 1,
    range => 1,
    read_env => 1,
    read_env_file => 1,
    read_json => 1,
    read_json_file => 1,
    read_perl => 1,
    read_perl_file => 1,
    read_yaml => 1,
    read_yaml_file => 1,
    regexp => 1,
    render => 1,
    replace => 1,
    roll => 1,
    schema => 1,
    search => 1,
    set => 1,
    sets => 1,
    space => 1,
    sorts => 1,
    string => 1,
    syscall => 1,
    template => 1,
    test => 1,
    text => 1,
    then => 1,
    throw => 1,
    true => 1,
    try => 1,
    tv => 1,
    type => 1,
    unpack => 1,
    vars => 1,
    vns => 1,
    what => 1,
    work => 1,
    wrap => 1,
    write_env => 1,
    write_env_file => 1,
    write_json => 1,
    write_json_file => 1,
    write_perl => 1,
    write_perl_file => 1,
    write_yaml => 1,
    write_yaml_file => 1,
    yaml => 1,
  );

  @args = grep defined && !ref && /^[A-Za-z]/ && $exports{$_}, @args;

  my %seen;
  for my $name (grep !$seen{$_}++, @args, 'true', 'false') {
    *{"${target}::${name}"} = $self->can($name) if !$target->can($name);
  }

  return $self;
}

# HOOKS

sub _qx {
  my (@args) = @_;
  local $| = 1;
  local $SIG{__WARN__} = sub {};
  (do{local $_ = qx(@{[@args]}); chomp if $_; $_}, $?, ($? >> 8))
}

# FUNCTIONS

sub all ($;$) {
  my ($data, $expr) = @_;

  my $cast = cast($data);

  my $code = (defined $expr && ref $expr ne 'CODE') ? sub{tv($_[1], $expr)} : $expr;

  if ($cast->isa('Venus::Kind') && $cast->does('Venus::Role::Mappable')) {
    return ref $code eq 'CODE' ? $cast->all($code) : $cast->count ? true() : false();
  }
  else {
    return false();
  }
}

sub any ($;$) {
  my ($data, $expr) = @_;

  my $cast = cast($data);

  my $code = (defined $expr && ref $expr ne 'CODE') ? sub{tv($_[1], $expr)} : $expr;

  if ($cast->isa('Venus::Kind') && $cast->does('Venus::Role::Mappable')) {
    return ref $code eq 'CODE' ? $cast->any($code) : $cast->count ? true() : false();
  }
  else {
    return false();
  }
}

sub args ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Args;

  if (!$code) {
    return Venus::Args->new($data);
  }

  return Venus::Args->new($data)->$code(@args);
}

sub array ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Array;

  if (!$code) {
    return Venus::Array->new($data);
  }

  return Venus::Array->new($data)->$code(@args);
}

sub arrayref (@) {
  my (@args) = @_;

  return @args > 1
    ? ([@args])
    : ((ref $args[0] eq 'ARRAY') ? ($args[0]) : ([@args]));
}

sub assert ($$) {
  my ($data, $expr) = @_;

  require Venus::Assert;

  my $assert = Venus::Assert->new->expression($expr);

  return $assert->validate($data);
}

sub async ($) {
  my ($code) = @_;

  require Venus::Process;

  return Venus::Process->new->future($code);
}

sub atom (;$) {
  my ($data) = @_;

  require Venus::Atom;

  return Venus::Atom->new($data);
}

sub await ($;$) {
  my ($future, $timeout) = @_;

  require Venus::Future;

  return $future->wait($timeout);
}

sub bool (;$) {
  my ($data) = @_;

  require Venus::Boolean;

  return Venus::Boolean->new($data);
}

sub box ($) {
  my ($data) = @_;

  require Venus::Box;

  my $box = Venus::Box->new($data);

  return $box;
}

sub call (@) {
  my ($data, @args) = @_;
  my $next = @args;
  if ($next && UNIVERSAL::isa($data, 'CODE')) {
    return $data->(@args);
  }
  my $code = shift(@args);
  if ($next && Scalar::Util::blessed($data)) {
    return $data->$code(@args) if UNIVERSAL::can($data, $code)
      || UNIVERSAL::can($data, 'AUTOLOAD');
    $next = 0;
  }
  if ($next && ref($data) eq 'SCALAR') {
    return $$data->$code(@args) if UNIVERSAL::can(load($$data)->package, $code);
    $next = 0;
  }
  if ($next && UNIVERSAL::can(load($data)->package, $code)) {
    no strict 'refs';
    return *{"${data}::${code}"}{"CODE"} ?
      &{"${data}::${code}"}(@args) : $data->$code(@args[1..$#args]);
  }
  if ($next && UNIVERSAL::can($data, 'AUTOLOAD')) {
    no strict 'refs';
    return &{"${data}::${code}"}(@args);
  }
  fault("Exception! call(@{[join(', ', map qq('$_'), @_)]}) failed.");
}

sub cast (;$$) {
  my ($data, $into) = (@_ ? (@_) : ($_));

  require Venus::What;

  my $what = Venus::What->new($data);

  return $into ? $what->cast($into) : $what->deduce;
}

sub catch (&) {
  my ($data) = @_;

  my $error;

  require Venus::Try;

  my @result = Venus::Try->new($data)->error(\$error)->result;

  return wantarray ? ($error ? ($error, undef) : ($error, @result)) : $error;
}

sub caught ($$;&) {
  my ($data, $type, $code) = @_;

  require Scalar::Util;

  ($type, my($name)) = @$type if ref $type eq 'ARRAY';

  my $is_true = $data
    && Scalar::Util::blessed($data)
    && $data->isa('Venus::Error')
    && $data->isa($type || 'Venus::Error')
    && ($data->name ? $data->of($name || '') : !$name);

  return undef unless $is_true;

  local $_ = $data;
  return $code ? $code->($data) : $data;
}

sub chain {
  my ($data, @args) = @_;

  return if !$data;

  for my $next (map +(ref($_) eq 'ARRAY' ? $_ : [$_]), @args) {
    $data = call($data, @$next);
  }

  return $data;
}

sub check ($$) {
  my ($data, $expr) = @_;

  require Venus::Assert;

  return Venus::Assert->new->expression($expr)->valid($data);
}

sub clargs (@) {
  my (@args) = @_;

  my ($argv, $specs) = (@args > 1) ? (map arrayref($_), @args) : ([@ARGV], arrayref(@args));

  my $opts = opts($argv, 'reparse', $specs);

  return wantarray ? (args($opts->unused), $opts, vars({})) : $opts;
}

sub cli (;$) {
  my ($data) = @_;

  require Venus::Cli;

  my $cli = Venus::Cli->new($data);

  return $cli;
}

sub clone ($) {
  my ($data) = @_;

  require Storable;
  require Scalar::Util;

  local $Storable::Deparse = 1;

  local $Storable::Eval = 1;

  return Scalar::Util::blessed($data)
    && $data->isa('Venus::Core')
    && ($data->DOES('Venus::Role::Encaseable') || $data->DOES('Venus::Role::Reflectable'))
    ? $data->clone
    : Storable::dclone($data);
}

sub code ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Code;

  if (!$code) {
    return Venus::Code->new($data);
  }

  return Venus::Code->new($data)->$code(@args);
}

sub config ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Config;

  if (!$code) {
    return Venus::Config->new($data);
  }

  return Venus::Config->new($data)->$code(@args);
}

sub concat (@) {
  my (@args) = @_;

  require Venus::Log;

  return Venus::Log->new->output(@args);
}

sub cop (@) {
  my ($data, @args) = @_;

  require Scalar::Util;

  ($data, $args[0]) = map {
    ref eq 'SCALAR' ? $$_ : Scalar::Util::blessed($_) ? ref($_) : $_
  } ($data, $args[0]);

  return space("$data")->cop(@args);
}

sub data ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Data;

  if (!$code) {
    return Venus::Data->new($data);
  }

  return Venus::Data->new($data)->$code(@args);
}

sub date ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Date;

  if (!$code) {
    return Venus::Date->new($data);
  }

  return Venus::Date->new($data)->$code(@args);
}

sub docs {
  my (@args) = @_;

  my $file = (grep -f, (caller(0))[1], $0)[0];

  my $data = data($file);

  return $data->docs->string(@args > 1 ? @args : (undef, @args));
}

sub enum {
  my (@data) = @_;

  require Venus::Enum;

  return Venus::Enum->new(@data);
}

sub error (;$) {
  my ($data) = @_;

  $data ||= {};
  $data->{context} ||= (caller(1))[3];

  require Venus::Throw;

  return Venus::Throw->new->die($data);
}

sub factory ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Factory;

  if (!$code) {
    return Venus::Factory->new($data);
  }

  return Venus::Factory->new($data)->$code(@args);
}

sub false () {

  require Venus::False;

  return Venus::False->value;
}

sub fault (;$) {
  my ($data) = @_;

  require Venus::Fault;

  return Venus::Fault->new($data)->throw;
}

sub flat {
  my @args = @_;

  return (
    map +(ref $_ eq 'HASH' ? flat(%$_) : (ref $_ eq 'ARRAY' ? flat(@$_) : $_)), @args,
  );
}

sub float ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Float;

  if (!$code) {
    return Venus::Float->new($data);
  }

  return Venus::Float->new($data)->$code(@args);
}

sub future {
  my (@data) = @_;

  require Venus::Future;

  return Venus::Future->new(@data);
}

sub gather ($;&) {
  my ($data, $code) = @_;

  require Venus::Gather;

  my $match = Venus::Gather->new($data);

  return $match if !$code;

  local $_ = $match;

  my $returned = $code->($match, $data);

  $match->data($returned) if ref $returned eq 'HASH';

  return $match->result;
}

sub gets ($;@) {
  my ($data, @args) = @_;

  $data = cast($data);

  my $result = [];

  if ($data->isa('Venus::Hash')) {
    $result = $data->gets(@args);
  }
  elsif ($data->isa('Venus::Array')) {
    $result = $data->gets(@args);
  }

  return wantarray ? (@{$result}) : $result;
}

sub hash ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Hash;

  if (!$code) {
    return Venus::Hash->new($data);
  }

  return Venus::Hash->new($data)->$code(@args);
}

sub hashref (@) {
  my (@args) = @_;

  return @args > 1
    ? ({(scalar(@args) % 2) ? (@args, undef) : @args})
    : ((ref $args[0] eq 'HASH')
    ? ($args[0])
    : ({(scalar(@args) % 2) ? (@args, undef) : @args}));
}

sub in ($$) {
  my ($lvalue, $rvalue) = @_;

  return any($lvalue, sub{tv($rvalue, $_)});
}

sub is_arrayref ($) {
  my ($data) = @_;

  return check($data, 'arrayref');
}

sub is_blessed ($) {
  my ($data) = @_;

  return check($data, 'object');
}

sub is_boolean ($) {
  my ($data) = @_;

  return check($data, 'boolean');
}

sub is_coderef ($) {
  my ($data) = @_;

  return check($data, 'coderef');
}

sub is_dirhandle ($) {
  my ($data) = @_;

  return check($data, 'dirhandle');
}

sub is_enum ($@) {
  my ($data, @args) = @_;

  my $enum = sprintf 'enum[%s]', join ', ', map "$_", @args;

  return check($data, $enum);
}

sub is_error ($;$@) {
  my ($data, $code, @args) = @_;

  require Scalar::Util;
  require Venus::Boolean;

  if (Scalar::Util::blessed($data) && $data->isa('Venus::Error')) {
    return $code
      ? ($data->can($code)
        ? Venus::Boolean->new($data->$code(@args))->is_true
        : Venus::Boolean->false)
      : Venus::Boolean->new($data)->is_true;
  }
  else {
    return Venus::Boolean->false;
  }
}

sub is_false ($;$@) {
  my ($data, $code, @args) = @_;

  require Scalar::Util;
  require Venus::Boolean;

  if (Scalar::Util::blessed($data) && $code) {
    return Venus::Boolean->new($data->$code(@args))->is_false;
  }
  else {
    return Venus::Boolean->new($data)->is_false;
  }
}

sub is_fault ($;$@) {
  my ($data, $code, @args) = @_;

  require Scalar::Util;
  require Venus::Boolean;

  if (Scalar::Util::blessed($data) && $data->isa('Venus::Fault')) {
    return Venus::Boolean->true;
  }
  else {
    return Venus::Boolean->false;
  }
}

sub is_filehandle ($) {
  my ($data) = @_;

  return check($data, 'filehandle');
}

sub is_float ($) {
  my ($data) = @_;

  return check($data, 'float');
}

sub is_glob ($) {
  my ($data) = @_;

  return check($data, 'glob');
}

sub is_hashref ($) {
  my ($data) = @_;

  return check($data, 'hashref');
}

sub is_number ($) {
  my ($data) = @_;

  return check($data, 'number');
}

sub is_object ($) {
  my ($data) = @_;

  return check($data, 'object');
}

sub is_package ($) {
  my ($data) = @_;

  return check($data, 'package');
}

sub is_reference ($) {
  my ($data) = @_;

  return check($data, 'reference');
}

sub is_regexp ($) {
  my ($data) = @_;

  return check($data, 'regexp');
}

sub is_scalarref ($) {
  my ($data) = @_;

  return check($data, 'scalarref');
}

sub is_string ($) {
  my ($data) = @_;

  return check($data, 'string');
}

sub is_true ($;$@) {
  my ($data, $code, @args) = @_;

  require Scalar::Util;
  require Venus::Boolean;

  if (Scalar::Util::blessed($data) && $code) {
    return Venus::Boolean->new($data->$code(@args))->is_true;
  }
  else {
    return Venus::Boolean->new($data)->is_true;
  }
}

sub is_undef ($) {
  my ($data) = @_;

  return check($data, 'undef');
}

sub is_value ($) {
  my ($data) = @_;

  return check($data, 'value');
}

sub is_yesno ($) {
  my ($data) = @_;

  return check($data, 'yesno');
}

sub is ($$) {
  my ($lvalue, $rvalue) = @_;

  require Scalar::Util;

  if (ref($lvalue) && ref($rvalue)) {
    return Scalar::Util::refaddr($lvalue) == Scalar::Util::refaddr($rvalue) ? true() : false();
  }
  else {
    return false();
  }
}

sub json (;$$) {
  my ($code, $data) = @_;

  require Venus::Json;

  if (!$code) {
    return Venus::Json->new;
  }

  if (lc($code) eq 'decode') {
    return Venus::Json->new->decode($data);
  }

  if (lc($code) eq 'encode') {
    return Venus::Json->new(value => $data)->encode;
  }

  return fault(qq(Invalid "json" action "$code"));
}

sub list (@) {
  my (@args) = @_;

  return map {defined $_ ? (ref eq 'ARRAY' ? (@{$_}) : ($_)) : ($_)} @args;
}

sub load ($) {
  my ($data) = @_;

  return space($data)->do('load');
}

sub log (@) {
  my (@args) = @_;

  state $codes = {
    debug => 'debug',
    error => 'error',
    fatal => 'fatal',
    info => 'info',
    trace => 'trace',
    warn => 'warn',
  };

  unshift @args, 'debug' if @args && !$codes->{$args[0]};

  require Venus::Log;

  my $log = Venus::Log->new($ENV{VENUS_LOG_LEVEL});

  return $log if !@args;

  my $code = shift @args;

  return $log->$code(@args);
}

sub make (@) {

  return if !@_;

  return call($_[0], 'new', @_);
}

sub map ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Map;

  if (!$code) {
    return Venus::Map->new($data);
  }

  return Venus::Map->new($data)->$code(@args);
}

sub match ($;&) {
  my ($data, $code) = @_;

  require Venus::Match;

  my $match = Venus::Match->new($data);

  return $match if !$code;

  local $_ = $match;

  my $returned = $code->($match, $data);

  $match->data($returned) if ref $returned eq 'HASH';

  return $match->result;
}

sub merge {
  my ($lvalue, @rvalues) = @_;

  return merge_join($lvalue, @rvalues);
}

sub merge_flat {
  my ($lvalue, @rvalues) = @_;

  return $lvalue if !@rvalues;

  if (@rvalues > 1) {
    my $result = $lvalue;

    $result = merge_flat($result, $_) for @rvalues;

    return $result;
  }

  my $rvalue = $rvalues[0];

  return $rvalue if !ref($lvalue) && !ref($rvalue);

  return $rvalue if !ref($lvalue) && ref($rvalue);

  if (ref($lvalue) eq 'ARRAY' && !ref($rvalue)) {
    return [@$lvalue, $rvalue];
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'ARRAY') {
    return [@$lvalue, @$rvalue];
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'HASH') {
    return [@$lvalue, values %$rvalue];
  }

  return $rvalue if ref($lvalue) eq 'HASH' && (!ref($rvalue) || ref($rvalue) eq 'ARRAY');

  if (ref($lvalue) eq 'HASH' && ref($rvalue) eq 'HASH') {
    my $result = {%$lvalue};
    for my $key (keys %$rvalue) {
      $result->{$key} = exists $lvalue->{$key} ? merge_flat($lvalue->{$key}, $rvalue->{$key}) : $rvalue->{$key};
    }
    return $result;
  }

  return $lvalue;
}

sub merge_flat_mutate {
  my ($lvalue, @rvalues) = @_;

  return $lvalue if !@rvalues;

  if (@rvalues > 1) {
    $lvalue = merge_flat_mutate($lvalue, $_) for @rvalues;
    return $lvalue;
  }

  my $rvalue = $rvalues[0];

  return $_[0] = $rvalue if !ref($lvalue) && !ref($rvalue);

  return $_[0] = $rvalue if !ref($lvalue) && ref($rvalue);

  if (ref($lvalue) eq 'ARRAY' && !ref($rvalue)) {
    push @$lvalue, $rvalue;
    return $lvalue;
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'ARRAY') {
    push @$lvalue, @$rvalue;
    return $lvalue;
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'HASH') {
    push @$lvalue, values %$rvalue;
    return $lvalue;
  }

  return $_[0] = $rvalue if ref($lvalue) eq 'HASH' && (!ref($rvalue) || ref($rvalue) eq 'ARRAY');

  if (ref($lvalue) eq 'HASH' && ref($rvalue) eq 'HASH') {
    for my $key (keys %$rvalue) {
      if (exists $lvalue->{$key}) {
        merge_flat_mutate($lvalue->{$key}, $rvalue->{$key});
      } else {
        $lvalue->{$key} = $rvalue->{$key};
      }
    }
    return $lvalue;
  }

  return $lvalue;
}

sub merge_join {
  my ($lvalue, @rvalues) = @_;

  return $lvalue if !@rvalues;

  if (@rvalues > 1) {
    my $result = $lvalue;

    $result = merge_join($result, $_) for @rvalues;

    return $result;
  }

  my $rvalue = $rvalues[0];

  return $rvalue if !ref($lvalue) && !ref($rvalue);

  return $rvalue if !ref($lvalue) && ref($rvalue);

  if (ref($lvalue) eq 'ARRAY' && !ref($rvalue)) {
    return [@$lvalue, $rvalue];
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'ARRAY') {
    return [@$lvalue, @$rvalue];
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'HASH') {
    return [@$lvalue, $rvalue];
  }

  return $rvalue if ref($lvalue) eq 'HASH' && (!ref($rvalue) || ref($rvalue) eq 'ARRAY');

  if (ref($lvalue) eq 'HASH' && ref($rvalue) eq 'HASH') {
    my $result = {%$lvalue};
    for my $key (keys %$rvalue) {
      $result->{$key} = exists $lvalue->{$key} ? merge_join($lvalue->{$key}, $rvalue->{$key}) : $rvalue->{$key};
    }
    return $result;
  }

  return $lvalue;
}

sub merge_join_mutate {
  my ($lvalue, @rvalues) = @_;

  return $lvalue if !@rvalues;

  if (@rvalues > 1) {
    $lvalue = merge_join_mutate($lvalue, $_) for @rvalues;
    return $lvalue;
  }

  my $rvalue = $rvalues[0];

  return $_[0] = $rvalue if !ref($lvalue) && !ref($rvalue);

  return $_[0] = $rvalue if !ref($lvalue) && ref($rvalue);

  if (ref($lvalue) eq 'ARRAY' && !ref($rvalue)) {
    push @$lvalue, $rvalue;
    return $lvalue;
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'ARRAY') {
    push @$lvalue, @$rvalue;
    return $lvalue;
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'HASH') {
    push @$lvalue, $rvalue;
    return $lvalue;
  }

  return $_[0] = $rvalue if ref($lvalue) eq 'HASH' && (!ref($rvalue) || ref($rvalue) eq 'ARRAY');

  if (ref($lvalue) eq 'HASH' && ref($rvalue) eq 'HASH') {
    for my $key (keys %$rvalue) {
      if (exists $lvalue->{$key}) {
        merge_join_mutate($lvalue->{$key}, $rvalue->{$key});
      } else {
        $lvalue->{$key} = $rvalue->{$key};
      }
    }
    return $lvalue;
  }

  return $lvalue;
}

sub merge_keep {
  my ($lvalue, @rvalues) = @_;

  return $lvalue if !@rvalues;

  if (@rvalues > 1) {
    my $result = $lvalue;

    $result = merge_keep($result, $_) for @rvalues;

    return $result;
  }

  my $rvalue = $rvalues[0];

  return $lvalue if !ref($lvalue) && !ref($rvalue);

  return $lvalue if !ref($lvalue) && ref($rvalue);

  if (ref($lvalue) eq 'ARRAY' && !ref($rvalue)) {
    return [@$lvalue, $rvalue];
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'ARRAY') {
    return [@$lvalue, @$rvalue];
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'HASH') {
    return [@$lvalue, $rvalue];
  }

  return $lvalue if ref($lvalue) eq 'HASH' && (!ref($rvalue) || ref($rvalue) eq 'ARRAY');

  if (ref($lvalue) eq 'HASH' && ref($rvalue) eq 'HASH') {
    my $result = {%$lvalue};
    for my $key (keys %$rvalue) {
      $result->{$key} = exists $lvalue->{$key} ? merge_keep($lvalue->{$key}, $rvalue->{$key}) : $rvalue->{$key};
    }
    return $result;
  }

  return $lvalue;
}

sub merge_keep_mutate {
  my ($lvalue, @rvalues) = @_;

  return $lvalue if !@rvalues;

  if (@rvalues > 1) {
    $lvalue = merge_keep_mutate($lvalue, $_) for @rvalues;
    return $lvalue;
  }

  my $rvalue = $rvalues[0];

  return $lvalue if !ref($lvalue) && !ref($rvalue);

  return $lvalue if !ref($lvalue) && ref($rvalue);

  if (ref($lvalue) eq 'ARRAY' && !ref($rvalue)) {
    push @$lvalue, $rvalue;
    return $lvalue;
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'ARRAY') {
    push @$lvalue, @$rvalue;
    return $lvalue;
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'HASH') {
    push @$lvalue, $rvalue;
    return $lvalue;
  }

  return $lvalue if ref($lvalue) eq 'HASH' && (!ref($rvalue) || ref($rvalue) eq 'ARRAY');

  if (ref($lvalue) eq 'HASH' && ref($rvalue) eq 'HASH') {
    for my $key (keys %$rvalue) {
      if (!exists $lvalue->{$key}) {
        $lvalue->{$key} = $rvalue->{$key};
      } else {
        merge_keep_mutate($lvalue->{$key}, $rvalue->{$key});
      }
    }
    return $lvalue;
  }

  return $lvalue;
}

sub merge_swap {
  my ($lvalue, @rvalues) = @_;

  return $lvalue if !@rvalues;

  if (@rvalues > 1) {
    my $result = $lvalue;

    $result = merge_swap($result, $_) for @rvalues;

    return $result;
  }

  my $rvalue = $rvalues[0];

  return $rvalue if !ref($lvalue) && !ref($rvalue);

  return $rvalue if !ref($lvalue) && ref($rvalue);

  if (ref($lvalue) eq 'ARRAY' && !ref($rvalue)) {
    return [@$lvalue, $rvalue];
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'ARRAY') {
    my $result = [@$lvalue];
    for my $i (0..$#$rvalue) {
      $result->[$i] = $rvalue->[$i] if exists $rvalue->[$i];
    }
    return $result;
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'HASH') {
    return [@$lvalue, $rvalue];
  }

  return $rvalue if ref($lvalue) eq 'HASH' && (!ref($rvalue) || ref($rvalue) eq 'ARRAY');

  if (ref($lvalue) eq 'HASH' && ref($rvalue) eq 'HASH') {
    my $result = {%$lvalue};
    for my $key (keys %$rvalue) {
      $result->{$key} = exists $lvalue->{$key} ? merge_swap($lvalue->{$key}, $rvalue->{$key}) : $rvalue->{$key};
    }
    return $result;
  }

  return $lvalue;
}

sub merge_swap_mutate {
  my ($lvalue, @rvalues) = @_;

  return $lvalue if !@rvalues;

  if (@rvalues > 1) {
    $lvalue = merge_swap_mutate($lvalue, $_) for @rvalues;
    return $lvalue;
  }

  my $rvalue = $rvalues[0];

  return $_[0] = $rvalue if !ref($lvalue) && !ref($rvalue);

  return $_[0] = $rvalue if !ref($lvalue) && ref($rvalue);

  if (ref($lvalue) eq 'ARRAY' && !ref($rvalue)) {
    push @$lvalue, $rvalue;
    return $lvalue;
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'ARRAY') {
    for my $i (0..$#$rvalue) {
      $lvalue->[$i] = $rvalue->[$i] if exists $rvalue->[$i];
    }
    return $lvalue;
  }

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'HASH') {
    push @$lvalue, $rvalue;
    return $lvalue;
  }

  return $_[0] = $rvalue if ref($lvalue) eq 'HASH' && (!ref($rvalue) || ref($rvalue) eq 'ARRAY');

  if (ref($lvalue) eq 'HASH' && ref($rvalue) eq 'HASH') {
    for my $key (keys %$rvalue) {
      if (exists $lvalue->{$key}) {
        merge_swap_mutate($lvalue->{$key}, $rvalue->{$key});
      } else {
        $lvalue->{$key} = $rvalue->{$key};
      }
    }
    return $lvalue;
  }

  return $lvalue;
}

sub merge_take {
  my ($lvalue, @rvalues) = @_;

  return $lvalue if !@rvalues;

  if (@rvalues > 1) {
    my $result = $lvalue;

    $result = merge_take($result, $_) for @rvalues;

    return $result;
  }

  my $rvalue = $rvalues[0];

  if (ref($rvalue) eq 'ARRAY') {
    return [map {merge_take(undef, $_)} @$rvalue];
  }

  if (ref($lvalue) eq 'HASH' && ref($rvalue) eq 'HASH') {
    my $result = {%$lvalue};
    foreach my $key (keys %$rvalue) {
      $result->{$key} = merge_take($lvalue->{$key}, $rvalue->{$key});
    }
    return $result;
  }

  if (ref($rvalue) eq 'HASH') {
    return {%$rvalue};
  }

  return $rvalue;
}

sub merge_take_mutate {
  my ($lvalue, @rvalues) = @_;

  return $lvalue if !@rvalues;

  if (@rvalues > 1) {
    $lvalue = merge_take_mutate($lvalue, $_) for @rvalues;
    return $lvalue;
  }

  my $rvalue = $rvalues[0];

  if (ref($lvalue) eq 'ARRAY' && ref($rvalue) eq 'ARRAY') {
    @$lvalue = @$rvalue;
    return $lvalue;
  }

  if (ref($lvalue) eq 'HASH' && ref($rvalue) eq 'HASH') {
    foreach my $key (keys %$rvalue) {
      $lvalue->{$key} = merge_take_mutate($lvalue->{$key}, $rvalue->{$key});
    }
    return $lvalue;
  }

  return $_[0] = $rvalue;
}

sub meta ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Meta;

  if (!$code) {
    return Venus::Meta->new(name => $data);
  }

  return Venus::Meta->new(name => $data)->$code(@args);
}

sub name ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Name;

  if (!$code) {
    return Venus::Name->new($data);
  }

  return Venus::Name->new($data)->$code(@args);
}

sub number ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Number;

  if (!$code) {
    return Venus::Number->new($data);
  }

  return Venus::Number->new($data)->$code(@args);
}

sub opts ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Opts;

  if (!$code) {
    return Venus::Opts->new($data);
  }

  return Venus::Opts->new($data)->$code(@args);
}

sub pairs (@) {
  my ($args) = @_;

  my $result = defined $args
    ? (
    ref $args eq 'ARRAY'
    ? ([map {[$_, $args->[$_]]} 0..$#{$args}])
    : (ref $args eq 'HASH' ? ([map {[$_, $args->{$_}]} sort keys %{$args}]) : ([])))
    : [];

  return wantarray ? @{$result} : $result;
}

sub path ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Path;

  if (!$code) {
    return Venus::Path->new($data);
  }

  return Venus::Path->new($data)->$code(@args);
}

sub perl (;$$) {
  my ($code, $data) = @_;

  require Venus::Dump;

  if (!$code) {
    return Venus::Dump->new;
  }

  if (lc($code) eq 'decode') {
    return Venus::Dump->new->decode($data);
  }

  if (lc($code) eq 'encode') {
    return Venus::Dump->new(value => $data)->encode;
  }

  return fault(qq(Invalid "perl" action "$code"));
}

sub process (;$@) {
  my ($code, @args) = @_;

  require Venus::Process;

  if (!$code) {
    return Venus::Process->new;
  }

  return Venus::Process->new->$code(@args);
}

sub proto ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Prototype;

  if (!$code) {
    return Venus::Prototype->new($data);
  }

  return Venus::Prototype->new($data)->$code(@args);
}

sub puts ($;@) {
  my ($data, @args) = @_;

  $data = cast($data);

  my $result = [];

  if ($data->isa('Venus::Hash')) {
    $result = $data->puts(@args);
  }
  elsif ($data->isa('Venus::Array')) {
    $result = $data->puts(@args);
  }

  return wantarray ? (@{$result}) : $result;
}

sub raise ($;$) {
  my ($self, $data) = @_;

  ($self, my $parent) = (@$self) if (ref($self) eq 'ARRAY');

  $data ||= {};
  $data->{context} ||= (caller(1))[3];

  $parent = 'Venus::Error' if !$parent;

  require Venus::Throw;

  return Venus::Throw->new(package => $self, parent => $parent)->die($data);
}

sub random (;$@) {
  my ($code, @args) = @_;

  require Venus::Random;

  state $random = Venus::Random->new;

  if (!$code) {
    return $random;
  }

  return $random->$code(@args);
}

sub range ($;@) {
  my ($data, @args) = @_;

  return array($data, 'range', @args);
}

sub read_env ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new->read_env($data);
}

sub read_env_file ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new->read_env_file($data);
}

sub read_json ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new->read_json($data);
}

sub read_json_file ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new->read_json_file($data);
}

sub read_perl ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new->read_perl($data);
}

sub read_perl_file ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new->read_perl_file($data);
}

sub read_yaml ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new->read_yaml($data);
}

sub read_yaml_file ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new->read_yaml_file($data);
}

sub regexp ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Regexp;

  if (!$code) {
    return Venus::Regexp->new($data);
  }

  return Venus::Regexp->new($data)->$code(@args);
}

sub render ($;$) {
  my ($data, $args) = @_;

  return template($data, 'render', undef, $args || {});
}

sub replace ($;$@) {
  my ($data, $code, @args) = @_;

  my @keys = qw(
    string
    regexp
    substr
  );

  my @data = (ref $data eq 'ARRAY' ? (map +(shift(@keys), $_), @{$data}) : $data);

  require Venus::Replace;

  if (!$code) {
    return Venus::Replace->new(@data);
  }

  return Venus::Replace->new(@data)->$code(@args);
}

sub roll (@) {

  return (@_[1,0,2..$#_]);
}

sub schema (;$@) {
  my ($code, @args) = @_;

  require Venus::Schema;

  if (!$code) {
    return Venus::Schema->new;
  }

  return Venus::Schema->new->$code(@args);
}

sub search ($;$@) {
  my ($data, $code, @args) = @_;

  my @keys = qw(
    string
    regexp
  );

  my @data = (ref $data eq 'ARRAY' ? (map +(shift(@keys), $_), @{$data}) : $data);

  require Venus::Search;

  if (!$code) {
    return Venus::Search->new(@data);
  }

  return Venus::Search->new(@data)->$code(@args);
}

sub set ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Set;

  if (!$code) {
    return Venus::Set->new($data);
  }

  return Venus::Set->new($data)->$code(@args);
}

sub sets ($;@) {
  my ($data, @args) = @_;

  $data = cast($data);

  my $result = [];

  if ($data->isa('Venus::Hash')) {
    $result = $data->sets(@args);

    $_[0] = $data->get;
  }
  elsif ($data->isa('Venus::Array')) {
    $result = $data->sets(@args);

    $_[0] = $data->get;
  }

  return wantarray ? (@{$result}) : $result;
}

sub space ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Space;

  if (!$code) {
    return Venus::Space->new($data);
  }

  return Venus::Space->new($data)->$code(@args);
}

sub sorts (@) {

  return CORE::sort(map list($_), @_);
}

sub string ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::String;

  if (!$code) {
    return Venus::String->new($data);
  }

  return Venus::String->new($data)->$code(@args);
}

sub syscall ($;@) {
  my (@args) = @_;

  require Venus::Os;

  for (my $i = 0; $i < @args; $i++) {
    if ($args[$i] =~ /^\|+$/) {
      next;
    }
    if ($args[$i] =~ /^\&+$/) {
      next;
    }
    if ($args[$i] =~ /^\w+$/) {
      next;
    }
    if ($args[$i] =~ /^[<>]+$/) {
      next;
    }
    if ($args[$i] =~ /^\d[<>&]+\d?$/) {
      next;
    }
    if ($args[$i] =~ /\$[A-Z]\w+/) {
      next;
    }
    if ($args[$i] =~ /^\$\((.*)\)$/) {
      next;
    }
    $args[$i] = Venus::Os->quote($args[$i]);
  }

  my ($data, $exit, $code) = (_qx(@args));

  return wantarray ? ($data, $code) : (($exit == 0) ? true() : false());
}

sub template ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Template;

  if (!$code) {
    return Venus::Template->new($data);
  }

  return Venus::Template->new($data)->$code(@args);
}

sub test ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Test;

  if (!$code) {
    return Venus::Test->new($data);
  }

  return Venus::Test->new($data)->$code(@args);
}

sub text {
  my (@args) = @_;

  my $file = (grep -f, (caller(0))[1], $0)[0];

  my $data = data($file);

  return $data->text->string(@args > 1 ? @args : (undef, @args));
}

sub then (@) {

  return ($_[0], call(@_));
}

sub throw ($;$@) {
  my ($data, $code, @args) = @_;

  $data ||= {};

  require Venus::Throw;

  my $throw = Venus::Throw->new(context => (caller(1))[3]);

  $data = {package => $data} if ref $data ne 'HASH';

  for my $key (keys %{$data}) {
    $throw->$key($data->{$key}) if $throw->can($key);
  }

  return $throw if !$code;

  return $throw->$code(@args);
}

sub true () {

  require Venus::True;

  return Venus::True->value;
}

sub try ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Try;

  if (!$code) {
    return Venus::Try->new($data);
  }

  return Venus::Try->new($data)->$code(@args);
}

sub tv {
  my ($lvalue, $rvalue) = @_;

  require Scalar::Util;

  if (is($lvalue, $rvalue)) {
    return true();
  }
  if (!defined($lvalue) && !defined($rvalue)) {
    return true();
  }
  if (!defined($lvalue) || !defined($rvalue)) {
    return false();
  }
  if (ref($lvalue) && ref($rvalue)) {
    if (Scalar::Util::blessed($lvalue) && Scalar::Util::blessed($rvalue)) {
      if (ref($lvalue) ne ref($rvalue)) {
        return false();
      }
      if (UNIVERSAL::isa($lvalue, 'HASH')) {
        return tv({%$lvalue}, {%$rvalue});
      }
      elsif (UNIVERSAL::isa($lvalue, 'ARRAY')) {
        return tv([@$lvalue], [@$rvalue]);
      }
      elsif (UNIVERSAL::isa($lvalue, 'REF')) {
        return tv($$lvalue, $$rvalue);
      }
      elsif (UNIVERSAL::isa($lvalue, 'SCALAR')) {
        return tv($$lvalue, $$rvalue);
      }
      elsif (UNIVERSAL::isa($lvalue, 'GLOB')) {
        return *$lvalue eq *$rvalue;
      }
      elsif (UNIVERSAL::isa($lvalue, 'REGEXP')) {
        return $lvalue eq $rvalue;
      }
      else {
        return false();
      }
    }
    else {
      if (ref($lvalue) eq 'ARRAY') {
        if (@$lvalue != @$rvalue) {
          return false();
        }
        for my $i (0 .. $#$lvalue) {
          if (!tv($lvalue->[$i], $rvalue->[$i])) {
            return false();
          }
        }
        return true();
      }
      elsif (ref($lvalue) eq 'HASH') {
        if (keys %$lvalue != keys %$rvalue) {
          return false();
        }
        for my $key (keys %$lvalue) {
          if (!exists $rvalue->{$key} || !tv($lvalue->{$key}, $rvalue->{$key})) {
            return false();
          }
        }
        return true();
      }
      elsif (ref($lvalue) eq 'SCALAR') {
        return tv($$lvalue, $$rvalue);
      }
      elsif (ref($lvalue) eq 'GLOB') {
        return *$lvalue eq *$rvalue;
      }
      elsif (ref($lvalue) eq 'REF') {
        return tv($$lvalue, $$rvalue);
      }
      elsif (ref($lvalue) eq 'REGEXP') {
        return $lvalue eq $rvalue;
      }
      else {
        return false();
      }
    }
  }
  if (!ref($lvalue) && !ref($rvalue)) {
    require Venus::What;

    if (Venus::What::scalar_is_boolean($lvalue) && Venus::What::scalar_is_boolean($rvalue)) {
      return $lvalue == $rvalue;
    }
    elsif (Venus::What::scalar_is_numeric($lvalue) && Venus::What::scalar_is_numeric($rvalue)) {
      return $lvalue == $rvalue;
    }
    elsif (!Venus::What::scalar_is_numeric($lvalue) && !Venus::What::scalar_is_numeric($rvalue)) {
      return $lvalue eq $rvalue;
    }
    else {
      return false();
    }
  }
  else {
    return false();
  }
}

sub type {
  my ($code, @args) = @_;

  require Venus::Type;

  if (!$code) {
    return Venus::Type->new;
  }

  return Venus::Type->new->$code(@args);
}

sub unpack (@) {
  my (@args) = @_;

  require Venus::Unpack;

  return Venus::Unpack->new->do('args', @args)->all;
}

sub vars ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::Vars;

  if (!$code) {
    return Venus::Vars->new($data);
  }

  return Venus::Vars->new($data)->$code(@args);
}

sub vns ($;@) {
  my ($name, $data, $code, @args) = @_;

  my $space = space('Venus')->child($name)->do('tryload');

  if (!$code) {
    return $space->package->new($#_ > 0 ? $data : ());
  }

  return $space->package->new($#_ > 0 ? $data : ())->$code(@args);
}

sub what ($;$@) {
  my ($data, $code, @args) = @_;

  require Venus::What;

  if (!$code) {
    return Venus::What->new($data);
  }

  return Venus::What->new($data)->$code(@args);
}

sub work ($) {
  my ($data) = @_;

  require Venus::Process;

  return Venus::Process->new->do('work', $data);
}

sub wrap ($;$) {
  my ($data, $name) = @_;

  return if !@_;

  my $moniker = $name // $data =~ s/\W//gr;
  my $caller = caller(0);

  no strict 'refs';
  no warnings 'redefine';

  return *{"${caller}::${moniker}"} = sub {@_ ? make($data, @_) : $data};
}

sub write_env ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new($data)->write_env;
}

sub write_env_file ($$) {
  my ($path, $data) = @_;

  require Venus::Config;

  return Venus::Config->new($data)->write_env_file($path);
}

sub write_json ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new($data)->write_json;
}

sub write_json_file ($$) {
  my ($path, $data) = @_;

  require Venus::Config;

  return Venus::Config->new($data)->write_json_file($path);
}

sub write_perl ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new($data)->write_perl;
}

sub write_perl_file ($$) {
  my ($path, $data) = @_;

  require Venus::Config;

  return Venus::Config->new($data)->write_perl_file($path);
}

sub write_yaml ($) {
  my ($data) = @_;

  require Venus::Config;

  return Venus::Config->new($data)->write_yaml;
}

sub write_yaml_file ($$) {
  my ($path, $data) = @_;

  require Venus::Config;

  return Venus::Config->new($data)->write_yaml_file($path);
}

sub yaml (;$$) {
  my ($code, $data) = @_;

  require Venus::Yaml;

  if (!$code) {
    return Venus::Yaml->new;
  }

  if (lc($code) eq 'decode') {
    return Venus::Yaml->new->decode($data);
  }

  if (lc($code) eq 'encode') {
    return Venus::Yaml->new(value => $data)->encode;
  }

  return fault(qq(Invalid "yaml" action "$code"));
}

1;