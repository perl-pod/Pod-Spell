package Pod::Wordlist;
use strict;
use warnings;

# VERSION

our %Wordlist; ## no critic ( Variables::ProhibitPackageVars )

while ( <DATA> ) {
	chomp( $_ );
	$Wordlist{$_} = 1;
}

1;

# ABSTRACT: English words that come up in Perl documentation
=pod

=head1 DESCRIPTION

Pod::Wordlist is used by L<Pod::Spell|Pod::Spell>, providing a set of words
(as keys in the hash C<%Pod::Spell::Wordlist>) that are English jargon
words that come up in Perl documentation, but which are not to be found
in general English lexicons.  (For example: autovivify, backreference,
chroot, stringify, wantarray.)

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

__DATA__
Aas
absolutize
absolutized
absolutizing
accessor
accessors
ACLs
acos
ActivePerl
ActiveState
adaptee
adaptees
addset
administrativa
afterwards
aggregator
aggregators
Albery
aliased
aliasing
allocs
alphabetics
alphanumerics
Amiga
AmigaOS
Aminet
analyses
AnyEvent
AOP
API
API
APIs
arcana
args
array's
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
autovivifies
autovivify
autovivifying
awk
Babelfish
backend
backends
backgrounded
backgrounding
backlink
backquotes
backquoting
backreference
backreferences
backreferencing
backslashed
backslashing
backtick
backticks
backtrace
backtraces
backwhack
backwhacking
bareword
barewords
basename
behaviour
benchmarked
bidirectional
binmode
bistable
bitfields
bitstrings
bitwise
blib
blockdenting
blog
blogs
bool
boolean
booleans
breakpoint
breakpoints
bsearch
bugfix
bugfixes
bugfixing
bugtracker
bugtracker
buildable
builtin
builtins
Bunce
bundle's
byacc
Bytecode
bytecode
byteorder
byteperl
bytestream
callback
callbacks
callee
calloc
CamelCase
canonicalize
capturable
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
chomps
chown
chr
chroot
chrooted
chunked
CISC
clearerr
clickable
closebrace
closedir
cmp
codepage
codepoint
coderef
coderefs
commifies
compilable
computerese
config
configurability
configurator
configurators
coprocess
coprocesses
copyable
coredump
coredumps
Coro
coroutines
cos
cosh
CPAN
CPAN's
CPAN.pm
CPANPLUS
cperl
cpp
creat
cron
crosscutting
cruft
csh
css
ctermid
ctime
curdir
curlies
cuserid
Cwd
cyclicities
cyclicity
cygwin
daemonization
datagram
datagrams
datastream
datatypes
DateTime
DBI
dbmclose
dbmopen
deallocate
deallocated
deallocates
deallocation
Debian
debugger's
decompiler
delset
delurk
denormalized
deparse
dequeue
deref
dereference
dereferenced
dereferencer
dereferencers
dereferencing
dereffing
deserialized
diffs
difftime
DirHandle
dirhandle
distname
Django
djgpp
dmake
Dominus
dosish
dotfile
DotFiles
dotfiles
downcases
drivename
DSL
DTDs
DynaLoader
egrep
egroup
EINTR
elsif
emacs
emptyset
encipherment
encodings
endgrent
endhostent
endian
endnetent
endprotoent
endpwent
endservent
enqueue
enqueues
enum
eof
EPP
eq
errno
et
euid
eval
evalled
evals
execl
execle
execlp
execv
execve
execvp
EXEs
fabs
FAQs
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
FileHandle
filehandle
filehandle's
filehandles
filemodes
filename
filenames
fileno
filesize
filespec
filespecs
filesystem
filesystem's
filesystems
filetest
filetests
fillset
Firefox
FirePHP
FIXME
fixpath
fmod
fmt
followups
fopen
foreach
foregrounded
formatter
formatter
formfeed
formline
formlines
fpathconf
fprintf
fputc
fputs
fread
FreezeThaw
freopen
Friedl
frontend
fscanf
fseek
fsetpos
fstat
ftell
ftok
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
gids
GIFs
Gisle
github
glibc
globals
globbed
globbing
globrefs
gmtime
Google
goto
gotos
grandfathered
GraphViz
grep
grepped
grepping
greps
groff
gt
GUID
GUIDs
gunzip
gvim
gzip
gzipped
hardcoded
hardcoding
hash's
hashref
Hietaniemi
homepage
hostname
htgroup
htmldir
htmlroot
htpasswd
HTTP
httpd
HTTPS
Hurd
iconv
idempotency
IETF
Ilya
indices
inf
inferencing
infile
init
initializer
inlined
inlining
inode
inplace
int
interconversion
interconverted
interprocess
ints
ioctl
IP
IPv4
IPv6
IRC
isalnum
isalpha
isatty
iscntrl
isdigit
isgraph
islower
ismember
ISP
ISP's
isprint
ispunct
isspace
isupper
isxdigit
iteratively
iterator
japanese
japh
Jarkko
Joseki
jpg
JSON
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
lexers
lexicals
lexing
lexperl
libdes
libnet
libwww
localeconv
localhost
localtime
locator
lockf
logfile
logicals
longjmp
lookahead
lookbehind
lookup
lookups
lseek
lt
Lukka
lvalue
lvalues
lwp
MachTen
MacOS
MacPerl
mailx
Makefile
makefile
makefiles
MakeMaker
malloc
manpage
manpages
Markdown
marshalling
matlab
maxima
mblen
mbstowcs
mbtowc
memchr
memcmp
memcpy
memmove
memoization
memoize
memoized
memoizing
memset
metacharacter
metacharacters
metaclasses
metaconfig
metadata
metainformation
metaquoting
Mexico
microtuning
Middleware
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
mkstemps
mktemp
mktime
modf
modulino
MongoDB
monkeypatch
monkeypatches
monkeypatching
mortalize
mortalized
mortalizes
mountpoint
Mozilla
msgctl
msgget
mtime
multi
multi-value
multi-valued
multibyte
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
mutators
mutexes
mv
MVC
mysql
namespace
namespaces
NaN
Nandor
NaNs
Napster
nawk
ncftp
ndbm
ne
nestable
New
newline
newlines
nmake
nonabortive
nonblocking
nonthreaded
noop
nosuid
nroff
numerics
nvi
nybble
nybbles
obsoleted
occurence
of
offsetof
ok
OO
OOP
op
opcode
opcodes
openbrace
opendir
opnumber
Orcish
ord
orientedness
Orwant
outdent
outfile
overloadable
overpackage
overpackages
overwriteable
parameterizable
PARC
parens
passphrase
passwd
patchlevel
pathconf
peeraddr
peerhost
peerport
Perl
perl
Perl's
perl's
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
perls
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
petabytes
phash
PHP
pid
pipe's
pkunzip
placeholders
Plack
pluggable
plugin
plugin's
plugins
podchecker
podified
podlators
PodParser
podpath
podroot
podselect
pointcut
pointcuts
polymorphic
polymorphing
postamble
pow
pragma
pragmas
pragmata
pre
preallocate
preallocated
preallocation
prebuilt
precompute
precompute
precomputed
precomputes
predeclaration
predeclare
predeclared
prepend
prepended
prepending
prepends
preprocessed
prereq
prereqs
printf
probe's
processable
procfs
Prymmer
pseudoclass
PSGI
Psion
ptr
pumpking
pumpkings
putc
putchar
qr
qsort
Quicksort
quotemeta
qx
rand
RDBMS
rdo
readdir
ReadLine
readline
readlink
README
README.posix?bc
readpipe
realloc
reals
realtime
recomputation
recompute
recomputing
recurse
recv
redeclaration
Redhat
redirections
redispatch
redistributable
ref
regex
regexes
regexp
regexps
reimplement
RemotePort
renderable
renice
reparse
representable
reswap
reusability
reval
rewinddir
RFCs
rindex
RISC
rmdir
roff
rootdir
rsh
rsync
runnable
runtime
rvalue
san
sbrace%s
scanf
Schwartzian
scoping
searchable
sed
seekable
seekdir
segfault
segfaults
segment's
SelfLoading
semctl
semget
semop
sendmail
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
ShipIt
shipit
shmctl
shmget
shmread
shmwrite
sigaction
sighandler
sigils
siglongjmp
sigpending
sigprocmask
sigsetjmp
sigsuspend
sigtrap
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
specifiers
spellcheck
spellchecking
spellchecks
Spiffy
sprintf
SQL
SQLite
sqrt
srand
sscanf
SSL
startup
statefulness
statfs
statics
STDERR
STDERR
STDIN
STDIN
stdio
stdios
STDOUT
STDOUT
stopword
stopword
stopwords
stopwords
storable
storages
strcat
strchr
strcmp
strcoll
strcpy
strcspn
strerror
strftime
stringification
stringification
stringifications
stringified
stringifies
stringify
stringify
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
structs
strxfrm
stty
subclass
subclassed
subclasses
subclassing
subdirectories
subdirectory
subdirs
subexpression
subexpressions
submatch
submatches
subnodes
subobjects
subpatterns
subprocess
subprocesses
subscriptable
substr
substring
substrings
subtree
subtrees
sudo
suidperl
superclass
superclass's
superclasses
superuser
svk
SVs
Sx
symlink
symlinked
symlinks
sysadmin
syscall
syscalls
sysconf
syslog
sysopen
sysread
sysseek
syswrite
taintedness
tanh
tarball
tarballs
tcdrain
tcflow
tcflush
tcgetattr
tcgetpgrp
Tcl
tcsendbreak
tcsetpgrp
tcsh
telldir
tempdir
tempfile
templating
tempnam
Tenon
termcap
terminal's
termios
TeX
textarea
textareas
threadedness
timegm
timelocal
timestamp
timezone
TIMTOWTDI
titlecase
Tk
Tk's
tmpfile
tmpnam
tokenizer
tokenizes
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
ttys
Tuomas
tuple
Turoff
twip
twips
typechecking
typedefs
typeglob
typeglobs
typemap
typemaps
tzname
tzset
uc
ucfirst
uid
uids
ulimit
umask
umasks
uname
unbackslashed
unblessed
unbuffer
unbuffered
unbuffering
uncastable
unconfigured
uncuddled
undef
undefine
undefines
undefining
undefs
undenting
undump
unescape
unescaped
unescaping
unexpand
ungetc
Unicode
unimport
unimports
uninitialized
University
Unixish
unmaintainable
unmaintained
unmangled
unmemoized
unmorph
unmounting
unparsable
unportable
unprototyped
unreferenced
unshift
unshifted
unshifts
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
URI
URI's
URI.pm
URIs
URIs
userinfo
username
UTC
UTF
utime
UUID
uuid
UUIDs
val
value's
varglob
variable's
variadic
vec
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
wcstombs
wctomb
wellformedness
whitelist
whitelists
whitespace
wiki
WindowsNT
wordlist
wordlists
wordpad
wordprocessor
workflow
workflows
wormhole
wrapsuid
writable
xor
XS
XSUB's
XSUBs
yacc
YAML
YAML's
YAPC's
yml
yylex
zsh
