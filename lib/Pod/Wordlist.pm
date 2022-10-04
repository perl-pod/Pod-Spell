package Pod::Wordlist;
use 5.008;
use strict;
use warnings;

our $VERSION = '1.26';

use Lingua::EN::Inflect 'PL';
use File::Spec ();
use constant {
    MAXWORDLENGTH => 50,
};

use Class::Tiny {
    wordlist  => \&_copy_wordlist,
    _is_debug => 0,
    no_wide_chars => 0,
};

our %Wordlist; ## no critic ( Variables::ProhibitPackageVars )

sub _copy_wordlist {
    my %copy;

    # %Wordlist can be accessed externally, and users will often add terms in
    # encoded form
    for my $word ( keys %Wordlist ) {
        my $decoded_word = $word;
        # if it was already decoded, this should do nothing
        utf8::decode($decoded_word);
        $copy{$decoded_word} = 1;
    }

    return \%copy;
}

BEGIN {
    my $file;

    # try to find wordlist in non-installed dist
    my ($d, $p) = File::Spec->splitpath(__FILE__);
    $p = File::Spec->catdir($p, (File::Spec->updir) x 2, 'share');
    my $full_path = File::Spec->catpath($d, $p, 'wordlist');
    if ($full_path && -e $full_path) {
        $file = $full_path;
    }

    if ( not defined $file ) {
        require File::ShareDir;
        $file = File::ShareDir::dist_file('Pod-Spell', 'wordlist');
    }

    open my $fh, '<:encoding(UTF-8)', $file
        or die "Cannot read $file: $!"; ## no critic (ErrorHandling::RequireCarping)
    while ( defined( my $line = readline $fh ) ) {
        chomp $line;
        $Wordlist{$line} = 1;
        $Wordlist{PL($line)} = 1;
    }
    close $fh;
}

sub learn_stopwords {
    my ( $self, $text ) = @_;
    my $stopwords = $self->wordlist;

    while ( $text =~ m<(\S+)>g ) {
        my $word = $1;
        utf8::decode($word);
        if ( $word =~ m/^!(.+)/s ) {
            # "!word" deletes from the stopword list
            my $negation = $1;
            # different $1 from above
            delete $stopwords->{$negation};
            delete $stopwords->{PL($negation)};
            print "Unlearning stopword <$negation>\n" if $self->_is_debug;
        }
        else {
            $word =~ s{'s$}{}; # we strip 's when checking so strip here, too
            $stopwords->{$word} = 1;
            $stopwords->{PL($word)} = 1;
            print "Learning stopword   <$word>\n" if $self->_is_debug;
        }
    }
    return;
}

sub is_stopword {
    my ($self, $word) = @_;
    my $stopwords = $self->wordlist;
    if ( exists $stopwords->{$word} or exists $stopwords->{ lc $word } ) {
        print "  Rejecting   <$word>\n" if $self->_is_debug;
        return 1;
    }
    return;
}

sub strip_stopwords {
    my ($self, $text) = @_;

    # Count the things in $text
    print "Content: <", $text, ">\n" if $self->_is_debug;

    my @words = grep { length($_) < MAXWORDLENGTH } split " ", $text;

    for ( @words ) {
        print "Parsing word: <$_>\n" if $self->_is_debug;
        # some spellcheckers can't cope with anything but Latin1
        $_ = '' if $self->no_wide_chars && /[^\x00-\xFF]/;

        # strip leading punctuation
        s/^[\(\[\{\'\"\:\;\,\?\!\.]+//;

        # keep everything up to trailing punctuation, not counting
        # periods (for abbreviations like "Ph.D."), single-quotes
        # (for contractions like "don't") or colons (for package
        # names like "Foo::Bar")
        s/^([^\)\]\}\"\;\,\?\!]+).*$/$1/;

        # strip trailing single-quote, periods or colons; after this
        # we have a word that could have internal periods or quotes
        s/[\.\'\:]+$//;

        # strip possessive
        s/'s$//i;

        # zero out variable names or things with internal symbols,
        # since those are probably code expressions outside a C<>
        my $is_sigil   = /^[\&\%\$\@\:\<\*\\\_]/;
        my $is_strange = /[\%\^\&\#\$\@\_\<\>\(\)\[\]\{\}\\\*\:\+\/\=\|\`\~]/;
        $_ = '' if $is_sigil || $is_strange;

        # stop if there are no "word" characters left; if it's just
        # punctuation that we didn't happen to strip or it's weird glyphs,
        # the spellchecker won't do any good anyway
        next unless /\w/;

        print "  Checking as <$_>\n" if $self->_is_debug;

        # replace it with any stopword or stopword parts stripped
        $_ = $self->_strip_a_word($_);

        print "  Keeping as  <$_>\n" if $_ && $self->_is_debug;
    }

    return join(" ", grep { defined && length } @words );
}

sub _strip_a_word {
    my ($self, $word) = @_;
    my $remainder;

    # try word as-is, including possible hyphenation vs stoplist
    if ($self->is_stopword($word) ) {
        $remainder = '';
    }
    # internal period could be abbreviations, so check with
    # trailing period restored and drop or keep on that basis
    elsif ( index($word, '.') >= 0 ) {
        my $abbr = "$word.";
        $remainder = $self->is_stopword($abbr) ? '' : $abbr;
    }
    # check individual parts of hyphenated word, keep whatever isn't a
    # stopword as individual words
    elsif ( index($word, '-') >= 0 ) {
        my @keep;
        for my $part ( split /-/, $word ) {
            push @keep, $part if ! $self->is_stopword( $part );
        }
        $remainder = join(" ", @keep) if @keep;
    }
    # otherwise, we just keep it
    else {
        $remainder = $word;
    }
    return $remainder;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Pod::Wordlist - English words that come up in Perl documentation

=head1 VERSION

This is the development version of Pod::Wordlist.

=head1 DESCRIPTION

Pod::Wordlist is used by L<Pod::Spell|Pod::Spell>, providing a set of words
that are English jargon words that come up in Perl documentation, but which are
not to be found in general English lexicons.  (For example: autovivify,
backreference, chroot, stringify, wantarray.)

You can also use this wordlist with your word processor by just
pasting C<share/wordlist>'s content into your wordprocessor, deleting
the leading Perl code so that only the wordlist remains, and then
spellchecking this resulting list and adding every word in it to your
private lexicon.

=head1 METHODS

=head2 learn_stopwords

    $wordlist->learn_stopwords( $text );

Modifies the stopword list based on a text block. See the rules
for <adding stopwords|Pod::Spell/ADDING STOPWORDS> for details.

=head2 is_stopword

    if ( $wordlist->is_stopword( $word ) ) { ... }

Returns true if the word is found in the stopword list.

=head2 strip_stopwords

    my $out = $wordlist->strip_stopwords( $text );

Returns a string with space separated words from the original
text with stopwords removed.

=head1 ATTRIBUTES

=head2 wordlist

    ref $self->wordlist eq 'HASH'; # true

This is the instance of the wordlist

=head2 no_wide_chars

If true, words with characters outside the Latin-1 range C<0x00> to C<0xFF> will
be stripped like stopwords.

=head1 WORDLIST

Note that the scope of this file is only English, specifically American
English.  (But you may find in useful to incorporate into your own
lexicons, even if they are for other dialects/languages.)

remove any q{'s} before adding to the list.

The list should be sorted and uniqued. The following will work (with GNU
Coreutils ).

    sort share/wordlist -u > /tmp/sorted && mv /tmp/sorted share/wordlist
