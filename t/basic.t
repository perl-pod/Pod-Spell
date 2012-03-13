use strict;
use warnings;
use Test::More 0.88;

use Pod::Spell;
use Pod::Wordlist;

my @them;

cmp_ok(  0 + keys %Pod::Wordlist::Wordlist, '>', 0, 'many keys' );

note "I'm ", (chr(65) eq 'A') ? '' : 'not ', "in ASCII world.";

use vars qw($podfile $textfile);
$podfile  ||= "psin.pod";
$textfile ||= "psout.txt";

foreach my $quotie (qw( A \n \r \cm \cj \t \f \b \a \e )) {
	my $val = eval qq/"$quotie"/;
	ok( ord( $val ),  $quotie . ' is '.  ord( $val ) );
}

note 'Universe tests complete.';
note '-' x 30;
note 'Real tests.';

open(POD, ">$podfile") || die "Can't make temp file '$podfile': $!";
print POD "\n=head1 TEST undef\n\n=for stopwords zpaph myormsp pleumgh\n\n=for :stopwords !myormsp\n\n Glakq\n\nPleumgh zpaph myormsp snickh.\n\n";
close(POD);
ok 1;
print "#   Wrote >$podfile (length ", -s $podfile, " bytes)\n";

open(POD, "<$podfile") || die "Can't read-open temp file '$podfile': $!";
open(TXT, ">$textfile") || die "Can't write-open temp file '$textfile': $!";
ok 1;
print "#   Opened <$podfile and >$textfile\n";

my $p = Pod::Spell->new;
ok 1;
print "#   Created parser object.\n";
$p->parse_from_filehandle(*POD{IO},*TXT{IO});
ok 1;
print "#   Converted.\n";
close(POD);
close(TXT);
undef $p;
print "#   Destroyed objects.\n";
print "#   $textfile is ", -s $textfile, " bytes long.\n";
open(TXT, "<$textfile") || die "Can't read-open temp file '$textfile': $!";
ok 1;
print "#   Opened <$textfile\n";

my $in = join '', <TXT>;
close(TXT);
ok 1;
print "#   Done reading ", length($in), " bytes from $textfile.\n";

{
  my $x = $in;
  $x =~ s/\s+/ /g;
  ok 1;
  print "#   Content:  $x\n";

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

if(unlink($textfile)) {
  ok 1;
  print "#   Unlinked $textfile\n";
} else {
  ok 0;
  print "#   Couldn't unlink $textfile: $!\n";
}

if(unlink($podfile)) {
  ok 1;
  print "#   Unlinked $podfile\n";
} else {
  ok 0;
  print "#   Couldn't unlink $podfile: $!\n";
}

done_testing;
