# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'
# Time-stamp: "2001-10-27 00:03:07 MDT"

use strict;
# Time-stamp: "1"
use Test;

my @them;
BEGIN { plan('tests' => 22) };
BEGIN { print "# Perl version $] under $^O\n" }

use Pod::Spell;
ok 1;
use Pod::Wordlist;

print "# Pod::Spell version $Pod::Spell::VERSION\n";
print "# Pod::Wordlist version $Pod::Wordlist::VERSION\n";
if(0 + keys %Pod::Wordlist::Wordlist) {
  ok 1;
  print "#  I see ", scalar(keys %Pod::Wordlist::Wordlist),
    " keys in %Pod::Wordlist::Wordlist\n";
} else {
  ok 0;
  print "#  I see no keys in %Pod::Wordlist::Wordlist\n";
}

print "#\n#-----------------\n# Universe tests...\n";
print "# I'm ", (chr(65) eq 'A') ? '' : 'not ', "in ASCII world.\n";



use vars qw($podfile $textfile);
$podfile  ||= "psin.pod";
$textfile ||= "psout.txt";

foreach my $quotie (qw( A \n \r \cm \cj \t \f \b \a \e )) {
  my $val = eval "\"$quotie\"";
  if($@) {
    ok 0;
    print "# Error in evalling quotie \"$quotie\"\n";
  } elsif(!defined $val) {
    ok 0;
    print "# \"$quotie\" is undef!?\n";
  } else {
    ok 1;
    print "#       \"$quotie\" is ", ord($val), "\n";
  }
}

print "# Universe tests complete.\n#------------------------\n# Real tests.\n#\n";
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


