## Contributing

Venus is an object-orientation framework and extendible standard library for
Perl 5, built on top of the Mars architecture with classes which wrap most
native Perl data types.

## Features

- Perl 5.18.0+
- Zero Dependencies
- Fast Object-Orientation
- Robust Standard Library
- Intuitive Value Classes
- Pure Perl Autoboxing
- Convenient Utility Classes
- Simple Package Reflection
- Flexible Exception Handling
- Composable Standards
- Pluggable (no monkeypatching)
- Proxyable Methods
- Type Assertions
- Type Coercions
- Value Casting
- Boolean Values
- Complete Documentation
- Complete Test Coverage

## Aspirations

The following features and goals should anchor the direction and development of
this project:

- No dependencies
- Performance-minded
- Exception handling
- Pure-Perl autoboxing
- Pluggable standard library
- Consistent naming, intuitive behaviors
- Robust and accurate documentation
- Small, flexible, powerful, optional
- Simple package reflection
- Utility classes for common behaviors
- Value classes for primitives data types
- Composable standards via traits (roles)

## Installation

Install Venus using [Git](https://git-scm.com):

```bash
git clone https://git.alnewkirk.com/usevenus/vns.git

cd vns

export PATH=$PATH:$(pwd)/shim

export VENUS_FILE=$(pwd)/.vns.pl

vns init

vns setup

vns test
```

## Directory Structure

```
  lib
  ├── Venus.pm
  ├── ...
  │   └── ...
  t
  ├── ...
  └── Venus.t
```

Important! Before you checkout the code and start making contributions you need
to understand the project structure and reasoning. This will help ensure you
put code changes in the right place so they won't get overwritten.

The `lib` directory is where the packages (modules, classes, etc) are. Feel
free to create, delete and/or update as you see fit. All POD (documentation)
changes are made in their respective test files under the `t` directory.

Documentation isn't created and maintained manually, it is generated at-will
(and typically before release). Altering POD files will almost certainly result
in those changes being lost.

## Testing

Running the test suite:

```bash
vns init && vns test
```

## Experiment

Experiment with the code using `perl` (REPL):

```bash
perl -Ilib -Ilocal/lib/perl5 -MVenus -de0
```

Experiment with the code using the `reply` (REPL):

```bash
reply -Ilib -Ilocal/lib/perl5 -e 'use Venus'
```

## Support

**Questions, Suggestions, Issues/Bugs**

Please post any questions, suggestions, issues or bugs to the [issue
tracker](https://github.com/usevenus/vns/issues) on GitHub.

## Philosophy

The goal of Venus is to be a viable non-core standard library, i.e. to provide a
robust set of methods for dealing with common computing tasks when operating on
primitive data types. Venus is concerned about developer ergonomics much more
than speed or conciseness.

## Ethic

Be a compliment, not a cudgel.