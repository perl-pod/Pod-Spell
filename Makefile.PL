
use strict;
use warnings;

use 5.008;

use ExtUtils::MakeMaker 6.30;

use File::ShareDir::Install;
install_share dist => "share";


my %WriteMakefileArgs = (
  "ABSTRACT" => "a formatter for spellchecking Pod",
  "AUTHOR" => "Sean M. Burke <sburke\@cpan.org>, Caleb Cushing <xenoterracide\@gmail.com>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30",
    "File::ShareDir::Install" => "0.03"
  },
  "DISTNAME" => "Pod-Spell",
  "EXE_FILES" => [
    "bin/podspell"
  ],
  "LICENSE" => "artistic_2",
  "NAME" => "Pod::Spell",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Class::Tiny" => 0,
    "File::ShareDir::ProjectDistDir" => 0,
    "File::Slurp" => 0,
    "Lingua::EN::Inflect" => 0,
    "Pod::Escapes" => 0,
    "Pod::Parser" => 0,
    "Text::Wrap" => 0,
    "base" => 0,
    "constant" => 0,
    "locale" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "File::Temp" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::Deep" => 0,
    "Test::More" => "0.88",
    "utf8" => 0
  },
  "VERSION" => "1.13",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Class::Tiny" => 0,
  "File::ShareDir::ProjectDistDir" => 0,
  "File::Slurp" => 0,
  "File::Spec" => 0,
  "File::Temp" => 0,
  "IO::Handle" => 0,
  "IPC::Open3" => 0,
  "Lingua::EN::Inflect" => 0,
  "Pod::Escapes" => 0,
  "Pod::Parser" => 0,
  "Test::Deep" => 0,
  "Test::More" => "0.88",
  "Text::Wrap" => 0,
  "base" => 0,
  "constant" => 0,
  "locale" => 0,
  "strict" => 0,
  "utf8" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);

{
package
MY;
use File::ShareDir::Install qw(postamble);
}


