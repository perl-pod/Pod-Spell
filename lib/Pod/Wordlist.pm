package Pod::Wordlist;
use strict;
use warnings;
use Lingua::EN::Inflect ('PL');

use Class::Tiny {
    wordlist => \&_copy_wordlist,
    _is_debug => 0,
};

use constant MAXWORDLENGTH => 50; ## no critic ( ProhibitConstantPragma )

# VERSION

our %Wordlist; ## no critic ( Variables::ProhibitPackageVars )

sub _copy_wordlist { return { %Wordlist } }

while ( <DATA> ) {
	chomp( $_ );
	$Wordlist{$_} = undef; # just has to exist
	$Wordlist{PL($_)} = undef;
}

=method learn_stopwords

    $wordlist->learn_stopwords( $text, $debug );

Modifies the stopword list based on a text block. See the rules
for <adding stopwords|Pod::Spell/ADDING STOPWORDS> for details.

=cut

sub learn_stopwords {
	my ( $self, $text, $debug ) = @_;
	my $stopwords = $self->wordlist;

	while ( $text =~ m<(\S+)>g ) {
		my $word = $1;
		if ( $word =~ m/^!(.+)/s ) {
			# "!word" deletes from the stopword list
			my $negation = $1;
			# different $1 from above
			delete $stopwords->{$negation};
			delete $stopwords->{PL($negation)};
			print "Unlearning stopword $word\n" if $self->_is_debug;
		}
		else {
			$stopwords->{$word} = undef;
			$stopwords->{PL($word)} = undef;
			print "Learning stopword $1\n" if $self->_is_debug;
		}
	}
	return;
}

=method strip_stopwords

    my $out = $wordlist->strip_stopwords( $text );

Returns a string with space separated words from the original
text with stopwords removed.

=cut

