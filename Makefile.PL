# This -*- perl -*- script writes the Makefile for Pod::Spell
# See perlmodinstall for installation help.
#
#                          Time-stamp: "2001-10-27 00:15:19 MDT"
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
require 5.004;
use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	=> 'Pod::Spell',
    'VERSION_FROM' => 'Spell.pm', # finds $VERSION
    'dist'        => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    'PREREQ_PM' => {
        'Pod::Parser'  => 1.0,
        'Text::Wrap'   => 1.0,
        'Pod::Escapes' => 1.01,
    },
    'EXE_FILES' => [qw(podspell)],
);

package MY;

sub libscan
{ # Determine things that should *not* be installed
    my($self, $path) = @_;
    return '' if $path =~ m/~/;
    $path;
}

__END__
