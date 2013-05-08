use strict;
use warnings;
use Test::More;
use Test::Deep;
use Pod::Spell;

my $p = new_ok 'Pod::Spell';

$p->_get_stopwords_from( 'foo bar baz' );

cmp_deeply [ keys( %{ $p->{spell_stopwords} } ) ],
	superbagof(qw(foo bar baz )),
	'stopwords added'
	;

$p->_get_stopwords_from( '!foo' );

cmp_deeply [ keys( %{ $p->{spell_stopwords} } ) ], superbagof(qw( bar baz )),
	'stopwords still exist';

ok ! exists $p->{spell_stopwords}{foo}, 'foo was removed';

done_testing;
