use strict;
use warnings;
use Test::More;
use File::Temp;

use Pod::Spell;
use Pod::Wordlist;

# realistically we're just checking to make sure the number seems reasonable
# and not broken
cmp_ok scalar( keys %Pod::Wordlist::Wordlist ), '>=', 1000, 'key count';

my $podfile  = File::Temp->new;
my $textfile = File::Temp->new;

print $podfile "\n=head1 TEST tree's undef\n"
    . "\n=for stopwords zpaph DDGGSS's myormsp pleumgh bruble-gruble\n"
    . "\n=for :stopwords !myormsp furble\n\n Glakq\n"
    . "\nPleumgh bruble-gruble DDGGSS's zpaph's zpaph-kafdkaj-snee myormsp snickh furbles.\n"
    . "\nFoo::Bar \$a \@b \%c __PACKAGE__->mumble() Foo->{\$bar}\n"
    . qq[\n"'" Kh.D. ('WinX32'.) L<Storable>'s\n]
    . qq[\nbeforecode C<incode> aftercode\n]
    . qq[\nbeforespacecodeC< inspacecode >afterspacecode\n]
    . qq[\nbeforejoinedcodeC<injoinedcode>afterjoinedcode\n]
    . qq[\nbeforeprecodeC<inprecode >afterprecode\n]
    . qq[\nbeforepostcodeC< inpostcode>afterpostcode\n]
    . qq[\nbeforeescapecodeC<E<gt> inescapecode>afterescapecode\n]
    . qq[\n]
    ;

# reread from beginning
$podfile->seek( 0, 0 );

my $p = new_ok 'Pod::Spell' => [ debug => 1 ];

$p->parse_from_filehandle( $podfile, $textfile );

# reread from beginning
$textfile->seek( 0, 0 );

my $in = do { local $/ = undef, <$textfile> };

my @words = split " ", $in;

my @expected = qw(
    TEST tree kafdkaj snee myormsp snickh Kh.D. WinX32 s
    beforecode aftercode
    beforespacecode afterspacecode
    afterprecode
    beforepostcode
);
is scalar @words, scalar @expected, 'word count';

is_deeply [ sort @words ], [ sort @expected ], 'words match'
    or diag "@words";

done_testing;
