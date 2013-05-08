use strict;
use warnings;
use Test::More;
use Test::Deep;
use Pod::Spell;

my ( $file0, $file1 );
open( my $podfile, '+<',  \$file0 );
open( my $textfile, '+<', \$file1 );

print $podfile "\n=head1 TEST undef\n"
	. "\n=begin stopwords\n"
	. "\nPleumgh zpaph myormsp snickh\n\n"
	. "\nblah blargh bazh\n\n"
	. "\n=end stopwords\n"
	;

# reread from beginning
$podfile->seek( 0, 0 );

my $p = new_ok 'Pod::Spell' => [ debug => 1 ];

$p->parse_from_filehandle( $podfile, $textfile );

cmp_deeply [ keys( %{ $p->{spell_stopwords} } ) ],
	superbagof(qw(Pleumgh zpaph myormsp snickh blah blargh bazh )),
	'stopwords added'
	;

done_testing;
