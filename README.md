# NAME

Pod::Spell - a formatter for spellchecking Pod

# VERSION

version 1.27

# SYNOPSIS

```perl
use Pod::Spell;
Pod::Spell->new->parse_from_file( 'File.pm' );

Pod::Spell->new->parse_from_filehandle( $infile, $outfile );
```

Also look at [podspell](https://metacpan.org/pod/podspell)

```perl
% perl -MPod::Spell -e "Pod::Spell->new->parse_from_file(shift)" Thing.pm |spell |fmt
```

...or instead of piping to spell or `ispell`, use `>temp.txt`, and open
`temp.txt` in your word processor for spell-checking.

# DESCRIPTION

Pod::Spell is a Pod formatter whose output is good for
spellchecking.  Pod::Spell is rather like [Pod::Text](https://metacpan.org/pod/Pod%3A%3AText), except that
it doesn't put much effort into actual formatting, and it suppresses things
that look like Perl symbols or Perl jargon (so that your spellchecking
program won't complain about mystery words like "`$thing`"
or "`Foo::Bar`" or "hashref").

This class works by filtering out words that look like Perl or any
form of computerese (like "`$thing`" or "`N>7`" or
"`@{$foo}{'bar','baz'}`", anything in C<...> or F<...>
codes, anything in verbatim paragraphs (code blocks), and anything
in the stopword list.  The default stopword list for a document starts
out from the stopword list defined by [Pod::Wordlist](https://metacpan.org/pod/Pod%3A%3AWordlist),
and can be supplemented (on a per-document basis) by having
`"=for stopwords"` / `"=for :stopwords"` region(s) in a document.

# METHODS

## new

```
Pod::Spell->new(%options)
```

Creates a new Pod::Spell instance. Accepts several options:

- debug

    When set to a true value, will output debugging messages about how the Pod
    is being processed.

    Defaults to false.

- stopwords

    Can be specified to use an alternate wordlist instance.

    Defaults to a new Pod::Wordlist instance.

- no\_wide\_chars

    Will be passed to Pod::Wordlist when creating a new instance. Causes all words
    with characters outside the Latin-1 range to be stripped from the output.

## stopwords

```perl
$self->stopwords->isa('Pod::WordList'); # true
```

## parse\_from\_filehandle($in\_fh,$out\_fh)

This method takes an input filehandle (which is assumed to already be
opened for reading) and reads the entire input stream looking for blocks
(paragraphs) of POD documentation to be processed. If no first argument
is given the default input filehandle `STDIN` is used.

The `$in_fh` parameter may be any object that provides a **getline()**
method to retrieve a single line of input text (hence, an appropriate
wrapper object could be used to parse PODs from a single string or an
array of strings).

## parse\_from\_file($filename,$outfile)

This method takes a filename and does the following:

- opens the input and output files for reading
(creating the appropriate filehandles)
- invokes the **parse\_from\_filehandle()** method passing it the
corresponding input and output filehandles.
- closes the input and output files.

If the special input filename "", "-" or "<&STDIN" is given then the STDIN
filehandle is used for input (and no open or close is performed). If no
input filename is specified then "-" is implied. Filehandle references,
or objects that support the regular IO operations (like `<$fh>`
or `$fh-<Egt`getline>) are also accepted; the handles must already be
opened.

If a second argument is given then it should be the name of the desired
output file. If the special output filename "-" or ">&STDOUT" is given
then the STDOUT filehandle is used for output (and no open or close is
performed). If the special output filename ">&STDERR" is given then the
STDERR filehandle is used for output (and no open or close is
performed). If no output filehandle is currently in use and no output
filename is specified, then "-" is implied.
Alternatively, filehandle references or objects that support the regular
IO operations (like `print`, e.g. [IO::String](https://metacpan.org/pod/IO%3A%3AString)) are also accepted;
the object must already be opened.

# ENCODINGS

If your Pod is encoded in something other than Latin-1, it should declare
an encoding using the ["`=encoding _encodingname_`" in perlpod](https://metacpan.org/pod/perlpod#encoding-encodingname) directive.

# ADDING STOPWORDS

You can add stopwords on a per-document basis with
`"=for stopwords"` / `"=for :stopwords"` regions, like so:

```
=for stopwords  plok Pringe zorch   snik !qux
foo bar baz quux quuux
```

This adds every word in that paragraph after "stopwords" to the
stopword list, effective for the rest of the document.  In such a
list, words are whitespace-separated.  (The amount of whitespace
doesn't matter, as long as there's no blank lines in the middle
of the paragraph.)  Plural forms are added automatically using
[Lingua::EN::Inflect](https://metacpan.org/pod/Lingua%3A%3AEN%3A%3AInflect). Words beginning with "!" are
_deleted_ from the stopword list -- so "!qux" deletes "qux" from the
stopword list, if it was in there in the first place.  Note that if
a stopword is all-lowercase, then it means that it's okay in _any_
case; but if the word has any capital letters, then it means that
it's okay _only_ with _that_ case.  So a Wordlist entry of "perl"
would permit "perl", "Perl", and (less interestingly) "PERL", "pERL",
"PerL", et cetera.  However, a Wordlist entry of "Perl" catches
only "Perl", not "perl".  So if you wanted to make sure you said
only "Perl", never "perl", you could add this to the top of your
document:

```
=for stopwords !perl Perl
```

Then all instances of the word "Perl" would be weeded out of the
Pod::Spell-formatted version of your document, but any instances of
the word "perl" would be left in (unless they were in a C<...> or
F<...> style).

You can have several "=for stopwords" regions in your document.  You
can even express them like so:

```
=begin stopwords

plok Pringe zorch

snik !qux

foo bar
baz quux quuux

=end stopwords
```

If you want to use E<...> sequences in a "stopwords" region, you
have to use ":stopwords", as here:

```
=for :stopwords
virtE<ugrave>
```

...meaning that you're adding a stopword of "virtù".  If
you left the ":" out, that would mean you were adding a stopword of
"virtE&lt;ugrave>" (with a literal E, a literal <, etc), which
will have no effect, since  any occurrences of virtE&lt;ugrave>
don't look like a normal human-language word anyway, and so would
be screened out before the stopword list is consulted anyway.

# CAVEATS

## finding stopwords defined with `=for`

Pod::Spell makes a single pass over the POD.  Stopwords
must be added **before** they show up in the POD.

# HINT

If you feed output of Pod::Spell into your word processor and run a
spell-check, make sure you're _not_ also running a grammar-check -- because
Pod::Spell drops words that it thinks are Perl symbols, jargon, or
stopwords, this means you'll have ungrammatical sentences, what with
words being missing and all.  And you don't need a grammar checker
to tell you that.

# SEE ALSO

- [Pod::Wordlist](https://metacpan.org/pod/Pod%3A%3AWordlist)
- [Pod::Simple](https://metacpan.org/pod/Pod%3A%3ASimple)
- [podchecker](https://metacpan.org/pod/podchecker) also known as [Pod::Checker](https://metacpan.org/pod/Pod%3A%3AChecker)
- [perlpod](https://metacpan.org/pod/perlpod), [perlpodspec](https://metacpan.org/pod/perlpodspec)

# BUGS

Please report any bugs or feature requests on the bugtracker website
[https://rt.cpan.org/Public/Dist/Display.html?Name=Pod-Spell](https://rt.cpan.org/Public/Dist/Display.html?Name=Pod-Spell) or by email
to [bug-Pod-Spell@rt.cpan.org](mailto:bug-Pod-Spell@rt.cpan.org).

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHORS

- Sean M. Burke <sburke@cpan.org>
- Caleb Cushing <xenoterracide@gmail.com>

# CONTRIBUTORS

- David Golden <dagolden@cpan.org>
- Graham Knop <haarg@haarg.org>
- Kent Fredric <kentfredric@gmail.com>
- Mohammad S Anwar <mohammad.anwar@yahoo.com>
- Olivier Mengué <dolmen@cpan.org>
- Paulo Custodio <pauloscustodio@gmail.com>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2024 by Olivier Mengué.

This is free software, licensed under:

```
The Artistic License 2.0 (GPL Compatible)
```