sub strip_stopwords {
	my ($self, $text) = @_;

	# Count the things in $text
	print "Content: <", $text, ">\n" if $self->_is_debug;

	my $stopwords = $self->wordlist;
	my $word;
	$text =~ tr/\xA0\xAD/ /d;

	# i.e., normalize non-breaking spaces, and delete soft-hyphens

	my $out = '';

	my ( $leading, $trailing );
	while ( $text =~ m<(\S+)>g ) {

		# Trim normal English punctuation, if leading or trailing.
		next if length $1 > MAXWORDLENGTH;
		$word = $1;
		if   ( $word =~ s/^([\`\"\'\(\[])//s ) { $leading = $1 }
		else                                   { $leading = '' }

		if   ( $word =~ s/([\)\]\'\"\.\:\;\,\?\!]+)$//s ) { $trailing = $1 }
		else                                              { $trailing = '' }

		if   ( $word =~ s/('s)$//s ) { $trailing = $1 . $trailing }

		if (
			$word =~ m/^[\&\%\$\@\:\<\*\\\_]/s

			# if it looks like it starts with a sigil, etc.
			or $word =~ m/[\%\^\&\#\$\@\_\<\>\(\)\[\]\{\}\\\*\:\+\/\=\|\`\~]/

			# or contains anything strange
		  )
		{
			print "rejecting {$word}\n" if $self->_is_debug && $word ne '_';
			next;
		}
		else {
			if ( exists $stopwords->{$word} or exists $stopwords->{ lc $word } )
			{
				print " [Rejecting \"$word\" as a stopword]\n"
					if $self->_is_debug;
			}
			else {
				$out .= "$leading$word$trailing ";
			}
		}
	}

	return $out;
}

1;

# ABSTRACT: English words that come up in Perl documentation
=pod

=head1 DESCRIPTION

Pod::Wordlist is used by L<Pod::Spell|Pod::Spell>, providing a set of words
that are English jargon words that come up in Perl documentation, but which are
not to be found in general English lexicons.  (For example: autovivify,
backreference, chroot, stringify, wantarray.)

You can also use this wordlist with your word processor by just
pasting C<Pod/Wordlist.pm>'s content into your wordprocessor, deleting
the leading Perl code so that only the wordlist remains, and then
spellchecking this resulting list and adding every word in it to your
private lexicon.

=head1 CONTRIBUTING

Note that the scope of this file is only English, specifically American
English.  (But you may find in useful to incorporate into your own
lexicons, even if they are for other dialects/languages.)

=cut

# XXX PLEASE KEEP THE LIST SORTED CASE-INSENSITIVELY
#
# This allows easier detection of words that differ only in case
# and should be consolidated into a lowercase version.  It also
# makes diffs easier to follow.
#
# Also remove any q{'s} before adding to the list

__DATA__
Aas
absolutize
absolutized
absolutizing
accessor
ACLs
acos
ActivePerl
ActiveState
adaptee
addset
administrativa
AES
afterwards
aggregator
Albery
aliased
aliasing
alloc
alphabetic
alphanumeric
AMD
Amiga
AmigaOS
Aminet
analysis
AnyEvent
AoH
AOP
API
APIs
arcana
arg
arrayref
asctime
asin
AspectJ
associativity
atan
atexit
atime
atof
atoi
atol
authenticator
autocroak
autoflush
autoflushing
autogenerate
autogenerated
autoincrement
autoload
autoloadable
autoloaded
AutoLoader
autoloading
automagically
autoprocess
autoquoting
autosplit
autouse
autovivification
autovivified
autovivify
autovivifying
awk
Babelfish
backend
backgrounded
backgrounding
backlink
backquote
backquoting
backreference
backreferencing
backslashed
backslashing
backtick
backtrace
backwhack
backwhacking
bareword
basename
bcrypt
behaviour
benchmarked
benchmarking
bidirectional
binmode
bistable
bitfield
bitstring
bitwise
blead
bleadperl
blib
blockdenting
blog
bool
boolean
breakpoint
BSCINABTE
bsearch
bugfix
bugfixing
bugtracker
buildable
builtin
Bunce
byacc
bytecode
byteorder
byteperl
bytestream
CAcert
callback
callee
calloc
CamelCase
canonicalize
canonpath
capturable
CAs
catdir
catfile
ccflags
cd
cetera
CGIs
changelog
charset
chdir
checksumming
chmod
chomp
chown
chr
chroot
chrooted
chunked
ciphertext
CISC
classname
clearerr
CLI
clickable
closebrace
closedir
cmp
codepage
codepoint
coderef
coercion
commifies
compilable
composable
computerese
config
configurability
configurator
coprocess
copyable
coredump
Coro
coroutine
cos
cosh
cpan
CPAN.pm
CPANPLUS
cpantester
cperl
cpp
creat
crlf
cron
crosscutting
cruft
cryptographically
csh
css
ctermid
ctime
curdir
curly
cuserid
cwd
cyclicity
cygwin
daemonization
datagram
dataset
datastream
datatype
datestamp
DateTime
DBI
dbmclose
dbmopen
deallocate
deallocated
deallocation
Debian
debugger
decompiler
decrypting
delset
delurk
denormalized
deparse
dequeue
deref
dereference
dereferenced
dereferencer
dereferencing
dereffing
deregistered
deserialization
deserialize
deserialized
deserializing
destructor
die'ing
diff
difftime
dirhandle
distname
Django
djgpp
dmake
DNS
Dominus
don'ts
dosish
dotfile
downcase
drivename
DSL
DTDs
DWIM
DWIMs
DynaLoader
dzil
egrep
egroup
EINTR
elsif
emacs
emptyset
encipherment
encoding
endeavour
endgrent
endhostent
endian
endnetent
endprotoent
endpwent
endservent
enqueue
enqueued
enum
eof
EPP
eq
errno
et
euid
eval
evalled
execl
execle
execlp
executable
execv
execve
execvp
EXEs
fabs
FAQs
fatalize
fatalized
fatpacking
fclose
fcntl
fdopen
feof
ferror
fflush
fgetc
fgetpos
fgets
Fibonacci
fifo
fileglob
filehandle
filemode
filename
fileno
filesize
filespec
filesystem
filetest
fillset
Firefox
FirePHP
FIXME
fixpath
flatfile
fmod
fmt
followup
fopen
foreach
foregrounded
formatter
formfeed
formline
fpathconf
fprintf
fputc
fputs
fread
FreeBSD
FreezeThaw
freopen
Freshmeat
Friedl
frontend
fscanf
fseek
fsetpos
fstat
ftell
ftok
fu
func
fwrite
gcc
gcos
getall
getattr
getc
getcc
getcflag
getchar
getcwd
getegid
getenv
geteuid
getgid
getgrent
getgrgid
getgrnam
getgroups
gethostbyaddr
gethostbyname
gethostent
getiflag
getispeed
getlflag
getlogin
getncnt
getnetbyaddr
getnetbyname
getnetent
getoflag
Getopts
getospeed
getpeername
getpgrp
getpid
getppid
getpriority
getprotobyname
getprotobynumber
getprotoent
getpwent
getpwnam
getpwuid
getservbyname
getservbyport
getservent
getsockname
gettimeofday
getuid
getval
getzcnt
gid
GIFs
Gisle
github
glibc
global
globbed
globbing
globref
gmtime
Google
goto
gotos
grandfathered
GraphViz
grep
grepped
grepping
groff
gt
guid
gunzip
gvim
gz
gzip
gzipped
hacky
hardcoded
hardcoding
hashref
Hietaniemi
HMAC
HMACs
homepage
honoured
hostname
hostonly
htgroup
htmldir
htmlroot
htpasswd
HTTP
httpd
httponly
https
Hurd
iconv
idempotency
identifier
IDs
IETF
Ilya
implementor
indices
inf
inferencing
infile
ini
init
initializer
inline
inlined
inlining
inode
inplace
installable
int
interconversion
interconverted
interoperability
interprocess
invocant
ioctl
IP
IPs
IPv
IPv4
IPv6
IRC
isa
isalnum
isalpha
isatty
iscntrl
isdigit
isgraph
ish
islower
ismember
ISP
isprint
ISPs
ispunct
isspace
isupper
isxdigit
iteratively
iterator
iTerm
japanese
japh
Jarkko
javascript
Joseki
jpg
json
Kerberos
Kernighan
ksh
kwalitee
l,strtold
lastkey
LaTeX
lc
lcfirst
ldexp
ldiv
Lenzo
lex
lexer
lexical
lexically
lexing
lexperl
libdes
libnet
libwww
linearized
linux
localeconv
localhost
localtime
locator
lockf
logfile
logical
login
longjmp
lookahead
lookbehind
lookup
lossy
lseek
lstat
lt
Lukka
lvalue
lwp
MachTen
MacOS
MacPerl
MACs
mailx
makefile
MakeMaker
malloc
manpage
Markdown
marshalling
matlab
maxima
mblen
mbstowcs
mbtowc
memcached
memchr
memcmp
memcpy
memmove
memoization
memoize
memoized
memoizing
memset
Mersenne
metacharacter
metaclasses
metaconfig
metadata
metainformation
metaquoting
Mexico
microtuning
middleware
miniperl
miscompiled
misconfiguration
misconfigured
mixin
mkdir
mkdn
mkdtemp
mkfifo
mkstemp
mktemp
mktime
modf
modulino
MongoDB
monkeypatch
monkeypatching
monospaced
mortalize
mortalized
mountpoint
Mozilla
msgctl
msgget
MSWin
mtime
multi
multi-value
multi-valued
multibyte
multicast
multicharacter
multihomed
multiline
multiprocess
multithreadable
multivalued
multiwindow
munge
munger
munging
munition
mutator
mutex
mv
MVC
MYMETA
mysql
namespace
NaN
Nandor
NaNs
Napster
nawk
ncftp
nd
ndbm
ne
nestable
New
newline
NFS
nmake
nonabortive
nonblocking
nonthreaded
noop
nosuid
nroff
numeric
numify
nvi
nybble
obsoleted
occurence
of
offsetof
ok
OO
OOP
op
opcode
openbrace
OpenBSD
opendir
OpenSSH
opnumber
Opscode
Orcish
ord
orientedness
Orwant
OSX
outdent
outfile
overloadable
overpackage
overwriteable
PadWalker
parameterizable
parameterized
parametric
PARC
paren
parser
passphrase
passwd
patchlevel
pathconf
pathname
peeraddr
peerhost
peerport
perl
perlaix
perlamiga
perlbook
perlboot
perlbootc
perlbot
perlbug
perlcc
perlclib
perlcompile
perlcritic
perlcygwin
perldata
perldbmfilter
perldebguts
perldebtut
perldelta
perldiag
perldoc
perldos
perldsc
perlebcdic
perlepoc
perlfaq
perlfilter
perlfork
perlform
perlhack
perlhist
perlhpux
perlintern
perlio
perliotut
perlipc
Perlis
Perlish
perllexwarn
perllol
perlmachten
perlmacos
perlmain
perlmodinstall
Perlmonks
perlmpeix
perlnewmod
perlnumber
perlobj
perlopentut
perlpod
perlport
perlref
perlreftut
perlrequick
perlretut
perlrun
perlsh
perlsolaris
perlstyle
perlsyn
perlthrtut
perltoc
perltodo
perltootc
perltrap
perlunicode
perlutil
perlvos
perlxs
perlxstut
perror
pessimal
pessimize
petabyte
phash
PHP
pid
pkunzip
placeholder
Plack
pluggable
plugin
PluginBundle
podchecker
podified
podlator
PodParser
podpath
podroot
podselect
pointcut
polymorphic
polymorphing
POSIX
postamble
postorder
pow
pragma
pragmata
pre
preallocate
preallocated
preallocation
prebuilt
precompiled
precompute
precomputed
predeclaration
predeclare
predeclared
prepend
prepended
prepending
preprocessed
prereq
printf
PRNG
PRNGs
processable
procfs
programmatically
prototyped
proxied
Prymmer
pseudoclass
PSGI
Psion
ptr
pumpking
putc
putchar
qr
qsort
quartile
Quicksort
quotemeta
qx
rand
RDBM
RDBMS
RDBMs
rdo
readdir
readline
readlink
README
README.posix?bc
readpipe
real
realloc
realtime
recomputation
recompute
recomputing
recurse
recv
redeclaration
Redhat
redirection
redispatch
redistributable
ref
regex
regexp
reimplement
rekeying
RemotePort
renderable
renice
reparse
repo
representable
resample
resampling
resending
resolver
reswap
rethrown
reusability
reval
rewinddir
RFCs
rindex
RISC
rmdir
roadmap
roff
rootdir
rsh
rsync
runnable
runtime
rvalue
rxvt
san
sbrace%s
scalability
scanf
Schwartzian
scoping
scp
searchable
sed
seekable
seekdir
segfault
SelfLoading
semctl
semget
semop
sendmail
Sereal
serializer
setall
setattr
setcc
setcflag
setenv
setgid
setgrent
sethostent
setiflag
setispeed
setjmp
setlflag
setlocale
setlogsock
setnetent
setoflag
setospeed
setpgid
setpriority
setprotoent
setpwent
setregid
setreuid
setservent
setsid
setuid
setval
sfio
sh
SHA
shipit
shmctl
shmget
shmread
shmwrite
sigaction
sighandler
sigil
siglongjmp
sigpending
sigprocmask
sigsetjmp
sigsuspend
sigtrap
SimpleDB
sinh
sizeof
SMTP
snd
sockaddr
sockdomain
sockhost
sockport
socktype
soundex
SourceForge
spam
specifier
spellcheck
spellchecking
Spiffy
sprintf
SQL
sqlite
sqrt
srand
sscanf
SSL
startup
statefulness
statfs
static
stderr
stdin
stdio
stdios
stdout
stopword
storable
storage
strcat
strchr
strcmp
strcoll
strcpy
strcspn
strerror
strftime
stringification
stringified
stringify
stringifying
stringwise
strlen
strncat
strncmp
strncpy
strpbrk
strrchr
strspn
strstr
strtod
strtok
strtol
strtoul
struct
strxfrm
stty
subclass
subclassed
subclassing
subdir
subdirectory
subexpression
submatch
subnode
subobject
subpattern
subprocess
subscriptable
substr
substring
subtree
subtype
subtyped
sudo
suidperl
superclass
superuser
svk
SVs
Sx
symlink
symlinked
sysadmin
syscall
sysconf
syslog
sysopen
sysread
sysseek
syswrite
taintedness
tanh
tarball
tcdrain
tcflow
tcflush
tcgetattr
tcgetpgrp
tcl
tcsendbreak
tcsetpgrp
tcsh
teardown
telldir
tempdir
tempfile
templating
tempnam
Tenon
termcap
termios
TeX
textarea
threadedness
timegm
timelocal
timestamp
timezone
TIMTOWTDI
TIMTOWTDIBSCINABTE
titlecase
Tk
tmpfile
tmpnam
tokenize
tokenizer
tolower
toolchain
Torkington
toupper
tr
transcoding
tridirectional
trn
tty
ttyname
Tuomas
tuple
Turoff
twip
txt
typechecking
typedefs
typeglob
typemap
tzname
tzset
uc
ucfirst
uid
ulimit
umask
uname
unbackslashed
unblessed
unbuffer
unbuffered
unbuffering
unbundled
uncastable
unconfigured
uncuddled
undef
undefine
undefining
undenting
undiagnosed
undump
unencrypted
unescape
unescaped
unescaping
unexpand
ungetc
unhandled
Unicode
unimport
unindented
uninitialized
University
unix
Unixish
unlink
unlinked
unlinking
unmaintainable
unmaintained
unmangled
unmemoized
unmorph
unmounting
unordered
unparsable
unportable
unprototyped
unreferenced
unshift
unshifted
unsignedness
unsubscripted
untaint
untainting
untrap
untrappable
untrapped
untrusted
unzipper
upcase
updir
upgradability
urandom
uri
URI.pm
url
userinfo
username
utc
utf
utime
uuid
val
varglob
variadic
vec
versa
vfprintf
vgrind
vim
vprintf
Vromans
vsprintf
W3CDTF
waitpid
wallclock
wantarray
warnock
wcstombs
wctomb
webserver
wellformedness
whitelist
whitespace
wiki
wildcard
WindowsNT
wordlist
wordpad
wordprocessor
workflow
wormhole
wrapsuid
writable
writeable
XKCD
xor
XS
XSUB
XSUBs
yacc
YAML
YAPC
yml
yylex
zsh
