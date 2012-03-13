use strict;
use warnings;
use Test::More 0.88;
use Test::Exception;
use File::Temp;

use Pod::Spell;
use Pod::Wordlist;

my @them;

cmp_ok(  0 + keys %Pod::Wordlist::Wordlist, '>', 0, 'many keys' );

note "I'm ", (chr(65) eq 'A') ? '' : 'not ', "in ASCII world.";

my $podfile  = File::Temp->new;
my $textfile = File::Temp->new;

foreach my $quotie (qw( A \n \r \cm \cj \t \f \b \a \e )) {
	my $val = eval qq/"$quotie"/;
	ok( ord( $val ),  $quotie . ' is '.  ord( $val ) );
}

note 'Universe tests complete.';
note '-' x 30;
note 'Real tests.';

open(my $pod, '>' , $podfile ) || die "Can't make temp file '$podfile': $!";
print $pod "\n=head1 TEST undef\n\n=for stopwords zpaph myormsp pleumgh\n\n=for :stopwords !myormsp\n\n Glakq\n\nPleumgh zpaph myormsp snickh.\n\n";
close($pod);

is -s $podfile, 123,  'podfile size';

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

undef $p;

is -s $textfile, 26,  'textfile size';

open($txt, '<', $textfile) || die "Can't read-open temp file '$textfile': $!";

my $in = do { local $/ = undef, <$txt> };

close($txt);

is( length $in, -s $textfile, 'infile' );

{
  my $x = $in;
  $x =~ s/\s+/ /g;
  note 'Content: ' . $x;

  my @words = $in =~ m/(\w+)/g;
  if(@words == 3 and $words[0] eq 'TEST' and
     $words[1] eq 'myormsp'  and $words[2] eq 'snickh'
  ) {
    ok 1;
    print "#   Converted content is indeed 'TEST myormsp snickh'.\n";
  } else {
    ok 0;
    print "#   Converted content is not as expected.\n";
  }

}

done_testing;
