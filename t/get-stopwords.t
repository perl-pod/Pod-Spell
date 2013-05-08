use strict;
use warnings;
use Test::More;
use Test::Deep;
use Pod::Spell;

my $p = new_ok 'Pod::Spell';

$p->_get_stopwords_from( 'foo bar baz' );

cmp_deeply [ keys( $p->{spell_stopwords} ) ], superbagof(qw(foo bar baz )),
	'stopwords added';

done_testing;
