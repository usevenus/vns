# This file is generated by Dist::Zilla::Plugin::CPANFile v6.030
# Do not edit this file directly. To change prereqs, edit the `dist.ini` file.

requires "perl" => "5.018";

on 'test' => sub {
  requires "perl" => "5.018";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};