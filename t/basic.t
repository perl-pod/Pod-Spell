use strict;
use warnings;
use Test::Most;
use File::Temp;

use Pod::Spell;
use Pod::Wordlist;

my @them;

cmp_ok(	0 + keys %Pod::Wordlist::Wordlist, '>', 0, 'many keys' );

my $podfile	= File::Temp->new;
my $textfile = File::Temp->new;

open(my $pod, '>' , $podfile ) || die "Can't make temp file '$podfile': $!";
print $pod "\n=head1 TEST undef\n\n=for stopwords zpaph myormsp pleumgh\n\n=for :stopwords !myormsp\n\n Glakq\n\nPleumgh zpaph myormsp snickh.\n\n";
close($pod);

is -s $podfile, 123,	'podfile size';

open($pod, '<', $podfile    ) || die "Can't read-open temp file '$podfile': $!";
open(my $txt, '>', $textfile) || die "Can't write-open temp file '$textfile': $!";

my $p;
lives_ok {
	$p = Pod::Spell->new;
} 'created parser object';

isa_ok( $p, 'Pod::Spell' );

$p->parse_from_filehandle( $pod, $txt );

close($pod);
close($txt);

is -s $textfile, 26,	'textfile size';

open($txt, '<', $textfile) || die "Can't read-open temp file '$textfile': $!";

my $in = do { local $/ = undef, <$txt> };

close($txt);

is( length $in, -s $textfile, 'infile' );

{
	my $x = $in;
	$x =~ s/\s+/ /g;

	my @words = $in =~ m/(\w+)/g;

	is scalar @words, 3, 'word count';

	cmp_deeply( [ @words ], bag( qw( TEST myormsp snickh ) ), 'words match' )
		or diag 'Content: ' . $x
		;
}

done_testing;
