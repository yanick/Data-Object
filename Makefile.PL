# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.042.
use strict;
use warnings;

use 5.014000;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Object Orientation for Perl 5",
  "AUTHOR" => "Al Newkirk <anewkirk\@ana.io>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "Data-Object",
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.014000",
  "NAME" => "Data::Object",
  "PREREQ_PM" => {
    "Moo" => "2.000001",
    "Type::Tiny" => "1.000005",
    "Type::Tiny::Signatures" => "0.05"
  },
  "VERSION" => "0.59",
  "test" => {
    "TESTS" => "t/data/*.t t/data/object/*.t t/data/object/class/*.t t/data/object/regexp/*.t t/data/object/role/*.t t/prev/data/*.t t/prev/data/object/*.t t/prev/data/object/array/*.t t/prev/data/object/class/*.t t/prev/data/object/code/*.t t/prev/data/object/float/*.t t/prev/data/object/hash/*.t t/prev/data/object/integer/*.t t/prev/data/object/library/*.t t/prev/data/object/number/*.t t/prev/data/object/regexp/*.t t/prev/data/object/role/*.t t/prev/data/object/scalar/*.t t/prev/data/object/signatures/*.t t/prev/data/object/string/*.t t/prev/data/object/undef/*.t t/prev/data/object/universal/*.t"
  }
);


my %FallbackPrereqs = (
  "Moo" => "2.000001",
  "Type::Tiny" => "1.000005",
  "Type::Tiny::Signatures" => "0.05"
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
