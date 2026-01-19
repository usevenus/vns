package Venus::Core;

use 5.018;

use strict;
use warnings;

# IMPORTS

use Venus::Hook;

# METHODS

{
  no warnings 'once';

  *ARGS = *Venus::Hook::ARGS;

  *ATTR = *Venus::Hook::ATTR;

  *AUDIT = *Venus::Hook::AUDIT;

  *BASE = *Venus::Hook::BASE;

  *BLESS = *Venus::Hook::BLESS;

  *BUILD = *Venus::Hook::BUILD;

  *BUILDARGS = *Venus::Hook::BUILDARGS;

  *CONSTRUCT = *Venus::Hook::CONSTRUCT;

  *CLONE = *Venus::Hook::CLONE;

  *DATA = *Venus::Hook::DATA;

  *DECONSTRUCT = *Venus::Hook::DECONSTRUCT;

  *DESTROY = *Venus::Hook::DESTROY;

  *DOES = *Venus::Hook::DOES;

  *EXPORT = *Venus::Hook::EXPORT;

  *FROM = *Venus::Hook::FROM;

  *GET = *Venus::Hook::GET;

  *IMPORT = *Venus::Hook::IMPORT;

  *ITEM = *Venus::Hook::ITEM;

  *META = *Venus::Hook::META;

  *METACACHE = *Venus::Hook::METACACHE;

  *MIXIN = *Venus::Hook::MIXIN;

  *MASK = *Venus::Hook::MASK;

  *NAME = *Venus::Hook::NAME;

  *ROLE = *Venus::Hook::ROLE;

  *SET = *Venus::Hook::SET;

  *STORE = *Venus::Hook::STORE;

  *SUBS = *Venus::Hook::SUBS;

  *TEST = *Venus::Hook::TEST;

  *UNIMPORT = *Venus::Hook::UNIMPORT;

  *USE = *Venus::Hook::USE;
}

1;
