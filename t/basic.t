use strict;
use warnings;
use Test::More;
use Test::Deep;
use File::Temp;

use Pod::Spell;
use Pod::Wordlist;

is scalar( keys %Pod::Wordlist::Wordlist ), 1007, 'key count';

my $podfile	 = File::Temp->new;
my $textfile = File::Temp->new;

print $podfile "\n=head1 TEST undef\n"
	. "\n=for stopwords zpaph myormsp pleumgh\n"
	. "\n=for :stopwords !myormsp\n\n Glakq\n"
	. "\nPleumgh zpaph myormsp snickh.\n\n"
	;

# reread from beginning
$podfile->seek( 0, 0 );

is -s $podfile, 123,	'podfile size';

my $p = new_ok 'Pod::Spell';

$p->parse_from_filehandle( $podfile, $textfile );

# reread from beginning
$textfile->seek( 0, 0 );

is -s $textfile, 26,	'textfile size';

# reread from beginning
$textfile->seek( 0, 0 );

my $in = do { local $/ = undef, <$textfile> };

is( length $in, -s $textfile, 'infile' );

my @words = $in =~ m/(\w+)/g;

is scalar @words, 3, 'word count';

cmp_deeply \@words, bag( qw( TEST myormsp snickh ) ), 'words match';

done_testing;
