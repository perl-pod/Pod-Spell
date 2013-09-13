use strict;
use warnings;
use Test::More;
use Test::Deep;
use File::Temp;

use Pod::Spell;
use Pod::Wordlist;

# realistically we're just checking to make sure the number seems reasonable
# and not broken
cmp_ok scalar( keys %Pod::Wordlist::Wordlist ), '>=', 1000, 'key count';

my $podfile  = File::Temp->new;
my $textfile = File::Temp->new;

print $podfile "\n=head1 TEST tree's undef\n"
	. "\n=for stopwords zpaph myormsp pleumgh\n"
	. "\n=for :stopwords !myormsp furble\n\n Glakq\n"
	. "\nPleumgh zpaph's myormsp snickh furbles.\n\n"
	;

# reread from beginning
$podfile->seek( 0, 0 );

my $p = new_ok 'Pod::Spell' => [ debug => 1 ];

$p->parse_from_filehandle( $podfile, $textfile );

# reread from beginning
$textfile->seek( 0, 0 );

my $in = do { local $/ = undef, <$textfile> };

my @words = $in =~ m/([a-z']+)/ig;

is scalar @words, 4, 'word count';

cmp_deeply \@words, bag( qw( TEST tree's myormsp snickh ) ), 'words match'
    or diag "@words";

done_testing;
